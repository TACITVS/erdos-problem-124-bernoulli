# Finite-seed API

The finite computations now have a single Python library surface:
`scripts/finite_seed.py`.

The command-line scripts are intentionally thin:

- `scripts/seed_bridge.py` prints central-interval seed profiles;
- `scripts/residue_bridge.py` prints residue-complete seed profiles.

Both frontends use the same `FiniteSeed` object and the same exact-critical
enumeration, doubling search, denominator, and frontier helpers.  This keeps
new bridge experiments from growing as isolated one-off scripts.

## Public objects

`FiniteSeed.from_limit(bases, k, seed_limit)` records:

- the sorted absorbed powers \(d^j\), \(k\le j\), \(d^j\le L\);
- the total seed sum;
- the first unabsorbed frontier power for each base;
- the reciprocal sum of the bases.

`central_profile(...)` computes the central interval obtained from subset sums
up to half the seed sum.

`residue_profile(...)` computes residue completeness modulo a chosen modulus,
including the least representative sum for each residue.

`residue_bridge_start(profile, multiple_start)` is the API hook for the
bounded residue-bridge lemma: if a disjoint tail later proves all multiples of
the modulus from `multiple_start` onward, this function returns the resulting
full integer ray start after adding the finite seed.

## Reason for this cut

The next mathematical target is not another ad hoc scan.  It is a theorem or a
counterexample for the tail-multiple premise in the residue-bridge lemma from
`notes/20_residue_bridge_profiles.md`.  A shared API makes that target explicit:
future code should consume `FiniteSeed`, `ResidueProfile`, and
`residue_bridge_start` instead of rebuilding powers, frontiers, or denominator
logic locally.
