"""SymPy verification for `notes/53_sidon_subgaussian.md`.

Three checks:

1. Density-exponent margin ``sum 1/log_2 a - 1`` for every hypothesis-meeting
   catalogue entry; must be strictly positive.

2. Classical Sidon constant upper bound ``C(q) <= pi/arcsin(1/q)`` for various
   lacunarity ratios.

3. Naive closure-condition check
   ``C_max^2 < (sum 1/log_2 a - 1)^2 / (2e)`` for each case.

Reserves prose for note 53; CAS does the mechanical verification.
"""

from __future__ import annotations

import math
import sympy as sp


CATALOGUE: list[tuple[str, list[int]]] = [
    ("{3,4,7}", [3, 4, 7]),
    ("{3,4,9,25}", [3, 4, 9, 25]),
    ("{3,4,5}", [3, 4, 5]),
    ("{3,5,7,13}", [3, 5, 7, 13]),
    ("{3,6,9,12,21,45,89}", [3, 6, 9, 12, 21, 45, 89]),
]


def density_exponent(bases: list[int]) -> float:
    return sum(1 / math.log2(a) for a in bases)


def reciprocal_sum(bases: list[int]) -> sp.Rational:
    return sum((sp.Rational(1, a - 1) for a in bases), sp.Rational(0))


def sidon_constant_upper(q: int) -> float:
    """C(q) <= pi/arcsin(1/q) (classical Sidon)."""
    return math.pi / math.asin(1.0 / q)


def closure_passes(bases: list[int]) -> tuple[bool, float, float]:
    """Check if C_max^2 < (sum 1/log_2 a - 1)^2 / (2e)."""
    margin = density_exponent(bases) - 1
    rhs = (margin ** 2) / (2 * math.e)
    c_max_sq = max(sidon_constant_upper(a) ** 2 for a in bases)
    return c_max_sq < rhs, c_max_sq, rhs


def main() -> None:
    print("== 1. Density-exponent margins ==")
    print(f"  {'set':<26}{'R(A)':<14}{'sum 1/log_2 a':<18}{'margin':<10}")
    for label, bases in CATALOGUE:
        R = reciprocal_sum(bases)
        d = density_exponent(bases)
        margin = d - 1
        print(f"  {label:<26}{str(R):<14}{d:<18.6f}{margin:<10.6f}")
    print()

    print("== 2. Sidon constant upper bound C(q) <= pi/arcsin(1/q) ==")
    print(f"  {'q':<6}{'C(q) upper bound':<18}{'C(q)^2':<18}")
    for q in [3, 4, 5, 6, 7, 9, 11, 13, 25]:
        c = sidon_constant_upper(q)
        print(f"  {q:<6}{c:<18.4f}{c*c:<18.4f}")
    print()

    print("== 3. Naive Sidon-bound closure ==")
    print(f"  {'set':<26}{'C_max^2':<14}{'(margin)^2/(2e)':<18}{'passes?':<10}")
    for label, bases in CATALOGUE:
        passes, cmsq, rhs = closure_passes(bases)
        verdict = "YES" if passes else "no"
        print(f"  {label:<26}{cmsq:<14.4f}{rhs:<18.6f}{verdict:<10}")
    print()
    print("Note: the naive Sidon constants are not sharp enough for any local")
    print("case to pass.  This is the analytic gap discussed in section 7 of")
    print("note 53.  Sharper constants or the S-unit fourth-moment route are")
    print("needed to close.")


if __name__ == "__main__":
    main()
