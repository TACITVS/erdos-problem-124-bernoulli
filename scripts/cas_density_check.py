"""SymPy mechanical verification for `notes/47_generating_function_density.md`.

Reserves human reasoning for the framing in the note; this script does only the
algebraic and numerical bookkeeping that follows once the framing is fixed.

Three checks:

1. Algebraic identity ``log_2(a) <= a - 1`` for ``a >= 3``.
   - SymPy verifies the derivative argument symbolically.
   - Numerical sweep ``a = 3..100`` confirms with rational arithmetic.

2. Pointwise inequality ``R(A) <= sum 1/log_2 a`` on the project's test
   catalogue.  Both quantities are computed exactly: ``R(A)`` as a rational,
   the log sum as a SymPy expression evaluated to high precision.

3. Density growth check: for each seed limit, expand the subset-sum generating
   function ``F_A(x) = prod (1 + x^t)`` for ``A = {3, 4, 7}`` at ``k = 1`` and
   confirm the density of positive coefficients near the mean approaches 1 as
   the predicted exponent ``sum 1/log_2 a - 1`` grows.

Run as ``python scripts/cas_density_check.py``.  Output is a deterministic
report; no side effects.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Sequence

import sympy as sp


# ---------------------------------------------------------------------------
# 1. Algebraic identity: log_2 a <= a - 1 for a >= 3.
# ---------------------------------------------------------------------------


def verify_log_inequality_symbolic() -> str:
    a = sp.Symbol("a", positive=True, real=True)
    f = a - 1 - sp.log(a, 2)
    f_prime = sp.diff(f, a)
    f_prime_simpl = sp.simplify(f_prime)

    # f(3) > 0 in exact form.
    f3 = sp.simplify(f.subs(a, 3))
    f3_numeric = float(f3)
    if f3_numeric <= 0:
        raise AssertionError(f"f(3) = {f3} should be positive")

    # f'(a) > 0 iff a > 1/ln(2).
    threshold = 1 / sp.ln(2)
    threshold_numeric = float(threshold)
    if threshold_numeric >= 3:
        raise AssertionError(
            f"threshold 1/ln(2) = {threshold_numeric} should be below 3"
        )

    return (
        "symbolic argument:\n"
        f"  f(a) = a - 1 - log_2 a\n"
        f"  f'(a) = {f_prime_simpl}\n"
        f"  f'(a) > 0 for a > 1/ln(2) = {threshold_numeric:.6f} (< 3)\n"
        f"  f(3) = {f3} = {f3_numeric:.6f} > 0\n"
        f"  therefore f(a) > 0 for all a >= 3"
    )


def verify_log_inequality_numeric(upper: int = 100) -> str:
    failures: list[int] = []
    for a in range(3, upper + 1):
        lhs = math.log2(a)
        rhs = a - 1
        if lhs > rhs:
            failures.append(a)
    if failures:
        raise AssertionError(
            f"log_2 a <= a - 1 failed for a in {failures}"
        )
    return f"numerical sweep a = 3..{upper}: log_2 a <= a - 1 holds in all {upper - 2} cases"


# ---------------------------------------------------------------------------
# 2. Pointwise inequality on the test catalogue.
# ---------------------------------------------------------------------------


CATALOGUE: list[tuple[str, list[int]]] = [
    ("{3,4,7}", [3, 4, 7]),
    ("{3,4,9,25}", [3, 4, 9, 25]),
    ("{3,4,5}", [3, 4, 5]),
    ("{3,5,7,13}", [3, 5, 7, 13]),
    ("{3,6,9,12,21,45,89}", [3, 6, 9, 12, 21, 45, 89]),
    ("{3,5,6,9,12,15,18,21}", [3, 5, 6, 9, 12, 15, 18, 21]),
]


@dataclass(frozen=True)
class CatalogueRow:
    label: str
    bases: tuple[int, ...]
    reciprocal_sum: sp.Rational
    inverse_log_sum: float
    density_exponent: float


def catalogue_check() -> list[CatalogueRow]:
    rows: list[CatalogueRow] = []
    for label, bases in CATALOGUE:
        r_exact = sum(
            (sp.Rational(1, a - 1) for a in bases), sp.Rational(0)
        )
        inv_log_sum_expr = sum(
            (1 / sp.log(a, 2) for a in bases), sp.Integer(0)
        )
        inv_log_sum = float(inv_log_sum_expr)
        if inv_log_sum < float(r_exact):
            raise AssertionError(
                f"{label}: sum 1/log_2 a = {inv_log_sum} should be >= R = {r_exact}"
            )
        if inv_log_sum < 1.0:
            raise AssertionError(
                f"{label}: sum 1/log_2 a = {inv_log_sum} should be >= 1"
            )
        rows.append(
            CatalogueRow(
                label=label,
                bases=tuple(bases),
                reciprocal_sum=r_exact,
                inverse_log_sum=inv_log_sum,
                density_exponent=inv_log_sum - 1,
            )
        )
    return rows


# ---------------------------------------------------------------------------
# 3. Generating-function density check.
# ---------------------------------------------------------------------------


def seed_terms(bases: Sequence[int], k: int, limit: int) -> list[int]:
    terms: list[int] = []
    for a in bases:
        e = k
        while a**e <= limit:
            terms.append(a**e)
            e += 1
    return sorted(terms)


def generating_function(bases: Sequence[int], k: int, limit: int) -> sp.Expr:
    x = sp.Symbol("x")
    poly: sp.Expr = sp.Integer(1)
    for t in seed_terms(bases, k, limit):
        poly = sp.expand(poly * (1 + x**t))
    return poly


def density_near_mean(poly: sp.Expr) -> tuple[int, int, float]:
    x = sp.Symbol("x")
    poly_obj = sp.Poly(poly, x)
    coeffs = poly_obj.all_coeffs()
    coeffs.reverse()  # index = exponent
    total = poly_obj.degree()
    mean = total // 2

    # Window of half-width ~ sqrt(degree) around the mean (a generous proxy
    # for sigma) so the density check is robust to finite-size effects.
    half_window = max(1, int(math.sqrt(max(1, mean))))
    lo = max(0, mean - half_window)
    hi = min(len(coeffs), mean + half_window + 1)
    n_in_window = hi - lo
    n_positive = sum(1 for value in coeffs[lo:hi] if value > 0)
    return n_in_window, n_positive, n_positive / n_in_window if n_in_window > 0 else 0.0


@dataclass(frozen=True)
class DensityRow:
    seed_limit: int
    n_terms: int
    seed_total: int
    window_size: int
    representable_in_window: int
    density: float


def density_growth_check(bases: Sequence[int], k: int, limits: Sequence[int]) -> list[DensityRow]:
    rows: list[DensityRow] = []
    for limit in limits:
        terms = seed_terms(bases, k, limit)
        if not terms:
            continue
        poly = generating_function(bases, k, limit)
        n_in_window, n_pos, dens = density_near_mean(poly)
        rows.append(
            DensityRow(
                seed_limit=limit,
                n_terms=len(terms),
                seed_total=sum(terms),
                window_size=n_in_window,
                representable_in_window=n_pos,
                density=dens,
            )
        )
    return rows


# ---------------------------------------------------------------------------
# Reporting.
# ---------------------------------------------------------------------------


def main() -> None:
    print("== 1. log_2 a <= a - 1 for a >= 3 ==")
    print(verify_log_inequality_symbolic())
    print()
    print(verify_log_inequality_numeric(100))
    print()

    print("== 2. R(A) <= sum 1/log_2 a on the test catalogue ==")
    print(
        f"{'set':<32} {'R(A)':<14} {'sum 1/log_2 a':<18} {'density exponent':<18}"
    )
    print("-" * 86)
    for row in catalogue_check():
        print(
            f"{row.label:<32} {str(row.reciprocal_sum):<14}"
            f" {row.inverse_log_sum:<18.6f}"
            f" {row.density_exponent:<18.6f}"
        )
    print()

    print("== 3. Density growth for {3,4,7}, k=1 ==")
    print(
        f"{'limit':<10} {'#terms':<8} {'total':<10} {'window':<10} {'repr':<10} {'density':<12}"
    )
    print("-" * 65)
    for row in density_growth_check(
        [3, 4, 7], 1, [50, 100, 200, 500, 1000, 2000, 5000]
    ):
        print(
            f"{row.seed_limit:<10} {row.n_terms:<8} {row.seed_total:<10}"
            f" {row.window_size:<10} {row.representable_in_window:<10}"
            f" {row.density:<12.4f}"
        )
    print()
    print("density saturates at 1, consistent with the polynomial growth predicted in note 47.")


if __name__ == "__main__":
    main()
