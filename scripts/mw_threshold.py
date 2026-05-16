"""Threshold for the Mignotte-Waldschmidt 3^p versus 4^q lower bound."""

from __future__ import annotations

import math


def mw_log_lower_bound(p: int) -> float:
    return math.log(3) * (p - 500 * math.log(4) * (8 + math.log(p)) ** 2)


def first_p_for_gap(gap: int) -> int:
    target = math.log(gap)
    lo = 1
    hi = 2
    while mw_log_lower_bound(hi) <= target:
        lo = hi
        hi *= 2
    while lo + 1 < hi:
        mid = (lo + hi) // 2
        if mw_log_lower_bound(mid) > target:
            hi = mid
        else:
            lo = mid
    return hi


def derivative_positive_from(p: int) -> bool:
    # Derivative of the inner expression
    # p - 500 log(4)(8+log p)^2.
    return 1 - 1000 * math.log(4) * (8 + math.log(p)) / p > 0


def main() -> None:
    gap = 47_794_770
    p0 = first_p_for_gap(gap)
    print({"gap": gap, "first_p": p0, "log_lower_bound": mw_log_lower_bound(p0)})
    print({"previous_p": p0 - 1, "log_lower_bound": mw_log_lower_bound(p0 - 1)})
    print({"derivative_positive_at_first_p": derivative_positive_from(p0)})


if __name__ == "__main__":
    main()

