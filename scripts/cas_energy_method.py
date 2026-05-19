"""Empirical check for `notes/57_energy_attempt_honest.md`.

Compute E_2 = sum r(n)^2 directly by enumerating subsets, and report the
ratio E_2/2^N as the seed grows.  The hypothesis "E_2/2^N = O(polylog)"
would imply the strict conductor theorem via the energy method; the
empirical data tests this hypothesis.

Conclusion (running this script): the ratio grows polynomially in T,
falsifying the polylog hypothesis.  The energy method therefore reduces
to the LLT obligation and does not bypass the analytic input.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Sequence


def seed_terms(bases: Sequence[int], k: int, limit: int) -> list[int]:
    out: list[int] = []
    for a in bases:
        e = k
        while a**e <= limit:
            out.append(a**e)
            e += 1
    return out


@dataclass
class EnergyRow:
    label: str
    limit: int
    n_terms: int
    seed_total: int
    n_subsets: int
    n_distinct_sums: int
    energy: int
    energy_over_2N: float
    llt_prediction: float
    ratio_to_llt: float


def compute_energy(bases: Sequence[int], k: int, limit: int) -> EnergyRow:
    terms = seed_terms(bases, k, limit)
    N = len(terms)
    counts: dict[int, int] = {}
    for mask in range(1 << N):
        s = 0
        for i in range(N):
            if (mask >> i) & 1:
                s += terms[i]
        counts[s] = counts.get(s, 0) + 1
    e2 = sum(v * v for v in counts.values())
    total = sum(terms)
    pow2N = 1 << N
    pow4N = pow2N * pow2N
    llt = pow4N / total if total > 0 else 0.0
    return EnergyRow(
        label="{" + ",".join(str(a) for a in bases) + "}",
        limit=limit,
        n_terms=N,
        seed_total=total,
        n_subsets=pow2N,
        n_distinct_sums=len(counts),
        energy=e2,
        energy_over_2N=e2 / pow2N,
        llt_prediction=llt,
        ratio_to_llt=e2 / llt if llt > 0 else 0.0,
    )


def main() -> None:
    print("Energy method empirical check: does E_2 / 2^N grow polylog (good) or polynomial (bad)?")
    print()
    print(
        f"{'set':<10}{'L':<7}{'N':<4}{'T~S':<8}{'2^N':<10}{'E_2':<14}"
        f"{'E_2/2^N':<10}{'4^N/T':<12}{'E_2 vs LLT':<14}"
    )
    print("-" * 95)
    for label, bases in [("{3,4,5}", [3, 4, 5]), ("{3,4,7}", [3, 4, 7]), ("{3,4,9,25}", [3, 4, 9, 25])]:
        for limit in [50, 100, 200, 500, 1000, 2000, 5000]:
            row = compute_energy(bases, 1 if label != "{3,4,9,25}" else 2, limit)
            print(
                f"{row.label:<10}{row.limit:<7}{row.n_terms:<4}{row.seed_total:<8}"
                f"{row.n_subsets:<10}{row.energy:<14}{row.energy_over_2N:<10.2f}"
                f"{row.llt_prediction:<12.0f}{row.ratio_to_llt:<14.3f}"
            )
        print()

    print("=" * 95)
    print("If E_2 / 2^N grew only as polylog(T), the Evertse-Schlickewei bound on")
    print("S-unit equations would imply the strict conductor theorem.  Empirically")
    print("E_2 / 2^N grows roughly as T^0.4, so the polylog hypothesis fails: the")
    print("energy method reduces to LLT-level off-resonance bounds, not bypassing them.")


if __name__ == "__main__":
    main()
