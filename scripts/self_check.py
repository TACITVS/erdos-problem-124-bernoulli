"""Quick regression checks for the research scripts."""

from __future__ import annotations

from cas_checks import exact_critical_sets
from erdos124 import conductor_by_search, reciprocal_sum, strict_interval_certificate


def main() -> None:
    assert reciprocal_sum((3, 4, 7)) == 1
    assert reciprocal_sum((3, 4, 5)) > 1

    assert conductor_by_search((3, 4, 7), 1, 100_000).last == 581
    assert conductor_by_search((3, 5, 7, 13), 1, 100_000).last == 112
    assert conductor_by_search((3, 4, 5), 1, 100_000).last == 79

    exact = exact_critical_sets(30, 5)
    assert len(exact) == 14
    assert (3, 4, 7) in exact
    assert (3, 5, 7, 13) in exact

    cert = strict_interval_certificate((3, 4, 5), 1, 1000)
    assert cert is not None
    assert cert.ray_start == 80

    print("self-checks passed")


if __name__ == "__main__":
    main()

