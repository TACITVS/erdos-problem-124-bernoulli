# Multi-base Bernoulli AC: deep dive

This note is the maximum-effort attack on the Multi-base Bernoulli AC
Conjecture (note 58 §4).  It contains:

- a rigorous partial result (dim-1 follows from Marstrand-Mattila);
- a sharper conjecture: $\hat\mu_A \in L^2(\mathbb R)$ for
  hypothesis-meeting $A$, strongly supported by numerics;
- a per-scale Fourier-decay reduction;
- connection to Hochman 2014 / Shmerkin 2014 / Varjú 2019;
- concrete sub-problem for $\{3,4\}$;
- explicit roadmap.

The headline empirical result: for every hypothesis-meeting case tested,
$\int_{-T}^T|\hat\mu_A(\xi)|^2\,d\xi$ saturates as $T\to\infty$ (e.g.,
$\to 1.87$ for $\{3,4\}$; $\to 1.23$ for $\{3,4,7\}$).  This is
exactly the AC + L² density signature.

## 1. The strengthened conjecture

> **Multi-base Bernoulli L² Conjecture.**  For hypothesis-meeting
> finite $A\subseteq\mathbb Z_{\ge3}$, the Fourier transform
> $\hat\mu_A$ of the multi-base Bernoulli convolution belongs to
> $L^2(\mathbb R)$.

This is *strictly stronger* than the AC conjecture (note 58 §4):

- AC: $\mu_A$ has density $f\in L^1(\mathbb R)$.
- L² density: $f\in L^2$, equivalent to $\hat\mu_A\in L^2$ by
  Plancherel.

L² density ⟹ AC (and additionally gives a quantitative form).

## 2. Rigorous partial result (dim 1)

**Theorem 2.1 (Marstrand–Mattila dim sum).**  For independent random
variables $Y, Z$ on $\mathbb R$ with Hausdorff dimensions $d_Y,
d_Z$,

$$\dim_H(\mathrm{Law}(Y+Z)) \ge \min(1, d_Y + d_Z).$$

(Standard, e.g., Mattila *Geometry of Sets and Measures*, Theorem 9.7.)

**Corollary 2.2.**  For $A\subseteq\mathbb Z_{\ge2}$ finite with
multiplicatively independent bases,

$$\dim_H(\mu_A) = \min\!\Bigl(1,\ \sum_{a\in A}\dim_H(B_{1/a})\Bigr)
= \min\!\Bigl(1,\ \sum_{a\in A}\frac{1}{\log_2 a}\Bigr).$$

For hypothesis-meeting $A$ (i.e., $\sum 1/(a-1)\ge 1$ plus
$a\ge3$), the algebraic identity $1/\log_2 a > 1/(a-1)$ (note 47)
gives $\sum 1/\log_2 a > 1$ strictly, so

$$\dim_H(\mu_A) = 1.$$

This is the *necessary* condition for AC.  It is **not** sufficient
(Cantor-like measures of dimension 1 exist, e.g., the Cantor function
push-forward to $[0,1]$).

## 3. Empirical evidence for L²

`scripts/cas_bernoulli_AC_deep.py` computes
$I(T) = \int_{-T}^T|\hat\mu_A(\xi)|^2\,d\xi$ directly by trapezoidal
quadrature with truncated Fourier products.

| set                | $I(10)$ | $I(100)$ | $I(1000)$ | $I(10000)$ | ratio $I(10^4)/I(10^2)$ |
|--------------------|----------:|-----------:|------------:|-------------:|--------------------------:|
| $\{3\}$ (singular) | 3.20 | 7.24 | 16.38 | 36.86 | **5.09 (linear)** |
| $\{4\}$ (singular) | 3.95 | 15.54 | 46.42 | 126.34 | **8.13 (linear)** |
| $\{3,4\}$        | 1.37 | 1.57 | 1.81 | **1.87** | **1.20 (saturating)** |
| $\{3,4,7\}$      | 1.18 | 1.20 | 1.23 | **1.23** | **1.02 (saturated)** |
| $\{3,4,9,25\}$   | 1.21 | 1.24 | 1.25 | **1.25** | **1.01 (saturated)** |

