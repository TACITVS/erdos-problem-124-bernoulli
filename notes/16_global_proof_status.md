# Global proof implementation status

This note implements the first checkpoint of the global-proof plan: a corrected
dependency audit.  It does not claim the full Erdos-124 theorem is proved.

## Target theorem

For every finite set \(A=\{d_1,\ldots,d_r\}\), \(d_i\ge3\), and every
\(k\ge1\), prove that

\[
\gcd(A)=1,\qquad \sum_{d\in A}{1\over d-1}\ge1
\]

implies that the subset sums of the powers \(d^j,\ j\ge k\), are cofinite.

The easier version with \(j\ge0\) has a Brown-criterion proof; it is not the
target here.

## What is certified now

The following pieces are in the repository and have been checked:

- monotonicity and hypothesis-minimal reduction;
- interval extension;
- frontier invariant \(K=C(E)-1-H\);
- strict-tail takeover after a finite bridge;
- exact-critical near-collision reduction;
- local residue-complete seed profiles modulo the exact-critical denominator;
- local certificates for \(\{3,4,7\},k=2\), \(\{3,4,7\},k=3\), and
  \(\{3,4,9,25\},k=2\);
- Hasclid checks for the Legendre threshold inequalities;
- typed Haskell checks for finite frontier states and the
  \(\log3/\log4\) continued-fraction window.

## Corrections to the implementation plan

The plan's global proof route has two open mathematical obligations.

First, the seed-bridge step is not merely an implementation detail.  A full
proof needs a theorem saying that every admissible finite \(A,k\) has a finite
set of allowed powers whose subset sums contain an interval large enough to
enter the tail argument.  The current certificates produce such intervals for
specific examples, but no general theorem is proved here.

Second, the exact-critical Baker step is not fully instantiated.  The current
local certificates import the Mignotte-Waldschmidt lower bound for \(3^a\) and
\(4^b\).  The full theorem needs an explicit bound for arbitrary
multiplicatively independent base classes, with hypotheses and constants
auditable enough that the finite pre-bound window is checkable.

Therefore the global proof is not finished.  The honest next theorem targets
are:

1. prove the global seed-bridge theorem, or find a structural counterexample to
   it;
2. instantiate an explicit Baker-type bound for arbitrary base pairs/classes;
3. connect those two ingredients to the already certified tail invariant.

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

That command is expected to fail until the two open obligations above are
actually proved.
