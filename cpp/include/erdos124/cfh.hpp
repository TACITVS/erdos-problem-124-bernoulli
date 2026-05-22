// erdos124/cfh.hpp — Chen-Fang-Hegyvári strict tail certifier.
//
// For strict hypothesis-meeting (A, k) with R(A) > 1, verifies that:
//  (H1) seed interval non-empty,
//  (H2) first tail term fits in seed span + 1,
//  (H3) strict takeover within max_steps advance steps.
//
// If all three hold, the certificate proves c(E) <= c* for all balanced
// frontiers with T(E) >= T*.  (Theorem A of note 72.)

#pragma once

#include "conductor.hpp"
#include "frontier.hpp"
#include "types.hpp"
#include <algorithm>
#include <optional>
#include <ranges>
#include <vector>

namespace erdos124 {
namespace cfh {

struct Certificate {
    bool verified = false;
    Integer c_star = -1;
    UInteger T_star = 0;
    UInteger S = 0;
    UInteger T_takeover = 0;
    int takeover_step = -1;
    Real invariant = 0;
    enum class Failure { None, SeedEmpty, FirstTailTooBig, NoTakeover, Other };
    Failure failure = Failure::None;
};

namespace detail {

// Run the CFH advance loop: at each step, advance the min-index frontier
// element by multiplying by its base; check margin and takeover.
[[nodiscard]] inline Certificate
run_advance_loop(const BaseSet& A, std::vector<UInteger> frontier,
                  int max_steps, Real R, Integer c_seed, UInteger T_initial) {
    Certificate cert{};
    cert.c_star = c_seed;
    cert.T_star = T_initial;
    const Real slack = R - 1;

    auto tail_capital = [&]() {
        Real C = 0;
        for (std::size_t i = 0; i < A.size(); ++i) {
            C += static_cast<Real>(frontier[i]) / static_cast<Real>(A[i] - 1);
        }
        return C;
    };
    const Real C0 = tail_capital();
    const Real invariant = C0 - static_cast<Real>(T_initial);
    cert.invariant = invariant;

    for (int step = 0; step <= max_steps; ++step) {
        auto min_it = std::ranges::min_element(frontier);
        UInteger T_now = *min_it;
        Real C_now = tail_capital();
        Real margin = C_now - static_cast<Real>(T_now) - invariant;
        if (margin < 0) {
            cert.failure = Certificate::Failure::NoTakeover;
            return cert;
        }
        if (slack * static_cast<Real>(T_now) >= invariant) {
            cert.verified = true;
            cert.takeover_step = step;
            cert.T_takeover = T_now;
            return cert;
        }
        auto idx = std::distance(frontier.begin(), min_it);
        frontier[idx] *= static_cast<UInteger>(A[idx]);
    }
    cert.failure = Certificate::Failure::NoTakeover;
    return cert;
}

} // namespace detail

// Verify CFH-strict certificate at scale T for case (A, k).
// Returns the certificate including failure reason if not verified.
[[nodiscard]] inline Certificate
verify_at_T(const BaseSet& A, int k, double T, int max_steps = 200,
            UInteger max_S = kDefaultMaxS) {
    Certificate cert{};
    BalancedFrontier E(A, T);
    Seed F(A, E, k);

    auto cr = compute_conductor(F, max_S);
    if (!cr) {
        cert.failure = Certificate::Failure::Other;
        return cert;
    }
    Integer c = cr->conductor;
    UInteger S = cr->S;
    cert.c_star = c;
    cert.T_star = E.T_min();
    cert.S = S;

    // (H1) seed interval non-empty.
    if (!cr->seed_interval_nonempty) {
        cert.failure = Certificate::Failure::SeedEmpty;
        return cert;
    }
    // (H2) first tail term fits.
    UInteger T0 = E.T_min();
    Integer span_plus_1 = static_cast<Integer>(S) - 2 * c - 1;
    if (static_cast<Integer>(T0) > span_plus_1) {
        cert.failure = Certificate::Failure::FirstTailTooBig;
        return cert;
    }

    // (H3) CFH advance + strict takeover.
    Real R = A.reciprocal_sum();
    if (R <= 1) {
        cert.failure = Certificate::Failure::Other;  // not strict
        return cert;
    }
    std::vector<UInteger> frontier(E.powers().begin(), E.powers().end());
    return detail::run_advance_loop(A, std::move(frontier), max_steps, R, c, T0);
}

// Search across geometrically-increasing T for a verifying T*.
[[nodiscard]] inline Certificate
search_certificate(const BaseSet& A, int k,
                    double T_start = 10.0, double T_max = 1e11,
                    int max_steps = 200, UInteger max_S = kDefaultMaxS) {
    for (double T = T_start; T <= T_max * 1.001; T *= 3.0) {
        auto cert = verify_at_T(A, k, T, max_steps, max_S);
        if (cert.verified) return cert;
    }
    return Certificate{.verified = false, .failure = Certificate::Failure::NoTakeover};
}

} // namespace cfh

} // namespace erdos124
