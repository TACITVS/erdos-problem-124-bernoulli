"""SymPy / numpy verification for `notes/52_fourth_moment_sunit.md`.

Two checks:

1. Empirical Monte Carlo of E[W^4] for several local cases, comparing to the
   trivial-pairing prediction ``3 N^2 / 4``.  The ratio should be ``1 + o(1)``
   as ``N`` grows (the S-unit contribution being lower order).

2. Exhaustive enumeration of non-trivial S-unit solutions
   ``sum eps_i a_i^{n_i} = 0`` for several base sets and modest ``n_max``.
   Reports the count to confirm Evertse-Schlickewei polynomial growth.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Iterable

import numpy as np


def weyl_array(bases: list[int], k: int, limit: int, thetas: np.ndarray) -> np.ndarray:
    s = np.zeros_like(thetas)
    for a in bases:
        e = k
        val = a**e
        while val <= limit:
            s = s + np.cos(2 * np.pi * val * thetas)
            val *= a
    return s


def seed_term_count(bases: list[int], k: int, limit: int) -> int:
    n = 0
    for a in bases:
        e = k
        while a**e <= limit:
            n += 1
            e += 1
    return n


@dataclass
class MomentRow:
    label: str
    bases: tuple[int, ...]
    k: int
    limit: int
    n_terms: int
    empirical_second: float
    empirical_fourth: float
    predicted_fourth: float


def monte_carlo_moments(
    bases: list[int], k: int, limits: list[int], samples: int = 4000
) -> list[MomentRow]:
    rng = np.random.default_rng(seed=2026)
    rows: list[MomentRow] = []
    for limit in limits:
        thetas = rng.uniform(0.0, 1.0, size=samples)
        W = weyl_array(bases, k, limit, thetas)
        N = seed_term_count(bases, k, limit)
        emp2 = float(np.mean(W * W))
        emp4 = float(np.mean(W ** 4))
        pred = 3 * N * N / 4
        rows.append(
            MomentRow(
                label="{" + ",".join(str(a) for a in bases) + "}",
                bases=tuple(bases),
                k=k,
                limit=limit,
                n_terms=N,
                empirical_second=emp2,
                empirical_fourth=emp4,
                predicted_fourth=pred,
            )
        )
    return rows


def enumerate_sunit_solutions(
    bases: list[int], k: int, n_max: int
) -> list[tuple[tuple[int, int, int], ...]]:
    """Enumerate non-trivial solutions sum eps_i a_i^{n_i} = 0 of length 4
    with eps_i in {+-1}, a_i in bases, n_i in [k, n_max].

    Returns sorted list of unique solutions; each solution is a sorted tuple
    of (sign, base, exponent) triples.
    """
    signed_powers = [
        (sign, a, e, sign * a**e)
        for a in bases
        for e in range(k, n_max + 1)
        for sign in (-1, 1)
    ]

    pair_sums: dict[int, list[tuple[tuple[int, int, int], tuple[int, int, int]]]] = {}
    for i, (s1, a1, e1, v1) in enumerate(signed_powers):
        for s2, a2, e2, v2 in signed_powers[i + 1 :]:
            total = v1 + v2
            pair_sums.setdefault(total, []).append(
                ((s1, a1, e1), (s2, a2, e2))
            )

    solutions: set[tuple[tuple[int, int, int], ...]] = set()
    for target, pair_list in pair_sums.items():
        complement = pair_sums.get(-target, [])
        if not complement:
            continue
        for pair1 in pair_list:
            for pair2 in complement:
                combined = pair1 + pair2
                normalized = tuple(sorted(combined))
                if _is_trivial(normalized):
                    continue
                solutions.add(normalized)

    return sorted(solutions)


def _is_trivial(quadruple: tuple[tuple[int, int, int], ...]) -> bool:
    groups: dict[tuple[int, int], int] = {}
    for sign, a, e in quadruple:
        groups[(a, e)] = groups.get((a, e), 0) + sign
    return all(v == 0 for v in groups.values())


def main() -> None:
    print("== 1. Empirical fourth moments of W ==\n")
    for label, bases, k, limits in [
        ("{3,4}", [3, 4], 1, [10, 100, 1000, 10000]),
        ("{3,4,7}", [3, 4, 7], 1, [10, 100, 1000, 10000]),
        ("{3,4,9,25}", [3, 4, 9, 25], 2, [100, 1000, 10000, 100000]),
    ]:
        print(f"-- {label}, k={k} --")
        print(
            f"  {'limit':<8}{'N':<6}{'E[W^2]':<12}{'E[W^4]':<14}{'3 N^2/4':<14}{'ratio':<10}"
        )
        for row in monte_carlo_moments(bases, k, limits):
            ratio = row.empirical_fourth / row.predicted_fourth if row.predicted_fourth > 0 else float("inf")
            print(
                f"  {row.limit:<8}{row.n_terms:<6}"
                f"{row.empirical_second:<12.4f}{row.empirical_fourth:<14.4f}"
                f"{row.predicted_fourth:<14.4f}{ratio:<10.4f}"
            )
        print()

    print("\n== 2. Non-trivial S-unit solutions enumeration ==\n")
    for label, bases, k, n_max in [
        ("{3,4}", [3, 4], 0, 12),
        ("{3,4}", [3, 4], 0, 16),
        ("{3,4,7}", [3, 4, 7], 1, 8),
        ("{3,4,9,25}", [3, 4, 9, 25], 2, 8),
    ]:
        print(f"-- {label}, k={k}, n_max={n_max} --")
        sols = enumerate_sunit_solutions(bases, k, n_max)
        print(f"  count of non-trivial S-unit solutions: {len(sols)}")
        for sol in sols[:6]:
            terms = [
                f"{'+' if s > 0 else '-'}{a}^{e}"
                for (s, a, e) in sol
            ]
            value_check = sum(s * a**e for (s, a, e) in sol)
            display = " ".join(terms)
            print(f"    {display} = {value_check}")
        if len(sols) > 6:
            print(f"    ... ({len(sols) - 6} more)")
        print()


if __name__ == "__main__":
    main()
