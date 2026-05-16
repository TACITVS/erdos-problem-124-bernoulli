"""Exact helper routines for Erdos problem 124 experiments."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from functools import reduce
from math import gcd
from typing import Iterable, Sequence


def gcd_all(values: Iterable[int]) -> int:
    return reduce(gcd, values, 0)


def reciprocal_sum(bases: Sequence[int]) -> Fraction:
    return sum((Fraction(1, d - 1) for d in bases), Fraction(0, 1))


def powers_upto(bases: Sequence[int], k: int, limit: int) -> list[int]:
    terms: list[int] = []
    for d in bases:
        p = d**k
        while p <= limit:
            terms.append(p)
            p *= d
    return sorted(terms)


def first_powers_above(bases: Sequence[int], k: int, limit: int) -> list[int]:
    out: list[int] = []
    for d in bases:
        p = d**k
        while p <= limit:
            p *= d
        out.append(p)
    return out


def subset_sum_bits_masked(terms: Iterable[int], limit: int) -> int:
    mask = (1 << (limit + 1)) - 1
    bits = 1
    for term in sorted(terms):
        if term <= limit:
            bits = (bits | (bits << term)) & mask
    return bits


def subset_sum_bits(terms: Iterable[int]) -> tuple[int, int]:
    bits = 1
    total = 0
    for term in sorted(terms):
        bits |= bits << term
        total += term
    return bits, total


def zero_positions(bits: int, limit: int) -> list[int]:
    zeros = (~bits) & ((1 << (limit + 1)) - 1)
    out: list[int] = []
    while zeros:
        low = zeros & -zeros
        out.append(low.bit_length() - 1)
        zeros ^= low
    return out


@dataclass(frozen=True)
class MissingStats:
    limit: int
    count: int
    last: int | None
    tail: tuple[int, ...]


def missing_stats(bits: int, limit: int, tail_size: int = 10) -> MissingStats:
    zeros = zero_positions(bits, limit)
    return MissingStats(
        limit=limit,
        count=len(zeros),
        last=zeros[-1] if zeros else None,
        tail=tuple(zeros[-tail_size:]),
    )


@dataclass(frozen=True)
class Interval:
    start: int
    end: int

    @property
    def span(self) -> int:
        return self.end - self.start


def longest_represented_interval(bits: int, limit: int) -> Interval:
    zeros = zero_positions(bits, limit)
    previous = -1
    best = Interval(0, -1)
    for z in zeros:
        candidate = Interval(previous + 1, z - 1)
        if candidate.span > best.span:
            best = candidate
        previous = z
    candidate = Interval(previous + 1, limit)
    if candidate.span > best.span:
        best = candidate
    return best


def conductor_by_search(bases: Sequence[int], k: int, limit: int) -> MissingStats:
    terms = powers_upto(bases, k, limit)
    bits = subset_sum_bits_masked(terms, limit)
    return missing_stats(bits, limit)


@dataclass(frozen=True)
class IntervalCertificate:
    bases: tuple[int, ...]
    k: int
    seed_limit: int
    interval: Interval
    final_span: int
    frontier: tuple[int, ...]
    extension_steps: int
    analytic_frontier: int
    reciprocal_sum: Fraction

    @property
    def ray_start(self) -> int:
        return self.interval.start


def strict_interval_certificate(
    bases: Sequence[int],
    k: int,
    seed_limit: int,
    max_steps: int = 100_000,
) -> IntervalCertificate | None:
    """Try to prove cofiniteness when the reciprocal sum is strictly > 1.

    The seed consists of all powers at most ``seed_limit``.  If its subset sums
    contain an interval that can be extended until the strict reciprocal-sum
    lower bound takes over, return a certificate proving every integer from
    ``certificate.ray_start`` onward is representable.
    """

    bases_tuple = tuple(bases)
    rsum = reciprocal_sum(bases_tuple)
    if rsum <= 1:
        raise ValueError("strict_interval_certificate requires reciprocal sum > 1")

    seed = powers_upto(bases_tuple, k, seed_limit)
    bits, total = subset_sum_bits(seed)
    interval = longest_represented_interval(bits, total)
    span = interval.span
    frontier = first_powers_above(bases_tuple, k, seed_limit)
    steps = 0

    while steps <= max_steps:
        next_term = min(frontier)
        weighted_frontier = sum(
            (Fraction(term, d - 1) for term, d in zip(frontier, bases_tuple)),
            Fraction(0, 1),
        )
        if Fraction(next_term) * (rsum - 1) >= weighted_frontier - span - 1:
            return IntervalCertificate(
                bases=bases_tuple,
                k=k,
                seed_limit=seed_limit,
                interval=interval,
                final_span=span,
                frontier=tuple(frontier),
                extension_steps=steps,
                analytic_frontier=next_term,
                reciprocal_sum=rsum,
            )

        if next_term > span + 1:
            return None

        for i, (term, d) in enumerate(zip(frontier, bases_tuple)):
            if term == next_term:
                span += next_term
                frontier[i] *= d
                steps += 1

    return None
