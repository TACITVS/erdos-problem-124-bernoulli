# Generic pair continued-fraction certificate

The checker `haskell/PairCFTailCertificate.hs` turns the pairwise analytic
part of the exact-critical tail into a reusable finite certificate.

## Input shape

For a multiplicatively independent pair \(x,y\), a gap \(B\), and an imported
analytic threshold \(A_0\), the checker certifies the finite window

\[
a_0\le a<A_0
\]

for possible near-collisions

\[
|x^a-y^b|<B.
\]

It computes an exact rational interval for

\[
{\log x\over \log y}
\]

using the atanh series for logarithms, extracts the forced continued-fraction
prefix, filters convergents with denominator \(a\) in the requested window, and
checks each exact integer gap.

The Legendre gate is checked by the sufficient inequality

\[
2aB<x^a-B.
\]

Since every base in the problem is at least \(3\), this implies

\[
{B\over a\log y(x^a-B)} < {1\over 2a^2},
\]

so any later near-collision must come from a continued-fraction convergent.

## What this changes

Before this step, the typed continued-fraction certificate was hard-wired to
\((x,y)=(3,4)\).  The new checker has the same exact arithmetic but parameterizes
the base pair, the gap, the Legendre start, and the imported analytic threshold.

This does not prove the global Baker-type bound.  It makes the post-bound
finite verification uniform: once a source gives an explicit threshold for an
independent pair, the finite CF window is checkable without new mathematics.

## Checked cases

The checker reproduces the three existing \(3/4\) windows:

- \(\{3,4,7\}, k=2\);
- \(\{3,4,7\}, k=3\);
- \(\{3,4,9,25\}, k=2\).

It also includes a finite-window sanity check for the independent pair \(5,13\)
with \(B=1000000\) and \(A_0=1000\).  That sanity case is not used as a theorem
dependency; it verifies that the code is genuinely pair-parametric.
