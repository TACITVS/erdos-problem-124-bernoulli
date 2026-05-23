# Extending (H4') closure to the (2, 3)-derived pair class

Phase B-20: apply Proposition 84.2 (note 86) with the known
irrationality measure bound $\mu(\log 2/\log 3) \le 5.117$
(Rhin 1987) to the broader class of multiplicatively-independent
integer pairs $(2^a, 3^b)$, and tabulate the regime structure.

## 0. Headline

> **The "(2, 3)-derived pair class"** — pairs $(x, y) \in \mathbb Z^2$
> with $x = 2^a, y = 3^b$ (or vice versa), $a, b \ge 1$ — has uniform
> irrationality measure bound:
> $$\mu(\log y/\log x) \;=\; \mu(\log 3/\log 2) \;\le\; 5.117$$
> (since irrationality measure is invariant under nonzero rational
> scaling, and $\log y/\log x = (b/a) \cdot \log 3/\log 2$).
>
> By Proposition 84.2, for every hypothesis-meeting $(A, k)$ with
> some pair $(2^a, 3^b)$ in $A^2$, (H4') is **unconditional** for
> $B^*$ above an explicit threshold (computed below).  Below the
> threshold, a bounded CF-window check (Proposition 84.1 with
> per-pair PQ bound) handles the remainder.

**Concrete claim** (verified by `haskell/RegimeThresholds.hs`):

For the (3, 4) pair across the four originally certified cases
($\{3,4,7\}$ at $k = 1, 2, 3$ and $\{3,4,9,25\}$ at $k = 2$):

- Proposition 84.1 with $K \le 112$ gives threshold shift
  $M_L' - M_L = 4$ to $5$.
- Proposition 84.2 with $\mu_0 \le 5.117$ gives threshold shift
  $M_L'' - M_L = 9$ to $10$.

**So Prop 84.1 is *tighter* for the certified cases** (the PQ bound
is more restrictive than the asymptotic $\mu$ bound).  Prop 84.2's
value lies in the **asymptotic regime** — cases where computing PQ
to sufficient depth is impractical, or where we want a *uniform*
closure across pairs without per-pair PQ computation.

## 1. The (2, 3)-derived pair class

Define $\mathcal P_{23}$ = {(x, y) : $x = 2^a, y = 3^b$ or
$x = 3^a, y = 2^b$, $a, b \ge 1$, $(a, b) \ne (0, 0)$, $x, y \ge 2$}.

By the irrationality-measure invariance theorem (well-known: $\mu$ is
unchanged under nonzero linear-rational transformations), every
$(x, y) \in \mathcal P_{23}$ satisfies
$$\mu(\log y/\log x) \;=\; \mu(\log 3/\log 2) \;\le\; 5.117.$$
The numerical bound is Rhin 1987.

**Pairs in $\mathcal P_{23}$ within $\{3, \ldots, 20\}$:**

| $x$ | $y$ | mult-indep? |
|---|---|---|
| 3 | 4 | ✓ |
| 3 | 8 | ✓ |
| 3 | 16 | ✓ |
| 9 | 4 | ✓ |
| 9 | 8 | ✓ |
| 9 | 16 | ✓ |
| (and reversals) | | |

For sets $A$ containing both a power-of-3 element ($3$ or $9$) and a
power-of-2 element ($4$, $8$, or $16$): such a pair is available,
giving $\mu_0 \le 5.117$.

This is a *substantial sub-class* of the 12,226 certified
hypothesis-meeting cases — most sets contain at least one element
from $\{3, 9\}$ and at least one from $\{4, 8, 16\}$.

## 2. Threshold table from `RegimeThresholds.hs`

| Case (pair) | $B^*$ | $M_L$ | $M_L'$ (Prop 84.1, $K=112$) | $M_L''$ (Prop 84.2, $\mu_0 = 5.117$) | Tighter tool |
|---|---:|---:|---:|---:|---|
| {3,4,7} k=1, (3,4) | 5,835 | 12 | 16 (shift +4) | 21 (shift +9) | Prop 84.1 |
| {3,4,7} k=2, (3,4) | 39.8M | 20 | 25 (shift +5) | 30 (shift +10) | Prop 84.1 |
| {3,4,7} k=3, (3,4) | 1.66G | 24 | 28 (shift +4) | 34 (shift +10) | Prop 84.1 |
| {3,4,9,25} k=2, (3,4) | 4.52M | 18 | 23 (shift +5) | 28 (shift +10) | Prop 84.1 |
| Synthetic small $B^*$, (2,9) | 10K | 19 | 28 (shift +9) | 38 (shift +19) | Prop 84.1 |
| Synthetic large $B^*$, (2,9) | 1G | 36 | 45 (shift +9) | 57 (shift +21) | Prop 84.1 |
| Synthetic small $B^*$, (4,9) | 10K | 9 | 13 (shift +4) | 16 (shift +7) | Prop 84.1 |
| Synthetic large $B^*$, (4,9) | 1G | 18 | 22 (shift +4) | 26 (shift +8) | Prop 84.1 |

**Honest reading:**

1. For all certified cases (and a wide range of synthetic ones),
   **Prop 84.1 with $K \le 112$ has the smaller shift** than Prop 84.2
   with $\mu_0 = 5.117$.  This is because $\log(K+1) = \log 113 \approx 4.7$,
   while $(\mu_0 - 1) \log \log B^* \approx 4.1 \cdot \log\log B^* \approx 9$ for $B^* \sim 10^6$.

2. **Prop 84.2 closes (H4') unconditionally** for any $B^*$ in the
   asymptotic regime — no per-case PQ computation needed.  This is
   its essential value.

3. Prop 84.1 requires the per-pair PQ bound $K$ to extend through
   the relevant convergent depth ($p_n$ up to $M_{\mathrm{MW}}$).
   For $(3, 4)$: certified through depth ~12 ($p_n$ up to ~$10^6$).
   Beyond that depth, $K$ would need re-certification.

4. The intermediate window $[M_L, \min(M_L', M_L''))$ is at most
   ~10 convergents wide.  These can be verified by exact rational
   arithmetic per case.

## 3. The combined closure result

> **Theorem 87.1 (combined (H4') closure for $(2, 3)$-derived pairs).**
> Let $(A, k)$ be hypothesis-meeting exact-critical with some pair
> $(x, y) \in A^2 \cap \mathcal P_{23}$ multiplicatively independent.
> Let $B^* = B^*(A, k, x, y)$ as in Theorem B''.  Define:
> 
> - $M_L = M_L(B^*, x, y)$ (Legendre threshold).
> - $M_L' = M_L'(B^*, x, y, K)$ (Prop 84.1 threshold under $K$).
> - $M_L'' = M_L''(B^*, x, y, \mu_0)$ (Prop 84.2 threshold under $\mu_0 = 5.117$).
> - $M_{\mathrm{MW}} = M_{\mathrm{MW}}(B^*, x, y)$ (MW threshold).
> 
> Let $M_L^{\dagger} = \min(M_L', M_L'')$.  Then (H4') holds if:
>
> - **(i)** every CF convergent $(p_n, q_n)$ of $\log y/\log x$ with
>   $p_n \in [M_L, M_L^{\dagger})$ has $|x^{p_n} - y^{q_n}| > B^*$
>   (the *intermediate-window check*, bounded enumeration); AND
>
> - **(ii)** for the range $[M_L^{\dagger}, M_{\mathrm{MW}})$:
>   - if $M_L^{\dagger} = M_L'$: Prop 84.1 closes provided $K$ bounds
>     the PQ through depth $M_{\mathrm{MW}}$ (a *per-pair certification*).
>   - if $M_L^{\dagger} = M_L''$: Prop 84.2 closes unconditionally
>     (via Rhin's $\mu_0 \le 5.117$).

*Proof.*  Direct combination of Propositions 84.1 and 84.2 (notes 84,
86), choosing the tighter shift.  $\square$

For pairs in $\mathcal P_{23}$, the **asymptotic regime is
unconditional** (Prop 84.2 always applies for sufficiently large
$B^*$).  The intermediate window is bounded by
$\min(M_L', M_L'') - M_L = O(1)$ — at most ~10 convergents to check.

## 4. Concrete instances of the unconditional asymptotic regime

For Prop 84.2 to be the *operative* tool (closing more than Prop 84.1
alone), we need $M_L'' < M_L'$.  This happens when the PQ bound $K$
is large enough that the bounded-PQ shift exceeds the
bounded-$\mu_0$ shift:
$$\log(K+1) / \log x \;>\; (\mu_0 - 1) \log\log B^* / \log x.$$

For $(3, 4)$ with $\mu_0 = 5.117$: Prop 84.2 beats Prop 84.1 iff
$\log(K+1) > 4.117 \log\log B^*$, i.e., $K > (\log B^*)^{4.117} / e^{O(1)}$.

For $B^* = 10^9$: $(\log B^*)^{4.117} \approx 20.7^{4.117} \approx 3 \cdot 10^5$.

So Prop 84.2 beats Prop 84.1 when the PQ bound exceeds $\sim 10^5$.

**Cases where Prop 84.2 is essential:**
- Pairs $(x, y)$ where deep CF computation hasn't been done (no
  computed $K$ bound).
- Cases with $B^*$ so large that the relevant CF depth exceeds
  computed extent.
- Theoretical / abstract claims about classes of $(A, k)$ not yet
  enumerated.

For pairs in $\mathcal P_{23}$: Prop 84.2 is **always available**
unconditionally with $\mu_0 = 5.117$, regardless of CF depth.

## 5. Closure summary

After this note, the (H4') verification has three modes:

| Mode | When | Cost | Conditional on |
|---|---|---|---|
| **Direct CF enumeration** | $B^*$ moderate, PQ certified through window depth | low (notes 46, 07, 09, 10, 11) | per-case PQ |
| **Prop 84.1 (bounded PQ)** | $K$ certified through window depth | low (one-time pair certification) | $K$ bound |
| **Prop 84.2 (bounded $\mu$)** | $\mu_0$ known for the pair | none (theorem-level) | $\mu_0$ from literature |

For pairs in $\mathcal P_{23}$: all three modes available.  For other
pairs $(x, y)$: needs per-pair $\mu_0$ from the literature.

## 6. Other small-pair $\mu$ bounds (literature pointers)

The literature on irrationality measures of $\log y/\log x$ for
specific small integer pairs is extensive.  Known sharp bounds
(reproduced from secondary sources; verify via primary literature
before citing):

| Pair | $\mu(\log y/\log x)$ best known | Source (approximate) |
|---|---|---|
| (2, 3) | $\le 5.117$ | Rhin 1987 (sharpened over time) |
| (2, 5) | $\le $ low single digits | Various; Hata, Marcovecchio |
| (3, 5) | $\le $ low single digits | Various |
| (2, 7), (3, 7), (5, 7) | bounds exist, less sharp | Laurent / general LMN |
| general pair $(x, y)$ | $\le 2 + O(\log x \log y)$ | Laurent 2008 generic form |

For each pair with a known sharp $\mu_0$, Prop 84.2 immediately
gives an unconditional asymptotic-regime closure.

## 7. Impact on the certified-cases class

The 12,226 certified hypothesis-meeting $(A, k)$ cases in notes 81,
70, 67 use pairs determined by note 17's multiplicative-class
reduction.  In practice the available pairs depend on $A$:

- Most sets contain at least one element of $\{4, 8, 16\}$ and at
  least one of $\{3, 9\}$: a $\mathcal P_{23}$ pair is available.

- Sets contained in $\{5, 6, 7, 10, 11, 12, 13, 14, 15, 17, 19, 20\}$:
  no $\mathcal P_{23}$ pair; need other Diophantine input.  These
  are a minority.

**Estimate** (without re-running the enumeration): roughly 70–90% of
the 12,226 certified cases have a $\mathcal P_{23}$ pair available.
For these, Theorem 87.1 gives an *unconditional* closure of (H4')
modulo the bounded intermediate-window check.

The remaining 10–30% need:
- $\mu$ bounds for pairs not in $\mathcal P_{23}$ (literature lookup); OR
- Per-pair PQ bounds via direct CF computation (extends Prop 84.1).

## 8. Status

This note (Phase B-20) delivers:

- **Theorem 87.1**: combined (H4') closure using both Prop 84.1 and
  Prop 84.2, via $\min(M_L', M_L'')$ shift selection.

- **Numerical verification** (`haskell/RegimeThresholds.hs`): for the
  four certified CF/MW cases, Prop 84.1 is the tighter tool;
  Prop 84.2 is essential for asymptotic / unconditional claims.

- **The $\mathcal P_{23}$ class**: all (2, 3)-derived pairs share
  $\mu_0 \le 5.117$, giving a uniform unconditional asymptotic
  closure across a substantial sub-class of certified cases.

What remains open:
- $\mu$ bounds for non-$\mathcal P_{23}$ pairs.  Literature work, not
  research math.
- Lang's conjecture ($\mu = 2$ uniformly) to collapse the
  intermediate window to zero.  Central remaining obstacle.

The honest scope: this note extends the (H4') closure analysis from
"one pair (3,4) specifically" to "any pair in $\mathcal P_{23}$
uniformly".  It does not close any new specific case beyond what
Prop 84.1 already gave for (3,4) — but it provides the *structural
foundation* for extending to all (2,3)-derived pairs (and, by
literature lookup, other small pairs).
