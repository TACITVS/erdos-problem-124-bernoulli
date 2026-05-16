"""Quick regression checks for the research scripts."""

from __future__ import annotations

from cas_checks import exact_critical_sets
from cf_near_collision import DEFAULT_B, convergents, interval_cf, log_interval_int
from erdos124 import conductor_by_search, reciprocal_sum, strict_interval_certificate
from exact_critical_tail import (
    denominator_and_weights,
    first_exponents_above,
    obstruction_bound,
)
from finite_seed import central_profile, find_seed_bridge, residue_profile
from hypothesis_minimal import is_hypothesis_minimal


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

    log3_lower, log3_upper = log_interval_int(3, 80)
    log4_lower, log4_upper = log_interval_int(4, 80)
    cf = interval_cf(log3_lower / log4_upper, log3_upper / log4_lower, 13)
    conv = convergents(cf)
    relevant = [(p, q) for p, q in conv if 20 <= q < 293_904]
    assert DEFAULT_B == 47_794_770
    assert relevant == [
        (19, 24),
        (23, 29),
        (42, 53),
        (485, 612),
        (527, 665),
        (24727, 31202),
        (25254, 31867),
        (150997, 190537),
    ]
    assert denominator_and_weights((3, 4, 9, 25)) == (24, (12, 8, 3, 1))
    assert obstruction_bound((3, 4, 9, 25), 2, 452_099) == 21_701_880
    assert first_exponents_above((3, 4, 9, 25), 2, 10_000_000) == (15, 12, 8, 6)
    assert is_hypothesis_minimal((3, 4, 7))
    assert is_hypothesis_minimal((3, 4, 9, 25))
    assert not is_hypothesis_minimal((3, 4, 7, 13))
    bridge = central_profile((3, 4, 7), 1, 1000)
    assert bridge.conductor_to_half == 581
    assert bridge.central_interval == (582, 1249)
    assert bridge.frontier == (2187, 1024, 2401)
    bridge_search = find_seed_bridge((3, 4, 7), 2, 1000, 64_000, 0)
    assert bridge_search.found is not None
    assert bridge_search.attempts == 2
    assert bridge_search.found.seed_limit == 2000
    assert bridge_search.found.central_interval == (1415, 1426)
    residue = residue_profile((3, 4, 7), 1, 1000, 6, True)
    assert residue.complete
    assert residue.first_completion_index == 3
    assert residue.first_completion_term == 7
    assert residue.max_residue_representative == 14
    exact_residue = residue_profile((3, 4, 9, 25), 1, 1000, 24, True)
    assert exact_residue.complete
    assert exact_residue.first_completion_index == 6
    assert exact_residue.first_completion_term == 25
    assert exact_residue.max_residue_representative == 59

    print("self-checks passed")


if __name__ == "__main__":
    main()
