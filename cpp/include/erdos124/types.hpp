// erdos124/types.hpp — Fundamental types and concepts.
//
// Declarative, immutable style.  All types are value types; modifications
// produce new values.  C++23.

#pragma once

#include <algorithm>
#include <cmath>
#include <concepts>
#include <cstdint>
#include <numeric>
#include <ranges>
#include <span>
#include <stdexcept>
#include <string>
#include <vector>

namespace erdos124 {

using Integer = std::int64_t;
using UInteger = std::uint64_t;
using Real = long double;

// A Base is a small positive integer >= 2 (typically >= 3 for Erdős 124).
using Base = int;

// A power a^j with a in A and j >= k.
struct Power {
    Base base;
    int exponent;
    UInteger value;

    constexpr auto operator<=>(const Power&) const = default;
};

// An immutable BaseSet: the underlying A in Erdős 124's hypothesis.
class BaseSet {
public:
    explicit BaseSet(std::vector<Base> bases) : bases_(std::move(bases)) {
        std::ranges::sort(bases_);
        if (bases_.empty() || bases_.front() < 2) {
            throw std::invalid_argument("BaseSet: bases must be >= 2");
        }
    }

    [[nodiscard]] std::span<const Base> bases() const noexcept { return bases_; }
    [[nodiscard]] std::size_t size() const noexcept { return bases_.size(); }
    [[nodiscard]] Base operator[](std::size_t i) const noexcept { return bases_[i]; }
    [[nodiscard]] Base min() const noexcept { return bases_.front(); }
    [[nodiscard]] Base max() const noexcept { return bases_.back(); }

    [[nodiscard]] Base gcd() const noexcept {
        return std::ranges::fold_left(
            bases_ | std::views::drop(1),
            static_cast<Base>(bases_.front()),
            [](Base g, Base a) { return std::gcd(g, a); }
        );
    }

    [[nodiscard]] Real reciprocal_sum() const noexcept {
        return std::ranges::fold_left(
            bases_,
            static_cast<Real>(0),
            [](Real acc, Base a) { return acc + static_cast<Real>(1) / static_cast<Real>(a - 1); }
        );
    }

    [[nodiscard]] Real marstrand_sum() const noexcept {
        constexpr Real log2 = 0.6931471805599453094L;
        return std::ranges::fold_left(
            bases_,
            static_cast<Real>(0),
            [log2](Real acc, Base a) -> Real {
                return acc + log2 / static_cast<Real>(std::log(static_cast<Real>(a)));
            }
        );
    }

    [[nodiscard]] std::string to_string() const {
        std::string out = "{";
        for (std::size_t i = 0; i < bases_.size(); ++i) {
            out += std::to_string(bases_[i]);
            if (i + 1 < bases_.size()) out += ",";
        }
        out += "}";
        return out;
    }

private:
    std::vector<Base> bases_;
};

// Regime classification by reciprocal sum.
enum class Regime { Fails, Exact, Strict };

[[nodiscard]] constexpr Regime classify(Real R, Real tol = 1e-9L) noexcept {
    if (R < 1 - tol) return Regime::Fails;
    if (R > 1 + tol) return Regime::Strict;
    return Regime::Exact;
}

// Concept: a balanced frontier maps each base a to an exponent e_a such
// that a^{e_a} >= T (the scale).
template <typename T>
concept FrontierLike = requires(const T& t) {
    { t.scale() } -> std::convertible_to<UInteger>;
    { t.exponent(Base{}) } -> std::convertible_to<int>;
    { t.power(Base{}) } -> std::convertible_to<UInteger>;
};

} // namespace erdos124
