"""SymPy verification for `notes/48_characteristic_function_bound.md`.

Computes the characteristic function

    phi_A(theta) = prod_{a in A, k <= n < N_a} cos(pi * a^n * theta)

at resonance points theta = p/q with q small, both exactly via modular
arithmetic and numerically via floating-point sweep.  The exact and
numerical values must agree.

The script also reports the maximum of |phi_A(theta)| on a sampled grid
across [0.01, 0.5], to confirm the empirical decay claimed in the note.

Reserves human reasoning for the framing in note 48; this script does only
the bookkeeping.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Sequence

import numpy as np
import sympy as sp


def seed_terms(bases: Sequence[int], k: int, limit: int) -> list[tuple[int, int]]:
    out: list[tuple[int, int]] = []
    for a in bases:
        e = k
        while a**e <= limit:
            out.append((a, e))
            e += 1
    return out


def factor_count(bases: Sequence[int], k: int, limit: int) -> dict[int, int]:
    counts: dict[int, int] = {a: 0 for a in bases}
    for a, _ in seed_terms(bases, k, limit):
        counts[a] += 1
    return counts


# ---------------------------------------------------------------------------
# Exact closed-form values of |phi| at theta = p/q via modular cos.
# ---------------------------------------------------------------------------


def cos_pi_rational(num: int, den: int) -> sp.Expr:
    """Return cos(pi * num / den) as an exact SymPy value."""
    return sp.cos(sp.pi * sp.Rational(num, den))


def phi_exact_at_rational(
    bases: Sequence[int], k: int, limit: int, p: int, q: int
) -> sp.Expr:
    """Exact |phi_A(p/q)| as a SymPy expression in radicals."""
    if q == 0:
        raise ValueError("q must be nonzero")
    value = sp.Integer(1)
    for a, e in seed_terms(bases, k, limit):
        power = a**e
        # cos(pi * power * p / q) reduces modulo 2 via floor.
        num_mod = (power * p) % (2 * q)
        c = cos_pi_rational(num_mod, q)
        value = value * c
    return sp.Abs(value)


def phi_numeric(bases: Sequence[int], k: int, limit: int, theta: float) -> float:
    value = 1.0
    for a, e in seed_terms(bases, k, limit):
        value *= math.cos(math.pi * (a**e) * theta)
    return abs(value)


# ---------------------------------------------------------------------------
# Per-base modular product formulas: the closed form for each resonance is
# determined by the residues a^n mod q.
# ---------------------------------------------------------------------------


def per_base_resonance_factor(
    a: int, k: int, limit: int, p: int, q: int
) -> tuple[sp.Expr, int]:
    """Return (|product over n of cos(pi a^n p / q)|, count of n).

    Computed exactly via SymPy radicals.
    """
    value = sp.Integer(1)
    count = 0
    e = k
    while a**e <= limit:
        num_mod = ((a**e) * p) % (2 * q)
        value = value * cos_pi_rational(num_mod, q)
        count += 1
        e += 1
    return sp.Abs(value), count


# ---------------------------------------------------------------------------
# Reporting tables.
# ---------------------------------------------------------------------------


@dataclass(frozen=True)
class ResonanceRow:
    label: str
    p: int
    q: int
    closed_form: sp.Expr
    numeric: float


CATALOGUE: list[tuple[str, list[int], int]] = [
    ("{3,4,7}, k=1", [3, 4, 7], 1),
    ("{3,4,9,25}, k=2", [3, 4, 9, 25], 2),
    ("{3,4,5}, k=1", [3, 4, 5], 1),
]


def resonances_up_to(q_max: int) -> list[tuple[int, int]]:
    out: list[tuple[int, int]] = []
    for q in range(2, q_max + 1):
        for p in range(1, q):
            if math.gcd(p, q) == 1:
                out.append((p, q))
    return out


def report_case(
    label: str, bases: list[int], k: int, limit: int, q_max: int
) -> None:
    print(f"\n== {label}, seed limit {limit} ==")
    counts = factor_count(bases, k, limit)
    print(f"  base counts: {counts}")
    print(f"  total terms: {sum(counts.values())}")

    print(f"  resonances with q <= {q_max}:")
    print(
        f"    {'p/q':<8} {'closed form':<28} {'numeric':<16} {'match?':<8}"
    )
    for p, q in resonances_up_to(q_max):
        closed = phi_exact_at_rational(bases, k, limit, p, q)
        closed_n = float(closed.evalf())
        numeric = phi_numeric(bases, k, limit, p / q)
        match = abs(closed_n - numeric) < 1e-9
        closed_str = sp.nsimplify(closed, [sp.sqrt(2), sp.sqrt(3), sp.sqrt(5)]).__str__()
        if len(closed_str) > 26:
            closed_str = f"{closed_n:.6e}"
        print(
            f"    {p}/{q:<6} {closed_str:<28} {numeric:<16.6e}"
            f" {'yes' if match else 'NO':<8}"
        )

    # Empirical maximum on [0.01, 0.5] (no rational point exactly hit).
    grid = np.linspace(0.011, 0.499, 4000)
    vals = np.array([phi_numeric(bases, k, limit, t) for t in grid])
    print(
        f"  empirical max |phi| on [0.011, 0.499] (4000-pt grid): {vals.max():.6e}"
    )


def density_target(bases: list[int], k: int, limit: int) -> float:
    """1 / sigma where sigma = sqrt(sum a^{2n} / 4)."""
    variance = 0.0
    for a, e in seed_terms(bases, k, limit):
        variance += (a**e) ** 2 / 4
    return 1.0 / math.sqrt(variance)


def report_density_target(label: str, bases: list[int], k: int, limits: list[int]) -> None:
    print(f"\n== Gaussian density target 1/sigma for {label} ==")
    print(f"  {'limit':<10} {'1/sigma':<14}")
    for limit in limits:
        print(f"  {limit:<10} {density_target(bases, k, limit):<14.6e}")


def main() -> None:
    for label, bases, k in CATALOGUE:
        for limit in [100, 1000, 10000]:
            report_case(label, bases, k, limit, q_max=6)
        report_density_target(label, bases, k, [100, 1000, 10000])


if __name__ == "__main__":
    main()
