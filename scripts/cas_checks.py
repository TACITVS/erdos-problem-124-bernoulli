"""SymPy checks for algebraic and Egyptian-fraction side conditions."""

from __future__ import annotations

from itertools import combinations

import sympy as sp


def reciprocal_sum_sympy(bases: tuple[int, ...]) -> sp.Rational:
    return sum((sp.Rational(1, d - 1) for d in bases), sp.Rational(0))


def exact_critical_sets(max_base: int, max_size: int) -> list[tuple[int, ...]]:
    out: list[tuple[int, ...]] = []
    for size in range(2, max_size + 1):
        for combo in combinations(range(3, max_base + 1), size):
            if sp.gcd_list(combo) != 1:
                continue
            if reciprocal_sum_sympy(combo) != 1:
                continue
            if all(reciprocal_sum_sympy(tuple(x for x in combo if x != d)) < 1 for d in combo):
                out.append(combo)
    return out


def brown_frontier_deficit_formula(size: int) -> sp.Expr:
    """Return the symbolic k>=1 frontier surplus expression.

    The expression is

        sum((E_i - q_i)/(d_i - 1)) - (T - 1),

    where E_i is the first unused power for base d_i, q_i=d_i^k is the first
    allowed power, and T is the next term.  Substituting E_i >= T gives the
    lower bound T*(sum 1/(d_i-1) - 1) + 1 - sum(q_i/(d_i-1)).
    """

    T = sp.Symbol("T", positive=True, integer=True)
    d = sp.symbols(f"d1:{size + 1}", integer=True, positive=True)
    q = sp.symbols(f"q1:{size + 1}", integer=True, positive=True)
    return sp.simplify(
        T * (sum(sp.Rational(1, 1) / (di - 1) for di in d) - 1)
        + 1
        - sum(qi / (di - 1) for qi, di in zip(q, d))
    )


def main() -> None:
    print("benchmark reciprocal sums")
    for bases in [(3, 4, 7), (3, 5, 7, 13), (3, 6, 7, 13, 21), (3, 4, 5)]:
        print(bases, reciprocal_sum_sympy(bases), sp.factorint(sp.ilcm(*[d - 1 for d in bases])))

    print()
    print("exact critical sets with max_base=30, max_size=5")
    exact = exact_critical_sets(30, 5)
    for combo in exact[:50]:
        print(combo)
    print(f"shown={min(50, len(exact))} total={len(exact)}")

    print()
    print("symbolic k>=1 frontier lower-bound surplus for r=3")
    print(brown_frontier_deficit_formula(3))


if __name__ == "__main__":
    main()

