"""Empirical Fourier analysis for `notes/60_bernoulli_AC_deep_dive.md`.

Computes the truncated Fourier transform |hat mu_A(xi)| of multi-base
Bernoulli convolutions, and tests the L^2 integrability:

  I(T) = integral_{-T}^T |hat mu_A(xi)|^2 d xi.

L^2 (bounded I(T) as T -> infty) iff mu_A has L^2 density => AC =>
Erdos 124 conductor theorem.
"""

from __future__ import annotations

import math
import numpy as np
from typing import Sequence


def hat_mu_A_array(xis: np.ndarray, bases: Sequence[int], terms: int = 80) -> np.ndarray:
    out = np.ones_like(xis, dtype=np.float64)
    for a in bases:
        for n in range(terms):
            out *= np.cos(np.pi * xis / (a ** (n + 1)))
    return out


def L2_integral(bases: Sequence[int], T: float, n_points: int = 20000, terms: int = 80) -> float:
    xis = np.linspace(-T, T, n_points)
    vals = hat_mu_A_array(xis, bases, terms)
    return float(np.trapezoid(vals ** 2, xis))


def per_scale_decay(
    bases: Sequence[int], k_max: int = 12, n_points: int = 4000, terms: int = 80
) -> list[tuple[int, float, float]]:
    rows: list[tuple[int, float, float]] = []
    for k in range(k_max):
        lo, hi = float(2 ** k), float(2 ** (k + 1))
        xis = np.linspace(lo, hi, n_points)
        vals = hat_mu_A_array(xis, bases, terms)
        I_k = float(np.trapezoid(vals ** 2, xis))
        I_k *= 2.0
        rows.append((k, I_k, I_k / (2 ** k)))
    return rows


CATALOGUE: list[tuple[str, list[int]]] = [
    ("{3}", [3]),
    ("{4}", [4]),
    ("{3,4}", [3, 4]),
    ("{3,4,5}", [3, 4, 5]),
    ("{3,4,7}", [3, 4, 7]),
    ("{3,4,9,25}", [3, 4, 9, 25]),
    ("{3,5,7,13}", [3, 5, 7, 13]),
]


def main() -> None:
    print("== L^2 integral I(T) of |hat mu_A|^2 on [-T, T] ==")
    print()
    print(
        f"{'set':<14}{'I(10)':<10}{'I(100)':<10}{'I(1000)':<10}{'I(10000)':<12}{'I(10^4)/I(10^2)':<20}{'verdict':<20}"
    )
    print("-" * 100)
    for label, bases in CATALOGUE:
        I_vals = [L2_integral(bases, T) for T in [10.0, 100.0, 1000.0, 10000.0]]
        ratio = I_vals[3] / I_vals[1] if I_vals[1] > 0 else 0.0
        verdict = "AC (saturating)" if ratio < 1.5 else "non-AC (growing)"
        print(
            f"{label:<14}{I_vals[0]:<10.4f}{I_vals[1]:<10.4f}{I_vals[2]:<10.4f}"
            f"{I_vals[3]:<12.4f}{ratio:<20.4f}{verdict:<20}"
        )
    print()

    print("== Per-scale decay I_k = integral on [2^k, 2^{k+1}] ==")
    print()
    for label, bases in CATALOGUE:
        print(f"-- {label} --")
        rows = per_scale_decay(bases, k_max=10)
        for k, I_k, ratio in rows:
            print(f"  k={k:>3}: I_k = {I_k:<14.6e}  I_k / 2^k = {ratio:<14.6e}")
        I_ks = [r[1] for r in rows if r[1] > 1e-15]
        if len(I_ks) >= 3:
            log_I = [math.log(v) for v in I_ks]
            ks_used = list(range(len(I_ks)))
            slope = (log_I[-1] - log_I[2]) / (ks_used[-1] - ks_used[2])
            print(f"  Asymptotic slope log(I_k) vs k:  {slope:.4f} (negative = decay = AC)")
        print()


if __name__ == "__main__":
    main()
