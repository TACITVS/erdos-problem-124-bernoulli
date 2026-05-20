# Clean proof or counterexample standard

The goal is not to win by making the finite search larger.  A useful computation
may suggest a lemma, verify a finite residue table, or check a finite hypothesis
inside a theorem, but the mathematical target is one of:

1. a clean proof that the hypotheses imply cofiniteness for every $k\ge 1$;
2. a clean counterexample, preferably with an infinite obstruction that can be
   described algebraically.

## What counts as proof here

An acceptable proof should have:

- explicit lemmas with quantified hypotheses;
- no dependence on an unbounded search;
- any finite verification isolated as a small, reproducible lemma;
- use of standard theorems, such as lower bounds for linear forms in logarithms,
  stated clearly enough that the dependency can be checked.

The current $\{3,4,7\}, k=2$ certificate is not the final ideal.  It has the
right infinite tail ingredient, the Mignotte-Waldschmidt lower bound, but it
still relies on a large exact finite frontier scan.  That scan should be viewed
as a guide to the next algebraic lemma.

## First-principles reduction

The interval-extension lemma is the central structural fact.  Once the subset
sums contain an interval $[M,M+H]$, future terms extend the interval whenever
the next term is at most $H+1$.

For exact-critical base sets, where

$$\sum_i {1\over d_i-1}=1,$$

the tail has an invariant

$$K=\sum_i {E_i\over d_i-1}-1-H,$$

where $E_i$ are the first unused powers.  The tail succeeds if

$$\sum_i {E_i\over d_i-1}-\min_i E_i\ge K.$$

For $\{3,4,7\}$, clearing denominators gives

$$3(E_3-T)+2(E_4-T)+(E_7-T)\ge 6K,\qquad T=\min(E_3,E_4,E_7).$$

Thus a failure forces all three frontier powers to be close together, and in
particular forces a pairwise near-collision

$$|3^a-4^b|<6K.$$

This is the bridge from subset sums to Diophantine approximation.

## Next clean-proof target

Replace the finite frontier scan in the $\{3,4,7\}, k=2$ certificate by a
human-checkable near-collision lemma:

> For the relevant frontier range, no powers $3^a$ and $4^b$ can be close
> enough to violate the interval-extension inequality.

Promising tools:

- continued fractions for $\log 4/\log 3$;
- explicit lower bounds for $|a\log 3-b\log 4|$;
- modular sieving as a finite, auditable residue lemma;
- sharper versions of Mignotte-Waldschmidt or Laurent bounds to reduce or
  eliminate finite checking.

## Counterexample route

A counterexample should not be sought only by pushing conductors higher.  A real
counterexample likely needs one of:

- a persistent modular obstruction;
- an infinite sequence of dangerous frontiers where interval extension fails;
- an exact-critical family whose power-spacing defeats all available lower
  bounds.

The current data does not show such a mechanism, but the search for one should
be structural: residues, recurrences, and Diophantine near-collisions.

