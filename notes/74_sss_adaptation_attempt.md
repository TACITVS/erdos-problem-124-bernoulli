# SSS framework adaptation — honest negative attempt

This note attempts to adapt the Saglietti-Shmerkin-Solomyak (SSS) 2018
framework for absolute continuity of self-similar measures to our
multi-base Bernoulli convolution setting, with the goal of closing the
algebraic conductor bound (or some equivalent).

## 0. Verdict

> **The SSS framework does not adapt to give Erdős 124, even
> conditionally on the conductor bridge.**
>
> Two independent obstructions:
> 1. **Parameter regime mismatch.**  SSS's framework operates in
>    the super-critical contraction region (typically
>    $\prod r_i^{p_i} > $ threshold related to entropy).  For
>    integer-Pisot $\lambda = 1/a$ ($a \ge 3$), each individual
>    factor has $\lambda < 1/2$ — outside the standard "a.e.
>    parameter" range.  The multi-base convolution lives in a
>    regime SSS does not cover.
> 2. **Fourier decay obstruction.**  Even if SSS-style methods gave
>    AC of $\mu_A$, they would not give the *Hölder regularity*
>    needed to recover the LLT bridge.  By Erdős 1939, integer-Pisot
>    $\hat B_{1/a}$ does not decay to 0, so the product
>    $\hat\mu_A = \prod_a \hat B_{1/a}$ inherits non-decay.  No Hölder
>    exponent $\alpha > 0$ is possible.  Without Hölder, LLT fails
>    (note 65).

This confirms note 65's conclusion via a separate route: no
fractal-geometric framework currently available bridges our
integer-Pisot multi-base convolution to Erdős 124.

The remaining viable direction is the **direct combinatorial conductor
bound** (the open obligation as stated), not via fractal-geometric
reformulation.

## 1. The SSS framework (summarized from arXiv:1709.05092)

> **Setup.**  Consider a *non-homogeneous* iterated function system
> $\{S_i\}_{i=1}^k$ on $\mathbb R$ with contractions
> $S_i(x) = r_i x + t_i$, $|r_i| < 1$, and a probability vector
> $(p_i)$.  The self-similar measure $\mu$ is the unique fixed point
> of $\mu = \sum_i p_i (S_i)_* \mu$.

> **Main theorem (SSS, informal).**  For a *parametrized* family
> $\{\mu_\theta\}_{\theta \in U}$ with $U$ an open set in parameter
> space (e.g., $\theta = (r_1, \ldots, r_k)$ or just one $r_i$), if
> the family lies in the **super-critical** region
> $\prod r_i^{p_i} > $ some threshold related to the entropy
> $h_\mu = -\sum p_i \log p_i$, then $\mu_\theta$ is AC for
> Lebesgue-a.e.\ $\theta \in U$ in the super-critical region.

> **Key tools.**  (a) Hochman's entropy machinery (for an entropy
> increase / dimension result); (b) transversality at random
> parameters; (c) Fourier decay estimates for "random" self-similar
> measures.  The proof's main novelty is combining transversality
> (which fails at specific algebraic parameters) with entropy methods
> to handle generic parameters.

## 2. Mapping to our setting

Multi-base Bernoulli convolution $\mu_A = *_{a \in A} B_{1/a}$:
- IFS interpretation: the random walk
  $\sum_a \sum_n \zeta_{a, n} a^{-n-1}$ corresponds to a multi-base
  self-similar IFS with contractions $1/a$ for $a \in A$ and trivial
  probabilities (uniform Bernoulli).
- Formally: $\mu_A$ is the fixed point of the map
  $\nu \mapsto \frac{1}{2^{|A|}} \sum_\varepsilon (S_\varepsilon)_* \nu$
  where $\varepsilon \in \{0, 1\}^{|A|}$ and
  $S_\varepsilon(x) = \sum_a x_a/a + \sum_a \varepsilon_a/(a-1)$
  is a multi-coordinate map... actually this needs more care.

