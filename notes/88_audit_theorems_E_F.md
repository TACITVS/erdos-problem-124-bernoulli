# Audit of Theorems E and F — corrections to notes 76 and 77

Phase B-21: audit Theorems E (note 76) and F (note 77) for hidden
assumptions and proof gaps, in the style of the (H5') audit of
Theorem B (note 82 → note 83).  Two substantive findings:

- **Theorem E (note 76):** notational conflation of *max gap* and
  *conductor*.  The theorem holds as a max-gap statement; the
  $c(T)$ notation in §2–4 is misleading.  Repairable by rename.

- **Theorem F (note 77):** **false as stated**.  Proof's major-arc
  analysis applies Taylor expansion of $\hat X_T$ outside its range
  of validity.  Direct counterexample: $r_T(10) = 0$ in the
  $\{3,4,5\}$ k=1 case for all $T$, while Theorem F claims
  $r_T(10) > 0$ for $T$ large.  Theorem F is **withdrawn** in its
  current form; the question of pointwise representability for
  small $n$ remains open.

## 0. Headline

> **Theorem E (note 76)** is correct as a *max-gap* theorem, but its
> conclusion was conflated with the project's *conductor*.  Note 76's
> §0 acknowledged the distinction but §2–4 used $c(T)$ ambiguously.
> Corrected: the theorem proves $g(T) = O(T^{1/3})$ where $g$ is max
> gap, NOT $c(T) = O(T^{1/3})$ where $c$ is conductor.
>
> **Theorem F (note 77)** is **incorrect as stated**.  The major-arc
> analysis (§2) uses the Taylor approximation $\hat X_T(\xi) \approx 1$
> on the range $|\xi| < \delta = T^{-1/2}/(12C \cdot n)$, but Taylor
> validity requires $|\xi| \ll 1/T$ — incompatible for $T > 1$ in the
> relevant range.  Direct numerical refutation: $r(10) = 0$ in
> $\{3,4,5\}$ k=1, contradicting Theorem F's claim that
> $r(n) > 0$ for $n \le 14$ at $T = 10000$.

## 1. Theorem E audit

### 1.1 The notational issue

Note 76 §0 explicitly writes:
> "max gap $g$ ≠ conductor $c$ in general.  The conductor is the
> largest missing value in $[0, S/2]$, while max gap is the longest
> run of consecutive missing values."

But §2–4 use $c(T)$ for max gap:

- §2 Lemma 2.2: "the maximum gap in $\text{supp}(X_T) \cap [0, S/2]$
  satisfies $c(T) \le 2 \cdot S \cdot D + 1$".  Here $c(T)$ is
  max gap.

- §4 Theorem E: "$c(T) \le 4 (C_A)^{1/3} T^{1/3} + 1 = O(T^{1/3})$".
  Same $c$ notation, still meaning max gap.

The project's *standard* notation is $c(T) =$ conductor (largest
missing value).  Using $c(T)$ for max gap in note 76 is a real
notational conflict, easily misread as "Theorem E closes the
conductor open obligation".

### 1.2 The actual content of Theorem E

> **Theorem E (corrected statement).**  Let $A$ be hypothesis-meeting,
> $F(E(T))$ the seed at scale $T$, $X_T = \sum_f \varepsilon_f f$ the
> subset-sum random variable.  If $L_2(T) := \sum_n p_T(n)^2 \le C_A/T$
> for all sufficiently large $T$, then the **max gap** $g(T)$ in
> $\mathrm{supp}(X_T) \cap [0, S(T)/2]$ satisfies
> $$g(T) \;\le\; 4 (C_A)^{1/3} T^{1/3} + 1.$$
>
> *This is a max-gap bound, not a conductor bound.*

This corrected statement is exactly what the proof in §2–4 (with $c$
read as $g$) actually establishes.  No issue with the proof — only
with the naming.

### 1.3 Why max gap ≠ conductor

Concrete example.  Suppose $\Sigma(F)$ misses exactly the single
integer $n_0 = 100$ in $[0, S/2]$.  Then:
- Max gap $g = 2$ (just one gap of length 1 between $99$ and $101$).
- Conductor $c = 100$ (the missing integer itself).

