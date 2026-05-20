# Global proof implementation status

This note implements the first checkpoint of the global-proof plan: a corrected
dependency audit.  It does not claim the full Erdos-124 theorem is proved.

## Target theorem

For every finite set $A=\{d_1,\ldots,d_r\}$, $d_i\ge3$, and every
$k\ge1$, prove that

$$\gcd(A)=1,\qquad \sum_{d\in A}{1\over d-1}\ge1$$

implies that the subset sums of the powers $d^j,\ j\ge k$, are cofinite.

The easier version with $j\ge0$ has a Brown-criterion proof; it is not the
target here.

## What is certified now

The following pieces are in the repository and have been checked:

- monotonicity and hypothesis-minimal reduction;
- interval extension;
- frontier invariant $K=C(E)-1-H$;
- strict-tail takeover after a finite bridge;
- exact-critical near-collision reduction;
- local residue-complete seed profiles modulo the exact-critical denominator;
- local certificates for $\{3,4,7\},k=2$, $\{3,4,7\},k=3$, and
  $\{3,4,9,25\},k=2$;
- Hasclid checks for the Legendre threshold inequalities;
- typed Haskell checks for finite frontier states and the
  $\log3/\log4$ continued-fraction window.

## Corrections to the implementation plan

The plan's qualitative route has been sharpened to one open mathematical
obligation.  The older residue-saturation and post-saturation central-interval
route remains useful as a possible attack, but it is no longer the cleanest
statement of what must be proved.

For a frontier $E$, let $c(E)$ be the finite seed conductor and
$T(E)=\min_i E_i$.  The identity proved in
`notes/28_power_saving_central_interval_target.md`,

$$K(E)=\kappa(A,k)+2c(E)+1,$$

shows that the tail obstruction is controlled exactly by finite seed conductor
growth, up to a fixed constant.

Therefore the remaining qualitative target is the power-saving central
conductor theorem:

1. in the strict case $\sum_i1/(d_i-1)>1$, prove $c(E)=o(T(E))$ along
   frontiers with $T(E)\to\infty$;
2. in the exact-critical case $\sum_i1/(d_i-1)=1$, prove
   $c(E)=O(T(E)^{1-\epsilon})$ for some $\epsilon>0$.

The exact-critical Baker step now has two versions.  For effective largest
missing claims, one still needs explicit bounds for arbitrary multiplicatively
independent base classes.  For a qualitative proof,
`notes/27_s_unit_exact_critical_tail.md` and
`notes/28_power_saving_central_interval_target.md` show that an imported
$S$-unit/Subspace-Theorem power-saving gap theorem can replace explicit
constants once the central conductor has this power saving.

Therefore the global proof is not finished.  The honest next task is to prove
the power-saving central conductor theorem, or find a structural counterexample
to it.

## Machine-readable audit

Run:

```text
runghc haskell\GlobalProofAudit.hs
```

The audit lists each proof obligation as `Certified`, `Imported`, or `Open`.
For release-style checking, run:

```text
runghc haskell\GlobalProofAudit.hs --require-complete
```

That command is expected to fail until the open power-saving central conductor
obligation is actually proved.