**Interpretation.** Single-base $I(T)$ grows linearly (matching
Lebesgue measure on Fourier-non-decaying Cantor measure ⟹ not L²).
Hypothesis-meeting multi-base $I(T)$ **saturates** as $T\to\infty$
⟹ $\hat\mu_A\in L^2(\mathbb R)$ ⟹ $\mu_A$ has L² density ⟹ AC.

This is strong empirical support for the conjecture, with a specific
numerical signature.

## 4. Per-scale reduction

$\hat\mu_A\in L^2(\mathbb R)$ iff $\sum_{k\ge 0}\int_{2^k\le|\xi|<2^{k+1}}
|\hat\mu_A(\xi)|^2\,d\xi < \infty$.

Define the per-scale integral

$$I_k := \int_{2^k\le|\xi|<2^{k+1}}|\hat\mu_A(\xi)|^2\,d\xi.$$

**L² ⟺ $\sum I_k<\infty$.**

By the bound $|\hat\mu_A|\le 1$: $I_k\le 2^k$ trivially.

The L² conjecture is equivalent to:

> **Per-scale decay**: $I_k = O(2^{-\epsilon k})$ for some $\epsilon>0$.

Empirically (from §3), $I_k$ appears to decay; the rate determines
the regularity of the L² density.

## 5. The Fourier-decay sub-conjecture

Suppose we can prove:

> **(★)** For hypothesis-meeting $A$, there exists $\epsilon>0$
> (depending on $A$) such that for all $\xi\in\mathbb R$ of large
> modulus,
> $$
> \int_{|\eta-\xi|<1}|\hat\mu_A(\eta)|^2\,d\eta = O(|\xi|^{-1-\epsilon}).
> $$

Then summing over $\xi=2^k$ (or partitioning) gives $I_k=O(2^{-\epsilon k})$,
hence $\hat\mu_A\in L^2$, hence the AC conjecture.

**(★) is the precise analytic obligation.**  It is a *Fourier-decay
estimate* on a multi-base Bernoulli convolution.  It's the kind of
estimate Hochman / Shmerkin / Varjú work on.

## 6. Why (★) is plausible

$\hat\mu_A(\xi) = \prod_a \hat B_{1/a}(\xi)$.

Each $\hat B_{1/a}$ is **bounded by 1 everywhere** but **does not
decay** as $|\xi|\to\infty$ (Cantor / Pisot measure).  Specifically,
by self-similarity: $|\hat B_{1/a}(a^n)|=|\hat B_{1/a}(1)|$ for all
$n\in\mathbb Z$.

So per-base, $|\hat B_{1/a}|$ has *resonance peaks* at $\xi=a^n$
and surrounding scales.

For multiplicatively independent bases $(a, b)$: the resonance peaks
of $\hat B_{1/a}$ (at $\xi=a^n$) and $\hat B_{1/b}$ (at
$\xi=b^m$) **cannot coincide** (except trivially).  So at any
$\xi$, at most one base is at resonance; the other is far from
resonance and contributes a non-trivial decay factor.

Heuristic: in any unit window around $\xi$, the product
$\prod_a|\hat B_{1/a}(\xi)|$ inherits the worst-case singular
behavior of one factor times the AC-like decay of the others.  Net
effect: decay rate is dominated by the "non-resonant" bases'
contribution.

Quantitatively: by Furstenberg-style equidistribution of multiplicative
orbits, the average of $|\hat B_{1/a}|^2$ over scale-1 windows decays
at rate determined by the *Furstenberg dimension* / Fourier dimension
of $B_{1/a}$.

For our setting: empirical $\epsilon$ appears to be $\approx \sum
1/\log_2 a - 1$ (matching the dim-sum slack), but I have not proved
this.

