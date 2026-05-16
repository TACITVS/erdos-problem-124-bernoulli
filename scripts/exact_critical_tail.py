"""Small exact-critical tail calculations.

The functions here keep the arithmetic used in the proof notes explicit:
denominator-cleared weights, obstruction bounds, and the few frontier states
before a continued-fraction reduction applies.
"""

from __future__ import annotations

import argparse
from math import gcd
from typing import Iterable


def lcm(values: Iterable[int]) -> int:
    out = 1
    for value in values:
        out = out // gcd(out, value) * value
    return out


def parse_bases(text: str) -> tuple[int, ...]:
    return tuple(int(part) for part in text.split(",") if part)


def denominator_and_weights(bases: tuple[int, ...]) -> tuple[int, tuple[int, ...]]:
    denominator = lcm(base - 1 for base in bases)
    weights = tuple(denominator // (base - 1) for base in bases)
    if sum(weights) != denominator:
        raise ValueError("base set is not exact-critical")
    return denominator, weights


def obstruction_bound(bases: tuple[int, ...], k: int, conductor: int) -> int:
    denominator, weights = denominator_and_weights(bases)
    initial_powers = sum(weight * base**k for weight, base in zip(weights, bases))
    return initial_powers + 2 * denominator * conductor + denominator


def first_exponents_above(
    bases: tuple[int, ...],
    k: int,
    seed_limit: int,
) -> tuple[int, ...]:
    exponents: list[int] = []
    for base in bases:
        exp = k
        value = base**exp
        while value <= seed_limit:
            exp += 1
            value *= base
        exponents.append(exp)
    return tuple(exponents)


def frontier_states_until(
    bases: tuple[int, ...],
    start_exponents: tuple[int, ...],
    target_base: int,
    target_exponent: int,
) -> list[tuple[int, ...]]:
    exponents = list(start_exponents)
    states: list[tuple[int, ...]] = []
    target_index = bases.index(target_base)
    while exponents[target_index] < target_exponent:
        states.append(tuple(exponents))
        values = [base**exp for base, exp in zip(bases, exponents)]
        next_value = min(values)
        for i, value in enumerate(values):
            if value == next_value:
                exponents[i] += 1
    return states


def margin_for_state(
    bases: tuple[int, ...],
    weights: tuple[int, ...],
    state: tuple[int, ...],
    bound: int,
) -> int:
    values = [base**exp for base, exp in zip(bases, state)]
    next_value = min(values)
    excess = sum(weight * (value - next_value) for weight, value in zip(weights, values))
    return excess - bound


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bases", required=True)
    parser.add_argument("--k", type=int, required=True)
    parser.add_argument("--seed-limit", type=int, required=True)
    parser.add_argument("--conductor", type=int, required=True)
    parser.add_argument("--target-base", type=int, default=3)
    parser.add_argument("--target-exp", type=int, required=True)
    args = parser.parse_args()

    bases = parse_bases(args.bases)
    denominator, weights = denominator_and_weights(bases)
    bound = obstruction_bound(bases, args.k, args.conductor)
    start = first_exponents_above(bases, args.k, args.seed_limit)
    states = frontier_states_until(bases, start, args.target_base, args.target_exp)
    margins = [(state, margin_for_state(bases, weights, state, bound)) for state in states]

    print(
        {
            "bases": bases,
            "k": args.k,
            "seed_limit": args.seed_limit,
            "conductor": args.conductor,
            "denominator": denominator,
            "weights": weights,
            "obstruction_bound": bound,
            "start_exponents": start,
            "target_base": args.target_base,
            "target_exponent": args.target_exp,
            "margins": margins,
        }
    )


if __name__ == "__main__":
    main()

