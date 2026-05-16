# Bounded-gap bridge

This note corrects and formalizes the next local target after
`notes/23_complete_sequence_lemma_extraction.md`.

## Correction

The previous extraction note said that bounded gaps plus complete residues
modulo a compatible modulus looked like a route to intervals.  That is too
weak as stated.  A bounded-gap set can still miss infinitely many points inside
each residue class.  Complete finite residue representatives do not by
themselves repair those holes.

The clean first-principles bridge needs an actual interval, not just residues.

## Lemma

Let \(F\) and \(B\) be disjoint sets of positive integers.  Suppose

\[
[M,M+H]\subseteq P(F)
\]

for some \(H\ge0\).  Suppose also that \(P(B)\) is unbounded and, when listed
in increasing order,

\[
0=x_0<x_1<x_2<\cdots,
\]

has consecutive gaps bounded by \(G\):

\[
x_{i+1}-x_i\le G\quad(i\ge0).
\]

If

\[
G\le H+1,
\]

then

\[
[M,\infty)\subseteq P(F\cup B).
\]

## Proof

Take any \(N\ge M\).  Choose \(x_i\in P(B)\) maximal with \(x_i\le N-M\).
Such an \(x_i\) exists because \(0\in P(B)\).  If \(N-M=x_i\), then
\(N=x_i+M\), and \(M\in P(F)\).

Otherwise \(x_i<N-M<x_{i+1}\).  The gap hypothesis gives

\[
0<N-M-x_i<G\le H+1.
\]

Since all quantities are integral,

\[
0\le N-M-x_i\le H.
\]

Thus \(N-x_i\in[M,M+H]\subseteq P(F)\), and \(x_i\in P(B)\).  Therefore
\(N\in P(F\cup B)\).

## Connection to Chen-Fang-Hegyvari

Chen-Fang-Hegyvari Lemma 2.1 gives a way to prove the bounded-gap hypothesis:
if an ordered tail \(B=\{b_1\le b_2\le\cdots\}\) has some \(n_0\) with

\[
b_n\le b_1+\cdots+b_{n-1}+b_{n_0}\quad(n\ge n_0),
\]

then the gaps in \(P(B)\) are bounded by \(b_{n_0}\).  Combining their lemma
with the bridge above gives this sufficient condition:

\[
b_{n_0}\le H+1
\quad\Longrightarrow\quad
[M,\infty)\subseteq P(F\cup B).
\]

This is now a precise post-saturation interval target.  The global proof still
needs a theorem producing a finite seed interval \([M,M+H]\) and a disjoint
tail satisfying the Chen-Fang-Hegyvari domination condition with
\(b_{n_0}\le H+1\).

## Code artifact

`haskell/GapBridge.hs` encodes the arithmetic part of the lemma:

- a finite seed interval;
- an imported tail gap bound;
- the check \(G\le H+1\);
- the resulting ray start.

`haskell/GapBridgeCertificate.hs` smoke-tests the bridge on the binary powers
case and computes the required tail-gap capacities for current local seed
profiles.  Except for the binary powers row, these local rows are conditional:
they do not prove the required tail gap bound.  They say exactly how strong a
bounded-gap theorem would have to be to replace the current Diophantine tail
machinery.
