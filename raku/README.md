# Raku proof DSL experiments

This directory contains Raku-side proof engineering for Erdős 124.

The current artifact is `Erdos124::ResidueDSL`, a small right-by-construction
DSL for the residue-lift and unit-base frame lemmas:

```text
raku raku\residue_dsl_certificate.raku
```

It validates:

- moduli;
- residue-frame representatives;
- multiple rays and intervals;
- lifted integer rays and intervals;
- unit-base residue frames from multiplicative order.

This is not an RFLK kernel proof.  It is an executable certificate DSL that
cross-checks the Haskell layer while taking advantage of Raku's custom operator
support, especially the congruence operator `≡ₘ`.

The external RFLK project at
`C:\Users\baian\Math_Research\Knuth_Problem\formal_raku` is a plausible next
integration target, but it needs an arithmetic/subset-sum theory extension
before it can honestly certify the Erdős 124 lemmas as machine-checked
theorems.
