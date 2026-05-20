# Single scaled progression absorption count

The complete-sequence absorption criterion in
`notes/36_complete_sequence_scaled_absorption.md` extends a seed interval by
ordered scaled terms.  For the scaled middle-interval theorem in
`notes/35_scaled_power_block_language.md` we want to know, quantitatively,
how many terms of a single scaled progression a given seed interval can
absorb.

This note proves the exact criterion in closed form and records the
dichotomy between the trivial base $d=2$ case and the geometric-progress
case $d\ge3$ that actually arises in Erdős 124.

## Setup

Fix a seed interval $I_0=[L_0,U_0]$ with span

$$H_0=U_0-L_0,$$

and a scaled progression with coefficient $q\ge1$, base $d\ge2$, and
exponent floor $n_0\ge0$.  Consider its sorted terms

$$b_i=qd^{n_0+i-1},\qquad i=1,2,3,\ldots.$$

The absorption criterion requires

$$b_i\le H_{i-1}+1,
\qquad
H_{i-1}=H_0+\sum_{j=1}^{i-1}b_j.$$

Substituting the geometric sum,

$$\sum_{j=1}^{i-1}b_j
=
qd^{n_0}\cdot{d^{i-1}-1\over d-1},$$

and clearing the denominator yields the closed-form criterion

$$qd^{n_0+i-1}(d-2)\le(d-1)(H_0+1)-qd^{n_0}.
\tag{$\star$}$$

## Dichotomy

### Case $d=2$

The factor $d-2$ vanishes, so $(\star)$ becomes

$$0\le H_0+1-q\cdot 2^{n_0}.$$

Either $H_0\ge q\cdot 2^{n_0}-1$, in which case *every* term of the
progression absorbs and the seed grows to a complete-sequence ray, or the
inequality fails and *no* term absorbs.

### Case $d\ge3$

The factor $d-2>0$ is positive, so $(\star)$ bounds $i$:

$$i\le
N(H_0;q,d,n_0)
=
1+
\left\lfloor\log_d\!{\bigl((d-1)(H_0+1)-qd^{n_0}\bigr)\over q(d-2)d^{n_0}}\right\rfloor.$$

When the inner argument is at most $1$, no terms absorb and the count is
$0$.

## Capacity formula

Recording both branches as one piecewise function:

$$N(H_0;q,d,n_0)
=
\begin{cases}
\infty & d=2\ \text{and}\ H_0\ge q\cdot 2^{n_0}-1,\\
0 & d=2\ \text{and}\ H_0<q\cdot 2^{n_0}-1,\\
\bigl\lfloor 1+\log_d X\bigr\rfloor & d\ge3\ \text{and}\ X\ge1,\\
0 & d\ge3\ \text{and}\ X<1,
\end{cases}
\qquad
X={(d-1)(H_0+1)-qd^{n_0}\over q(d-2)d^{n_0}}.$$

## Span growth after absorption

If $N\ge1$ terms absorb, the new seed span is

$$H_N=H_0+qd^{n_0}\cdot{d^N-1\over d-1}.$$

For $d\ge3$ at the maximal $N$, the closed-form criterion forces

$$qd^{n_0+N-1}(d-2)\le(d-1)(H_0+1)-qd^{n_0},$$

which after multiplying by $d$ gives

$$qd^{n_0+N}(d-2)\le d(d-1)(H_0+1)-qd^{n_0+1}.$$

Rearranging:

$$H_N\le H_0\cdot{2(d-1)\over d-2}+O_{d,q,n_0}(1).$$

So one round of single-progression absorption multiplies the seed span by a
fixed factor $2(d-1)/(d-2)$, which is $4$ for $d=3$, $3$ for $d=4$,
and tends to $2$ as $d\to\infty$.

## Consequence for the scaled middle-interval theorem

Iterating absorption across multiple progressions, each round absorbs
$O(\log H_{\rm current})$ terms and multiplies the span by a constant.
Therefore the total number of terms absorbed in growing the span from
$H_0$ to $H$ is

$$O((\log H)^2).$$

This is the rough additive-combinatorial accounting that the scaled
middle-interval theorem needs.  It does not directly produce a power-saving
conductor bound — that would require the iteration to *also* preserve the
conductor identity from `notes/28_power_saving_central_interval_target.md`
through each round — but it gives the right shape for the absorption budget.

A separate ignition lemma (`notes/24_bounded_gap_bridge.md` plus an explicit
seed search) provides the initial $H_0$; after ignition the geometric
doubling described here drives the span to $H$ using only
$O(\log_d H)$ rounds and $O((\log H)^2)$ absorbed terms.

## Typed artifact

`haskell/SingleProgressionAbsorption.hs` defines:

- `AbsorptionCount`, recording the capacity, the actual maximum prefix
  length, and the post-absorption span;
- `absorbablePrefix :: Integer -> Integer -> Integer -> Integer -> AbsorptionCount`,
  computing the count for given $H_0,q,d,n_0$;
- `spanGrowthFactor :: Integer -> (Integer, Integer)`,
  returning the structural factor $2(d-1)/(d-2)$ for $d\ge3$ (and
  signalling the trivial dyadic case).

`haskell/SingleProgressionAbsorptionCertificate.hs` checks:

- the dyadic dichotomy on small examples;
- the closed-form count formula for $d=3,4,5$ against a direct sequential
  absorption simulation through `GapBridge.absorbTerm`;
- explicit boundary cases at $H_0$ just above and just below the
  ignition threshold.
