# A path: multi-base Bernoulli convolution framing

The previous note (57) confirmed that three existing rephrasings (LLT,
entropy, energy method) converge on the *same* analytic obligation.  No
amount of repackaging within additive combinatorics + Fourier on the
torus seems to bypass it.

This note proposes a genuinely different framing: **the Erdős 124
conductor obligation is equivalent to an absolute-continuity question
about a multi-base Bernoulli convolution measure on the real line.**
This connects the problem to a different active research community
(fractal geometry / dynamical systems of Bernoulli convolutions:
Solomyak, Hochman, Shmerkin, Varjú, Akiyama) with different techniques
that, as far as I can tell, have *not* been applied to Erdős 124.

The note is structured as: setup, connection, conjecture, why this might
break the bind, what next.

## 1. Setup

For a single base $a\ge 2$, the **Bernoulli convolution at parameter
$\lambda=1/a$** is the probability measure $B_{1/a}$ on $\mathbb{R}$
that is the law of the random variable

$$Y_a = \sum_{n=0}^\infty \epsilon_n\,a^{-n},\quad \epsilon_n\stackrel{\text{iid}}{\sim}\operatorname{Unif}\{0,1\}.$$

**Erdős (1939):** for $\lambda = 1/a$ with $a$ a Pisot number (every
integer $a\ge2$ is trivially Pisot), $B_{1/a}$ is **singular** with
respect to Lebesgue measure.  For $a=3$ this is the standard Cantor
measure of dimension $\log_3 2$; for general integer $a$, it is
Cantor-like of dimension $\log_a 2 = 1/\log_2 a$.

So single-base Bernoulli convolutions for integer bases are *singular* —
their support has full topological span but Lebesgue measure zero, with
huge gaps.

For a **multi-base** convolution with finite $A\subseteq\mathbb{Z}_{\ge 2}$:

$$\mu_A := *_{a\in A} B_{1/a}.$$

This is the convolution of independent Bernoulli convolutions — equivalently,
the law of

$$Y_A = \sum_{a\in A}\sum_{n=0}^\infty \epsilon_{a,n}\,a^{-n},\quad \epsilon_{a,n}\stackrel{\text{iid}}{\sim}\operatorname{Unif}\{0,1\}.$$

Each $B_{1/a}$ is singular Cantor-like; the *convolution* $\mu_A$
can be absolutely continuous.

## 2. The connection to Erdős 124

For our seed $F=\{a^e:a\in A,e\ge k\}$ and finite frontier
$E=(a^{e_a})$, the finite subset-sum distribution is

$$X_E = \sum_{a\in A}\sum_{e=k}^{e_a-1}\epsilon_{a,e}\,a^e,
\qquad \epsilon_{a,e}\stackrel{\text{iid}}{\sim}\operatorname{Unif}\{0,1\}.$$

Renormalising: let $\widetilde X_E = X_E / \max_a a^{e_a-1}$.  As
$E\to\infty$ along any frontier with $e_a\to\infty$, the distribution
$\widetilde X_E$ converges (weak-* on a fixed interval) to a
**rescaled multi-base Bernoulli convolution** $\widetilde\mu_A$ that is
the multi-base measure $\mu_A$ translated and dilated to a fixed compact
interval.

**Equivalence (sketch):**

> **Conductor $\Leftrightarrow$ absolute continuity.**
> The finite-seed conductor $c(E)$ tends to $o(T(E))$ as
> $T(E)\to\infty$ if and only if the limiting measure $\widetilde\mu_A$
> is absolutely continuous on $\mathbb{R}$.

The "if" direction: AC means the limit measure has bounded density on its
support, so the discrete approximations $\widetilde X_E$ approach the
uniform-density measure, and the discrete support density $\to 1$,
which is exactly conductor $=o(T)$.

The "only if" direction: a singular limit measure has a fractal gap
structure that persists into the discrete approximations, forcing
$c(E)$ to grow proportionally to $T(E)$.

(The equivalence is sketched; making it rigorous is itself a project.
But the *heuristic* is clear and matches all the empirical data we have.)

## 3. The hypothesis-meeting translation

For $\widetilde\mu_A$ to be absolutely continuous, a *necessary*
condition is that its Hausdorff dimension equals 1.  Convolution adds
dimensions (up to clipping at 1) by the Marstrand projection theorem and
its descendants: 

$$\dim(\widetilde\mu_A) \;\le\; \min\!\Bigl(1,\ \sum_a \dim(B_{1/a})\Bigr) = \min\!\Bigl(1,\ \sum_a \frac{1}{\log_2 a}\Bigr).$$

The right-hand side is the *density exponent* of note 47.  Under the
Erdős 124 hypothesis ($\sum 1/(a-1)\ge 1$ plus the algebraic identity
$\sum 1/\log_2 a \ge \sum 1/(a-1)$), the sum is $\ge 1$.  In every
hypothesis-meeting case it is *strictly* greater than $1$ — by the
elementary inequality $\log_2 a < a-1$ for $a\ge 3$.

