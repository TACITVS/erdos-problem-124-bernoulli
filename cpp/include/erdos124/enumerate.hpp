// erdos124/enumerate.hpp — Enumerate base sets.
//
// Declarative range-based generation of subsets of {3, ..., max_base}
// with filters (gcd = 1, R > 1, etc.).

#pragma once

#include "types.hpp"
#include <numeric>
#include <ranges>
#include <vector>

namespace erdos124 {
namespace enumerate {

// All k-subsets of {3, 4, ..., max_base} as vector<BaseSet>.
[[nodiscard]] inline std::vector<BaseSet>
subsets_of_size(int max_base, int size) {
    std::vector<BaseSet> out;
    if (size < 1 || max_base < 3) return out;
    const int n = max_base - 3 + 1;
    if (size > n) return out;
    std::vector<int> idx(size);
    std::iota(idx.begin(), idx.end(), 0);
    while (true) {
        std::vector<Base> A;
        A.reserve(size);
        for (int i = 0; i < size; ++i) A.push_back(3 + idx[i]);
        out.emplace_back(std::move(A));
        int j = size - 1;
        while (j >= 0 && idx[j] == n - size + j) --j;
        if (j < 0) break;
        ++idx[j];
        for (int i = j + 1; i < size; ++i) idx[i] = idx[i - 1] + 1;
    }
    return out;
}

// All subsets of {3..max_base} with size in [min_size, max_size].
[[nodiscard]] inline std::vector<BaseSet>
subsets_in_range(int max_base, int min_size, int max_size) {
    std::vector<BaseSet> out;
    for (int size = min_size; size <= max_size; ++size) {
        auto block = subsets_of_size(max_base, size);
        for (auto& A : block) out.push_back(std::move(A));
    }
    return out;
}

// Filter: gcd(A) == 1.
[[nodiscard]] inline auto coprime_filter() {
    return std::views::filter([](const BaseSet& A) { return A.gcd() == 1; });
}

// Filter: R(A) classified as Strict (R > 1 strict).
[[nodiscard]] inline auto strict_filter(Real tol = 1e-9L) {
    return std::views::filter([tol](const BaseSet& A) {
        return classify(A.reciprocal_sum(), tol) == Regime::Strict;
    });
}

// Filter: R(A) classified as Exact (R = 1).
[[nodiscard]] inline auto exact_filter(Real tol = 1e-9L) {
    return std::views::filter([tol](const BaseSet& A) {
        return classify(A.reciprocal_sum(), tol) == Regime::Exact;
    });
}

} // namespace enumerate
} // namespace erdos124
