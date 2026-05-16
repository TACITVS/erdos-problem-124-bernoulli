"""Finite seed-bridge profiles for Erdos 124.

The global seed-bridge theorem is still open.  This script isolates the finite
object that local certificates use: a finite seed whose subset sums cover a
central interval.
"""

from __future__ import annotations

import argparse
from dataclasses import asdict, dataclass
from fractions import Fraction
from itertools import combinations

from erdos124 import (
    first_powers_above,
    gcd_all,
    missing_stats,
    powers_upto,
    reciprocal_sum,
    subset_sum_bits_masked,
)


@dataclass(frozen=True)
class SeedBridgeProfile:
    bases: tuple[int, ...]
    k: int
    seed_limit: int
    term_count: int
    seed_sum: int
    half_sum: int
    conductor_to_half: int | None
    central_interval: tuple[int, int] | None
    central_span: int
    frontier: tuple[int, ...]
    reciprocal_sum: Fraction


def parse_bases(text: str) -> tuple[int, ...]:
    return tuple(int(part) for part in text.split(",") if part)


def central_profile(bases: tuple[int, ...], k: int, seed_limit: int) -> SeedBridgeProfile:
    seed = powers_upto(bases, k, seed_limit)
    seed_sum = sum(seed)
    half_sum = seed_sum // 2
    bits = subset_sum_bits_masked(seed, half_sum)
    stats = missing_stats(bits, half_sum)
    conductor = stats.last
    if conductor is None:
        central_interval = (0, seed_sum)
    else:
        central_interval = (conductor + 1, seed_sum - conductor - 1)
    central_span = central_interval[1] - central_interval[0]
    return SeedBridgeProfile(
        bases=bases,
        k=k,
        seed_limit=seed_limit,
        term_count=len(seed),
        seed_sum=seed_sum,
        half_sum=half_sum,
        conductor_to_half=conductor,
        central_interval=central_interval,
        central_span=central_span,
        frontier=tuple(first_powers_above(bases, k, seed_limit)),
        reciprocal_sum=reciprocal_sum(bases),
    )


def exact_critical_sets(max_base: int, max_size: int) -> list[tuple[int, ...]]:
    out: list[tuple[int, ...]] = []
    for size in range(2, max_size + 1):
        for bases in combinations(range(3, max_base + 1), size):
            if gcd_all(bases) != 1:
                continue
            if reciprocal_sum(bases) != 1:
                continue
            if all(reciprocal_sum(tuple(x for x in bases if x != d)) < 1 for d in bases):
                out.append(bases)
    return out


def printable(profile: SeedBridgeProfile) -> dict[str, object]:
    out = asdict(profile)
    out["reciprocal_sum"] = str(profile.reciprocal_sum)
    return out


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bases")
    parser.add_argument("--k", type=int, default=1)
    parser.add_argument("--seed-limit", type=int, default=10_000)
    parser.add_argument("--batch-exact", action="store_true")
    parser.add_argument("--max-base", type=int, default=30)
    parser.add_argument("--max-size", type=int, default=5)
    parser.add_argument("--limit", type=int, default=20)
    args = parser.parse_args()

    if args.batch_exact:
        cases = exact_critical_sets(args.max_base, args.max_size)[: args.limit]
    else:
        if not args.bases:
            raise SystemExit("--bases is required unless --batch-exact is used")
        cases = [parse_bases(args.bases)]

    for bases in cases:
        print(printable(central_profile(bases, args.k, args.seed_limit)))


if __name__ == "__main__":
    main()