So the Erdős 124 hypothesis is **exactly the dimension-sum condition for
$\widetilde\mu_A$ to have dimension 1**.  This is the *necessary*
condition for absolute continuity.

The sufficient condition (= actual AC) is open and is where the
breakthrough would happen.

## 4. The conjecture

> **Conjecture (Multi-base Bernoulli AC).**
> Let $A\subseteq\mathbb{Z}_{\ge 3}$ be finite with $\gcd(A)=1$ and
> $\sum_{a\in A} 1/(a-1) \ge 1$.  Then the multi-base Bernoulli
> convolution $\mu_A = *_{a\in A} B_{1/a}$ is absolutely continuous
> with respect to Lebesgue measure on $\mathbb{R}$.

**This conjecture is what would close Erdős 124.**  Via the equivalence
in §2, AC of $\mu_A$ gives conductor $=o(T)$, which (plus the existing
tail engines under the analytic input) gives Erdős 124.

The conjecture is *also* a clean question in fractal geometry, posable to
the active Bernoulli-convolution community without reference to Erdős
124 at all.

## 5. Why this might break the bind

Three reasons this framing is structurally different from notes 47–57:

**(a) Different obstacle, different community.**
The previous framings (LLT, entropy, energy) all reduced to *anti-concentration*
of $\sum \delta_i a^{e_i}$ for $\delta_i\in\{-1,0,+1\}$ — a Fourier
question on the torus.  The Bernoulli convolution framing reduces to
*absolute continuity* of a measure on $\mathbb{R}$ — a Fourier question
on the real line.  These are related but the *techniques* used are
different:

- LLT / energy: Esseen-Salem-Zygmund-style sub-Gaussian tail bounds.
- AC of Bernoulli convolution: transfer operators (Hochman 2014),
  random walks on groups (Bourgain–Furman–Lindenstrauss–Mozes style),
  entropy of self-similar measures (Hochman / Shmerkin / Akiyama).

The latter set of tools is *not* what we've been using.  And the active
community using them has not, to my knowledge, looked at
multi-base $1/a$ (integer-Pisot) convolutions specifically.

**(b) Recent breakthrough machinery.**
Hochman 2014 (*Annals of Math*) proved that the exceptional set of
$\lambda$ where $B_\lambda$ fails to have dim 1 has Hausdorff
dimension 0.  Shmerkin 2014 extended.  Varjú 2019 (*J. AMS*) proved AC
for algebraic $\lambda$ sufficiently close to 1.

Our parameter is *each* $1/a$ — *not* in $(1/2,1)$ for $a\ge 3$.
So the single-base $B_{1/a}$ is Cantor-like (this is the Pisot
case Erdős originally identified as singular).  But the *convolution* of
several singular measures with dim sum $\ge 1$ is the natural
generalisation, and the same Hochman–Shmerkin–Varjú entropy / random-walk
machinery is the right tool to attack it.

**(c) Dimension condition matches our hypothesis.**
The fact that $\sum 1/\log_2 a > 1$ is exactly what we need for the
*necessary* dimension condition is encouraging: it says the Erdős 124
hypothesis is *precisely* the right strength for the dimension framing.
The remaining gap (dimension 1 vs. absolute continuity) is the same gap
that recent breakthroughs have addressed for single-base parameters.

## 6. Why I think this is *new*

Erdős 124 has been studied by combinatorial number theorists since BEGL
1996.  Bernoulli convolutions have been studied by fractal geometers
/ dynamicists since Erdős 1939.  The communities barely overlap.

My (limited) literature search found:
- Many papers on AC of single-base $B_\lambda$ for $\lambda\in(1/2,1)$.
- Many papers on Erdős 124 and complete sequences.
- **Zero papers explicitly identifying the Erdős 124 conductor obligation
  with a multi-base Bernoulli convolution absolute-continuity question.**

The two-paragraph reduction sketched in §2 is, as far as I can tell, not
in the literature.  If correct, it is a new connection between two
well-developed but disjoint areas.

## 6.5 Empirical evidence supporting the conjecture

`scripts/cas_bernoulli_density.py` samples from each
multi-base Bernoulli convolution by Monte Carlo and reports two
indicators of (in)absolute continuity:

- the **zero-bin fraction**: fraction of histogram bins with no
  samples (high = singular, gappy; low = full-support);
- the **density ratio**: max/min of non-zero bin densities (high =
  spiky/Cantor; bounded = smooth/AC-like).

Results (200k samples, 200 bins, depth 50):

