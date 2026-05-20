"""Empirical conductor growth: does c(E) stabilize as E grows for fixed A,k?

For each hypothesis-meeting (A, k), compute c(E) for a sequence of balanced
frontiers E with T(E) growing, and report whether c(E) appears to be
bounded, sublinear, or linear in T(E).

This is the empirical test of the mixed-base middle-interval conjecture:
that conductor is bounded by a constant depending only on A, k.

Output is a small table — NOT a massive computation.  ~30 frontier
evaluations per case, ~10 cases.
"""

from __future__ import annotations

import sys
from fractions import Fraction
from itertools import combinations

from erdos124 import (
    gcd_all,
    powers_upto,
    reciprocal_sum,
    subset_sum_bits,
    missing_stats,
)


def balanced_frontier(bases, k, exponent_floor):
    """Build seed F(E) for the 'all e_a = exponent_floor' choice (DEGENERATE).

    This frontier is UNBALANCED in the note 28 / note 59 sense; the seed is
    dominated by the small-base contributions and the conductor is c ~ S/2
    for hypothesis-meeting A.  Kept for comparison.
    """
    terms = []
    frontier_powers = []
    for a in bases:
        e_a = exponent_floor
        for j in range(k, e_a):
            terms.append(a**j)
        frontier_powers.append(a**e_a)
    T = min(frontier_powers)
    return sorted(terms), T, sum(terms)


def balanced_T_frontier(bases, k, T):
    """Build seed F(E) for balanced frontier with e_a = ceil(log_a T).

    This is the correct asymptotic notion: each E_a = a^{e_a} is in [T, aT).
    """
    import math
    terms = []
    frontier_powers = []
    for a in bases:
        e_a = max(k + 1, int(math.ceil(math.log(T) / math.log(a))) + 1)
        # ensure a^{e_a} >= T
        while a**e_a < T:
            e_a += 1
        for j in range(k, e_a):
            terms.append(a**j)
        frontier_powers.append(a**e_a)
    return sorted(terms), min(frontier_powers), sum(terms), frontier_powers


def compute_conductor(bases, k, exponent_floor, limit_mult=2):
    terms, T, S = balanced_frontier(bases, k, exponent_floor)
    if S > 10**8:
        return None
    half = S // 2
    bits = 1
    for t in terms:
        bits |= bits << t
    c = -1
    for pos in range(half, -1, -1):
        if not (bits >> pos) & 1:
            c = pos
            break
    return (T, S, c, len(terms))


def compute_conductor_balanced_T(bases, k, T):
    terms, Tmin, S, frontier_powers = balanced_T_frontier(bases, k, T)
    if S > 5 * 10**7:
        return None
    half = S // 2
    bits = 1
    for t in terms:
        bits |= bits << t
    c = -1
    for pos in range(half, -1, -1):
        if not (bits >> pos) & 1:
            c = pos
            break
    return (Tmin, S, c, len(terms), frontier_powers)


def scan_one(bases, k, e_min=2, e_max=12):
    """Scan exponent floors for fixed (A, k); return list of (e, T, S, c, n_terms)."""
    rows = []
    for e in range(e_min, e_max + 1):
        result = compute_conductor(bases, k, e)
        if result is None:
            break
        T, S, c, n = result
        rows.append((e, T, S, c, n))
    return rows


