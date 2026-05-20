# Quotient reciprocal-sum identity

The conductor boss tree from `notes/34_conductor_boss_lemma_ladder.md` has two
open cuts ready to attack: `scaled-power-middle-interval` and
`quotient-block-selection`.  This note advances the second cut by computing
the precise reciprocal-sum content of the quotient block built by
`notes/38_quotient_conductor_bridge.md`.

The point is to make the modular-bridge selection theory quantitative.  The
reciprocal sum is the universal carrying capacity behind every conductor
theorem in this project, so knowing exactly how much of it survives the
quotient is the right first algebraic invariant to track.

## Divisible subset

Fix a finite base set $A\subseteq\mathbb{Z}_{\ge2}$ and a modulus
$m\ge1$.  For each prime $p$, let $v_p$ be the $p$-adic valuation.
Define the divisible subset

$$D(m,A)
=
\{d\in A:\ v_p(d)\ge1\ \text{for every prime}\ p\mid m\}.$$

Equivalently, $D(m,A)$ is the set of bases in $A$ whose prime support
covers the support of $m$.  The p-adic well-formedness lemma in
`notes/37_p_adic_quotient_block_selection.md` shows that the divisible bases
are exactly the bases that contribute an eventually $m$-divisible pure-power
tail and so enter the scaled quotient block.

## Quotient block bases

Each $d\in D(m,A)$ yields one scaled quotient progression

$$\left({d^{e_0(d;m,k)}\over m}\right)d^n,\qquad n\ge0,$$

whose underlying base is exactly $d$.  The coefficient
$q_d=d^{e_0(d;m,k)}/m$ is a positive integer.

The set of bases of the quotient block is therefore precisely $D(m,A)$.

## Reciprocal-sum identity

The reciprocal sum of a base set $B$ is

$$R(B)=\sum_{d\in B}{1\over d-1}.$$

For a single scaled progression $(q,d,n_0)$, the cumulative-to-frontier
ratio is asymptotically $1/(d-1)$:

$${1\over qd^{n_0+e+1}}\sum_{n=n_0}^{n_0+e}qd^n
=
{1-d^{-(e+1)}\over d-1}
\xrightarrow{e\to\infty}
{1\over d-1}.$$

The coefficient $q$ cancels.  So on the asymptotic conductor scale, the
reciprocal-sum contribution of a scaled progression $qd^n$ is the same as
the pure progression $d^n$.

Combining with the previous identification of bases:

> **Quotient reciprocal-sum identity.**
> The asymptotic reciprocal sum of the scaled quotient block of $A$ at
> modulus $m$ equals
> $$R(D(m,A))=\sum_{d\in D(m,A)}{1\over d-1}.$$

## Selection slack

Define the **selection slack** of $m$ for $A$ as

$$\sigma(m,A)=R(D(m,A))-1.$$

Three regimes:

- **Strict slack** $\sigma(m,A)>0$: the quotient block still has positive
  reciprocal-sum slack, matching the strict-tail hypothesis on the original.
- **Critical slack** $\sigma(m,A)=0$: the quotient block is exact-critical.
- **Slack deficit** $\sigma(m,A)<0$: the quotient block has lost some
  reciprocal-sum capacity.  The deficit must be compensated either by extra
  finite seed coverage in the residue frame, or by a stronger conductor input
  on the quotient side than the strict/exact-critical asymptotic theorems
  would deliver.

The applicability range of the modular bridge as a *recursive reduction* into
the same conductor theorem is therefore $\sigma(m,A)\ge0$.  In the deficit
regime the bridge is still a valid one-shot transfer, but it does not chain.

## Worked examples

### Exact-critical $\{3,4,7\}$, $k=1$

$R(A)=1/2+1/3+1/6=1$.

| $m$ | $D(m,A)$    | $R(D(m,A))$ | $\sigma(m,A)$ |
|-------|---------------|---------------|-----------------|
| 2     | $\{4\}$     | $1/3$       | $-2/3$        |
| 3     | $\{3\}$     | $1/2$       | $-1/2$        |
| 4     | $\{4\}$     | $1/3$       | $-2/3$        |
| 6     | $\emptyset$ | 0             | $-1$          |
| 7     | $\{7\}$     | $1/6$       | $-5/6$        |

Every nontrivial modulus has slack deficit.  The modular bridge cannot
recursively reduce $\{3,4,7\}$ to itself; it is a one-shot tool only.  The
existing local certificate handles $\{3,4,7\}$ by direct finite-seed
analysis plus the Mignotte-Waldschmidt continued-fraction tail gate.

### Exact-critical $\{3,4,9,25\}$, $k=2$

$R(A)=1/2+1/3+1/8+1/24=1$.

