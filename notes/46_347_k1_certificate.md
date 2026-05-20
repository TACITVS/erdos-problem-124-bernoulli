# Closed-form certificate for $\{3,4,7\}, k=1$

The strategy revision in `notes/45_strategy_revision.md` recommended
attempting a closed-form proof for one small case as a sanity check on
whether the existing infrastructure can in fact close anything.  This note
records the result: $\{3,4,7\}, k=1$ closes cleanly through the same
typed-certificate template that already handles $k=2$ and $k=3$.

The local conductor 581 for $\{3,4,7\}, k=1$ was previously asserted only
empirically in the README.  It is now upgraded to a typed certificate.

## Constants

For exact-critical $A=\{3,4,7\}$:

$$D=6,\qquad w=(3,2,1),\qquad
\kappa(A,1)
=
{3\over2}+{4\over3}+{7\over6}=4.$$

The local finite-seed scan (`scripts/erdos124.py`, seed limit
$100{,}000$) returns conductor

$$c=581.$$

The denominator-cleared obstruction is

$$6K=D\kappa+2Dc+D
=
24+6{\cdot}2{\cdot}581+6
=
7002.$$

So the per-state margin formula

$$\mu(E)=
6\left(3(E_3-T)+2(E_4-T)+(E_7-T)\right)-7002,
\qquad
T=\min(E_3,E_4,E_7),$$

must be positive at every frontier $E=(3^a,4^b,7^c)$ reachable after the
finite seed.

## Frontier scan

The first powers above the seed limit are

$$(E_3,E_4,E_7)=(3^{11},4^{9},7^{6})=(177147,262144,117649).$$

The greedy frontier advance from $(11,9,6)$ visits

$$(11,9,6),\quad (11,9,7),\quad (12,9,7),\ldots,$$

i.e. only the first two states have $a=11$; the third already pushes the
$3$-exponent past the Legendre threshold below.  Both $a=11$ states have
positive margin: $460{,}482$ and $809{,}388$ respectively.

## Legendre threshold

The condition

$$2aB<3^a-B,\qquad B=7002,$$

first holds at $a=11$ (and fails at $a=10$).  So for every frontier
state with $a\ge11$, a tail failure forcing
$|3^a-4^b|<7002$ implies that $b/a$ is a convergent of
$\log3/\log4$ by Legendre's theorem.

Since the start exponent is exactly $a=11$, no pre-Legendre states need
to be scanned beyond the two listed above.

## Continued-fraction window

The continued-fraction prefix of $\log3/\log4$, certified through exact
rational logarithm intervals, is

$$[0,1,3,1,4,1,1,11,1,46,1,5,112].$$

The convergents with denominators in $[11,293895)$ are the same eight
that already appear in the $k=2$ and $k=3$ certificates:

$${19\over24},\ {23\over29},\ {42\over53},\ {485\over612},\
{527\over665},\ {24727\over31202},\ {25254\over31867},\
{150997\over190537}.$$

Their minimum exact gap is

$$\min|3^a-4^b|=7{\,}551{\,}629{\,}537,$$

vastly exceeding $B=7002$.  Therefore no such convergent is a
near-collision.

## Mignotte–Waldschmidt threshold

The standard Mignotte–Waldschmidt bound

$$|3^p-4^q|>\exp\bigl\{\log3\,(p-500\log4(8+\log p)^2)\bigr\}$$

first exceeds $7002$ at $p=293895$, with the inner expression increasing
there (`scripts/mw_threshold.py`).  The next convergent after this
threshold has denominator

$$21{\,}372{\,}011>293895,$$

so the convergent enumeration above is complete in the relevant window.

## Combining

The two-state finite frontier scan handles $a<$ Legendre threshold (only
$a=11$ is reachable, contributing two states with positive margin); the
continued-fraction window handles $a\in[11,293895)$; the
Mignotte–Waldschmidt bound handles $a\ge293895$.  Together they certify
that no frontier state can produce a near-collision violating the cleared
obstruction $B=7002$.

Therefore the central interval $[582,S-582]$ is preserved by every
subsequent term, and no integer above $581$ is ever missed.

## Comparison with $k=2$ and $k=3$

| $k$ | seed limit  | $c$         | $B=6K$         | Legendre start | states scanned | min margin       |
|-------|-------------|---------------|------------------|----------------|----------------|------------------|
| 1     | $10^{5}$  | 581           | 7002             | 11             | 2              | 460{,}482        |
| 2     | $5{\cdot}10^7$ | 3{,}982{,}888 | 47{,}794{,}770  | 20             | 7              | 323{,}200{,}122  |
| 3     | $5{\cdot}10^9$ | 166{,}025{,}260 | 1{,}992{,}303{,}678 | 23  | 4              | 14{,}827{,}662{,}282 |

The $k=1$ certificate is the cheapest of the four (fewest scanned states
and smallest cleared obstruction).  All four use the same MW input and the
same convergent list.

## What this shows

This is a real closed-form proof in the sense that:

- No exhaustive frontier scan beyond two enumerated states is needed.
- The continued-fraction certificate uses exact rational arithmetic, no
  floating-point logarithms.
- The Mignotte–Waldschmidt input is identified explicitly as the only
  imported analytic fact.

It is **not** a proof of the full Erdős 124 theorem.  It closes one
specific exact-critical case.  But it confirms that the CF/MW route works
end-to-end for $\{3,4,7\}$ at every $k\in\{1,2,3\}$, which was the
template the strategy revision identified as the right one.

## Boss tree change

`local {3,4,7} and {3,4,9,25} certificates` in `GlobalProofAudit.hs` now
covers $\{3,4,7\}$ at every $k\in\{1,2,3\}$ and $\{3,4,9,25\}$ at
$k=2$.  The empirical-only $k=1$ claim in the README is upgraded to a
typed certificate.

## Audit note

The fact that the same convergent list and the same MW input handle every
exact-critical $\{3,4,7\}$-style case (k=1, k=2, k=3, and $\{3,4,9,25\}$
k=2) is suggestive: the per-case work is purely arithmetic and the analytic
content is shared.  A natural next concrete target, in the spirit of the
strategy revision, is to characterise *which* exact-critical small sets
have the property that the relevant convergent list is bounded by the
existing eight.  This would broaden the cleanly-certifiable class without
new analytic input.