def report_case(bases, k):
    R = reciprocal_sum(bases)
    M = sum(Fraction(1) / (b - 1).bit_length() for b in bases)  # rough Marstrand-ish
    print(f"\n=== A = {list(bases)}, k = {k} ===")
    print(f"  R(A) = sum 1/(d-1) = {R}  ({'strict' if R > 1 else 'exact' if R == 1 else 'fails'})")
    rows = scan_one(bases, k, e_min=2, e_max=15)
    if not rows:
        print("  (no rows computed)")
        return
    print(f"  {'e':>3}  {'T(E)':>12}  {'S(E)':>14}  {'c(E)':>10}  {'c/T':>8}  {'#seed':>6}")
    print(f"  {'-'*3}  {'-'*12}  {'-'*14}  {'-'*10}  {'-'*8}  {'-'*6}")
    for e, T, S, c, n in rows:
        ratio = float(c) / max(T, 1)
        print(f"  {e:>3}  {T:>12d}  {S:>14d}  {c:>10d}  {ratio:>8.4f}  {n:>6d}")

    # Detect: is c(E) stabilizing, sublinear, or linear?
    if len(rows) >= 3:
        last_c = [r[3] for r in rows[-3:]]
        last_T = [r[1] for r in rows[-3:]]
        if max(last_c) - min(last_c) <= max(2, last_c[0] // 100):
            verdict = "STABILIZING (bounded conjecture supported)"
        elif last_c[-1] < last_T[-1] / 100:
            verdict = "SUBLINEAR (c/T -> 0)"
        elif last_c[-1] > last_T[-1] * 0.1:
            verdict = "LINEAR-ish (c/T not small)"
        else:
            verdict = "INTERMEDIATE"
        print(f"  verdict: {verdict}")


def report_case_balanced_T(bases, k, T_values):
    """Report c(E) vs T for balanced frontiers E with e_a = ceil(log_a T)."""
    R = reciprocal_sum(bases)
    print(f"\n=== A = {list(bases)}, k = {k} — BALANCED-T frontier ===")
    print(f"  R(A) = {R}  ({'strict' if R > 1 else 'exact' if R == 1 else 'fails'})")
    print(f"  {'T':>8}  {'min E':>10}  {'S(E)':>12}  {'c(E)':>10}  {'c/T':>8}  {'c/sqrt(T)':>10}  {'#seed':>5}  {'frontier':>30}")
    print(f"  {'-'*8}  {'-'*10}  {'-'*12}  {'-'*10}  {'-'*8}  {'-'*10}  {'-'*5}  {'-'*30}")
    rows = []
    for T in T_values:
        result = compute_conductor_balanced_T(bases, k, T)
        if result is None:
            print(f"  {T:>8d}  (S too big — skipping)")
            continue
        Tmin, S, c, n, frontier = result
        ratio_T = float(c) / max(Tmin, 1)
        ratio_sqrtT = float(c) / max(Tmin, 1) ** 0.5
        frontier_str = str(frontier[:5]) + ("..." if len(frontier) > 5 else "")
        print(f"  {T:>8d}  {Tmin:>10d}  {S:>12d}  {c:>10d}  {ratio_T:>8.4f}  {ratio_sqrtT:>10.2f}  {n:>5d}  {frontier_str:>30}")
        rows.append((T, Tmin, S, c, n))
    # diagnose growth
    if len(rows) >= 4:
        Ts = [r[1] for r in rows]
        cs = [r[3] for r in rows]
        # Log-log slope of c vs T over last 3 rows
        import math
        if Ts[-3] > 0 and Ts[-1] > 0 and cs[-3] > 0 and cs[-1] > 0:
            slope = (math.log(cs[-1]) - math.log(cs[-3])) / (math.log(Ts[-1]) - math.log(Ts[-3]))
            print(f"  log-log slope c vs T (last 3): {slope:.3f}")
            if slope < 0.5:
                print(f"  verdict: SUBLINEAR with exponent < 1/2 (very good)")
            elif slope < 1.0:
                print(f"  verdict: SUBLINEAR with exponent {slope:.2f} (asymptotic theorem supported)")
            elif slope < 1.1:
                print(f"  verdict: NEAR-LINEAR (boundary)")
            else:
                print(f"  verdict: SUPER-LINEAR — conductor theorem fails on this frontier choice")


def main():
    cases = [
        ([3, 4, 5], 1),
        ([3, 4, 7], 1),
        ([3, 4, 7], 2),
        ([3, 4, 7], 3),
        ([3, 4, 9, 25], 2),
        ([3, 5, 7, 13], 1),
    ]
    T_values_small = [100, 300, 1000, 3000, 10000, 30000, 100000, 300000, 1000000]
    for bases, k in cases:
        if gcd_all(bases) != 1:
            continue
        report_case_balanced_T(bases, k, T_values_small)


if __name__ == "__main__":
    main()
