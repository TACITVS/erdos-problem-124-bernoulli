"""SymPy / numpy verification for `notes/51_self_contained_34_bound.md`.

Three checks:

1. The second-moment identity ``E_theta[W_N^{(a)}(theta)^2] = N/2`` via Monte
   Carlo on uniform theta in [0,1).

2. Empirical histogram of ``|W_N|/sqrt(N)`` showing approximately Gaussian
   tails for typical theta.

3. The fourth moment ``E[W_N^4]`` compared to the trivial-pairing
   prediction ``3 N^2 / 4 + O(N)``; deviations expose non-trivial S-unit
   solutions among the orbit indices.

Reserves prose for note 51; this script does only the bookkeeping.
"""

from __future__ import annotations

import math
import random
from dataclasses import dataclass

import numpy as np


def weyl_sum_array(a: int, thetas: np.ndarray, N: int) -> np.ndarray:
    """Vectorised W_N^{(a)}(theta) over a numpy array of thetas."""
    val = np.ones_like(thetas, dtype=np.float64)
    s = np.zeros_like(thetas, dtype=np.float64)
    for _ in range(N):
        val = val * a
        s = s + np.cos(2 * np.pi * val * thetas)
    return s


@dataclass
class MomentRow:
    base: int
    N: int
    samples: int
    empirical_second: float
    predicted_second: float
    empirical_fourth: float
    predicted_fourth_trivial: float


def moment_table(bases: list[int], Ns: list[int], samples: int) -> list[MomentRow]:
    rng = np.random.default_rng(seed=2026)
    rows: list[MomentRow] = []
    for N in Ns:
        for a in bases:
            thetas = rng.uniform(0.0, 1.0, size=samples)
            w = weyl_sum_array(a, thetas, N)
            second = float(np.mean(w * w))
            fourth = float(np.mean(w ** 4))
            rows.append(
                MomentRow(
                    base=a,
                    N=N,
                    samples=samples,
                    empirical_second=second,
                    predicted_second=N / 2,
                    empirical_fourth=fourth,
                    predicted_fourth_trivial=3 * N * N / 4,
                )
            )
    return rows


def histogram_normalised(a: int, N: int, samples: int, bins: int = 12) -> list[tuple[float, float, int]]:
    rng = np.random.default_rng(seed=2025)
    thetas = rng.uniform(0.0, 1.0, size=samples)
    w = weyl_sum_array(a, thetas, N)
    norm = w / math.sqrt(N)
    counts, edges = np.histogram(norm, bins=bins, range=(-3.0, 3.0))
    out: list[tuple[float, float, int]] = []
    for i in range(bins):
        out.append((float(edges[i]), float(edges[i + 1]), int(counts[i])))
    return out


def main() -> None:
    print("== 1. Empirical second and fourth moments of W_N(a, theta) ==")
    print(
        f"  {'N':<6}{'a':<4}{'samples':<10}"
        f"{'E[W^2]':<14}{'pred N/2':<12}{'ratio':<10}"
        f"{'E[W^4]':<14}{'pred 3N^2/4':<14}{'ratio':<10}"
    )
    for row in moment_table(bases=[3, 4], Ns=[10, 20, 30, 50], samples=4000):
        ratio2 = row.empirical_second / row.predicted_second
        ratio4 = row.empirical_fourth / row.predicted_fourth_trivial
        print(
            f"  {row.N:<6}{row.base:<4}{row.samples:<10}"
            f"{row.empirical_second:<14.4f}{row.predicted_second:<12.4f}{ratio2:<10.4f}"
            f"{row.empirical_fourth:<14.4f}{row.predicted_fourth_trivial:<14.4f}{ratio4:<10.4f}"
        )
    print()

    print("== 2. Histogram of |W_N|/sqrt(N) for N=30, a=3 (4000 samples) ==")
    for lo, hi, count in histogram_normalised(a=3, N=30, samples=4000):
        bar = "#" * (count // 20)
        print(f"  [{lo:>5.2f}, {hi:>5.2f}]  {count:>5}  {bar}")
    print()
    print("Expected: approximately Gaussian (subgaussian tails) per the second-moment heuristic.")


if __name__ == "__main__":
    main()
