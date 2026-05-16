"""Finite residue profiles for seed-bridge searches.

The full seed-bridge theorem needs interval information, not only congruence
information.  Still, residue completeness is a useful structural cut: after
clearing the exact-critical denominators, a finite seed that realizes every
residue modulo that denominator can be separated from the remaining quotient
problem.
"""

from __future__ import annotations

import argparse
from dataclasses import asdict, dataclass
from fractions import Fraction
from itertools import combinations
from math import gcd
from typing import Iterable

from erdos124 import first_powers_above, gcd_all, powers_upto, reciprocal_sum


@dataclass(frozen=True)
class ResidueProfile:
    bases: tuple[int, ...]
    k: int
    seed_limit: int
    modulus: int
    denominator_modulus: bool
    term_count: int
    seed_sum: int
    covered_count: int
    complete: bool
    first_completion_index: int | None
    first_completion_term: int | None
    max_residue_representative: int | None
    residue_representatives: tuple[int | None, ...]
    missing_residues: tuple[int, ...]
    frontier: tuple[int, ...]
    reciprocal_sum: Fraction


@dataclass(frozen=True)
class ResidueSearch:
    bases: tuple[int, ...]
    k: int
    modulus: int
    denominator_modulus: bool
    max_seed_limit: int
    attempts: int
    found: ResidueProfile | None


def parse_bases(text: str) -> tuple[int, ...]:
    return tuple(int(part) for part in text.split(",") if part)


def lcm(values: Iterable[int]) -> int:
    out = 1
    for value in values:
        out = out // gcd(out, value) * value
    return out


