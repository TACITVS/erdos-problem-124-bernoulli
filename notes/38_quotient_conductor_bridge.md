# Quotient conductor bridge

The previous cuts created three independent tools:

1. p-adic quotient-block selection;
2. complete-sequence absorption for scaled blocks;
3. modular conductor lift from quotient intervals back to ordinary intervals.

This note records the composition of those tools.

## Setup

Fix a modulus $m$.  Suppose a p-adic quotient selection gives:

- a unit-base residue frame $F$ modulo $m$;
- a quotient block $G'$, written as a finite union of scaled progressions.

Suppose also that, inside the quotient problem, a seed of total $S'_0$ has
central conductor $c'$, so it represents

$$[c'+1,\ S'_0-c'-1].$$

Choose finitely many terms from the selected scaled quotient block and order
them increasingly.  If those terms satisfy the complete-sequence inequalities
over the quotient interval, then `notes/36_complete_sequence_scaled_absorption.md`
gives a larger quotient seed of total $S'_1$ with the same conductor bound:

$$[c'+1,\ S'_1-c'-1].$$

## Producing the modular lift input

The quotient interval produces the interval of multiples

$$[m(c'+1),\ m(S'_1-c'-1)].$$

This is exactly the `ScaledCentralBlock` input expected by
`notes/33_modular_conductor_lift.md`.

Let $R$ be the residue-frame width.  The lifted ordinary interval is

$$[m(c'+1)+R,\ m(S'_1-c'-1)].$$

Therefore, if this interval reaches the whole half-sum of the combined finite
seed, the ordinary finite seed has conductor bound

$$m(c'+1)+R-1.$$

## What is now separated

This bridge separates the remaining work into two explicit failure modes:

1. **Complete-sequence failure.**  The selected quotient terms do not touch the
   current quotient interval.
2. **Half-sum reach failure.**  The quotient interval is valid, but after
   residue-frame loss it does not reach the combined half-sum.

Both failures are algebraic inequalities.  No subset-sum search is hidden in
this bridge.

## Typed artifact

`haskell/QuotientConductorBridge.hs` composes:

- `QuotientBlockSelection.hs`;
- `CompleteSequence.hs`;
- `ConductorLift.hs`.

Given a quotient selection, an existing quotient conductor $c'$, and finite
counts from each quotient progression, it either returns:

- the ordered quotient terms;
- the extended quotient central block;
- the combined whole seed total;
- the lifted conductor bound;

or it rejects the data at the exact failed inequality.

`haskell/QuotientConductorBridgeCertificate.hs` checks successful dyadic and
ternary bridges, plus both failure modes above.
