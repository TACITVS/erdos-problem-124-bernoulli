"""Produce a strict reciprocal-sum interval certificate."""

from __future__ import annotations

import argparse

from erdos124 import strict_interval_certificate


def parse_bases(text: str) -> tuple[int, ...]:
    return tuple(int(part) for part in text.split(",") if part)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bases", default="3,4,5")
    parser.add_argument("--k", type=int, default=1)
    parser.add_argument("--seed-limit", type=int, default=1000)
    args = parser.parse_args()

    cert = strict_interval_certificate(parse_bases(args.bases), args.k, args.seed_limit)
    if cert is None:
        raise SystemExit("no certificate found")

    print(cert)
    print(f"proves all n >= {cert.ray_start}")


if __name__ == "__main__":
    main()

