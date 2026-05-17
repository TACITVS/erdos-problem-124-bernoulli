# Scaled power block language

This note makes the first open cut from
`notes/34_conductor_boss_lemma_ladder.md` precise.

The modular conductor route creates quotient blocks.  After dividing a
divisible pure-power block by a modulus, the result is usually not a pure-power
block.  It has terms of the form

\[
q d^n.
\]

So the next additive-combinatorial theorem should be stated for finite unions
of scaled power progressions, not just for pure powers.

## Definition

A scaled power progression is a triple

\[
(q,d,e_0),\qquad q\ge1,\ d\ge2,\ e_0\ge0,
\]

with terms

\[
q d^n,\qquad n\ge e_0.
\]

A scaled power block is a finite union of such progressions, with multiplicity
preserved when two progressions contain the same integer.

## Quotient normalization

Let \(m\ge1\).  If

\[
m\mid d^k,
\]

then the pure-power tail

\[
d^k,d^{k+1},d^{k+2},\ldots
\]

is \(m\)-divisible, and its quotient is the scaled progression

\[
{d^k\over m} d^n,\qquad n\ge0.
\]

Indeed,

\[
{d^{k+j}\over m}={d^k\over m}d^j.
\]

This is the exact language produced by quotient-block selection.

## Scaling and asymptotics

The conductor ladder now has the following shape:

1. choose a modulus \(m\) and residue frame \(F\);
2. put \(m\)-divisible pure-power tails into \(G=mG'\);
3. normalize \(G'\) as a scaled power block;
4. prove a middle interval theorem for that scaled power block;
5. transfer the conductor bound back with `notes/33_modular_conductor_lift.md`.

The scaled language is therefore not cosmetic.  It is the domain where the next
middle-interval theorem must be proved.

## Basic monotonicity

If \(B\subseteq B'\) are finite scaled blocks, then every subset sum of \(B\)
is a subset sum of \(B'\).  Therefore adding scaled progressions cannot destroy
an already represented interval.  It can only improve the conductor.

This lets a proof use a convenient scaled subblock.  Once a subblock has a
central interval with a suitable conductor bound, any larger quotient block has
at least that much additive coverage.

## Remaining theorem target

The next hard theorem is:

> **Scaled middle interval theorem.**  
> For the scaled power blocks arising from quotient-block selection, finite
> initial segments have central conductors satisfying the same sublinear or
> power-saving bounds needed in `notes/28_power_saving_central_interval_target.md`.

This note does not prove that theorem.  It removes ambiguity about the objects
that theorem must discuss.

`notes/36_complete_sequence_scaled_absorption.md` records the first reusable
sublemma toward that theorem: ordered scaled terms satisfying the
complete-sequence inequalities preserve an existing central conductor bound.
`notes/37_p_adic_quotient_block_selection.md` records the p-adic criterion for
constructing valid scaled quotient blocks from a modulus.
`notes/38_quotient_conductor_bridge.md` composes those scaled quotient blocks
with complete-sequence absorption and modular conductor lifting.

## Typed artifact

`haskell/ScaledPowerBlock.hs` defines:

- validated scaled progressions;
- finite term generation by count or limit;
- frontier and total helpers;
- quotient normalization of divisible pure-power tails.

`haskell/ScaledPowerBlockCertificate.hs` checks the normalization identities on
small examples.
