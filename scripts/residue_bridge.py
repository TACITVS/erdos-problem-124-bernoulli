"""CLI for finite residue profiles."""

from __future__ import annotations

import argparse

from finite_seed import (
    ResidueProfile,
    ResidueSearch,
    exact_critical_sets,
    find_residue_profile,
    parse_bases,
    printable_dataclass,
    profile_modulus,
    residue_bridge_start,
    residue_profile,
)


def printable(profile: ResidueProfile, multiple_start: int | None = None) -> dict[str, object]:
    out = printable_dataclass(profile)
    if multiple_start is not None and profile.complete:
        out["bridge_start"] = residue_bridge_start(profile, multiple_start)
    return out


def printable_search(search: ResidueSearch, multiple_start: int | None = None) -> dict[str, object]:
    return {
        "bases": search.bases,
        "k": search.k,
        "modulus": search.modulus,
        "denominator_modulus": search.denominator_modulus,
        "max_seed_limit": search.max_seed_limit,
        "attempts": search.attempts,
        "found": None if search.found is None else printable(search.found, multiple_start),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bases")
    parser.add_argument("--k", type=int, default=1)
    parser.add_argument("--seed-limit", type=int, default=1000)
    parser.add_argument("--modulus", type=int)
    parser.add_argument("--modulus-denominator", action="store_true")
    parser.add_argument("--multiple-start", type=int)
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
                    ),
                    args.multiple_start,
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
                    ),
                    args.multiple_start,
                )
            )


if __name__ == "__main__":
    main()