Max gap small does NOT imply conductor small.

For our certified cases: $c$ ranges from 79 to ~$10^8$; max gap is
empirically small (often $\le 10$).  These are genuinely different
quantities.

### 1.4 What Theorem E gives that the original framing implied — and didn't

Original framing: "Theorem E reduces the conductor open obligation
to $L_2 = O(1/T)$".

Corrected: "Theorem E reduces a **max gap** bound to $L_2 = O(1/T)$".

The conductor open obligation is NOT reduced to BC L² by Theorem E.

(The link from max gap to conductor would require an additional
argument, possibly via the monotonicity-in-$T$ argument sketched in
note 76 §0 — but that was identified as "unresolved".)

### 1.5 Repair

Replace $c(T)$ by $g(T)$ throughout note 76 §2–4, and amend Theorem E's
statement to specify "max gap".  A repair patch is appended to note 76
in a follow-up commit.

## 2. Theorem F audit

### 2.1 The major-arc Taylor issue

Note 77 §2 writes:
> "Major arc integral over $|\xi| < \delta$:
> $\mathcal I_{\text{maj}}(n) = \int_{|\xi| < \delta} \hat X_T(\xi) e^{-2\pi i n\xi} d\xi
> \approx \int_{|\xi|<\delta} e^{-2\pi i n\xi} d\xi = \sin(2\pi n\delta)/(\pi n)$."

The approximation $\hat X_T(\xi) \approx 1$ over $|\xi| < \delta$ is
made implicitly.  This is justified by Taylor expansion:
$\hat X_T(\xi) = 1 - 2\pi^2 \xi^2 \mathbb E[X_T^2] + O(\xi^4)$.

For the approximation $\hat X_T \approx 1$ to be valid with relative
error $< 1$: $\xi^2 \mathbb E[X_T^2] \lesssim 1$, i.e., $|\xi| \lesssim 1/\sqrt{\mathbb E[X_T^2]}$.

For balanced $F$ at scale $T$: $\mathbb E[X_T^2] = \sigma_T^2 + (\mathbb E X_T)^2
\approx (\sum_f f)^2/4 + \sum_f f^2/4 = O(T^2)$.

So $|\xi| \lesssim 1/T$ for Taylor validity.

But §4 picks $\delta = 1/(6n)$ with $n \le T^{1/2}/(12C)$, giving
$\delta \ge 12 C/(6 T^{1/2}) = 2C/T^{1/2}$ — much *larger* than $1/T$
for $T > 1$.

So Taylor validity fails on the major arc.  The approximation
$\hat X_T \approx 1$ does not hold over $|\xi| < \delta = T^{-1/2}$.

### 2.2 Direct numerical refutation

For $A = \{3, 4, 5\}$, $k = 1$: the seed at any $T$ is
$F(T) \subseteq \{3, 4, 5, 9, 16, 25, 27, 64, 81, 125, \ldots\}$.

Check $r_T(10)$ for any $T$: is $10$ expressible as a subset sum of
distinct elements of $F$?

- $10 = 3 + ?$ with $? \in F \setminus \{3\}$: need $? = 7$.  $7 \notin F$.
- $10 = 4 + ?$: need $? = 6 \notin F$.
- $10 = 5 + ?$: need $? = 5 \notin F \setminus \{5\}$.  (Each $5$ used at most once.)
- $10 = 9 + 1$: $1 \notin F$.
- $10 = $ no other singleton.
- $10 = 3 + 4 + ?$: need $? = 3$, already used.
- $10 = 3 + 5 + ?$: need $? = 2 \notin F$.
- $10 = 4 + 5 + ?$: need $? = 1 \notin F$.
- $10 = $ no other 3-element subset.

Conclusion: **$r_T(10) = 0$ for all $T$**.  Hence $r_T(10) > 0$ is
false at any $T$, regardless of how large.

Theorem F's claim: "for sufficiently large $T$, every integer
$n \in [0, T^{1/2}/(12C)]$ satisfies $r_T(n) > 0$".

