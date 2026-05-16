"""Reproduce bounded benchmark searches for Erdos problem 124."""

from __future__ import annotations

from erdos124 import conductor_by_search, powers_upto, reciprocal_sum


BENCHMARKS = [
    ((3, 4, 7), 1, 100_000),
    ((3, 5, 7, 13), 1, 100_000),
    ((3, 6, 7, 13, 21), 1, 100_000),
    ((3, 4, 5), 1, 100_000),
    ((3, 4, 7), 2, 50_000_000),
]


def main() -> None:
    for bases, k, limit in BENCHMARKS:
        stats = conductor_by_search(bases, k, limit)
        print(
            {
                "bases": bases,
                "k": k,
                "limit": limit,
                "reciprocal_sum": str(reciprocal_sum(bases)),
                "terms": len(powers_upto(bases, k, limit)),
                "missing_count": stats.count,
                "last_missing": stats.last,
                "tail": stats.tail,
            }
        )


if __name__ == "__main__":
    main()

