"""Enumerate small minimal reciprocal-sum candidates.

This helps identify computational test cases.  A set is minimal here if it has
gcd 1, reciprocal sum at least 1, and removing any base makes the reciprocal
sum less than 1.
"""

from __future__ import annotations

import argparse
from itertools import combinations

from erdos124 import gcd_all, reciprocal_sum


def minimal_candidates(
    max_base: int,
    max_size: int,
    exact_only: bool = False,
) -> list[tuple[int, ...]]:
    out: list[tuple[int, ...]] = []
    bases = range(3, max_base + 1)
    for size in range(2, max_size + 1):
        for combo in combinations(bases, size):
            if gcd_all(combo) != 1:
                continue
            rsum = reciprocal_sum(combo)
            if exact_only and rsum != 1:
                continue
            if rsum < 1:
                continue
            if all(reciprocal_sum(tuple(x for x in combo if x != d)) < 1 for d in combo):
                out.append(combo)
    return out


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-base", type=int, default=30)
    parser.add_argument("--max-size", type=int, default=6)
    parser.add_argument("--exact-only", action="store_true")
    parser.add_argument("--limit", type=int, default=100)
    args = parser.parse_args()

    candidates = minimal_candidates(args.max_base, args.max_size, args.exact_only)
    for combo in candidates[: args.limit]:
        print(combo, reciprocal_sum(combo))
    print(f"shown={min(len(candidates), args.limit)} total={len(candidates)}")


if __name__ == "__main__":
    main()
