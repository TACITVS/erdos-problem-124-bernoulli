"""Reusable finite-seed profiles for Erdos 124.

This module is the library layer behind the seed-bridge command-line tools.
It keeps the shared finite object explicit: bases, exponent cutoff, seed limit,
the absorbed powers, and the first unabsorbed frontier powers.
"""

from __future__ import annotations

from dataclasses import asdict, dataclass
from fractions import Fraction
from itertools import combinations
from math import gcd
from typing import Iterable, Sequence

from erdos124 import (
    first_powers_above,
    gcd_all,
    missing_stats,
    powers_upto,
    reciprocal_sum,
    subset_sum_bits_masked,
)


@dataclass(frozen=True)
class FiniteSeed:
    bases: tuple[int, ...]
    k: int
    seed_limit: int
    terms: tuple[int, ...]
    seed_sum: int
    frontier: tuple[int, ...]
    reciprocal_sum: Fraction

    @classmethod
    def from_limit(cls, bases: Sequence[int], k: int, seed_limit: int) -> "FiniteSeed":
        base_tuple = tuple(bases)
        terms = tuple(powers_upto(base_tuple, k, seed_limit))
        return cls(
            bases=base_tuple,
            k=k,
            seed_limit=seed_limit,
            terms=terms,
            seed_sum=sum(terms),
            frontier=tuple(first_powers_above(base_tuple, k, seed_limit)),
            reciprocal_sum=reciprocal_sum(base_tuple),
        )

    @property
    def term_count(self) -> int:
        return len(self.terms)


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


@dataclass(frozen=True)
class SeedBridgeSearch:
    bases: tuple[int, ...]
    k: int
    min_span: int
    max_seed_limit: int
    attempts: int
    found: SeedBridgeProfile | None


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


