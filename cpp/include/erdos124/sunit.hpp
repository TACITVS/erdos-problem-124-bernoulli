// erdos124/sunit.hpp — Qualitative S-unit certifier for exact-critical
// hypothesis-meeting (A, k).
//
// For exact-critical (R = 1) cases, CFH-strict fails (zero slack).
// The S-unit qualitative route (note 70 + Theorem B of note 72):
//
//   (1) verify gcd(A) = 1 and R(A) = 1
//   (2) verify A has multiplicatively-independent pair (note 17)
//   (3) verify seed interval [c+1, S-c-1] non-empty at some T*
//   (4) cite imported S-unit finiteness theorem (Evertse-Schlickewei-
//       Schmidt; Beukers-Schlickewei)
//
// Gives QUALITATIVE Erdős 124: there exists N_0 (non-effective) such
// that every N >= N_0 is a subset sum.

#pragma once

#include "conductor.hpp"
#include "frontier.hpp"
#include "mw.hpp"
#include "types.hpp"
#include <expected>
#include <optional>
#include <utility>

namespace erdos124 {
namespace sunit {

struct Certificate {
    bool verified = false;
    Integer c_star = -1;
    UInteger T_star = 0;
    UInteger S = 0;
    std::optional<std::pair<Base, Base>> indep_pair;
    enum class Failure { None, NotExactCritical, GcdNotOne, NoIndepPair, SeedEmpty, Other };
    Failure failure = Failure::None;
};

// Verify the S-unit qualitative certificate at scale T for case (A, k).
[[nodiscard]] inline Certificate
verify_at_T(const BaseSet& A, int k, double T, UInteger max_S = kDefaultMaxS) {
    Certificate cert{};

    if (A.gcd() != 1) {
        cert.failure = Certificate::Failure::GcdNotOne;
        return cert;
    }

    constexpr Real tol = 1e-9L;
    Real R = A.reciprocal_sum();
    if (std::fabs(R - 1.0L) > tol) {
        cert.failure = Certificate::Failure::NotExactCritical;
        return cert;
    }

    auto pair = mw::find_indep_pair(A);
    if (!pair) {
        cert.failure = Certificate::Failure::NoIndepPair;
        return cert;
    }
    cert.indep_pair = pair;

    BalancedFrontier E(A, T);
    Seed F(A, E, k);
    auto cr = compute_conductor(F, max_S);
    if (!cr) {
        cert.failure = Certificate::Failure::Other;
        return cert;
    }
    cert.c_star = cr->conductor;
    cert.T_star = E.T_min();
    cert.S = cr->S;
    if (!cr->seed_interval_nonempty) {
        cert.failure = Certificate::Failure::SeedEmpty;
        return cert;
    }

    cert.verified = true;
    return cert;
}

// Search across geometrically-increasing T.
[[nodiscard]] inline Certificate
search_certificate(const BaseSet& A, int k,
                    double T_start = 10.0, double T_max = 1e9,
                    UInteger max_S = kDefaultMaxS) {
    Certificate first_fail{};
    for (double T = T_start; T <= T_max * 1.001; T *= 3.0) {
        auto cert = verify_at_T(A, k, T, max_S);
        if (cert.verified) return cert;
        first_fail = cert;
        // If failure is structural (not just SeedEmpty), no point continuing
        if (cert.failure == Certificate::Failure::GcdNotOne ||
            cert.failure == Certificate::Failure::NotExactCritical ||
            cert.failure == Certificate::Failure::NoIndepPair) {
            return cert;
        }
    }
    return first_fail;
}

} // namespace sunit
} // namespace erdos124