Alternative interpretation: each $B_{1/a}$ is the standard Bernoulli
convolution at parameter $\lambda = 1/a$.  The convolution $\mu_A =
*_a B_{1/a}$ is NOT a standard self-similar measure on $\mathbb R$;
it's a convolution of $|A|$ singular Cantor measures.

## 3. Parameter regime obstruction

For each individual $B_{1/a}$:
- Contraction parameter: $\lambda = 1/a$.
- For $a = 3$: $\lambda = 1/3 \approx 0.333$.
- For $a \ge 3$: $\lambda \le 1/3 < 1/2$.

The "super-critical" regime for single-base BC is $\lambda \in
(1/2, 1)$.  Our $\lambda = 1/a$ for $a \ge 3$ is in $(0, 1/3]$ —
*sub-critical*, far below the SSS regime.

For multi-base convolution: the "effective" contraction is some
combined rate.  The Marstrand dimension condition
$\sum_a 1/\log_2 a > 1$ is the multi-base analog of "super-critical".

Hypothesis-meeting multi-base sets DO satisfy $\sum 1/\log_2 a > 1$,
so the *combined* effect is super-critical.  But the individual
factors are sub-critical, and SSS's machinery operates per-factor.

**Specific obstacle.**  SSS's transversality/entropy methods need each
contraction $\lambda$ to lie in a regime where Garsia entropy
$h_{1/\lambda}$ has known lower bounds (Hochman 2014).  For
$\lambda < 1/2$ (i.e., $a \ge 3$), Hochman's bounds give
$h_\lambda = \log 2$ (full entropy), but the corresponding
**separation** is poor — the IFS has heavy overlap.

For multi-base: each base's IFS has heavy overlap, and combined
overlap is even more complex.

## 4. Fourier decay obstruction (the more fundamental issue)

By Erdős 1939 (re-stated): for $\lambda = 1/a$ with $a \ge 2$ integer,
$\hat B_{1/a}(\xi)$ does not decay to 0 as $|\xi| \to \infty$.

Specifically: $|\hat B_{1/a}(2\pi a^k)|$ is bounded *below* by an
explicit constant $C_a > 0$ for all $k$ (the "Vieta product"
$\prod_{m \ge 1} |\cos(\pi/a^m)|$).

For $a = 3$: $C_3 = \prod_{m \ge 1} |\cos(\pi/3^m)| \approx 0.466$.

For multi-base $\hat\mu_A = \prod_a \hat B_{1/a}$: at $\xi$ where
multiple Vieta products simultaneously align,
$|\hat\mu_A(\xi)| \ge \prod_a C_a > 0$.

By Diophantine simultaneous-approximation arguments
(Kronecker-Weyl), there are infinitely many $\xi$ with $|\hat\mu_A(\xi)| \ge \delta$
for some $\delta > 0$.  So $\hat\mu_A \not\to 0$ at infinity.

**Consequence.**  $\mu_A$ does NOT have Hölder-continuous density of
any positive exponent.  (Hölder ⟹ $\hat\mu_A$ decays polynomially
⟹ $\hat\mu_A \to 0$.)

This kills the L^1 Fourier approach to LLT (note 65), regardless of
whether AC holds.

## 5. Where SSS might succeed (but doesn't help)

If we could adapt SSS to prove **mere AC** (not Hölder) of $\mu_A$:
- Would give a clean fractal-geometric result.
- Would NOT close Erdős 124, because note 65's LLT bridge requires
  Hölder, not just AC.

For mere AC: empirically supported (notes 60-62) but rigorously open
(note 64).  SSS framework adaptation might or might not succeed; even
if successful, it doesn't bridge to Erdős 124.

## 6. The honest situation

