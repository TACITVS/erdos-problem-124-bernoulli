// erdos124/diophantine.hpp — Diophantine analysis for DGS + MW direction.
//
// Tools for the "non-parametric transversality replacement" needed to
// adapt Damanik-Gorodetski-Solomyak 2015 to fixed integer-Pisot
// parameters (note 79).
//
// Central object: the SEPARATION of the joint Fourier-zero lattice of
// the multi-base IFS as functions of base pair Diophantine properties.

#pragma once

#include "fourier.hpp"
#include "mw.hpp"
#include "types.hpp"
#include <cmath>
#include <ranges>
#include <vector>

namespace erdos124 {
namespace diophantine {

// "Transversality coefficient" K(A) for a base set A: the minimum
// Diophantine exponent across all multiplicatively-independent pairs in A.
//
// K(A) small => bases are well-separated in log-space => Fourier
// transforms decorrelate quickly => |hat mu_A|^2 averages small.
//
// K(A) large => bases nearly mult-dependent => slow decorrelation,
// L^2 conjecture harder.
[[nodiscard]] inline Real
transversality_coefficient(const BaseSet& A) noexcept {
    Real K = 0;
    for (std::size_t i = 0; i < A.size(); ++i) {
        for (std::size_t j = i + 1; j < A.size(); ++j) {
            if (mw::multiplicatively_independent(A[i], A[j])) {
                Real k_ij = mw::diophantine_exponent(A[i], A[j]);
                K = std::max(K, k_ij);
            }
        }
    }
    return K;
}

// For a multi-base IFS with bases A, the Fourier transform hat mu_A
// has zeros at xi = (2k+1) a^j / 2 for each (a, j) with a in A, j >= 0.
// These form a "zero lattice" Z_A subset of R_>0.
//
// Returns the first M zeros of hat mu_A near xi = R, sorted ascending.
// Coincident zeros (different bases hitting the same xi) are deduplicated.
[[nodiscard]] inline std::vector<Real>
nearby_zeros(const BaseSet& A, Real R, int M = 100, int max_exp = 30) {
    constexpr Real coincidence_tol = 1e-12L;
    std::vector<Real> zeros;
    for (Base a : A.bases()) {
        Real ap = 1;
        for (int j = 0; j <= max_exp; ++j) {
            Real spacing = ap;
            if (spacing > 2 * R) break;
            Real start = 0.5 * ap;
            Real lower = R - spacing;
            Integer k_min = static_cast<Integer>(std::floor((lower - start) / spacing));
            if (k_min < 0) k_min = 0;
            for (int idx = 0; idx < 20; ++idx) {
                Real z = start + (k_min + idx) * spacing;
                if (z >= R - spacing && z <= R + spacing) zeros.push_back(z);
            }
            ap *= a;
        }
    }
    std::ranges::sort(zeros);
    // Deduplicate (coincident zeros are common in multi-base, e.g., 1/2
    // is a zero for every base).
    auto last = std::unique(zeros.begin(), zeros.end(),
        [&](Real x, Real y) {
            return std::fabs(x - y) <= coincidence_tol * std::max<Real>(1, std::fabs(x));
        });
    zeros.erase(last, zeros.end());
    if (zeros.size() > static_cast<std::size_t>(M)) zeros.resize(M);
    return zeros;
}

// Empirical "zero separation": minimum NON-ZERO distance between
// consecutive distinct zeros of hat mu_A near xi = R.
[[nodiscard]] inline Real
empirical_min_separation(const BaseSet& A, Real R, int M = 100) {
    auto zeros = nearby_zeros(A, R, M);
    if (zeros.size() < 2) return std::numeric_limits<Real>::infinity();
    Real min_sep = std::numeric_limits<Real>::infinity();
    for (std::size_t i = 1; i < zeros.size(); ++i) {
        Real d = zeros[i] - zeros[i - 1];
        if (d > 0) min_sep = std::min(min_sep, d);
    }
    return min_sep;
}

// L^2 density of mu_A * tilde mu_A at 0 (the autocorrelation), which by
// Parseval equals I_infty / (2*pi).  This is the natural target for BC L^2.
[[nodiscard]] inline Real
autocorrelation_density_at_zero(const BaseSet& A, double T, int terms = 60) {
    Real IT = I_T(A, T, terms);
    return IT / (2 * kPi);
}

// Estimate the "L^2 density at zero" of mu_A * tilde mu_A by integrating
// |hat mu_A|^2 against a Gaussian kernel of width 1/T.  As T -> infty,
// this gives the actual density (under BC L^2 conjecture).
[[nodiscard]] inline Real
density_at_zero_proxy(const BaseSet& A, double T, int terms = 60) {
    const auto inv_powers = precompute_inv_powers(A, terms);
    const long long n_pts = static_cast<long long>(std::max(1000000.0, 8.0 * T));
    const double R = T;
    const double dx = 2 * R / static_cast<double>(n_pts);
    double sum = 0;
#pragma omp parallel for reduction(+:sum) schedule(static)
    for (long long i = 0; i < n_pts; ++i) {
        double xi = -R + (i + 0.5) * dx;
        double weight = std::exp(-(xi * xi) / (2 * R * R));  // Gaussian width R
        sum += hat_mu_squared(xi, inv_powers) * weight;
    }
    return sum * dx / (R * std::sqrt(2 * kPi));
}

} // namespace diophantine
} // namespace erdos124
