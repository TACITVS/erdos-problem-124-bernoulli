// erdos124/fourier.hpp — Characteristic functions and Fourier integration.
//
// hat B_{1/a}(xi) = prod_n cos(pi xi a^{-n-1}) (modulo phase)
// hat mu_A(xi) = prod_a hat B_{1/a}(xi)
//
// Computes |hat mu_A|^2 and integrates against various weights.

#pragma once

#include "types.hpp"
#include <cmath>
#include <chrono>
#include <span>
#include <vector>

#ifdef _OPENMP
#include <omp.h>
#endif

namespace erdos124 {

inline constexpr Real kPi = 3.14159265358979323846L;

// Precompute the inverse powers 1/a, 1/a^2, ..., 1/a^terms for each
// base a in A.  Used to evaluate |hat mu_A(xi)|^2 efficiently.
[[nodiscard]] inline std::vector<std::vector<double>>
precompute_inv_powers(const BaseSet& A, int terms = 60) {
    std::vector<std::vector<double>> out(A.size());
    for (std::size_t i = 0; i < A.size(); ++i) {
        double inv = 1.0 / static_cast<double>(A[i]);
        out[i].reserve(terms);
        for (int n = 0; n < terms; ++n) {
            out[i].push_back(inv);
            inv /= A[i];
        }
    }
    return out;
}

// Evaluate |hat mu_A(xi)|^2 = prod_{a,n} cos^2(pi xi / a^{n+1}).
// Truncates when the cumulative product is too small to matter.
[[nodiscard]] inline double
hat_mu_squared(double xi, const std::vector<std::vector<double>>& inv_powers) noexcept {
    double prod = 1.0;
    for (const auto& powers_a : inv_powers) {
        for (double inv_pow : powers_a) {
            double arg = kPi * xi * inv_pow;
            if (std::fabs(arg) < 1e-14) break;
            prod *= std::cos(arg);
            if (std::fabs(prod) < 1e-300) return 0.0;
        }
    }
    return prod * prod;
}

// Trapezoidal integration of |hat mu_A|^2 on [lo, hi], OpenMP-parallel.
[[nodiscard]] inline double
integrate_trapezoidal(const std::vector<std::vector<double>>& inv_powers,
                       double lo, double hi, long long n_pts) {
    const double dx = (hi - lo) / static_cast<double>(n_pts);
    const double endpoint = 0.5 * (hat_mu_squared(lo, inv_powers) +
                                    hat_mu_squared(hi, inv_powers));
    double inner = 0.0;
#pragma omp parallel for reduction(+:inner) schedule(static)
    for (long long i = 1; i < n_pts; ++i) {
        double xi = lo + i * dx;
        inner += hat_mu_squared(xi, inv_powers);
    }
    return (endpoint + inner) * dx;
}

// Symmetric integral I(T) = int_{-T}^T |hat mu_A|^2 d xi with adaptive
// sampling rate.
[[nodiscard]] inline double
I_T(const BaseSet& A, double T, int terms = 60,
    long long min_pts = 10000LL, long long max_pts = 200000000LL) {
    const auto inv_powers = precompute_inv_powers(A, terms);
    long long n_pts = static_cast<long long>(8.0 * T);
    if (n_pts < min_pts) n_pts = min_pts;
    if (n_pts > max_pts) n_pts = max_pts;
    return integrate_trapezoidal(inv_powers, -T, T, n_pts);
}

// Empirical decade integrals: int_{r}^{2r} |hat mu_A|^2 d xi for
// r = R_start, 2 R_start, ..., R_end.  Useful for empirical tail
// estimation.
struct DecadeIntegral {
    double r_low, r_high;
    double integral;
};

[[nodiscard]] inline std::vector<DecadeIntegral>
decade_integrals(const BaseSet& A, double R_start, double R_end,
                  int n_pts_per_decade = 100000, int terms = 60) {
    const auto inv_powers = precompute_inv_powers(A, terms);
    std::vector<DecadeIntegral> out;
    for (double r = R_start; r <= R_end + 1; r *= 2.0) {
        const double integral = integrate_trapezoidal(inv_powers, r, 2 * r, n_pts_per_decade);
        out.push_back({r, 2 * r, integral});
    }
    return out;
}

} // namespace erdos124