| Approach | What it would give | What's needed for Erdős 124 |
|---|---|---|
| SSS framework adaptation | AC of $\mu_A$ (best case) | Hölder regularity (impossible for integer-Pisot) |
| Kittle-Kogler 2024 adaptation | AC of $\mu_A$ via entropy + separation | Same issue: only AC, not Hölder |
| Direct Hölder analysis | Hölder fails by Erdős 1939 | N/A — proven impossible |
| Direct combinatorial conductor bound | Bounded conductor (note 66 conjecture) | Closes everything |

The fractal-geometry attack direction (whether via SSS, Kittle-Kogler,
or any other modern AC framework) is **fundamentally blocked** by the
Fourier non-decay of integer-Pisot factors.  Note 65 identified this
obstruction abstractly; this note confirms it specifically for SSS.

The remaining viable attack direction is the **direct combinatorial
conductor bound** — the open obligation as originally stated in note 28.
This requires NEW combinatorial techniques, not fractal-geometric
adaptation.

## 7. What this note rules out

By this analysis, the following research directions can be
**deprioritized** for closing Erdős 124:

- Adapting SSS 2018 to our integer-Pisot multi-base setting (this note).
- Adapting Kittle-Kogler 2024 (per note 64 analysis).
- Adapting Saglietti-Shmerkin-Solomyak 2018 plane version (similar
  parameter-regime mismatch).
- Adapting Solomyak-Spiewak 2023 plane version (similar).

All of these would, at best, give AC of $\mu_A$ — which, by note 65,
is *insufficient* for the LLT bridge to Erdős 124.

## 8. What this note suggests

For Erdős 124 progress, focus on:

1. **Direct combinatorial conductor bound** (the open obligation).
   The Bounded Conductor Conjecture (note 66 v2 in note 71) is the
   actual target.
2. **Sub-problems amenable to additive combinatorics** (Plünnecke-Ruzsa,
   Sárközy-Solymosi).  These work directly with subset sums, not
   measures.
3. **Effective Subspace constants** for the specific multiplicatively-
   independent pairs in hypothesis-meeting $A$.  Bilu-Tichy 2000 and
   later refinements.  Per-pair, would extend the CF/MW machinery.
4. **Lean formalization** of Theorems A, B, C and Proposition D.
   Mechanical verification, no algebraic content gained but reduces
   gap risk.

## 9. Status

This note (Phase B-7) is an HONEST NEGATIVE attempt.  The SSS framework
does not adapt to give Erdős 124, for two independent reasons:
parameter-regime mismatch (SSS lives in $\lambda > 1/2$; we have
$\lambda \le 1/3$) and Fourier non-decay (integer-Pisot factors don't
allow Hölder regularity, which is what's actually needed for the
LLT bridge).

This is the project's **13th** documented negative result in the
disparate-area exploration.  Combined with notes 50-57 (the original
11), notes 63-65 (the Bernoulli convolution audit), and this note 74,
the project has now exhausted most of the fractal-geometric attack
directions and confirmed that Erdős 124 requires combinatorial
(not analytic) techniques.

The combinatorial direction — the original conductor program from
notes 28-49 — remains the project's correct path forward.  Notes 67,
69, 70, 71 add per-case certification machinery; Theorems A, B, C and
Proposition D (notes 72, 73) consolidate the algebraic content; the
*uniform algebraic conductor bound* remains the central open problem.

This is the honest state.

Sources:
- [Saglietti-Shmerkin-Solomyak 2018 (arXiv)](https://arxiv.org/abs/1709.05092)
- [Solomyak-Spiewak 2023 (arXiv)](https://arxiv.org/pdf/2301.10620)
- [Smoothness of random self-similar measures (PTRF 2025)](https://link.springer.com/article/10.1007/s00440-025-01389-2)
- [Shmerkin-Solomyak 2014, convolutions](https://www.semanticscholar.org/paper/Absolute-continuity-of-self-similar-measures,-their-Shmerkin-Solomyak/4744e83f836baf5f432f35abf6f3b8438d8b135a)
- [AC in parametrised non-homogeneous SS measures (arXiv 1812.05006)](https://arxiv.org/pdf/1812.05006)
