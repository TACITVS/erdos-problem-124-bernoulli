// erdos124/conductor.hpp — Subset-sum conductor computation.
//
// The conductor c(F) = max{n in [0, S/2] : n not in supp(X_F)} where
// X_F is the subset sum random variable with seed F.  Uses the
// half-bitset optimization: subset sums in [0, S/2] cannot include
// elements > S/2.
//
// Imperative inner loop (hot path) hidden behind a functional interface.

#pragma once

#include "frontier.hpp"
#include "types.hpp"
#include <bit>
#include <cstdint>
#include <expected>
#include <optional>
#include <span>
#include <string>
#include <vector>

namespace erdos124 {

// Tunable: cap on S to prevent OOM.  Default ~1.4e11 (about 8GB half-bitset).
inline constexpr UInteger kDefaultMaxS = (UInteger)1 << 37;

namespace detail {

// In-place bitset shift-OR: bits |= bits << shift.
// Bits past `bits.size()*64 - 1` are dropped.
inline void shift_or(std::span<UInteger> bits, UInteger shift) noexcept {
    const std::size_t n = bits.size();
    const UInteger word_shift = shift / 64;
    const UInteger bit_shift = shift % 64;
    if (word_shift >= n) return;
    if (bit_shift == 0) {
        for (std::size_t i = n - 1; i >= word_shift; --i) {
            bits[i] |= bits[i - word_shift];
            if (i == 0) break;
        }
    } else {
        for (std::size_t i = n - 1; i >= word_shift + 1; --i) {
            UInteger hi = bits[i - word_shift] << bit_shift;
            UInteger lo = bits[i - word_shift - 1] >> (64 - bit_shift);
            bits[i] |= hi | lo;
            if (i == word_shift + 1) break;
        }
        bits[word_shift] |= bits[0] << bit_shift;
    }
}

inline bool test_bit(std::span<const UInteger> bits, UInteger b) noexcept {
    return (bits[b / 64] >> (b % 64)) & 1ULL;
}

} // namespace detail

// Result of conductor computation: the conductor value, or an error.
struct ConductorResult {
    Integer conductor;        // -1 if no missing value in [0, S/2]
    UInteger S;               // sum of seed terms (echoed for convenience)
    bool seed_interval_nonempty;  // true iff 2c + 2 <= S
};

// Compute the conductor of a seed, using the half-bitset optimization.
// Returns std::unexpected if S exceeds the memory cap.
[[nodiscard]] inline std::expected<ConductorResult, std::string>
compute_conductor(const Seed& seed, UInteger max_S = kDefaultMaxS) {
    const UInteger S = seed.sum();
    if (S > max_S) {
        return std::unexpected(
            "S=" + std::to_string(S) + " exceeds max_S=" + std::to_string(max_S));
    }
    const UInteger half = S / 2;
    const std::size_t n_words = (half + 64) / 64 + 1;
    std::vector<UInteger> bits(n_words, 0);
    bits[0] = 1;
    for (UInteger t : seed.terms()) {
        if (t <= half) detail::shift_or(bits, t);
    }
    Integer c = -1;
    for (Integer pos = static_cast<Integer>(half); pos >= 0; --pos) {
        if (!detail::test_bit(bits, static_cast<UInteger>(pos))) {
            c = pos;
            break;
        }
    }
    return ConductorResult{
        .conductor = c,
        .S = S,
        .seed_interval_nonempty = (2 * c + 2 <= static_cast<Integer>(S)),
    };
}

// Convenience wrapper from (BaseSet, k, T).
[[nodiscard]] inline std::expected<ConductorResult, std::string>
conductor_at_T(const BaseSet& A, int k, double T, UInteger max_S = kDefaultMaxS) {
    BalancedFrontier E(A, T);
    Seed F(A, E, k);
    return compute_conductor(F, max_S);
}

// Compute L_2 = sum p_T(n)^2 where p_T(n) = r(n)/2^|F| and r(n) is the
// count of subsets summing to n.  Returns long double for high precision.
//
// Uses a DP table with explicit counts (NOT bitset), so memory cost is
// O(S) UInteger entries.
[[nodiscard]] inline std::expected<Real, std::string>
compute_L2(const Seed& seed, UInteger max_S = (UInteger)1 << 28) {
    const UInteger S = seed.sum();
    if (S > max_S) {
        return std::unexpected("S=" + std::to_string(S) + " exceeds max_S for L2 DP");
    }
    std::vector<UInteger> r(S + 1, 0);
    r[0] = 1;
    for (UInteger t : seed.terms()) {
        if (t > S) continue;
        for (Integer n = static_cast<Integer>(S); n >= static_cast<Integer>(t); --n) {
            r[n] += r[n - t];
        }
    }
    Real sum_sq = 0;
    for (UInteger cnt : r) {
        Real x = static_cast<Real>(cnt);
        sum_sq += x * x;
    }
    Real pow4 = 1;
    for (std::size_t i = 0; i < seed.size(); ++i) pow4 *= 4;
    return sum_sq / pow4;
}

} // namespace erdos124
