// bernoulli_fourier.cpp — triple-check of the multi-base Bernoulli AC conjecture.
//
// Computes I(T) = integral_{-T}^T |hat mu_A(xi)|^2 d xi by three
// independent methods:
//   (1) trapezoidal on [-T, T];
//   (2) per-scale summation: I(T) = sum_k I_k on [2^k, 2^{k+1}];
//   (3) Monte Carlo on [-T, T].
//
// L^2 saturation iff mu_A has L^2 density iff Erdos 124 conductor closes.
//
// Build:  g++ -O3 -fopenmp -std=c++20 -march=native cpp/bernoulli_fourier.cpp \
//             -o cpp/bernoulli_fourier.exe

#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <cstring>
#include <vector>
#include <string>
#include <random>
#include <chrono>
#include <algorithm>

#ifdef _OPENMP
#include <omp.h>
#endif

constexpr double PI = 3.14159265358979323846;

inline double hat_mu_squared(double xi, const std::vector<std::vector<double>>& inv_powers) {
    double prod = 1.0;
    for (const auto& powers_a : inv_powers) {
        for (double inv_pow : powers_a) {
            double arg = PI * xi * inv_pow;
            if (std::fabs(arg) < 1e-14) break;
            prod *= std::cos(arg);
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

double integrate_trapezoidal(const std::vector<std::vector<double>>& inv_powers,
                              double lo, double hi, long long n_pts) {
    double dx = (hi - lo) / static_cast<double>(n_pts);
    double endpoint_sum = 0.5 * (hat_mu_squared(lo, inv_powers) + hat_mu_squared(hi, inv_powers));
    double inner_sum = 0.0;

#pragma omp parallel for reduction(+:inner_sum) schedule(static)
    for (long long i = 1; i < n_pts; i++) {
        double xi = lo + static_cast<double>(i) * dx;
        inner_sum += hat_mu_squared(xi, inv_powers);
    }

    return (endpoint_sum + inner_sum) * dx;
}

double per_scale_integral(const std::vector<std::vector<double>>& inv_powers,
                          int k, long long n_pts) {
    double lo = std::pow(2.0, static_cast<double>(k));
    double hi = std::pow(2.0, static_cast<double>(k + 1));
    return 2.0 * integrate_trapezoidal(inv_powers, lo, hi, n_pts);
}

double monte_carlo_integral(const std::vector<std::vector<double>>& inv_powers,
                            double lo, double hi, long long n_samples, uint64_t seed) {
    double sum = 0.0;
#pragma omp parallel reduction(+:sum)
    {
        std::mt19937_64 rng;
#ifdef _OPENMP
        rng.seed(seed + static_cast<uint64_t>(omp_get_thread_num()));
#else
        rng.seed(seed);
#endif
        std::uniform_real_distribution<double> unif(lo, hi);
#pragma omp for schedule(static)
        for (long long i = 0; i < n_samples; i++) {
            double xi = unif(rng);
            sum += hat_mu_squared(xi, inv_powers);
        }
    }
    return (sum / static_cast<double>(n_samples)) * (hi - lo);
}

long long choose_n_pts(double lo, double hi, long long min_pts, long long max_pts) {
    long long n = static_cast<long long>(4.0 * (hi - lo));
    if (n < min_pts) n = min_pts;
    if (n > max_pts) n = max_pts;
    return n;
}

struct TestCase {
    std::string label;
    std::vector<int> bases;
};

std::vector<TestCase> default_cases() {
    return {
        {"{3}", {3}},
        {"{4}", {4}},
        {"{5}", {5}},
        {"{7}", {7}},
        {"{3,4}", {3, 4}},
        {"{3,5}", {3, 5}},
        {"{3,4,5}", {3, 4, 5}},
        {"{3,4,7}", {3, 4, 7}},
        {"{3,4,9,25}", {3, 4, 9, 25}},
        {"{3,5,7,13}", {3, 5, 7, 13}},
        {"{3,6,9,12,21,45,89}", {3, 6, 9, 12, 21, 45, 89}}
    };
}

void cmd_cumulative(const std::vector<TestCase>& cases, const std::vector<double>& Ts,
                    int terms, long long max_pts) {
    std::printf("== Cumulative L^2 integral I(T) = int_{-T}^{T} |hat mu_A|^2 dxi ==\n\n");
    std::printf("%-25s | %-10s | %-12s | %-14s | %-10s | %-10s\n",
                "case", "T", "n_pts", "I(T)", "time(s)", "I/I_prev");
    std::printf("%s\n", std::string(95, '-').c_str());

    for (const auto& tc : cases) {
        auto inv_powers = precompute_inv_powers(tc.bases, terms);
        double prev_I = 0.0;
        for (double T : Ts) {
            long long n_pts = choose_n_pts(-T, T, 10000LL, max_pts);
            auto start = std::chrono::high_resolution_clock::now();
            double I = integrate_trapezoidal(inv_powers, -T, T, n_pts);
            auto end = std::chrono::high_resolution_clock::now();
            double secs = std::chrono::duration<double>(end - start).count();

            double ratio = (prev_I > 0) ? (I / prev_I) : 0.0;
            std::printf("%-25s | %-10.0e | %-12lld | %-14.6f | %-10.3f | %-10.4f\n",
                        tc.label.c_str(), T, n_pts, I, secs, ratio);
            prev_I = I;
        }
        std::printf("\n");
    }
}

void cmd_per_scale(const std::vector<TestCase>& cases, int k_max, int terms,
                   long long n_pts_per_scale) {
    std::printf("== Per-scale I_k = 2 * int_{2^k}^{2^{k+1}} |hat mu_A|^2 dxi ==\n\n");
    std::printf("%-25s | ", "case");
    for (int k = 0; k < k_max; k++) std::printf("k=%-2d        ", k);
    std::printf("| sum I_k\n");

    for (const auto& tc : cases) {
        auto inv_powers = precompute_inv_powers(tc.bases, terms);
        std::printf("%-25s | ", tc.label.c_str());
        double total = 0.0;
        for (int k = 0; k < k_max; k++) {
            double I_k = per_scale_integral(inv_powers, k, n_pts_per_scale);
            total += I_k;
            std::printf("%-11.4e ", I_k);
        }
        std::printf("| %.6f\n", total);
    }
}

void cmd_monte_carlo(const std::vector<TestCase>& cases, double T, long long n_samples,
                     int terms) {
    std::printf("== Monte Carlo I_MC(T) vs trapezoidal I_trap(T), T=%.0e, samples=%lld ==\n\n",
                T, n_samples);
    std::printf("%-25s | I_MC(T)        | I_trap(T)      | rel diff\n", "case");

    for (const auto& tc : cases) {
        auto inv_powers = precompute_inv_powers(tc.bases, terms);
        double I_mc = monte_carlo_integral(inv_powers, -T, T, n_samples, 2026);
        long long n_pts_trap = choose_n_pts(-T, T, 10000LL, 100000000LL);
        double I_trap = integrate_trapezoidal(inv_powers, -T, T, n_pts_trap);
        double rel_diff = std::fabs(I_mc - I_trap) / std::max(I_trap, 1e-10);
        std::printf("%-25s | %-14.6f | %-14.6f | %.4f\n",
                    tc.label.c_str(), I_mc, I_trap, rel_diff);
    }
}

void print_header() {
    std::printf("# bernoulli_fourier — triple-check of multi-base Bernoulli AC conjecture\n");
#ifdef _OPENMP
    std::printf("# OpenMP enabled, %d threads\n", omp_get_max_threads());
#else
    std::printf("# Single-threaded (no OpenMP)\n");
#endif
    std::printf("\n");
}

int main(int argc, char** argv) {
    print_header();

    std::string mode = (argc >= 2) ? argv[1] : "default";
    auto cases = default_cases();
    int terms = 60;

    if (mode == "default") {
        std::vector<double> Ts = {1e2, 1e3, 1e4, 1e5, 1e6};
        cmd_cumulative(cases, Ts, terms, 100000000LL);
    } else if (mode == "huge") {
        std::vector<double> Ts = {1e3, 1e4, 1e5, 1e6, 1e7, 1e8};
        cmd_cumulative(cases, Ts, terms, 800000000LL);
    } else if (mode == "per-scale") {
        cmd_per_scale(cases, /*k_max=*/22, terms, /*n_pts_per_scale=*/200000);
    } else if (mode == "monte-carlo") {
        cmd_monte_carlo(cases, /*T=*/1e6, /*n_samples=*/10000000, terms);
    } else {
        std::fprintf(stderr, "unknown mode: %s\n", mode.c_str());
        std::fprintf(stderr, "modes: default, huge, per-scale, monte-carlo\n");
        return 1;
    }

    return 0;
}
