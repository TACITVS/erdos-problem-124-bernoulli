# Prefix gap bridge

This note refines `notes/24_bounded_gap_bridge.md`.

## Lemma

Let $P(F)$ contain an interval $[M,M+H]$.  Let

$$p_1,\ldots,p_s$$

be the first terms of a disjoint tail.  If

$$p_j\le H+1+p_1+\cdots+p_{j-1}
\quad(1\le j\le s),$$

then adding this prefix extends the seed interval to

$$[M,M+H+p_1+\cdots+p_s].$$

If the remaining tail subset sums are unbounded and have consecutive gaps
bounded by $G$, and

$$G\le H+1+p_1+\cdots+p_s,$$

then

$$[M,\infty)\subseteq P(F\cup\{p_1,\ldots,p_s\}\cup B).$$

## Proof

The first assertion is exactly interval extension, iterated through the finite
prefix.  After the prefix has been absorbed, apply the bounded-gap bridge from
`notes/24_bounded_gap_bridge.md` to the enlarged interval and the remaining
tail $B$.

## Why this matters

This separates the local problem into two finite-looking demands:

1. a finite prefix must be absorbable by ordinary interval extension;
2. the remaining tail must have subset-sum gaps bounded by the final interval
   capacity.

For strict reciprocal-sum cases, this is a promising route because strict slack
should force Chen-Fang-Hegyvari domination after a finite prefix.

For exact-critical cases, the same capacity check can be positive, but the
remaining bounded-gap theorem is still the hard part.  In particular, a
capacity row should not be read as a proof of the required tail gap bound.

## Capacity rows now checked

`haskell/GapBridgeCertificate.hs` checks the following conditional capacities:

- binary powers: no prefix, gap bound $1$, ray starts at $0$;
- $\{3,4,5\}, k=1$: seed interval $[80,2132]$, absorb prefix $1024$,
  then a tail gap bound $2187$ would imply the ray from $80$;
- $\{3,4,7\}, k=2$ with the large local seed: absorb
  $67108864,129140163$, then a tail gap bound $268435456$ would imply the
  ray from $3982889$;
- $\{3,4,9,25\}, k=2$: no prefix is needed for the capacity inequality if a
  tail gap bound $14348907$ is supplied.

Only the binary row has a built-in tail theorem.  The other rows are explicit
targets for a future Chen-Fang-Hegyvari domination certificate.
