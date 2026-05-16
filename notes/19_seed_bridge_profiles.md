# Seed-bridge profiles

The global seed-bridge theorem remains open.  This pass makes the finite object
in that theorem explicit and reproducible.

Given bases \(A\), exponent cutoff \(k\), and a seed limit \(L\), the seed is
the finite set of powers

\[
\{d^j: d\in A,\ k\le j,\ d^j\le L\}.
\]

If the seed has total sum \(U\), it is enough to scan subset sums up to
\(\lfloor U/2\rfloor\).  If every integer from \(c+1\) to \(\lfloor U/2\rfloor\)
is represented, then complementing subsets proves the central interval

\[
[c+1,\ U-c-1].
\]

The script `scripts/seed_bridge.py` computes these profiles.  The Haskell file
`haskell/SeedBridgeProfiles.hs` verifies the arithmetic shape of the recorded
profiles:

- half-sum;
- central interval endpoints;
- central span;
- frontier length.

It does not replace the subset-sum bitset computation.  It records the finite
seed facts in a typed, auditable form after the bitset computation has produced
them.

## Checked profiles

At seed limit \(1000\) and \(k=1\), every exact-critical set with maximum base
at most \(30\) and size at most \(5\) already has a nonempty central interval.
The same profile is recorded for the strict test case \(\{3,4,5\},k=1\).

A bounded doubling search from seed limit \(1000\), with maximum seed limit
\(64000\), also finds a nonempty central interval for the same fourteen
exact-critical sets at \(k=2\).  The largest first successful seed limit in
this batch is \(4000\).

These profiles are evidence for the global seed-bridge theorem, but they are
not a proof of it.  The remaining global task is still to prove that a suitable
seed profile exists for every admissible finite \(A,k\), or to find a structural
counterexample.
