"""Simulate exact-critical interval extension after a finite central interval."""

from __future__ import annotations

import argparse
from fractions import Fraction

from erdos124 import (
    first_powers_above,
    missing_stats,
    powers_upto,
    reciprocal_sum,
    subset_sum_bits_masked,
)


def parse_bases(text: str) -> tuple[int, ...]:
    return tuple(int(part) for part in text.split(",") if part)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bases", default="3,4,7")
    parser.add_argument("--k", type=int, default=2)
    parser.add_argument("--seed-limit", type=int, default=50_000_000)
    parser.add_argument("--conductor", type=int)
    parser.add_argument("--steps", type=int, default=1000)
    args = parser.parse_args()

    bases = parse_bases(args.bases)
    rsum = reciprocal_sum(bases)
    if rsum != 1:
        raise SystemExit(f"expected exact-critical reciprocal sum, got {rsum}")

    seed = powers_upto(bases, args.k, args.seed_limit)
    seed_sum = sum(seed)
    half = seed_sum // 2

    if args.conductor is None:
        bits = subset_sum_bits_masked(seed, half)
        conductor = missing_stats(bits, half).last
        if conductor is None:
            conductor = -1
    else:
        conductor = args.conductor

    # By symmetry of finite subset sums, checking up to seed_sum//2 proves the
    # central interval [conductor+1, seed_sum-conductor-1].
    interval_start = conductor + 1
    interval_end = seed_sum - conductor - 1
    span = interval_end - interval_start
    frontier = first_powers_above(bases, args.k, args.seed_limit)
    weighted = sum(
        (Fraction(term, d - 1) for term, d in zip(frontier, bases)),
        Fraction(0, 1),
    )
    invariant = weighted - 1 - span

    min_margin: tuple[int, int, int, tuple[int, ...]] | None = None
    for step in range(args.steps):
        next_term = min(frontier)
        margin = span + 1 - next_term
        if min_margin is None or margin < min_margin[2]:
            min_margin = (step, next_term, margin, tuple(frontier))
        if margin < 0:
            print("failed")
            print({"step": step, "next_term": next_term, "margin": margin})
            return
        for i, (term, d) in enumerate(zip(frontier, bases)):
            if term == next_term:
                span += next_term
                frontier[i] *= d

    print(
        {
            "bases": bases,
            "k": args.k,
            "seed_limit": args.seed_limit,
            "seed_sum": seed_sum,
            "conductor_to_half": conductor,
            "initial_interval": (interval_start, interval_end),
            "initial_span": interval_end - interval_start,
            "invariant": str(invariant),
            "steps": args.steps,
            "min_margin": min_margin,
        }
    )


if __name__ == "__main__":
    main()

