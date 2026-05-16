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

