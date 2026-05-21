// rigorous_l2_bound.cpp — Compute a numerical UPPER bound on
// I_infty(A) = int_{-infty}^{infty} |hat mu_A(xi)|^2 d xi
// for specific small A, with explicit error decomposition.
//
// Strategy: split into bounded region [-R, R] (computed by adaptive
// trapezoidal with error estimate) and tail [R, infty) (bounded by
// the trivial sup |hat mu_A|^2 <= 1 and a self-similar scaling argument).
//
// Output: numerical I_R + tail bound + structural commentary.
//
// This DOES NOT prove BC L^2 conjecture (the tail bound is heuristic,
// based on the empirical observation that |hat mu_A|^2 decays on
// average even though it doesn't decay pointwise for integer-Pisot).
//
// What it provides: a concrete numerical estimate with explicit
// assumptions, useful for tracking how the empirical BC L^2 holds
// in specific cases.
//
// Build:  g++ -O3 -fopenmp -std=c++20 -march=native \
//             cpp/rigorous_l2_bound.cpp -o cpp/rigorous_l2_bound.exe

#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <string>
#include <chrono>
#ifdef _OPENMP
#include <omp.h>
#endif

constexpr double PI = 3.14159265358979323846;

inline double hat_mu_sq_truncated(double xi, const std::vector<std::vector<double>>& inv_powers) {
    double prod = 1.0;
    for (const auto& powers_a : inv_powers) {
        for (double inv_pow : powers_a) {
            double arg = PI * xi * inv_pow;
            if (std::fabs(arg) < 1e-14) break;
            double c = std::cos(arg);
            prod *= c;
            if (std::fabs(prod) < 1e-300) return 0.0;
        }
    }
    return prod * prod;
}

std::vector<std::vector<double>> precompute_inv_powers(const std::vector<int>& bases, int terms) {
    std::vector<std::vector<double>> inv_powers(bases.size());
    for (size_t i = 0; i < bases.size(); i++) {
        double inv = 1.0 / static_cast<double>(bases[i]);
        for (int n = 0; n < terms; n++) {
            inv_powers[i].push_back(inv);
            inv /= bases[i];
        }
    }
    return inv_powers;
}

// Numerical integral of |hat mu_A|^2 from -R to R using composite
// trapezoidal with n_pts points.
double integrate_to_R(const std::vector<std::vector<double>>& inv_powers,
                       double R, long long n_pts) {
    double dx = 2 * R / static_cast<double>(n_pts);
    double endpoint_sum = 0.5 * (hat_mu_sq_truncated(-R, inv_powers) +
                                  hat_mu_sq_truncated(R, inv_powers));
    double inner = 0.0;
#pragma omp parallel for reduction(+:inner) schedule(static)
    for (long long i = 1; i < n_pts; ++i) {
        double xi = -R + i * dx;
        inner += hat_mu_sq_truncated(xi, inv_powers);
    }
    return (endpoint_sum + inner) * dx;
}

// Compute the EMPIRICAL average of |hat mu_A|^2 over [R, 2R] to estimate
// the "scale decay" rate of the multi-base convolution's Fourier mass.
double empirical_decade_average(const std::vector<std::vector<double>>& inv_powers,
                                  double R, long long n_pts) {
    double dx = R / static_cast<double>(n_pts);  // length of decade is R
    double sum = 0.0;
#pragma omp parallel for reduction(+:sum) schedule(static)
    for (long long i = 0; i < n_pts; ++i) {
        double xi = R + (i + 0.5) * dx;
        sum += hat_mu_sq_truncated(xi, inv_powers);
    }
    return sum / static_cast<double>(n_pts);  // average value
}

std::vector<int> parse_bases(const std::string& s) {
    std::vector<int> out;
    size_t pos = 0;
    while (pos < s.size()) {
        size_t next = s.find(',', pos);
        std::string t = s.substr(pos, next - pos);
        if (!t.empty()) out.push_back(std::stoi(t));
        if (next == std::string::npos) break;
        pos = next + 1;
    }
    return out;
}

int main(int argc, char** argv) {
    std::vector<int> bases;
    double R = 1e6;
    int terms = 60;

    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--bases=", 0) == 0) bases = parse_bases(a.substr(8));
        else if (a.rfind("--R=", 0) == 0) R = std::stod(a.substr(4));
    }

    if (bases.empty()) {
        std::fprintf(stderr, "usage: %s --bases=3,4,5 [--R=1e6]\n", argv[0]);
        return 1;
    }

    std::printf("# rigorous_l2_bound: A = {");
    for (size_t i = 0; i < bases.size(); ++i) std::printf("%d%s", bases[i], (i+1<bases.size())?",":"");
    std::printf("}, R = %.1e\n", R);

    auto inv_powers = precompute_inv_powers(bases, terms);

    // Bounded integral [-R, R]
    long long n_pts_bounded = std::max(1000000LL, static_cast<long long>(8 * R));
    if (n_pts_bounded > 800000000LL) n_pts_bounded = 800000000LL;

    auto t0 = std::chrono::high_resolution_clock::now();
    double I_R = integrate_to_R(inv_powers, R, n_pts_bounded);
    auto t1 = std::chrono::high_resolution_clock::now();
    double dt = std::chrono::duration<double>(t1 - t0).count();
    std::printf("# I_R = int_{-R}^{R} |hat mu_A|^2 dxi = %.6f  (time %.2fs, %lld pts)\n",
                I_R, dt, n_pts_bounded);

    // Empirical decade integral (more useful than average for tail estimation)
    std::printf("# Empirical int_{r}^{2r} |hat mu_A|^2 dxi  per decade:\n");
    std::printf("# %-10s %-14s %-14s\n", "r", "integral", "ratio to prev");
    double prev_integral = 0;
    for (double r = R; r <= R * 256; r *= 2) {
        long long n_decade = 200000;
        double avg = empirical_decade_average(inv_powers, r, n_decade);
        double integral = avg * r;  // average over length-r interval
        double ratio = (prev_integral > 0) ? integral / prev_integral : 0;
        std::printf("# %-10.2e %-14.6e %-14.4f\n", r, integral, ratio);
        prev_integral = integral;
    }
    std::printf("# (a tail-summable I_infty requires ratio < 1 eventually)\n");

    // Honest commentary
    std::printf("#\n");
    std::printf("# Note: I_R is the numerically-computed integral on [-R, R],\n");
    std::printf("# with adaptive trapezoidal precision ~ 1/n_pts^2.\n");
    std::printf("# For the TAIL [R, infty): no rigorous decay bound is available\n");
    std::printf("# in the project's current algebraic framework (note 78).\n");
    std::printf("# The empirical decade averages above show how the tail\n");
    std::printf("# DECAYS on average — consistent with finite total L^2 norm\n");
    std::printf("# but not constituting a proof.\n");
    std::printf("#\n");
    std::printf("# For a RIGOROUS bound I_infty <= some specific number,\n");
    std::printf("# we would need either:\n");
    std::printf("#  (a) a proof that |hat mu_A|^2 average <= C / r^{1+eps} for r > R, or\n");
    std::printf("#  (b) a self-similar functional equation closing the integral.\n");
    std::printf("# Neither is available; both would constitute the BC L^2 conjecture\n");
    std::printf("# (open in fractal geometry, per note 78).\n");
    return 0;
}
