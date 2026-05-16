"""Certified continued-fraction reduction for log(3)/log(4).

This script avoids floating-point logarithms.  It bounds log(n) using

    log(x) = 2 * sum_{j>=0} y^(2j+1)/(2j+1), y=(x-1)/(x+1),

with a rational geometric tail bound.
"""

from __future__ import annotations

from fractions import Fraction


B = 47_794_770
MW_THRESHOLD_A = 293_904


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


def small_frontier_margins() -> list[tuple[tuple[int, int, int], int]]:
    states = [
        (17, 13, 10),
        (17, 14, 10),
        (18, 14, 10),
        (18, 15, 10),
        (18, 15, 11),
        (19, 15, 11),
        (19, 16, 11),
    ]
    out: list[tuple[tuple[int, int, int], int]] = []
    for a, b, c in states:
        e3, e4, e7 = 3**a, 4**b, 7**c
        t = min(e3, e4, e7)
        g = 3 * (e3 - t) + 2 * (e4 - t) + (e7 - t)
        out.append(((a, b, c), g - B))
    return out


def main() -> None:
    log3_lower, log3_upper = log_interval_int(3, 80)
    log4_lower, log4_upper = log_interval_int(4, 80)
    alpha_lower = log3_lower / log4_upper
    alpha_upper = log3_upper / log4_lower
    cf = interval_cf(alpha_lower, alpha_upper, 13)
    conv = convergents(cf)

    relevant = [(p, q) for p, q in conv if 20 <= q < MW_THRESHOLD_A]
    next_after_threshold = next((p, q) for p, q in conv if q >= MW_THRESHOLD_A)
    gap_checks = [(p, q, abs(3**q - 4**p) > B) for p, q in relevant]

    print(
        {
            "B": B,
            "large_a_threshold": 20,
            "large_a_threshold_check": 2 * 20 * B < 3**20 - B,
            "cf_prefix": cf,
            "relevant_convergents_b_over_a": relevant,
            "next_convergent_b_over_a": next_after_threshold,
            "all_relevant_gaps_exceed_B": all(ok for _, _, ok in gap_checks),
            "gap_checks": gap_checks,
            "small_frontier_margins_G_minus_B": small_frontier_margins(),
        }
    )


if __name__ == "__main__":
    main()