Empirically for $\{3, 4, 5\}$ k=1: $T \cdot L_2(T) \to 0.58$ from
note 76 §8, so $C \approx 0.58$ is the smallest constant satisfying
$L_2 \le C/T$.

At $T = 10000$: $T^{1/2}/(12C) \approx 100/6.96 \approx 14.4 > 10$.
So Theorem F claims $r_T(10) > 0$, but in fact $r_T(10) = 0$.

**Theorem F is false.**

### 2.3 The underlying issue

Theorem F's intent: pointwise representability for small $n$, via
circle method + L² bound on minor arc.

The issue: the major arc analysis assumes $\hat X_T$ behaves like a
"delta function" near $\xi = 0$, contributing $\sim \delta$ to
$\mathcal I_{\text{maj}}(n)$ for $n \delta < 1/4$.  But $\hat X_T$
actually decays rapidly away from $\xi = 0$ — it's NOT delta-like.

For a true delta-like behavior, one would need $\hat X_T(\xi)$
*concentrated* near $\xi = 0$ to width $1/T$, then approximately zero
on $[1/T, 1]$.  Empirically for our $\hat X_T$: this is *roughly*
true (Fourier of a discrete measure decays), but the precise
quantitative form depends on multi-base structure.

A correct circle-method analysis would need:
1. Sharp estimate of $\hat X_T$ on $|\xi| < 1/T$ (where Taylor holds).
2. Sharp estimate on $\hat X_T$ for $|\xi| > 1/T$ (where Taylor fails).
3. Combine to get $\mathcal I_{\text{maj}}$ + $\mathcal I_{\text{minor}}$.

Step 1 gives $\mathcal I_{\text{maj}} \approx 2/T$ (the major arc
width times $1$).  Step 2 is the difficulty: the actual
$\int_{1/T}^{1-1/T} \hat X_T(\xi) e^{-2\pi i n\xi} d\xi$ may or may
not be small.  L² bound alone gives only $\sqrt{L_2}$, dominating
$1/T$ unless $L_2 = O(1/T^2)$ — much stronger than the BC L²
conjecture.

So circle method with L²-only minor arc bound gives at most:
- Major arc: $\sim 1/T$.
- Minor arc: $\le \sqrt{L_2} = O(T^{-1/2})$.

