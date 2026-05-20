# Raku DSL fit for Erdős 124

This note records how Raku should fit into the current proof project.

The external project inspected here is:

```text
C:\Users\baian\Math_Research\Knuth_Problem\formal_raku
```

Its own `CLAIMS_POLICY.md` and `TRUST_MODEL.md` are important.  They distinguish
kernel-checked theorems from trusted axioms, empirical checks, symbolic
derivations, and conjectures.  That distinction is exactly right for this
project: adding an Erdős 124 statement as an axiom inside a DSL would not be a
proof.

## Current decision

Use Raku immediately for a small right-by-construction certificate DSL, not yet
as a full RFLK formalization.

The reason is practical.  The current RFLK showcase has useful strict-mode
audit machinery, but Erdős 124 needs concrete integer arithmetic, modular
arithmetic, finite subset sums, intervals, and conductor bounds.  Those are not
yet present as a mature reusable theory in the inspected RFLK core.  A direct
RFLK proof today would either:

1. introduce too many trusted arithmetic axioms; or
2. spend the next pass building foundational arithmetic infrastructure instead
   of advancing Erdős 124.

The better immediate use of Raku is therefore a domain-specific certificate
language whose constructors enforce the proof-side invariants.

## Artifact added

`raku/lib/Erdos124/ResidueDSL.rakumod` defines:

- validated `Modulus` objects;
- validated `ResidueFrame` objects;
- validated multiple rays and intervals;
- lifted integer rays and intervals;
- unit-base residue frames from multiplicative order;
- a custom congruence operator `≡ₘ`.

The certificate runner is:

```text
raku raku\residue_dsl_certificate.raku
```

It checks the same residue-lift examples currently covered by Haskell and the
unit-base frame construction for:

- base $7$ modulo $6$;
- base $3$ modulo $5$.

## Mathematical role

The Raku DSL does not change the remaining open theorem.  It strengthens the
engineering around two certified lemmas:

1. residue frame plus multiple ray/interval lifts to an ordinary ray/interval;
2. a base that is a unit modulo $m$ gives an algebraic complete residue
   frame.

These are now checked in two independent languages:

- Haskell, with typed certificate modules;
- Raku, with validated DSL constructors and a custom congruence operator.

This is useful because the next proof work is likely to build an inductive
modular-conductor argument.  The DSL makes invalid residue-frame or
multiple-interval objects unconstructible, so future experiments can assemble
larger proof objects without silently mixing moduli or accepting malformed
representatives.

## RFLK integration target

A serious RFLK integration should start only after defining a small arithmetic
theory for:

- divisibility and congruence;
- finite lists and subset sums;
- integer intervals;
- monotone interval lifting;
- multiplicative order modulo $m$.

Then the residue-lift bridge and unit-base frame lemma can be expressed as
kernel-checked theorems rather than executable certificate checks.

Until that arithmetic theory exists, the correct claim category for this Raku
artifact is executable/symbolic certificate support, not formal proof.
