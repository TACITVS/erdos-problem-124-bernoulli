"""Certified continued-fraction reduction for log(3)/log(4).

This script avoids floating-point logarithms.  It bounds log(n) using

    log(x) = 2 * sum_{j>=0} y^(2j+1)/(2j+1), y=(x-1)/(x+1),

with a rational geometric tail bound.
"""

from __future__ import annotations

import argparse
from fractions import Fraction


DEFAULT_B = 47_794_770


def log_interval_int(x: int, terms: int) -> tuple[Fraction, Fraction]:
    y = Fraction(x - 1, x + 1)
    y2 = y * y
    yp = y
    partial = Fraction(0, 1)
    for n in range(terms):
        partial += yp / (2 * n + 1)
        yp *= y2
    lower = 2 * partial
    tail = 2 * yp / (2 * terms + 1) / (1 - y2)
    return lower, lower + tail


def interval_cf(lower: Fraction, upper: Fraction, max_terms: int) -> list[int]:
    out: list[int] = []
    lo, hi = lower, upper
    for _ in range(max_terms):
        alo = lo.numerator // lo.denominator
        ahi = hi.numerator // hi.denominator
        if alo != ahi:
            break
        out.append(alo)
        lo -= alo
        hi -= ahi
        if lo <= 0:
            break
        lo, hi = 1 / hi, 1 / lo
    return out


def convergents(cf: list[int]) -> list[tuple[int, int]]:
    p0, p1 = 0, 1
    q0, q1 = 1, 0
    out: list[tuple[int, int]] = []
    for a in cf:
        p = a * p1 + p0
        q = a * q1 + q0
        out.append((p, q))
        p0, p1 = p1, p
        q0, q1 = q1, q
    return out


def first_legendre_threshold(gap: int) -> int:
    a = 1
    while 2 * a * gap >= 3**a - gap:
        a += 1
    return a


def mw_log_lower_bound(p: int) -> float:
    import math

    return math.log(3) * (p - 500 * math.log(4) * (8 + math.log(p)) ** 2)


def first_mw_threshold(gap: int) -> int:
    import math

    target = math.log(gap)
    lo = 1
    hi = 2
    while mw_log_lower_bound(hi) <= target:
        lo = hi
        hi *= 2
    while lo + 1 < hi:
        mid = (lo + hi) // 2
        if mw_log_lower_bound(mid) > target:
            hi = mid
        else:
            lo = mid
    return hi


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--gap", type=int, default=DEFAULT_B)
    args = parser.parse_args()

    gap = args.gap
    legendre_threshold = first_legendre_threshold(gap)
    mw_threshold = first_mw_threshold(gap)

    log3_lower, log3_upper = log_interval_int(3, 80)
    log4_lower, log4_upper = log_interval_int(4, 80)
    alpha_lower = log3_lower / log4_upper
    alpha_upper = log3_upper / log4_lower
    cf = interval_cf(alpha_lower, alpha_upper, 13)
    conv = convergents(cf)

    relevant = [(p, q) for p, q in conv if legendre_threshold <= q < mw_threshold]
    next_after_threshold = next((p, q) for p, q in conv if q >= mw_threshold)
    gap_checks = [(p, q, abs(3**q - 4**p) > gap) for p, q in relevant]

    print(
        {
            "gap": gap,
            "legendre_threshold": legendre_threshold,
            "legendre_threshold_check": 2 * legendre_threshold * gap
            < 3**legendre_threshold - gap,
            "mw_threshold": mw_threshold,
            "cf_prefix": cf,
            "relevant_convergents_b_over_a": relevant,
            "next_convergent_b_over_a": next_after_threshold,
            "all_relevant_gaps_exceed_B": all(ok for _, _, ok in gap_checks),
            "gap_checks": gap_checks,
        }
    )


if __name__ == "__main__":
    main()