def exact_critical_denominator(bases: Sequence[int]) -> int:
    denominator = lcm(base - 1 for base in bases)
    weights = tuple(denominator // (base - 1) for base in bases)
    if sum(weights) != denominator:
        raise ValueError(f"{tuple(bases)} is not exact-critical")
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


def initial_seed_limit(bases: Sequence[int], k: int) -> int:
    return max(base**k for base in bases)


def seed_limits_by_doubling(
    bases: Sequence[int],
    k: int,
    start_limit: int,
    max_seed_limit: int,
) -> Iterable[int]:
    seed_limit = start_limit if start_limit > 0 else initial_seed_limit(bases, k)
    while seed_limit <= max_seed_limit:
        yield seed_limit
        seed_limit *= 2


def central_profile_from_seed(seed: FiniteSeed) -> SeedBridgeProfile:
    half_sum = seed.seed_sum // 2
    bits = subset_sum_bits_masked(seed.terms, half_sum)
    stats = missing_stats(bits, half_sum)
    conductor = stats.last
    if conductor is None:
        central_interval = (0, seed.seed_sum)
    else:
        central_interval = (conductor + 1, seed.seed_sum - conductor - 1)

    return SeedBridgeProfile(
        bases=seed.bases,
        k=seed.k,
        seed_limit=seed.seed_limit,
        term_count=seed.term_count,
        seed_sum=seed.seed_sum,
        half_sum=half_sum,
        conductor_to_half=conductor,
        central_interval=central_interval,
        central_span=central_interval[1] - central_interval[0],
        frontier=seed.frontier,
        reciprocal_sum=seed.reciprocal_sum,
    )


def central_profile(bases: Sequence[int], k: int, seed_limit: int) -> SeedBridgeProfile:
    return central_profile_from_seed(FiniteSeed.from_limit(bases, k, seed_limit))


def find_seed_bridge(
    bases: Sequence[int],
    k: int,
    start_limit: int,
    max_seed_limit: int,
    min_span: int,
) -> SeedBridgeSearch:
    base_tuple = tuple(bases)
    attempts = 0
    for seed_limit in seed_limits_by_doubling(base_tuple, k, start_limit, max_seed_limit):
        attempts += 1
        profile = central_profile(base_tuple, k, seed_limit)
        if profile.central_span >= min_span:
            return SeedBridgeSearch(base_tuple, k, min_span, max_seed_limit, attempts, profile)
    return SeedBridgeSearch(base_tuple, k, min_span, max_seed_limit, attempts, None)


def rotate_residue_bits(bits: int, shift: int, modulus: int, mask: int) -> int:
    shift %= modulus
    if shift == 0:
        return bits
    return ((bits << shift) | (bits >> (modulus - shift))) & mask


def covered_residues(bits: int, modulus: int) -> tuple[int, ...]:
    return tuple(residue for residue in range(modulus) if bits & (1 << residue))


def minimal_residue_representatives(
    terms: Iterable[int],
    modulus: int,
) -> tuple[int | None, ...]:
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


def residue_profile_from_seed(
    seed: FiniteSeed,
    modulus: int,
    denominator_modulus: bool = False,
) -> ResidueProfile:
    if modulus <= 0:
        raise ValueError("modulus must be positive")

    mask = (1 << modulus) - 1
    bits = 1
    first_completion_index: int | None = None
    first_completion_term: int | None = None

    for index, term in enumerate(seed.terms, start=1):
        bits |= rotate_residue_bits(bits, term, modulus, mask)
        bits &= mask
        if bits == mask and first_completion_index is None:
            first_completion_index = index
            first_completion_term = term

    covered = covered_residues(bits, modulus)
    covered_set = set(covered)
    missing = tuple(residue for residue in range(modulus) if residue not in covered_set)
    representatives = minimal_residue_representatives(seed.terms, modulus)
    finite_representatives = tuple(value for value in representatives if value is not None)

    return ResidueProfile(
        bases=seed.bases,
        k=seed.k,
        seed_limit=seed.seed_limit,
        modulus=modulus,
        denominator_modulus=denominator_modulus,
        term_count=seed.term_count,
        seed_sum=seed.seed_sum,
        covered_count=len(covered),
        complete=len(covered) == modulus,
        first_completion_index=first_completion_index,
        first_completion_term=first_completion_term,
        max_residue_representative=max(finite_representatives) if finite_representatives else None,
        residue_representatives=representatives,
        missing_residues=missing,
        frontier=seed.frontier,
        reciprocal_sum=seed.reciprocal_sum,
    )


def residue_profile(
    bases: Sequence[int],
    k: int,
    seed_limit: int,
    modulus: int,
    denominator_modulus: bool = False,
) -> ResidueProfile:
    return residue_profile_from_seed(
        FiniteSeed.from_limit(bases, k, seed_limit),
        modulus,
        denominator_modulus,
    )


def find_residue_profile(
    bases: Sequence[int],
    k: int,
    start_limit: int,
    max_seed_limit: int,
    modulus: int,
    denominator_modulus: bool,
) -> ResidueSearch:
    base_tuple = tuple(bases)
    attempts = 0
    for seed_limit in seed_limits_by_doubling(base_tuple, k, start_limit, max_seed_limit):
        attempts += 1
        profile = residue_profile(base_tuple, k, seed_limit, modulus, denominator_modulus)
        if profile.complete:
            return ResidueSearch(
                bases=base_tuple,
                k=k,
                modulus=modulus,
                denominator_modulus=denominator_modulus,
                max_seed_limit=max_seed_limit,
                attempts=attempts,
                found=profile,
            )

    return ResidueSearch(
        bases=base_tuple,
        k=k,
        modulus=modulus,
        denominator_modulus=denominator_modulus,
        max_seed_limit=max_seed_limit,
        attempts=attempts,
        found=None,
    )


def profile_modulus(
    bases: Sequence[int],
    fixed_modulus: int | None,
    use_denominator: bool,
) -> tuple[int, bool]:
    if use_denominator:
        return exact_critical_denominator(bases), True
    if fixed_modulus is None:
        raise ValueError("provide --modulus or --modulus-denominator")
    return fixed_modulus, False


def residue_bridge_start(profile: ResidueProfile, multiple_start: int) -> int:
    """Return the ray start given a theorem for multiples of ``profile.modulus``.

    If every multiple of ``profile.modulus`` from ``multiple_start`` onward is
    representable by a disjoint tail, and this profile is complete, then every
    integer from the returned value onward is represented after adding the seed.
    """

    if not profile.complete or profile.max_residue_representative is None:
        raise ValueError("residue bridge requires a complete residue profile")
    return multiple_start + profile.max_residue_representative


def printable_dataclass(value: object) -> dict[str, object]:
    out = asdict(value)
    for key, item in tuple(out.items()):
        if isinstance(item, Fraction):
            out[key] = str(item)
    return out
