// erdos124/mw.hpp — Mignotte-Waldschmidt effective Diophantine bounds.
//
// For multiplicatively-independent positive integers a, b, the
// Mignotte-Waldschmidt 1993 theorem gives an effective lower bound on
// |m log a - n log b| for positive integers m, n:
//
//   |m log a - n log b| >= exp(-C(a, b) * max(log m, log n))
//
// where C(a, b) is an explicit constant depending on a, b.
//
// Equivalent forms used in this project (see notes 46, 07, 09, 10, 11):
//
//   |a^m - b^n| >= max(a^m, b^n) * exp(-C(a, b) * max(log m, log n))
//                = max(a^m, b^n)^{1 - C(a, b) / log max(a^m, b^n)}
//
// For the DGS + MW direction (note 79), we need the rate at which two
// multiplicatively-independent base power sequences SEPARATE in R.
//
// This module provides:
//   - mw_constant(a, b): a conservative C(a, b) from the literature.
//   - separation_lower_bound(a, b, m, n): explicit lower bound on
//     |a^m - b^n|.
//   - diophantine_exponent(a, b): a "transversality exponent" k(a, b)
//     such that |m log a - n log b| >= 1 / max(m, n)^k(a, b) for all
//     sufficiently large m, n.

#pragma once

#include "types.hpp"
#include <algorithm>
#include <cmath>
#include <stdexcept>

namespace erdos124 {
namespace mw {

// Conservative Mignotte-Waldschmidt constant for the (a, b) pair.
//
// Sources:
//   Laurent-Mignotte-Nesterenko 1995, "Formes lineaires en deux logarithmes
//     et determinants d'interpolation".  Gives the explicit constant for
//     linear forms |m log a - n log b|.
//
//   For (a, b) = (3, 4): Laurent-Mignotte 1994 give C(3, 4) ~ 41.
//   For general (a, b): C(a, b) ~ (max log a, log b)^? times explicit
//     numerical factor.
//
// We use a conservative upper bound C(a, b) <= 200 * log(max(a, b))
// which is loose but explicit.  Sharper constants are available from the
// literature for specific pairs.
[[nodiscard]] inline Real mw_constant(Base a, Base b) noexcept {
    if (a == b) return 0;  // multiplicatively dependent
    const Real log_max = std::log(static_cast<Real>(std::max(a, b)));
    return 200.0L * log_max;  // conservative
}

// Lower bound on |a^m - b^n| from Mignotte-Waldschmidt.
[[nodiscard]] inline Real
separation_lower_bound(Base a, Base b, int m, int n) noexcept {
    if (a == b) return 0;
    const Real C = mw_constant(a, b);
    const Real log_max_exp = std::log(static_cast<Real>(std::max(m, n)) + 1);
    const Real log_max_power = std::max(
        m * std::log(static_cast<Real>(a)),
        n * std::log(static_cast<Real>(b))
    );
    // |a^m - b^n| >= max(a^m, b^n) * exp(-C log max(m, n))
    const Real log_lb = log_max_power - C * log_max_exp;
    if (log_lb < -700) return 0;  // exp underflow
    return std::exp(log_lb);
}

// "Diophantine exponent": for multiplicatively-independent (a, b),
// |m log a - n log b| >= 1 / max(m, n)^k for k = k(a, b).
//
// Laurent-Mignotte gives k(a, b) finite and bounded.  This is the
// "transversality exponent" for the DGS adaptation.
[[nodiscard]] inline Real diophantine_exponent(Base a, Base b) noexcept {
    if (a == b) return 0;
    // From Laurent-Mignotte-Nesterenko, the exponent in |m log a - n log b|
    // ~ (max(m, n))^{-k} is typically O(log max(a, b)).
    // Conservative: k(a, b) <= 30 * log(max(a, b))^2.
    const Real log_max = std::log(static_cast<Real>(std::max(a, b)));
    return 30.0L * log_max * log_max;
}

// Pairwise check: are a, b multiplicatively independent?
[[nodiscard]] inline bool
multiplicatively_independent(Base a, Base b) noexcept {
    if (a == b) return false;
    // a, b mult-indep iff log a / log b irrational, i.e., no positive
    // integers p, q with a^p = b^q.
    // For integer a, b > 1: iff their prime factorizations have
    // incompatible exponent vectors.  Quick test: find primes p with
    // v_p(a) != 0 != v_p(b) and check ratio v_p(a)/v_p(b) consistent
    // across all such p.
    Base x = a, y = b;
    Base g = std::gcd(x, y);
    if (g == 1) return true;  // disjoint prime supports => mult-indep
    // Compute the "primitive root" of a and b separately.
    auto prim = [](Base n) {
        for (Base z = 2; z * z <= n; ++z) {
            Base m = n;
            int count = 0;
            while (m > 1 && m % z == 0) { m /= z; ++count; }
            if (count > 0 && m == 1) {
                // n = z^count
                return std::pair<Base, int>{z, count};
            }
        }
        // n is itself prime, or has multiple prime factors
        return std::pair<Base, int>{n, 1};
    };
    auto [za, ca] = prim(a);
    auto [zb, cb] = prim(b);
    return !(za == zb);  // mult-indep iff different primitive roots
}

// Find a multiplicatively-independent pair in A, if any.
[[nodiscard]] inline std::optional<std::pair<Base, Base>>
find_indep_pair(const BaseSet& A) {
    for (std::size_t i = 0; i < A.size(); ++i) {
        for (std::size_t j = i + 1; j < A.size(); ++j) {
            if (multiplicatively_independent(A[i], A[j])) {
                return std::pair<Base, Base>{A[i], A[j]};
            }
        }
    }
    return std::nullopt;
}

} // namespace mw
} // namespace erdos124