$r_T(n)/2^{|F|} \le \mathcal I_{\text{maj}} + \mathcal I_{\text{minor}} = O(T^{-1/2})$ — *positive only if* one of these is positive (which the bound doesn't guarantee).

The conclusion $r_T(n) > 0$ requires a SHARPER bound on $\hat X_T$ on
the minor arc, beyond Cauchy-Schwarz from $L_2$.

This is the **Diophantine subtlety** flagged in note 77 §8–9.  But
the version of Theorem F as stated in §5 *bypassed* this subtlety
incorrectly.

### 2.4 What can be salvaged

The CORRECT version of Theorem F would be:

> **Theorem F (corrected, conjectural).**  Assume $L_2(T) \le C/T$
> AND a Diophantine estimate of the form
> $|\hat X_T(\xi)|^2 \le C'/T$ uniformly for
> $\xi \in [1/T, 1 - 1/T]$.  Then for $T \ge T_0$ and
> $n \in [c(T) + 1, T^{1/2}/(12 \max(C, C'))]$, $r_T(n) > 0$.

The new hypothesis $|\hat X_T(\xi)|^2 \le C'/T$ uniformly is much
stronger than $L_2 = O(1/T)$ (which is an integrated bound).  It's
related to (but distinct from) **Fourier decay** of the Bernoulli
convolution $\mu_A$.

Whether this Diophantine bound holds for our multi-base $F$:
**open**.  No published result establishes it for integer-Pisot.

So Theorem F's *original* claim (BC L² ⟹ pointwise representability)
**does not hold**.  The corrected statement above is conditional on
both BC L² *and* a uniform Fourier decay estimate.

### 2.5 Status of Theorem F

> **Theorem F is withdrawn in its original form.**  Note 77 should
> be revised to acknowledge:
>
> (a) The major-arc Taylor approximation is invalid for the chosen
>     $\delta$.
> (b) The conclusion is empirically refutable ($r(10) = 0$ in
>     $\{3,4,5\}$ k=1).
> (c) A corrected version requires a uniform $|\hat X_T(\xi)|$ bound,
>     not just $L_2$ — open.

This is a real audit finding, in the same spirit as the (H5')
discovery for Theorem B.  Auditing pays off.

## 3. Impact on the project

### 3.1 Boss tree / GlobalProofAudit

`haskell/GlobalProofAudit.hs` does not currently list Theorems E or F
as certified — they are presented as conditional reductions in notes
76, 77.  No update to the audit script is needed for the
correctness of the existing entries.

However, README.md and PROOF_STATE.md should be amended to:
- Replace any "Theorem E closes conductor" claims with "Theorem E
  closes max gap" — qualified to max gap.
- Withdraw any claim that Theorem F gives pointwise representability.
- Note 88 as the audit reference.

### 3.2 What the open obligation reduction chain becomes

Before this audit, the reduction chain looked like:
```
BC L² ⟹ L_2 = O(1/T) ⟹ {max gap = O(T^{1/3}) (Thm E),
                        r(n) > 0 for n ≤ √T (Thm F)}
                    ⟹ Erdős 124 (modulo some gap analysis)
```

After the audit:
```
BC L² ⟹ L_2 = O(1/T) ⟹ max gap = O(T^{1/3}) (Thm E, corrected)
                                   |
                                   v
                       (does NOT imply conductor bound)
```

The bridge from max gap to conductor remains a NEW open problem,
*not* solved by Theorem E even under BC L².

So the audit shrinks what the project's "BC L² ⟹ Erdős 124" reduction
provides.  The retraction in PROOF_STATE.md §5.2 of the BC route is
*further reinforced*: even granting BC L², the bridge to Erdős 124 is
not closed.

### 3.3 Open problems sharpened

The (H4') reformulation (note 84) remains intact — it does not
depend on Theorems E or F.  Theorem B'' + Proposition 83.1 + 84.1 +
84.2 + 87.1 remain valid.

The conductor open obligation now has *two* paths it could be
closed:
1. (H4') uniformly ⟸ Lang's conjecture (note 84).
2. Direct conductor bound from Fourier analysis ⟸ uniform Fourier
   decay (a sharper hypothesis than BC L², via the corrected
   Theorem F path).

Both are open, but the structural framing is now correct.

## 4. Lessons

This audit found:
- (H5') hidden assumption in Theorem B (closed in note 83 via
  induction).
- Theorem E notational conflation (max gap vs conductor; correctable).
- **Theorem F false as stated** (proof gap, empirical refutation).

Project-level lesson: every load-bearing algebraic theorem should be
audited at this level of detail BEFORE being added to PROOF_STATE.md
or used in subsequent reductions.  The (H5') and Theorem F findings
each represent multi-week potential delays if not caught.

Recommendation: a one-time audit pass over Theorems A, B, B', B'',
C, Proposition D, 83.1, 84.1, 84.2, 87.1 — the entire algebraic
backbone — to catch any remaining hidden assumptions.

The audit discipline is paying off.  Each pass surfaces real issues.

## 5. Status

This note (Phase B-21) delivers:

- **Audit of Theorem E (note 76):** notational issue identified, fix
  is straightforward.  Theorem E correctly states max gap bound, not
  conductor bound.

- **Audit of Theorem F (note 77):** false as stated.  Proof gap
  (Taylor expansion misuse).  Empirical refutation
  ($r_T(10) = 0$ in $\{3,4,5\}$ k=1 for all $T$).  Theorem F
  withdrawn pending corrected statement requiring uniform Fourier
  decay (open).

- **Project impact:** README.md and PROOF_STATE.md should be amended
  in follow-up commits to reflect these corrections.

This is a substantial correctness finding.  The (H4') reformulation
of the open obligation (notes 84, 86, 87) is unaffected; the
Diophantine framing remains the project's central remaining
question.