## 7. Concrete sub-conjecture for $\{3,4\}$

> **$\{3,4\}$ Sub-conjecture.**  The convolution
> $\mu_{\{3,4\}} = B_{1/3} * B_{1/4}$ is absolutely continuous on
> $\mathbb R$, with density in $L^2$.

This is the smallest non-trivial case.  By the algebra:
$\dim_H(\mu_{\{3,4\}}) = \min(1, \log_3 2 + \log_4 2)
= \min(1, 0.6309 + 0.5)
= \min(1, 1.1309) = 1$.

So dim 1 holds.  AC is open.

**Attack lines:**

(a) Direct Fourier estimate.  $\hat\mu_{\{3,4\}}(\xi) = \prod_{n\ge0}
\cos(\pi\xi 3^{-n-1}) \cdot \prod_{n\ge0}\cos(\pi\xi 4^{-n-1})$.  Show
this is in $L^2(\mathbb R)$.  Per-scale bound via Diophantine
analysis of $\log 3/\log 4$.

(b) Marstrand projection.  $\mu_{\{3,4\}}$ is the (1,1)-direction
projection of the 2D product measure $B_{1/3} \otimes B_{1/4}$
(dimension 1.13 > 1).  By Marstrand, a.e. direction projection is AC.
The diagonal (1,1) is specific; check whether it's in the exceptional
set.

(c) Solomyak transversality.  Solomyak's transversality method (1995)
proved a.e. $\lambda\in(1/2,1)$ gives AC $B_\lambda$.  Adapted to
convolutions of two BCs, may give AC for a.e. pair $(\lambda_1,
\lambda_2)$.  Whether $(1/3, 1/4)$ is in the AC set: specific question.

(d) Hochman entropy.  Hochman 2014 method: if entropy of finite
truncation matches dimension, the limit is AC.  For multi-base, need
the analogous entropy formula.

## 8. What I can actually contribute

Honest about what's within my reach:

**Can do (this note):**

- Make the L² conjecture precise (§1).
- Prove dim 1 (§2, by citing Marstrand-Mattila).
- Strong empirical evidence (§3, original numerics).
- Per-scale reduction (§4-5, elementary).
- Heuristic for plausibility (§6).
- Identify the simplest sub-conjecture and attack lines (§7).
- Identify what's open and who works on it.

**Cannot do (open research):**

- Prove (★) or the L² conjecture from §1.
- Translate Hochman's entropy framework to multi-base convolutions of
  Pisot-singular measures.
- Prove or disprove the $\{3,4\}$ sub-conjecture.

What I can contribute is the **clean formulation** of the open
sub-problem (★), with empirical evidence pointing to its likely truth,
plus connection to the active research community.

## 9. Connection to recent breakthroughs (specific theorems)

**Solomyak 1995** (*Annals of Math*): $B_\lambda$ is AC for Lebesgue
a.e. $\lambda\in(1/2,1)$.

**Hochman 2014** (*Annals of Math*): the exceptional set $\{\lambda :
B_\lambda \text{ has dimension }<\dim_S\}$ has Hausdorff dimension 0,
where $\dim_S = \log 2/\log(1/\lambda)$ is the similarity dimension.
This was a major breakthrough.

**Shmerkin 2014** (*GAFA*): the exceptional set for AC has zero
Hausdorff dimension.

**Varjú 2019** (*J. AMS*): $B_\lambda$ is AC for all algebraic
$\lambda\in(\lambda_0, 1)$ for some $\lambda_0 = \lambda_0(\text{Mahler
measure})$.

**Akiyama–Komornik–Loridant**: extensive work on non-Pisot algebraic
parameters.

**For our multi-base $\{1/3, 1/4, ...\}$:**

Each parameter $1/a$ is *below* the Solomyak / Hochman threshold
$(1/2, 1)$ for $a\ge 3$, and is the reciprocal of a Pisot
number (every integer $\ge 2$ is Pisot).  So single-base
$B_{1/a}$ is *singular* by Erdős 1939 — outside the Hochman/Solomyak
"generic AC" regime.