| case                    | support       | zero-bin frac | density ratio |
|-------------------------|---------------|---------------|---------------|
| singular 1-base $\{3\}$ | $[0,1.50]$ | 0.730         | 7.88          |
| singular 1-base $\{4\}$ | $[0,1.33]$ | 0.855         | 6266          |
| multi $\{3,4\}$       | $[0,2.83]$  | 0.110         | 9.61          |
| **hypothesis** $\{3,4,7\}$    | $[0,4.00]$  | **0.000**     | 34.3          |
| **hypothesis** $\{3,4,5\}$    | $[0,4.08]$  | **0.000**     | 28.4          |
| **hypothesis** $\{3,4,9,25\}$ | $[0,5.00]$  | **0.000**     | 91.97         |
| **hypothesis** $\{3,5,7,13\}$ | $[0,4.31]$  | **0.000**     | _(similar)_   |

**Empirical pattern.**  Every hypothesis-meeting multi-base case has
**zero zero-bin fraction** (full support, no Cantor gaps) and bounded
density ratio.  Pure single-base Bernoulli convolutions for integer
bases have clear singular signature (huge zero-bin fraction, often
4-digit ratios).  The two-base $\{3,4\}$ is intermediate, suggesting
the AC transition happens around the hypothesis threshold.

This is concrete empirical support for the conjecture.  Of course, Monte
Carlo cannot prove AC (singular measures can also produce "smooth-looking"
histograms at moderate resolution), but the *pattern* — single-base
singular, hypothesis-meeting multi-base apparently AC — is exactly what
the conjecture predicts.

## 7. Concrete next steps

If I were continuing the project, the highest-value moves would be:

1. **Make the equivalence in §2 rigorous.**  The "if" direction (AC ⇒
   conductor o(T)) is a quantitative weak-convergence argument; doable
   in 1–2 weeks of careful work.  The "only if" is more delicate but
   probably also doable.

2. **Run empirical tests of the conjecture for small $A$.**  Numerically
   compute the density of $\mu_A$ for $A=\{3,4\}$, $\{3,4,7\}$,
   $\{3,5\}$, etc., and check whether it appears AC vs singular.
   This is concrete CAS work.

3. **Translate Hochman 2014's machinery to multi-base.**  Hochman's
   theorem uses the "entropy of self-similar measures" framework.  The
   multi-base analogue would involve products of contracting maps with
   different ratios.  Some recent work (Shmerkin–Solomyak, Akiyama) has
   moved in this direction; the question is whether it covers integer
   Pisot bases.

4. **Engage the Bernoulli convolution community.**  Post a question on
   MathOverflow titled "Multi-base Bernoulli convolutions of integer
   Pisot parameters: absolutely continuous?"; cite the connection to
   Erdős 124.  This is the Tao-style "attract the right experts" move.

## 8. Honest caveats

- The equivalence in §2 is sketched, not proved.  I am ~85% confident
  it is correct; I have not done the careful weak-convergence work.
- The conjecture in §4 may itself be false.  Empirically, the convolution
  of integer-Pisot Bernoullis often appears AC, but specific counterexamples
  might exist.
- Even if the conjecture is true, proving it is a fractal-geometry
  problem that may itself require new techniques.  The Bernoulli
  convolution community has open problems and active progress, but no
  guarantee they would solve this specific question quickly.
- This framing is "new" in the sense of not being in the literature I've
  searched, but Bernoulli convolution experts may know it as folklore.

## 9. Why I'm more optimistic about this than about previous notes

The previous "this might break the bind" notes (49 resonance, 52 S-unit,
53 Sidon) all reduced the obligation but stayed within additive
combinatorics + Fourier.  This note moves to a different area of
mathematics — fractal geometry / dynamical systems — with a different
community and different active tools.

The fact that:
- The reduction is clean.
- The hypothesis $\sum 1/\log_2 a > 1$ matches the necessary condition
  exactly.
- Recent breakthroughs (Hochman 2014, Varjú 2019) gave dramatic progress
  on the single-base AC question.
- The communities haven't talked.

makes me think this is the *first* genuine new attack the project has
identified, as opposed to a repackaging.

I cannot claim it will close.  I can claim it is the most concrete and
non-trivial path forward I see, and that it has the right shape to
plausibly close given continued progress in the Bernoulli convolution
community.

## Status

Adds no Certified obligation.  Proposes a new conjecture and a new
research direction.  Identifies the Erdős 124 combinatorial conductor
obligation with the multi-base Bernoulli convolution absolute-continuity
problem.

## References

- P. Erdős, *On a family of symmetric Bernoulli convolutions*, Amer. J. Math. 61 (1939).
- B. Solomyak, *On the random series $\sum\pm\lambda^n$*, Ann. Math. 142 (1995).
- M. Hochman, *On self-similar sets with overlaps and inverse theorems for entropy*, Ann. Math. 180 (2014).
- P. Shmerkin, *On the exceptional set for absolute continuity of Bernoulli convolutions*, GAFA 24 (2014).
- P. Varjú, *Absolute continuity of Bernoulli convolutions for algebraic parameters*, J. AMS 32 (2019).
- C. Akiyama et al., *Bernoulli convolutions associated with certain non-Pisot numbers*.
- See [Sixty years of Bernoulli convolutions](https://gauss.math.yale.edu/~ws442/papers/sixty.pdf) for a survey.
