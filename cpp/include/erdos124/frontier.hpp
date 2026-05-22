// erdos124/frontier.hpp — Balanced frontiers and seeds.
//
// A balanced frontier E at scale T sets e_a = ceil(log_a T) for each
// base a in A, giving the seed F(E) = {a^j : a in A, k <= j < e_a}.
//
// Immutable value semantics.

#pragma once

#include "types.hpp"
#include <cmath>
#include <ranges>
#include <vector>

namespace erdos124 {

// A balanced frontier at scale T: stores exponents e_a and powers a^{e_a}.
class BalancedFrontier {
public:
    BalancedFrontier(const BaseSet& A, double T_target)
        : T_target_(T_target) {
        exponents_.reserve(A.size());
        powers_.reserve(A.size());
        for (Base a : A.bases()) {
            int e_a = static_cast<int>(std::ceil(std::log(T_target) / std::log(static_cast<double>(a))));
            if (e_a < 1) e_a = 1;
            UInteger p = 1;
            for (int i = 0; i < e_a; ++i) p *= static_cast<UInteger>(a);
            while (static_cast<double>(p) < T_target) {
                ++e_a;
                p *= static_cast<UInteger>(a);
            }
            exponents_.push_back(e_a);
            powers_.push_back(p);
        }
    }

    [[nodiscard]] UInteger scale() const noexcept { return T_min(); }
    [[nodiscard]] double target() const noexcept { return T_target_; }

    [[nodiscard]] int exponent(std::size_t i) const noexcept { return exponents_[i]; }
    [[nodiscard]] UInteger power(std::size_t i) const noexcept { return powers_[i]; }
    [[nodiscard]] std::span<const int> exponents() const noexcept { return exponents_; }
    [[nodiscard]] std::span<const UInteger> powers() const noexcept { return powers_; }

    [[nodiscard]] UInteger T_min() const noexcept {
        return *std::ranges::min_element(powers_);
    }

    [[nodiscard]] Real tail_capital(const BaseSet& A) const noexcept {
        Real C = 0;
        for (std::size_t i = 0; i < A.size(); ++i) {
            C += static_cast<Real>(powers_[i]) / static_cast<Real>(A[i] - 1);
        }
        return C;
    }

private:
    double T_target_;
    std::vector<int> exponents_;
    std::vector<UInteger> powers_;
};

// A Seed F(E, k) = {a^j : a in A, k <= j < e_a(E)} as an immutable list
// of integer terms, sorted ascending.
class Seed {
public:
    Seed(const BaseSet& A, const BalancedFrontier& E, int k)
        : k_(k), S_(0) {
        for (std::size_t i = 0; i < A.size(); ++i) {
            Base a = A[i];
            int e_a = E.exponent(i);
            UInteger t = 1;
            for (int j = 0; j < k; ++j) t *= static_cast<UInteger>(a);
            for (int j = k; j < e_a; ++j) {
                terms_.push_back(t);
                S_ += t;
                t *= static_cast<UInteger>(a);
            }
        }
        std::ranges::sort(terms_);
    }

    [[nodiscard]] std::span<const UInteger> terms() const noexcept { return terms_; }
    [[nodiscard]] std::size_t size() const noexcept { return terms_.size(); }
    [[nodiscard]] UInteger sum() const noexcept { return S_; }
    [[nodiscard]] int k() const noexcept { return k_; }

private:
    int k_;
    UInteger S_;
    std::vector<UInteger> terms_;
};

} // namespace erdos124
