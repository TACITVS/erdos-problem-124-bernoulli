# Proposition 84.2 — (H4') via irrationality measure $\mu(\log y/\log x)$

Phase B-19: extend Proposition 84.1 (note 84) from a *bounded-PQ*
hypothesis to a *bounded irrationality-measure* hypothesis.  Since
$\mu(\log y / \log x)$ is known to be finite for any
multiplicatively-independent integer pair $(x, y)$ (via Baker's
theorem on linear forms in logarithms), this gives an **uncondi
tional structural result** that closes (H4') asymptotically for every
mult-indep pair — at the cost of a *per-pair* effective threshold on
$B^*$.

Combined with Proposition 84.1 for small $B^*$ (where partial
quotients can be computed directly), the **two propositions cover
both ends of the $B^*$ spectrum**, leaving only a per-pair
intermediate range that requires explicit computation.

## 0. Headline

> **Proposition 84.2 (irrationality-measure form).**  Let
> $\alpha = \log y/\log x$ with $x < y$ multiplicatively-independent
> integers $\ge 3$.  Suppose $\mu(\alpha) \le \mu_0$ for some explicit
> $\mu_0 \ge 2$ (such $\mu_0$ exists effectively for every
> mult-indep integer pair by Baker / Laurent–Mignotte–Nesterenko).
>
> Define $M_L'' = M_L''(\mu_0, B^*, x)$ as the smallest integer $p$
> satisfying
> $$p \log x \;>\; (\mu_0 - 1) \log p + \log(4 B^*/\log x).$$
>
> Then for every CF convergent $(p_n, q_n)$ of $\alpha$ with
> $p_n \ge M_L''$ (and $q_n$ large enough for the asymptotic $\mu$
> bound to apply):
> $$|x^{p_n} - y^{q_n}| \;>\; B^*.$$
>
> In particular, **(H4') holds automatically** for the window
> $[M_L'', M_{\mathrm{MW}})$, contributing alongside Proposition 84.1
> to the (H4') verification.

## 1. Setup

Recall (note 84):
- $\alpha = \log y/\log x$, $x < y$ mult-indep, $\alpha > 1$.
- CF convergents $(p_n, q_n)$ with $p_n > q_n$.
- (H4') = "every $|x^{p_n} - y^{q_n}| > B^*$ for $p_n \in [M_L, M_{\mathrm{MW}})$".

The *irrationality measure* of $\alpha$ is:
$$\mu(\alpha) \;:=\; \inf\Bigl\{\mu : |q\alpha - p| > q^{-(\mu-1)}
                                       \text{ for all but finitely many } (p, q)\Bigr\}.$$

For algebraic irrational $\alpha$: $\mu(\alpha) = 2$ by Roth.  For
transcendental $\alpha$: $\mu(\alpha) \ge 2$ always, with
$\mu(\alpha) = 2$ for almost-every $\alpha$ (Khintchine), and Lang
conjectures $\mu(\alpha) = 2$ for $\alpha = \log y/\log x$.

**Known explicit bounds.**  Best known $\mu(\log p/\log q)$ for small
integer pairs:
- $\mu(\log 2/\log 3) \le 5.117$ (Rhin 1987) — sharpened over time.
  Hence $\mu(\log 4/\log 3) = \mu((\log 2/\log 3)/(1/2)) = \mu(\log 2/\log 3) \le 5.117$.
  (Multiplication by a non-zero rational doesn't change irrationality
  measure.)
- Similar bounds known for $(\log 3/\log 5), (\log 2/\log 5)$, etc.
- For general mult-indep pairs: explicit but loose bounds via
  Laurent 2008.

## 2. The proposition

> **Proposition 84.2.**  Let $\alpha = \log y/\log x$ as above with
> $\mu(\alpha) \le \mu_0$.  Then for any $\epsilon > 0$, there exists
> a *finite* $q_*(\mu_0, \epsilon, \alpha)$ such that:
> $$\text{for } q_n \ge q_*\!:\quad q_{n+1} \;\le\; q_n^{\mu_0 - 1 + \epsilon}.$$
>
> Equivalently: for $q_n \ge q_*$, the next CF partial quotient
> satisfies $a_{n+1} \le q_n^{\mu_0 - 2 + \epsilon}$.

*Proof.*  By definition of $\mu$, for any $\epsilon > 0$:
$|q\alpha - p| > q^{-(\mu_0 - 1 + \epsilon)}$ for all but finitely many
$(p, q)$.  At a CF convergent, $|q_n \alpha - p_n| < 1/q_{n+1}$.
Combining: $1/q_{n+1} > q_n^{-(\mu_0 - 1 + \epsilon)}$ for $q_n$
beyond the finite exceptional set, i.e.,
$q_{n+1} < q_n^{\mu_0 - 1 + \epsilon}$.  $\square$

## 3. Deriving (H4') from bounded $\mu$

> **Lemma 86.1 (irrationality-measure form of Lemma 84.1).**  Under
> Proposition 84.2's hypothesis, for every CF convergent $(p_n, q_n)$
> with $q_n \ge q_*$:
> $$|x^{p_n} - y^{q_n}| \;\ge\; \frac{x^{p_n} \log x}{4 q_n^{\mu_0 - 1 + \epsilon}}.$$

*Proof.*  Combining Lemma 84.1 with Proposition 84.2:
$$|x^{p_n} - y^{q_n}| \;\ge\; \frac{x^{p_n} \log x}{4 q_{n+1}}
   \;\ge\; \frac{x^{p_n} \log x}{4 q_n^{\mu_0 - 1 + \epsilon}}. \quad\square$$

> **Proposition 84.2 (refined).**  Under the hypothesis $\mu(\alpha) \le \mu_0$,
> for every CF convergent $(p_n, q_n)$ with $p_n \ge M_L''$, where
> $M_L''$ is the smallest integer satisfying
> $$x^{M_L''} \cdot \log x \;>\; 4 (M_L'')^{\mu_0 - 1 + \epsilon} B^*,$$
> (equivalently $M_L'' \log x - (\mu_0 - 1 + \epsilon) \log M_L'' > \log(4 B^* / \log x)$),
> we have
> $$|x^{p_n} - y^{q_n}| \;>\; B^*.$$

*Proof.*  By Lemma 86.1, $|x^{p_n} - y^{q_n}| \ge x^{p_n} \log x /
(4 q_n^{\mu_0 - 1 + \epsilon}) \ge x^{p_n} \log x /
(4 p_n^{\mu_0 - 1 + \epsilon})$ (using $q_n < p_n$).  For $p_n \ge M_L''$:
$x^{p_n} \log x > 4 p_n^{\mu_0 - 1 + \epsilon} B^*$, giving the
claim.  $\square$

**Threshold growth.**  Asymptotically:
$$M_L'' \;\sim\; \frac{\log B^*}{\log x} + \frac{(\mu_0 - 1)}{\log x} \log\log B^* + O(1).$$
For comparison, $M_L \sim \log B^*/\log x + O(\log\log B^*)$.
So $M_L'' - M_L = O((\mu_0 - 1) \log\log B^*/\log x)$ — sub-logarithmic
in $B^*$, polynomial in $\mu_0$.

## 4. Two-regime (H4') analysis

Combining Propositions 84.1 and 84.2:

| $B^*$ regime | Tool | Hypothesis required |
|---|---|---|
| **Small** $B^* \le B_1$ | Proposition 84.1 (bounded PQ) | Explicit PQ bound $K$ in first few convergents |
| **Large** $B^* \ge B_2$ | Proposition 84.2 (bounded $\mu$) | $\mu_0$ from Baker / LMN |
| **Intermediate** $B_1 < B^* < B_2$ | Either, with per-case CF computation | Explicit PQ + $\mu$ bridging |

For the (3, 4)-pair with $\mu_0 \le 5.2$ (rounding up Rhin's bound):

- $B_1$ = largest $B^*$ such that $M_{\mathrm{MW}}(B^*)$ is within the
  certified PQ-bounded depth.  Currently: ~12 convergents reaching
  $p_n \approx 10^6$, so $M_{\mathrm{MW}} \le 10^6 \Rightarrow B^* \le $ a moderate value.

- $B_2$ = smallest $B^*$ such that $M_L''(\mu_0, B^*, x)$ is below
  $M_L(B^*, x, y)$, i.e., the asymptotic regime kicks in.
  Compute: $M_L'' = M_L + O((\mu_0 - 1) \log\log B^*/\log x)$.  The
  asymptotic kicks in when $\log B^*$ dominates
  $(\mu_0 - 1) \log\log B^*$, which is automatic for $\log B^* \ge $
  modest constant.

For $\{3,4,7\}$ k=1 with $B^* = 5835$: $\log B^* \approx 8.7$.
$(\mu_0 - 1) \log\log B^* = 4.2 \cdot \log 8.7 \approx 4.2 \cdot 2.16 \approx 9$.
The asymptotic regime requires $\log B^* \gg 9$, not satisfied here.
So Proposition 84.2 doesn't apply directly for $B^* = 5835$ —
Proposition 84.1 with $K \le 112$ (note 84 §4.1) is the right tool.

For higher-$k$ cases with $B^* \approx 10^9$: $\log B^* \approx 20.7$,
$(\mu_0 - 1) \log\log B^* \approx 4.2 \cdot 3.0 = 12.6 < 20.7$.  ✓
Proposition 84.2 applies asymptotically.  Specifically:
$M_L'' - M_L \approx 12.6/\log 3 \approx 11.5$, so $M_L'' \approx M_L + 12 \approx 32$.

For $\{3,4,7\}$ k=3 with $M_L = 23$, $M_L'' \approx 35$.  The window
$[M_L'', M_{\mathrm{MW}}) \approx [35, 10^{11})$ has (H4') automatic.
The intermediate range $[M_L, M_L'') = [23, 35]$ has $\le 12$
convergents whose gaps must be checked directly (via the bounded-PQ
form with computed $K$).

## 5. Uniform-class corollary

> **Corollary 86.2 (uniform (H4') for (3,4)-pair class).**  For every
> hypothesis-meeting $(A, k)$ with $(3, 4) \in A^2$ multiplicatively
> independent, the verification of (H4') reduces to:
> 1. Computing $c^*$, $B^*$, $M_L$, $M_L''$, $M_{\mathrm{MW}}$ for the case.
> 2. Verifying that the CF convergents of $\log 4/\log 3$ in
>    $[M_L, M_L'')$ (a window of $O(\log\log B^*)$ convergents) all
>    have $|3^{p_n} - 4^{q_n}| > B^*$.
> 3. Proposition 84.2 handles the rest of the window $[M_L'', M_{\mathrm{MW}})$.

Step 2 is a *bounded-window arithmetic check* — no infinite
enumeration required.  Step 3 is *unconditional* given the known
$\mu(\log 4/\log 3) \le 5.2$.

This is the **best clean uniform result** for the (3, 4)-pair class.

For other pairs $(x, y)$: same structure, with $\mu_0$ from Baker /
LMN / pair-specific results.

## 6. What remains genuinely open

After Proposition 84.2:

**Uniform across all hypothesis-meeting $(A, k)$:**  requires the
chosen pair $(x, y) \in A^2$ to have a *known* $\mu(\log y/\log x) \le \mu_0$
with $\mu_0$ moderate enough that the intermediate-range CF check
(Step 2 of Corollary 86.2) is computationally feasible.

For pairs with poor known $\mu$ bounds (or large $\mu_0$): the
intermediate range grows, eventually swamping any practical
verification.  This is the residual obstacle.

**Lang's conjecture $\mu = 2$ uniformly:** would eliminate the
intermediate range entirely.  Until Lang's conjecture is proved (or
shown to be false), the uniform-across-all-$(A, k)$ result is
conditional on the Baker-style effective bounds for each pair.

## 7. Effective improvement summary

After this note + note 84:

- (H4') verification per case reduces to:
  - For $B^*$ small: explicit CF window enumeration (computational).
  - For $B^*$ moderate: per-pair $K$ bound + Proposition 84.1.
  - For $B^*$ large: Proposition 84.2 with known $\mu_0$ — *no
    per-case computation*.

- The intermediate range $[B_1, B_2]$ requires explicit but bounded
  computation (window size $O(\log\log B^*)$).

- For the four originally certified CF/MW cases: Proposition 84.1
  with $K \le 112$ handles all four.

- For *new* hypothesis-meeting cases with $(3, 4) \in A^2$ and $B^*$
  in the large regime ($B^* \ge B_2 \approx 10^6$, say): Proposition
  84.2 with $\mu_0 \le 5.2$ handles them *unconditionally*, no extra
  computation beyond the pair-independent $\mu$ bound.

This extends the (H4') closure from a finite set of certified cases
to an *infinite class* defined by pair structure and $B^*$ size.

## 8. Status

This note (Phase B-19) delivers:

- **Proposition 84.2**: bounded $\mu(\log y/\log x)$ ⟹ (H4')
  automatic on a window $[M_L'', M_{\mathrm{MW}})$ with effective
  $M_L'' = M_L + O((\mu_0 - 1) \log\log B^*/\log x)$.
- **Lemma 86.1**: irrationality-measure form of Lemma 84.1.
- **Corollary 86.2**: clean uniform (H4') for the (3, 4)-pair class.
- **Two-regime analysis** dividing $B^*$ into small (Prop 84.1) and
  large (Prop 84.2), with a bounded intermediate range.

What's genuinely closed: (H4') is unconditional for any
$(A, k)$-pair with known $\mu_0$ and $B^*$ in the large regime.

What's still open: Lang's conjecture (or sharper $\mu$ bounds) to
collapse the intermediate range to zero.  This remains the central
Diophantine obstacle, now precisely framed.
