"""Enumerate hypothesis-minimal base sets.

A base set is hypothesis-minimal if it satisfies the Erdos-124 hypotheses and
every one-element deletion fails at least one hypothesis.  By the reduction
lemma in notes/13_reduction_lemmas.md, any counterexample has such a subset.
"""

from __future__ import annotations

import argparse
from itertools import combinations
from math import gcd
from typing import Iterable

from erdos124 import reciprocal_sum


def gcd_all(values: Iterable[int]) -> int:
    out = 0
    for value in values:
        out = gcd(out, value)
    return out


def satisfies_hypotheses(bases: tuple[int, ...]) -> bool:
    return gcd_all(bases) == 1 and reciprocal_sum(bases) >= 1


def is_hypothesis_minimal(bases: tuple[int, ...]) -> bool:
    if not satisfies_hypotheses(bases):
        return False
    for index in range(len(bases)):
        sub = bases[:index] + bases[index + 1 :]
        if satisfies_hypotheses(sub):
            return False
    return True


def enumerate_sets(max_base: int, max_size: int) -> list[tuple[int, ...]]:
    out: list[tuple[int, ...]] = []
    for size in range(2, max_size + 1):
        for bases in combinations(range(3, max_base + 1), size):
            if is_hypothesis_minimal(bases):
                out.append(bases)
    return out


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-base", type=int, default=30)
    parser.add_argument("--max-size", type=int, default=6)
    parser.add_argument("--limit", type=int, default=50)
    args = parser.parse_args()

    sets = enumerate_sets(args.max_base, args.max_size)
    for bases in sets[: args.limit]:
        print(bases, reciprocal_sum(bases))
    print(f"shown={min(args.limit, len(sets))} total={len(sets)}")


if __name__ == "__main__":
    main()

