"""SymPy verification for `notes/50_off_resonance_equidistribution.md`.

Checks three numerical facts referenced in note 50:

1. The integral identity ``int_0^1 log|cos(pi x)| dx = -log 2`` to high
   precision via SymPy / mpmath.

2. The per-base geometric-mean cos factor ``beta_a(p, q)`` for ``q`` up to
   40 clusters near ``1/2``, as predicted by the Birkhoff ergodic theorem
   on the doubling map.

3. For irrational ``theta`` (Liouville-disjoint examples such as
   ``1/sqrt(2)``, ``1/sqrt(3)``, ``e/10``), ``|phi_A(theta)|`` decays at
   approximately the predicted rate ``T^{-sum 1/log_2 a}``.

The note's prose is the framing; this script does the verification.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Sequence

import mpmath
import sympy as sp


# ---------------------------------------------------------------------------
# 1. Integral identity.
# ---------------------------------------------------------------------------


def integral_log_cos() -> tuple[mpmath.mpf, mpmath.mpf]:
    mpmath.mp.dps = 50
    actual = mpmath.quad(lambda t: mpmath.log(abs(mpmath.cos(mpmath.pi * t))), [0, 1])
    expected = -mpmath.log(2)
    return actual, expected


# ---------------------------------------------------------------------------
# 2. beta_a(p, q) histogram over (p, q).
# ---------------------------------------------------------------------------


def orbit_mod(a: int, modulus: int, max_steps: int = 4000) -> tuple[list[int], int, int]:
    seen: dict[int, int] = {}
    value = 1 % modulus
    sequence: list[int] = []
    for n in range(max_steps):
        if value in seen:
            return sequence, seen[value], n - seen[value]
        seen[value] = n
        sequence.append(value)
        value = (value * a) % modulus
    raise RuntimeError(f"orbit did not close for a={a}, modulus={modulus}")


def beta_numeric(a: int, p: int, q: int) -> float:
    modulus = 2 * q
    seq, rho, period = orbit_mod(a, modulus)
    if period == 0:
        cycle = seq[rho:]
        period = max(1, len(cycle))
    else:
        cycle = seq[rho : rho + period]
    product = 1.0
    for value in cycle:
        product *= abs(math.cos(math.pi * value * p / q))
    if product == 0:
        return 0.0
    return product ** (1.0 / period)


@dataclass
class BetaHistogramRow:
    bucket: str
    count: int


def beta_histogram(a: int, q_max: int) -> list[BetaHistogramRow]:
    buckets = {
        "[0.00, 0.10]": 0,
        "(0.10, 0.30]": 0,
        "(0.30, 0.45]": 0,
        "(0.45, 0.55]": 0,
        "(0.55, 0.70]": 0,
        "(0.70, 0.90]": 0,
        "(0.90, 1.00]": 0,
    }
    for q in range(2, q_max + 1):
        for p in range(1, q):
            if math.gcd(p, q) != 1:
                continue
            value = beta_numeric(a, p, q)
            if value <= 0.10:
                buckets["[0.00, 0.10]"] += 1
            elif value <= 0.30:
                buckets["(0.10, 0.30]"] += 1
            elif value <= 0.45:
                buckets["(0.30, 0.45]"] += 1
            elif value <= 0.55:
                buckets["(0.45, 0.55]"] += 1
            elif value <= 0.70:
                buckets["(0.55, 0.70]"] += 1
            elif value <= 0.90:
                buckets["(0.70, 0.90]"] += 1
            else:
                buckets["(0.90, 1.00]"] += 1
    return [BetaHistogramRow(bucket=b, count=c) for b, c in buckets.items()]


# ---------------------------------------------------------------------------
# 3. Generic |phi_A(theta)| decay vs predicted T^{-sum 1/log_2 a}.
# ---------------------------------------------------------------------------


def seed_terms(bases: Sequence[int], k: int, limit: int) -> list[tuple[int, int]]:
    out: list[tuple[int, int]] = []
    for a in bases:
        e = k
        while a**e <= limit:
            out.append((a, e))
            e += 1
    return out


def phi_numeric(bases: Sequence[int], k: int, limit: int, theta: float) -> float:
    value = 1.0
    for a, e in seed_terms(bases, k, limit):
        value *= math.cos(math.pi * (a**e) * theta)
    return abs(value)


def t_max(bases: Sequence[int], k: int, limit: int) -> int:
    return max((a**e) for a, e in seed_terms(bases, k, limit))


def density_exponent(bases: Sequence[int]) -> float:
    return sum(1.0 / math.log2(a) for a in bases)


# ---------------------------------------------------------------------------
# Reports.
# ---------------------------------------------------------------------------


def main() -> None:
    print("== 1. int_0^1 log|cos(pi x)| dx ==")
    actual, expected = integral_log_cos()
    print(f"  SymPy mpmath quad: {actual}")
    print(f"  -log 2:            {expected}")
    print(f"  difference:        {actual - expected}")
    print()

    print("== 2. beta_a(p, q) histogram for q in [2, 40] ==")
    for a in [3, 4, 5, 7]:
        print(f"  base a={a}:")
        rows = beta_histogram(a, q_max=40)
        for r in rows:
            bar = "#" * r.count
            print(f"    {r.bucket:<15} {r.count:>4}  {bar}")
        print()

    print("== 3. Generic |phi_A(theta)| vs T^{-sum 1/log_2 a} ==")
    for label, bases, k in [
        ("{3,4,7}, k=1", [3, 4, 7], 1),
        ("{3,4,9,25}, k=2", [3, 4, 9, 25], 2),
        ("{3,4,5}, k=1", [3, 4, 5], 1),
    ]:
        exp = density_exponent(bases)
        print(f"  {label}: predicted decay exponent = sum 1/log_2 a = {exp:.6f}")
        for theta_label, theta_val in [
            ("1/sqrt(2)", 1.0 / math.sqrt(2)),
            ("1/sqrt(3)", 1.0 / math.sqrt(3)),
            ("e/10", math.e / 10),
        ]:
            print(
                f"    theta = {theta_label}"
                f"  ({'limit':<7}{'#terms':<8}{'T_max':<10}{'|phi|':<14}{'T^-exp':<14}{'ratio':<10})"
            )
            for limit in [1000, 100000, 10000000]:
                phi = phi_numeric(bases, k, limit, theta_val)
                T = t_max(bases, k, limit)
                pred = T ** (-exp)
                ratio = phi / pred if pred > 0 else float("inf")
                print(
                    f"      ({limit:<7}{len(seed_terms(bases, k, limit)):<8}{T:<10}"
                    f"{phi:<14.6e}{pred:<14.6e}{ratio:<10.4f})"
                )
            print()


if __name__ == "__main__":
    main()
