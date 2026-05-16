# Complete-sequence lemma extraction

This note records the first extraction pass from the complete-sequence papers
identified in `notes/22_bibliography.md`.  It is deliberately narrower than the
bibliography: only lemmas and definitions that can feed the residue and interval
parts of the current Erdos 124 proof architecture are recorded here.

## Sources inspected

1. Yong-Gao Chen, Jin-Hui Fang, Norbert Hegyvari, "On the subset sums of
   exponential type sequences", Acta Arithmetica 173 (2016), 141-150.
   DOI: `10.4064/aa8133-3-2016`.
2. Fang-Gang Xue, Jin-Hui Fang, Jie Ma, "On exponential type sequences",
   Discrete Applied Mathematics 338 (2023), 187-189.
   DOI: `10.1016/j.dam.2023.05.023`.

The 2016 paper is available as a full PDF from IMPAN and was text-extracted
locally.  The 2023 paper is not fully open through the sources inspected here,
but the ScienceDirect preview exposes the abstract, theorem headings, the
definition of quasi-complete residue sets, and proof-snippet context.  Exact
symbol-level use of the 2023 theorems still needs the full article.

## Extracted definitions

For a sequence \(A\) of positive integers, \(P(A)\) is the set of finite sums
of distinct terms of \(A\), with \(0\in P(A)\).  A sequence is complete when
\(P(A)\) contains all sufficiently large integers.

The 2016 paper also uses subcomplete for the weaker condition that \(P(A)\)
contains an infinite arithmetic progression.  This matters because some finite
residue gates give density or arithmetic progressions before they give full
cofiniteness.

The 2023 paper introduces quasi-complete residue witnesses.  The accessible
ScienceDirect text gives the exact definition: a set
\(\{c_1,\ldots,c_p\}\) is quasi-complete modulo \(p\) if, after division by
\(d=\gcd(c_1,\ldots,c_p)\), the set
\(\{c_1/d,\ldots,c_p/d\}\) is a complete residue system modulo \(p\).  The new
Haskell module encodes this finite predicate directly:

\[
\{c_i\}_{i=1}^p\text{ is quasi-complete mod }p
\quad\Longleftrightarrow\quad
\{c_i/\gcd(c_1,\ldots,c_p)\}\text{ covers every residue mod }p.
\]

This is stronger and more structured than merely adjoining the empty residue.
It matters because Xue-Fang-Ma use quasi-complete witnesses to prove positive
lower asymptotic density for \(P(S_pA)\).  The checker therefore requires a
quasi-complete witness to contain exactly \(p\) integers.

## Extracted lemmas and proof patterns

### Bounded-gap lemma from Chen-Fang-Hegyvari

The useful interval lemma is Lemma 2.1 of the 2016 paper.  In project language:

Let \(B=\{b_1\le b_2\le\cdots\}\) be a sequence of positive integers.  If some
fixed \(n_0\) satisfies

\[
b_n\le b_1+\cdots+b_{n-1}+b_{n_0}
\quad(n\ge n_0),
\]

then \(P(B)\), when listed increasingly, has gaps bounded by \(b_{n_0}\).

This is not yet the central interval theorem needed for Erdos 124, but it is a
real candidate engine.  It turns a tail-domination inequality into a uniform
gap bound for subset sums.  The project should now try to combine this with
finite residue representatives: bounded gaps plus complete residues modulo a
compatible modulus is the natural route to actual intervals.

### Density threshold for \(S_pA_t\)

Theorem 1.1 of the 2016 paper proves sharp density facts for

\[
S_pA_t=\{p^i a_j:i\ge0,\ 1\le j\le t\}.
\]

The parts relevant here are qualitative:

- \(t\ge p-1\) forces positive lower asymptotic density for \(P(S_pA_t)\);
- \(2^t<p\) forces asymptotic density zero;
- the middle range \(t<p-1\) and \(2^t\ge p\) admits both behaviors.

This is a warning against using counting density as a substitute for
cofiniteness.  It also shows why a finite residue gate has to be paired with an
interval or bounded-gap mechanism.

### Fibonacci proof pattern

Theorem 1.2 of the 2016 paper proves completeness for a finite Fibonacci
multiplier block \(S_pF_k(n)\).  The proof has a residue-to-completeness
template worth preserving:

1. construct finite subset sums that cover a full residue system modulo a
   carefully chosen \(d\);
2. use periodicity modulo \(d\) to move small residue representatives above the
   forbidden early indices;
3. write the remaining quotient in base \(p\);
4. replace each digit by a finite subset-sum representative.

This is close to the shape wanted for the post-saturation bridge in Erdos 124,
except our powers are a union of independent pure-power families rather than
one scaled multiplier sequence.

### Xue-Fang-Ma residue gates

The ScienceDirect preview of the 2023 note says that it further studies lower
asymptotic density and completeness for \(S_pA_t\).  The preview exposes three
important qualitative statements:

- a quasi-complete residue condition on \(P(A_t)\) implies positive lower
  asymptotic density;
- completeness of \(S_pA_t\) forces \(P(A_t)\) to contain a complete residue
  system modulo \(p\);
- a special sufficient condition gives completeness.

These statements justify the API vocabulary only.  Any proof step depending on
the proof details, or on details outside the exposed theorem statements, must
wait for the full text.

## Consequence for the proof plan

The next mathematical target should be split into two formal lemmas.

First, a residue-saturation lemma:

> Find a finite seed, depending on \(A\) and \(k\), whose subset sums cover the
> required residue system modulo the exact-critical denominator or another
> analytically justified modulus.

Second, an interval-from-gaps lemma:

> If a residue-complete finite seed has representatives with maximum \(R\), and
> an ordered tail satisfies a Chen-Fang-Hegyvari style bounded-gap inequality
> with gap bound \(G\), prove an explicit interval or cofinite ray once the
> residue period is no larger than the interval/gap structure can absorb.

The first lemma is still open.  The second is now less vague: Lemma 2.1 gives a
concrete bounded-gap hypothesis to formalize and test.

## Code artifact added

`haskell/ResidueGate.hs` now exposes finite predicates for:

- complete residue coverage;
- gcd-normalized quasi-complete residue witnesses;
- subset-sum residue masks;
- missing residues relative to a chosen coverage target.

`haskell/ResidueGateCertificate.hs` is an executable smoke test for that API.
It checks the quasi-complete witness \(\{2,4,6\}\) modulo \(3\), the binary
seed \(P(\{1\})\) modulo \(2\), and two local exact-critical seed residue
profiles.

This code proves no global theorem.  Its purpose is to stop the next residue
certificate layer from hard-coding ad hoc residue conventions.