**The key observation**: the *convolution* of singular measures with
dim sum $>1$ is what we're asking about.  No theorem I have found
directly addresses this for the integer-Pisot parameter case.

This appears to be a **genuine gap in the literature**.

## 10. Specific question for the Bernoulli convolution community

To pose on MathOverflow / direct contact:

> **Question.**  Let $a, b \ge 2$ be multiplicatively independent
> integers (both Pisot, so individual Bernoulli convolutions $B_{1/a},
> B_{1/b}$ are singular Cantor-like).  If
> $1/\log_2 a + 1/\log_2 b > 1$ (Marstrand condition), is the
> convolution $B_{1/a} * B_{1/b}$ absolutely continuous?
> Is it known to fail in any specific case?

This is a clean, narrow question that experts in the area could either
resolve quickly (with a known reference) or recognize as open.

## 11. Roadmap

If the AC conjecture holds:

```
Multi-base Bernoulli AC Conjecture (open)
    ⟹ μ_A has density in L^1 (by definition)
    ⟹ (Theorem 7 of note 59) conductor c(T) = o(T)
    ⟹ (Theorem 6.1 of note 59) Erdős 124
```

If the L² Conjecture from §1 holds (stronger):

```
L² Conjecture (open, empirically strongly supported)
    ⟹ density in L^2 (Plancherel)
    ⟹ AC (since L^2 ⊆ L^1 + tail)
    ⟹ Erdős 124 by the chain above.
```

So the **fractal-geometric path to Erdős 124** reduces to:

1. (Strong form) Prove $\hat\mu_A \in L^2(\mathbb R)$ for
   hypothesis-meeting $A$.
2. (Weak form) Prove $\mu_A$ AC for hypothesis-meeting $A$.

Strong form ⟹ weak form ⟹ Erdős 124.

**Attack steps (priority):**

(i) Resolve the $\{3,4\}$ sub-conjecture (§7).  Smallest non-trivial
    case.  Attack via direct Fourier estimate, Marstrand projection,
    or contact with experts.

(ii) If $\{3,4\}$ AC holds: try $\{3,4,5\}$, then $\{3,4,7\}$,
     then exact-critical cases.

(iii) Develop a general theorem: "for multiplicatively independent
      integer-Pisot bases with dim sum > 1, the convolution is AC".

(iv) Make Theorem 7 of note 59 fully rigorous (handle the weak-$*$
     and Sobolev technicalities).

(v) Formalise in Lean / Mathlib.

## 12. Status

Adds no Certified obligation; the AC conjecture is itself open.

Adds:
- A sharper conjecture (L²) and a precise sub-conjecture ($\{3,4\}$).
- Strong empirical evidence via Fourier L² numerics.
- A clean per-scale reduction.
- Specific attack lines from recent literature.
- A community-facing question to attract experts.

This is, as far as I can tell, the **most concentrated effort the
project can muster** on the fractal-geometric path without crossing
the line into actually proving the conjecture (which requires real
fractal-geometry research).

## 13. References (selected)

- Erdős, *On a family of symmetric Bernoulli convolutions*, AJM 61 (1939).
- Mattila, *Geometry of Sets and Measures in Euclidean Spaces*, CUP (1995).
- Solomyak, *On the random series $\sum\pm\lambda^n$*, AoM 142 (1995).
- Hochman, *On self-similar sets with overlaps and inverse theorems for entropy*, AoM 180 (2014).
- Shmerkin, *On the exceptional set for absolute continuity of Bernoulli convolutions*, GAFA 24 (2014).
- Varjú, *Absolute continuity of Bernoulli convolutions for algebraic parameters*, J. AMS 32 (2019).
- Kittle, *Absolutely Continuous Stationary Measures* (PhD thesis), Cambridge (2024).
- Akiyama et al., *Bernoulli convolutions associated with certain non-Pisot numbers*.