def exact_critical_denominator(bases: tuple[int, ...]) -> int:
    denominator = lcm(base - 1 for base in bases)
    weights = tuple(denominator // (base - 1) for base in bases)
    if sum(weights) != denominator:
        raise ValueError(f"{bases} is not exact-critical")
    return denominator


def exact_critical_sets(max_base: int, max_size: int) -> list[tuple[int, ...]]:
    out: list[tuple[int, ...]] = []
    for size in range(2, max_size + 1):
        for bases in combinations(range(3, max_base + 1), size):
            if gcd_all(bases) != 1:
                continue
            if reciprocal_sum(bases) != 1:
                continue
            if all(reciprocal_sum(tuple(x for x in bases if x != base)) < 1 for base in bases):
                out.append(bases)
    return out


def rotate_residue_bits(bits: int, shift: int, modulus: int, mask: int) -> int:
    shift %= modulus
    if shift == 0:
        return bits
    return ((bits << shift) | (bits >> (modulus - shift))) & mask


def covered_residues(bits: int, modulus: int) -> tuple[int, ...]:
    return tuple(residue for residue in range(modulus) if bits & (1 << residue))


def minimal_residue_representatives(terms: Iterable[int], modulus: int) -> tuple[int | None, ...]:
    representatives: list[int | None] = [None] * modulus
    representatives[0] = 0
    for term in terms:
        next_representatives = representatives.copy()
        shift = term % modulus
        for residue, value in enumerate(representatives):
            if value is None:
                continue
            next_residue = (residue + shift) % modulus
            candidate = value + term
            known = next_representatives[next_residue]
            if known is None or candidate < known:
                next_representatives[next_residue] = candidate
        representatives = next_representatives
    return tuple(representatives)


def residue_profile(
    bases: tuple[int, ...],
    k: int,
    seed_limit: int,
    modulus: int,
    denominator_modulus: bool = False,
) -> ResidueProfile:
    if modulus <= 0:
        raise ValueError("modulus must be positive")

    mask = (1 << modulus) - 1
    full = mask
    bits = 1
    seed = powers_upto(bases, k, seed_limit)
    completion_index: int | None = None
    completion_term: int | None = None

    for index, term in enumerate(seed, start=1):
        bits |= rotate_residue_bits(bits, term, modulus, mask)
        bits &= mask
        if bits == full and completion_index is None:
            completion_index = index
            completion_term = term

    covered = covered_residues(bits, modulus)
    covered_set = set(covered)
    missing = tuple(residue for residue in range(modulus) if residue not in covered_set)
    representatives = minimal_residue_representatives(seed, modulus)
    finite_representatives = tuple(value for value in representatives if value is not None)
    return ResidueProfile(
        bases=bases,
        k=k,
        seed_limit=seed_limit,
        modulus=modulus,
        denominator_modulus=denominator_modulus,
        term_count=len(seed),
        seed_sum=sum(seed),
        covered_count=len(covered),
        complete=len(covered) == modulus,
        first_completion_index=completion_index,
        first_completion_term=completion_term,
        max_residue_representative=max(finite_representatives) if finite_representatives else None,
        residue_representatives=representatives,
        missing_residues=missing,
        frontier=tuple(first_powers_above(bases, k, seed_limit)),
        reciprocal_sum=reciprocal_sum(bases),
    )


def initial_seed_limit(bases: tuple[int, ...], k: int) -> int:
    return max(base**k for base in bases)


def find_residue_profile(
    bases: tuple[int, ...],
    k: int,
    start_limit: int,
    max_seed_limit: int,
    modulus: int,
    denominator_modulus: bool,
) -> ResidueSearch:
    if start_limit <= 0:
        start_limit = initial_seed_limit(bases, k)

    attempts = 0
    seed_limit = start_limit
    while seed_limit <= max_seed_limit:
        attempts += 1
        profile = residue_profile(bases, k, seed_limit, modulus, denominator_modulus)
        if profile.complete:
            return ResidueSearch(
                bases=bases,
                k=k,
                modulus=modulus,
                denominator_modulus=denominator_modulus,
                max_seed_limit=max_seed_limit,
                attempts=attempts,
                found=profile,
            )
        seed_limit *= 2

    return ResidueSearch(
        bases=bases,
        k=k,
        modulus=modulus,
        denominator_modulus=denominator_modulus,
        max_seed_limit=max_seed_limit,
        attempts=attempts,
        found=None,
    )


def profile_modulus(
    bases: tuple[int, ...],
    fixed_modulus: int | None,
    use_denominator: bool,
) -> tuple[int, bool]:
    if use_denominator:
        return exact_critical_denominator(bases), True
    if fixed_modulus is None:
        raise ValueError("provide --modulus or --modulus-denominator")
    return fixed_modulus, False


def printable(profile: ResidueProfile) -> dict[str, object]:
    out = asdict(profile)
    out["reciprocal_sum"] = str(profile.reciprocal_sum)
    return out


def printable_search(search: ResidueSearch) -> dict[str, object]:
    return {
        "bases": search.bases,
        "k": search.k,
        "modulus": search.modulus,
        "denominator_modulus": search.denominator_modulus,
        "max_seed_limit": search.max_seed_limit,
        "attempts": search.attempts,
        "found": None if search.found is None else printable(search.found),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bases")
    parser.add_argument("--k", type=int, default=1)
    parser.add_argument("--seed-limit", type=int, default=1000)
    parser.add_argument("--modulus", type=int)
    parser.add_argument("--modulus-denominator", action="store_true")
    parser.add_argument("--batch-exact", action="store_true")
    parser.add_argument("--max-base", type=int, default=30)
    parser.add_argument("--max-size", type=int, default=5)
    parser.add_argument("--limit", type=int, default=20)
    parser.add_argument("--search", action="store_true")
    parser.add_argument("--max-seed-limit", type=int, default=1_000_000)
    args = parser.parse_args()

    if args.batch_exact:
        cases = exact_critical_sets(args.max_base, args.max_size)[: args.limit]
    else:
        if not args.bases:
            raise SystemExit("--bases is required unless --batch-exact is used")
        cases = [parse_bases(args.bases)]

    for bases in cases:
        modulus, denominator_modulus = profile_modulus(
            bases,
            args.modulus,
            args.modulus_denominator,
        )
        if args.search:
            print(
                printable_search(
                    find_residue_profile(
                        bases,
                        args.k,
                        args.seed_limit,
                        args.max_seed_limit,
                        modulus,
                        denominator_modulus,
                    )
                )
            )
        else:
            print(
                printable(
                    residue_profile(
                        bases,
                        args.k,
                        args.seed_limit,
                        modulus,
                        denominator_modulus,
                    )
                )
            )


if __name__ == "__main__":
    main()
