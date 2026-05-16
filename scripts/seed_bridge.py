"""CLI for finite central-interval seed profiles."""

from __future__ import annotations

import argparse

from finite_seed import (
    SeedBridgeProfile,
    SeedBridgeSearch,
    central_profile,
    exact_critical_sets,
    find_seed_bridge,
    parse_bases,
    printable_dataclass,
)


def printable(profile: SeedBridgeProfile) -> dict[str, object]:
    return printable_dataclass(profile)


def printable_search(search: SeedBridgeSearch) -> dict[str, object]:
    return {
        "bases": search.bases,
        "k": search.k,
        "min_span": search.min_span,
        "max_seed_limit": search.max_seed_limit,
        "attempts": search.attempts,
        "found": None if search.found is None else printable(search.found),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bases")
    parser.add_argument("--k", type=int, default=1)
    parser.add_argument("--seed-limit", type=int, default=10_000)
    parser.add_argument("--batch-exact", action="store_true")
    parser.add_argument("--max-base", type=int, default=30)
    parser.add_argument("--max-size", type=int, default=5)
    parser.add_argument("--limit", type=int, default=20)
    parser.add_argument("--search", action="store_true")
    parser.add_argument("--max-seed-limit", type=int, default=1_000_000)
    parser.add_argument("--min-span", type=int, default=0)
    args = parser.parse_args()

    if args.batch_exact:
        cases = exact_critical_sets(args.max_base, args.max_size)[: args.limit]
    else:
        if not args.bases:
            raise SystemExit("--bases is required unless --batch-exact is used")
        cases = [parse_bases(args.bases)]

    for bases in cases:
        if args.search:
            print(
                printable_search(
                    find_seed_bridge(
                        bases,
                        args.k,
                        args.seed_limit,
                        args.max_seed_limit,
                        args.min_span,
                    )
                )
            )
        else:
            print(printable(central_profile(bases, args.k, args.seed_limit)))


if __name__ == "__main__":
    main()
