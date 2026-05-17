"""SymPy verification for `notes/49_resonance_decay.md`.

For each base ``a`` and modulus ``q``, computes:

- pre-period ``rho_a(q)`` and period ``pi_a(q)`` of ``a^n mod 2q``,
- the per-period geometric-mean cos factor
  ``beta_a(p, q) = prod_j |cos(pi * v_j * p / q)| ^ (1 / pi_a(q))``,
- the polynomial decay rate
  ``Delta(A, p, q) = - sum_a log(beta_a(p, q)) / log(a)``.

Cross-checks the predicted asymptotic ``|phi_A(p/q)| ~ T^{-Delta}`` against
direct numerical computation at multiple seed sizes.

Reserves human reasoning for the framing in note 49; this script does only
the mechanical orbit analysis and decay-rate computation.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Sequence

import sympy as sp


def orbit_mod(a: int, modulus: int, max_steps: int = 2000) -> tuple[list[int], int, int]:
    """Return (sequence, pre-period rho, period pi) for a^n mod modulus."""
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


def cos_pi_rational(num: int, den: int) -> sp.Expr:
    return sp.cos(sp.pi * sp.Rational(num, den))


def cycle_of(a: int, q: int) -> tuple[list[int], int, int]:
    modulus = 2 * q
    seq, rho, period = orbit_mod(a, modulus)
    if period == 0:
        cycle = seq[rho:]
    else:
        cycle = seq[rho : rho + period]
    return cycle, rho, max(period, 1)


def beta_exact(a: int, p: int, q: int) -> sp.Expr:
    """Exact geometric-mean cos factor as a SymPy expression."""
    cycle, rho, period = cycle_of(a, q)
    product = sp.Integer(1)
    for value in cycle:
        product = product * sp.Abs(cos_pi_rational(value * p, q))
    if period == 0:
        return product  # degenerate
    return product ** sp.Rational(1, period)


def beta_numeric(a: int, p: int, q: int) -> float:
    return float(beta_exact(a, p, q).evalf(30))


def delta_for(bases: Sequence[int], p: int, q: int) -> tuple[sp.Expr, float]:
    """Symbolic and numeric Delta(A, p, q)."""
    symbolic_terms: list[sp.Expr] = []
    numeric_total = 0.0
    for a in bases:
        beta = beta_exact(a, p, q)
        beta_n = float(beta.evalf(30))
        symbolic_terms.append(-sp.log(beta) / sp.log(a))
        if beta_n == 0:
            numeric_total = math.inf
        else:
            numeric_total += -math.log(beta_n) / math.log(a)
    delta_sym = sum(symbolic_terms, sp.Integer(0))
    return delta_sym, numeric_total


# ---------------------------------------------------------------------------
# Direct numerical phi_A(p/q) for cross-check.
# ---------------------------------------------------------------------------


def seed_terms(bases: Sequence[int], k: int, limit: int) -> list[tuple[int, int]]:
    out: list[tuple[int, int]] = []
    for a in bases:
        e = k
        while a**e <= limit:
            out.append((a, e))
            e += 1
    return out


def phi_numeric(bases: Sequence[int], k: int, limit: int, p: int, q: int) -> float:
    value = 1.0
    for a, e in seed_terms(bases, k, limit):
        value *= math.cos(math.pi * (a**e) * p / q)
    return abs(value)


def t_max(bases: Sequence[int], k: int, limit: int) -> int:
    return max((a**e) for a, e in seed_terms(bases, k, limit))


# ---------------------------------------------------------------------------
# Catalogue and reports.
# ---------------------------------------------------------------------------


CATALOGUE: list[tuple[str, list[int], int]] = [
    ("{3,4,7}, k=1", [3, 4, 7], 1),
    ("{3,4,9,25}, k=2", [3, 4, 9, 25], 2),
    ("{3,4,5}, k=1", [3, 4, 5], 1),
]


@dataclass
class ResonanceReport:
    p: int
    q: int
    beta_per_base: list[tuple[int, sp.Expr]]
    delta_symbolic: sp.Expr
    delta_numeric: float


def resonance_table(bases: list[int], q_max: int) -> list[ResonanceReport]:
    reports: list[ResonanceReport] = []
    for q in range(2, q_max + 1):
        for p in range(1, q):
            if math.gcd(p, q) != 1:
                continue
            betas = [(a, beta_exact(a, p, q)) for a in bases]
            delta_sym, delta_n = delta_for(bases, p, q)
            reports.append(
                ResonanceReport(
                    p=p,
                    q=q,
                    beta_per_base=betas,
                    delta_symbolic=sp.simplify(delta_sym),
                    delta_numeric=delta_n,
                )
            )
    return reports


def crosscheck_decay(
    bases: list[int],
    k: int,
    p: int,
    q: int,
    limits: list[int],
) -> list[tuple[int, float, float]]:
    """Compare empirical |phi_A(p/q)| to predicted T^{-Delta}."""
    _, delta_n = delta_for(bases, p, q)
    rows: list[tuple[int, float, float]] = []
    for limit in limits:
        emp = phi_numeric(bases, k, limit, p, q)
        T = t_max(bases, k, limit)
        if delta_n == math.inf:
            pred = 0.0
        elif T == 0:
            pred = 1.0
        else:
            pred = T ** (-delta_n)
        rows.append((limit, emp, pred))
    return rows


def main() -> None:
    print("== Per-resonance closed-form decay table ==\n")
    for label, bases, k in CATALOGUE:
        print(f"-- {label} (q <= 6) --")
        print(
            f"  {'p/q':<8} {'beta values per base':<60} {'Delta symbolic':<28} {'Delta numeric':<12}"
        )
        table = resonance_table(bases, q_max=6)
        for r in table:
            beta_strs: list[str] = []
            for a, beta in r.beta_per_base:
                beta_simpl = sp.simplify(beta)
                beta_str = str(beta_simpl)
                if len(beta_str) > 16:
                    beta_str = f"~{float(beta.evalf(20)):.4f}"
                beta_strs.append(f"a={a}:{beta_str}")
            beta_summary = ", ".join(beta_strs)
            delta_str = (
                "infty"
                if r.delta_numeric == math.inf
                else f"{float(r.delta_symbolic.evalf(20)):.6f}"
            )
            print(
                f"  {r.p}/{r.q:<6}"
                f" {beta_summary:<60}"
                f" {str(r.delta_symbolic)[:26]:<28}"
                f" {delta_str:<12}"
            )

        # Minimum non-trivial Delta.
        finite_deltas = [r.delta_numeric for r in table if r.delta_numeric != math.inf]
        if finite_deltas:
            print(f"  min finite Delta on q<=6: {min(finite_deltas):.6f}")
        print()

    print("\n== Cross-check: empirical |phi| vs T^{-Delta} ==\n")
    crosscheck_specs = [
        ("{3,4,7}, k=1", [3, 4, 7], 1, [(1, 3), (1, 4)]),
        ("{3,4,9,25}, k=2", [3, 4, 9, 25], 2, [(1, 3), (1, 4)]),
    ]
    for label, bases, k, pq_list in crosscheck_specs:
        for p, q in pq_list:
            print(f"  {label} at p/q = {p}/{q}:")
            rows = crosscheck_decay(bases, k, p, q, [100, 1000, 10000])
            print(f"    {'limit':<8} {'empirical':<18} {'predicted T^-D':<18} {'ratio':<10}")
            for limit, emp, pred in rows:
                ratio = emp / pred if pred > 0 else float("inf")
                print(f"    {limit:<8} {emp:<18.6e} {pred:<18.6e} {ratio:<10.4f}")
            print()


if __name__ == "__main__":
    main()
