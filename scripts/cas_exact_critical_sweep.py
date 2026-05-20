"""Counterexample hunt + I(infinity) pattern search for exact-critical Erdos 124 sets.

For each exact-critical (R=1) base set A with max base <= 30 and size <= 6
(33 cases), runs the C++ binary cpp/bernoulli_fourier.exe to compute
I(T) = integral_{-T}^T |hat mu_A|^2 d xi at multiple T values, then looks for
patterns in the saturation value I(infinity).
"""

from __future__ import annotations

import math
import statistics
import subprocess
import sys
from dataclasses import dataclass
from fractions import Fraction
from functools import reduce
from itertools import combinations
from math import gcd
from pathlib import Path
from typing import Sequence


BINARY = Path("cpp/bernoulli_fourier.exe").resolve()

# Ensure the mingw64 OpenMP DLL is on PATH for subprocess invocations.
import os
_MINGW = r"C:\msys64\mingw64\bin"
if os.path.isdir(_MINGW) and _MINGW not in os.environ.get("PATH", ""):
    os.environ["PATH"] = _MINGW + os.pathsep + os.environ.get("PATH", "")


def gcd_all(xs):
    return reduce(gcd, xs)


def enumerate_exact_critical(max_base: int = 30, max_size: int = 6):
    cases = []
    for size in range(2, max_size + 1):
        for combo in combinations(range(3, max_base + 1), size):
            if gcd_all(combo) != 1:
                continue
            R = sum(Fraction(1, a - 1) for a in combo)
            if R == 1:
                cases.append(combo)
    return cases


def run_binary(bases, T):
    bases_str = ",".join(str(b) for b in bases)
    cmd = [str(BINARY), f"--bases={bases_str}", f"--T={T:g}"]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=600)
    except subprocess.TimeoutExpired:
        return None
    for line in result.stdout.splitlines():
        if "I(T)=" in line:
            try:
                return float(line.split("I(T)=")[1].split()[0])
            except (IndexError, ValueError):
                return None
    return None


@dataclass
class Row:
    bases: tuple
    R: Fraction
    dim_sum: float
    n_bases: int
    support: float
    I_T1: float
    I_T2: float
    I_T3: float
    ratio_2_to_3: float


def support_length(bases):
    return sum(a / (a - 1) for a in bases)


def dim_sum(bases):
    return sum(1.0 / math.log2(a) for a in bases)


def pearson(xs, ys):
    n = len(xs)
    if n < 2:
        return 0.0
    mx = sum(xs) / n
    my = sum(ys) / n
    num = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    dx = math.sqrt(sum((x - mx) ** 2 for x in xs))
    dy = math.sqrt(sum((y - my) ** 2 for y in ys))
    return num / (dx * dy) if dx * dy > 0 else 0.0


def main():
    if not BINARY.exists():
        print(f"binary not found: {BINARY}; build with cpp/bernoulli_fourier.cpp", file=sys.stderr)
        return 1

    cases = enumerate_exact_critical(max_base=30, max_size=6)
    print(f"# Exact-critical sets to test: {len(cases)}")
    print()

    Ts = [1e4, 1e5, 1e6]
    rows = []
    for i, combo in enumerate(cases):
        R = sum(Fraction(1, a - 1) for a in combo)
        ds = dim_sum(combo)
        sup = support_length(combo)
        I_vals = [run_binary(combo, T) for T in Ts]
        if any(v is None for v in I_vals):
            print(f"  {list(combo)}: timeout or parse error, skipping")
            continue
        I1, I2, I3 = I_vals
        ratio = I3 / I2 if I2 > 0 else 0.0
        row = Row(combo, R, ds, len(combo), sup, I1, I2, I3, ratio)
        rows.append(row)
        flag = " !!!" if abs(ratio - 1.0) > 0.05 else ""
        print(
            f"  [{i+1:2d}/{len(cases)}] {list(combo)}  "
            f"I(1e4)={I1:.4f}  I(1e5)={I2:.4f}  I(1e6)={I3:.4f}  "
            f"ratio={ratio:.4f}{flag}"
        )

    print()
    print("=" * 80)
    print(f"== Pattern analysis on {len(rows)} cases ==")
    print()

    sorted_rows = sorted(rows, key=lambda r: r.I_T3)
    print(f"{'A':<35}  {'|A|':>4}  {'dim_sum':>8}  {'support':>10}  {'I(1e6)':>10}  {'ratio':>8}")
    print("-" * 90)
    for r in sorted_rows:
        print(
            f"{str(list(r.bases)):<35}  {r.n_bases:>4}  {r.dim_sum:>8.4f}  "
            f"{r.support:>10.4f}  {r.I_T3:>10.4f}  {r.ratio_2_to_3:>8.4f}"
        )

    print()
    I_vals = [r.I_T3 for r in rows]
    print(f"I(1e6) mean = {statistics.mean(I_vals):.4f}")
    print(f"I(1e6) stdev = {statistics.stdev(I_vals):.4f}")
    print(f"I(1e6) min = {min(I_vals):.4f}")
    print(f"I(1e6) max = {max(I_vals):.4f}")
    print()

    print("Pearson correlation of I(1e6) with:")
    print(f"  |A|                                = {pearson([r.n_bases for r in rows], I_vals):.4f}")
    print(f"  dim_sum (sum 1/log_2 a)            = {pearson([r.dim_sum for r in rows], I_vals):.4f}")
    print(f"  support (sum a/(a-1))              = {pearson([r.support for r in rows], I_vals):.4f}")
    print(f"  max(A)                             = {pearson([max(r.bases) for r in rows], I_vals):.4f}")
    print(f"  min(A)                             = {pearson([min(r.bases) for r in rows], I_vals):.4f}")
    print(f"  1/support                          = {pearson([1.0 / r.support for r in rows], I_vals):.4f}")
    print(f"  log(support)                       = {pearson([math.log(r.support) for r in rows], I_vals):.4f}")
    print()

    counterexamples = [r for r in rows if abs(r.ratio_2_to_3 - 1.0) > 0.01]
    if counterexamples:
        print(f"!!! POTENTIAL COUNTEREXAMPLES (ratio I(1e6)/I(1e5) deviates from 1 by >1%): {len(counterexamples)}")
        for r in counterexamples:
            print(f"  {list(r.bases)}  ratio={r.ratio_2_to_3:.6f}  (I(1e5)={r.I_T2:.4f}, I(1e6)={r.I_T3:.4f})")
    else:
        print("** No counterexamples: all hypothesis-meeting exact-critical sets saturate. **")

    return 0


if __name__ == "__main__":
    sys.exit(main())