| $m$ | $D(m,A)$    | $R(D(m,A))$  | $\sigma(m,A)$  |
|-------|---------------|----------------|------------------|
| 2     | $\{4\}$     | $1/3$        | $-2/3$         |
| 3     | $\{3,9\}$   | $5/8$        | $-3/8$         |
| 5     | $\{25\}$    | $1/24$       | $-23/24$       |
| 6     | $\emptyset$ | 0              | $-1$           |
| 8     | $\{4\}$     | $1/3$        | $-2/3$         |
| 25    | $\{25\}$    | $1/24$       | $-23/24$       |

The best candidate is $m=3$ with deficit $-3/8$.  Still in the deficit
regime, but smaller than the deficits available for $\{3,4,7\}$.

### Strict $\{3,4,5\}$, $k=1$

$R(A)=1/2+1/3+1/4=13/12$.

| $m$ | $D(m,A)$ | $R(D(m,A))$ | $\sigma(m,A)$ |
|-------|-----------|---------------|-----------------|
| 2     | $\{4\}$ | $1/3$       | $-2/3$        |
| 3     | $\{3\}$ | $1/2$       | $-1/2$        |
| 4     | $\{4\}$ | $1/3$       | $-2/3$        |
| 5     | $\{5\}$ | $1/4$       | $-3/4$        |

The strict slack is consumed.  Again the modular bridge cannot recurse on
this set.

### Modular-gate $\{3,6,9,12,21,45,89\}$, $k=2$

This set is itself exact-critical:
$R(A)=1/2+1/5+1/8+1/11+1/20+1/44+1/88=440/440=1$.

| $m$ | $D(m,A)$               | $R(D(m,A))$ | $\sigma(m,A)$ |
|-------|--------------------------|---------------|-----------------|
| 3     | $\{3,6,9,12,21,45\}$   | $87/88$     | $-1/88$       |
| 9     | $\{3,6,9,12,21,45\}$   | $87/88$     | $-1/88$       |
| 89    | $\{89\}$               | $1/88$      | $-87/88$      |

Two facts to note.  First, $D(m,A)$ depends only on the radical
$\operatorname{rad}(m)$, not on $m$ itself.  Second, the modulus $m=3$
puts $\{3,6,9,12,21,45,89\}$ within $1/88$ of critical on the quotient
side.  The remaining slack deficit $1/88$ is exactly the reciprocal-sum
contribution of the lone escape base $89$, which matches the modular-gate
analysis: the divisible mass nearly closes the problem, and the single escape
base is what controls residue saturation.

### Synthetic recursive example

A genuinely recursive example must have a divisible subfamily that is itself
hypothesis-meeting.  One small example is
$A=\{3,5,6,9,12,15,18,21\}$, with $R(A)\approx1.38$.

| $m$ | $D(m,A)$                 | $R(D(m,A))$ | $\sigma(m,A)$ |
|-------|----------------------------|---------------|-----------------|
| 3     | $\{3,6,9,12,15,18,21\}$  | $\approx1.13$ | $\approx+0.13$ |
| 5     | $\{5,15\}$               | $\approx0.32$ | $\approx-0.68$ |

At $m=3$ the divisible subfamily inherits a strict positive slack, so the
modular bridge becomes a genuine recursive reduction tool.  Examples of this
shape are not among the small hypothesis-minimal local cases; they arise only
when $A$ contains many $p$-divisible bases at once.

## Conclusions for the boss tree

The cut `quotient-block-selection` divides cleanly along the slack sign:

1. **Recursive regime** $\sigma(m,A)\ge0$: the modular bridge composes with
   the same asymptotic conductor theorem on the quotient block.  This is the
   easy case to ladder; the hard work moves to the scaled middle-interval
   theorem.
2. **Deficit regime** $\sigma(m,A)<0$: the modular bridge gives a one-shot
   transfer.  The quotient-side conductor must be controlled by other means
   (direct subset-sum scan, residue-frame absorption, or a stronger
   imported analytic bound).

For the present hypothesis-minimal cases the deficit regime dominates.  This
realigns the modular bridge from "the main recursive engine" to "a useful
one-shot translator", and shifts the conductor-theorem proof toward the
direct scaled middle-interval theorem on $A$ itself rather than on a
quotient.

## Typed artifact

`haskell/QuotientReciprocalSum.hs` defines:

- `Rational` reciprocal-sum arithmetic (kept exact via
  `Data.Ratio.Ratio Integer`);
- `divisibleSubset :: Integer -> [Integer] -> [Integer]`, the divisible base
  list $D(m,A)$;
- `reciprocalSum :: [Integer] -> Ratio Integer`;
- `selectionSlack :: Integer -> [Integer] -> Ratio Integer`, the value
  $R(D(m,A))-1$;
- `bridgeRegime :: Integer -> [Integer] -> BridgeRegime`, classifying
  Recursive / Critical / Deficit.

`haskell/QuotientReciprocalSumCertificate.hs` checks the identity on:

- the worked exact-critical cases $\{3,4,7\}$ and $\{3,4,9,25\}$;
- the strict case $\{3,4,5\}$;
- the modular-gate case $\{3,6,9,12,21,45,89\}$ at multiple moduli;
- and rejection of negative or zero moduli.
