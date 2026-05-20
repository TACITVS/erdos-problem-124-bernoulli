# Literature pulse-check 2023–2026 — multi-base Bernoulli AC

Plan-mandated Phase 2: targeted search for any 2023–2026 paper that
proves, disproves, or directly implies the **Multi-base Bernoulli AC
Conjecture** (note 58 §4, refined to **L² density** by note 63).

## 0. Verdict

> **(d) The conjecture remains genuinely open** in the 2023–2026
> literature.

No paper directly proves or refutes it.  Every available AC result
for self-similar / Bernoulli-convolution-type measures operates in
*one of* the following regimes:

1. The supercritical single-base regime $\lambda\in(1/2,1)$ (Solomyak
   1995, Shmerkin 2014, Varjú 2019, and all subsequent refinements).
2. Almost-every-parameter statements in a continuous family.
3. Conditions involving Garsia entropy and Mahler-measure proximity
   that the explicit reciprocal-integer parameters
   $\lambda_a = 1/a$ **fail** for $a\ge 3$.

The integer-Pisot regime $\lambda = 1/a$ with $a\ge 3$, where each
single-base $B_{1/a}$ is **singular** (Cantor-like), and the question
of whether convolving enough of them produces AC once the dimension
sum exceeds 1, **does not appear in any 2023–2026 paper located**.

## 1. Most relevant recent papers

| arXiv | Authors / Year | One-sentence summary | Applies? |
|---|---|---|---|
| **2409.18936** | Kittle & Kogler, Sep 2024 — "On absolute continuity of inhomogeneous and contracting on average self-similar measures" | Sufficient condition (Garsia entropy + separation + contraction ratio) for AC of inhomogeneous and contracting-on-average self-similar measures in arbitrary dimension; first explicit AC inhomogeneous examples. | **Closest match.** Hypotheses (entropy/separation) are not yet verified for our $B_{1/a_1}*\cdots*B_{1/a_n}$ |
| **2103.12684** | Kittle 2021/2024 — *Ann. Sci. ENS* — "Absolute continuity of self-similar measures" | Sufficient condition for AC of a single self-similar measure via Garsia entropy + Mahler-measure proximity; strengthens Varjú. | **No** — single-measure, needs $\lambda$ near 1 in Mahler-measure terms, fails for $\lambda=1/a$ |
| **2409.04608** | Corso & Shmerkin 2024 | Extends $L^q$-dimension theorem for dynamically driven self-similar measures from $\mathbb R$ to higher dimensions. | **No** — about $L^q$-dimensions, not AC |
| **2501.17795** | Jan 2025 — "Dimension of contracting on average self-similar measures" | Generalises Hochman's dimension theorem to contracting-on-average measures under weaker separation. | **No** — dimension equality only |
| **2412.16753** | Dec 2024 — Self-conformal IFS dimension on $\mathbb R$ | Extends Hochman's dimension result to real-analytic IFS. | **No** — dimension, not AC |
| **2508.14698** | Aug 2025 — Fourier decay & AC for typical homogeneous self-similar in $\mathbb R^d$, $d\ge 3$ | Fourier decay / AC for *typical* parameters in supercritical region. | **No** — typical / parameter-dependent |
| **2507.21605** | Jul 2025 — "Fourier transform of random Bernoulli convolutions" | Bias-randomized Bernoulli convolutions. | **No** — different randomization, $\lambda>1/2$ |
| **2502.17145** | 2025 — "Slicing the torus and thermodynamics of self-similar measures" | Slicing / thermodynamic formalism. | **No** |
| **2311.00569** | Sidorov 2023 — *Bernoulli convolutions* (survey) | Survey of Solomyak/Hochman/Shmerkin/Varjú; no new results in our regime. | **No**, but useful sanity check |
| Plms 2025 | Kittle & Kogler — "Absolutely continuous Furstenberg measures" | AC for Furstenberg (random matrix products) stationary measures. | **No** — different object |
| **2301.10620** | Solomyak & Spiewak 2023 — AC of self-similar measures on the plane | Plane version of Saglietti-Shmerkin-Solomyak. | **No** — almost-every-parameter |

## 2. Earlier baseline (re-confirmed unchanged in 2023–2026)

- **Erdős 1939**: every integer $a\ge 2$ is Pisot, so each individual
  $B_{1/a}$ ($a\ge 3$) is singular Cantor-like with Fourier transform
  not tending to 0.
- For $\lambda<1/2$ the support of $B_\lambda$ is a Cantor set, so
  $B_{1/a}$ for $a\ge 3$ is necessarily singular.  The conjecture is
  about whether **convolution** rescues AC once dim sum $>1$.
- **Shmerkin-Solomyak 2014–2016** (arXiv:1406.0204): handles AC of
  self-similar measures, their projections and convolutions in the
  $(1/2, 1)$ regime via transversality — does not extend to
  $\lambda\le 1/3$.
- **Convolutions of two specific Cantor measures**: known to sometimes
  be AC and sometimes singular (e.g.\ Nazarov-Peres-Shmerkin 2009 type
  results); no general criterion based purely on dim sum $>1$ has been
  established for the integer-Pisot multi-base case.

## 3. The Kittle-Kogler 2024 framework as the most promising vehicle

Kittle-Kogler (arXiv:2409.18936) give a **sufficient condition** for
AC of inhomogeneous / contracting-on-average self-similar measures
that does not require $\lambda > 1/2$.  The condition involves:

- A lower bound on Garsia entropy $h_\mu$ matching the upper-bound
  dimension;
- Quantitative separation of the IFS cylinder sets.

For $\mu_A = *_{a\in A} B_{1/a}$ viewed as a self-similar measure
with weights $1/2^{|A|}$ on the $2^{|A|}$ contractions
$(x_a)\mapsto (\epsilon_a/(a-1) + x_a/a)_a$, both hypotheses are
*delicate* but *not obviously inaccessible*:

- **Garsia entropy:** the joint random variable
  $(\zeta_{a,n})_{a,n}$ generates entropy at rate $\sum_a \log 2 = |A|\log 2$
  per "layer."  The contraction rate is $\prod_a (1/a)$, giving log-
  contraction $\sum_a \log a$.  The Garsia entropy
  $h_\mu = |A|\log 2$, and dimension $= h_\mu / \sum_a\log a
  = \sum_a (\log 2)/\log a = \sum_a 1/\log_2 a$.  Hypothesis-meeting
  $A$ has this $>1$, matching the Marstrand condition.
- **Separation:** the cylinders of the multi-base IFS overlap heavily
  when $\sum_a 1/(a-1)\ge 1$, so separation conditions like exponential
  separation are violated.  This is where the Kittle-Kogler hypothesis
  fails most directly for our case.

So Kittle-Kogler 2024 is **not directly applicable** without
strengthening their separation hypothesis.  But it's the **closest
existing framework**, and translating its proof to handle our
overlap structure would be the natural attack.

## 4. What was specifically searched (and absent)

Searches performed via WebSearch:
- "multi-base Bernoulli convolution absolutely continuous"
- "convolution Bernoulli integer base 1/3 1/4"
- "Akiyama/Komornik multi-base β-expansion AC"
- "Shmerkin/Hochman/Varjú/Rapaport/Sahlsten 2024-2025 self-similar AC"
- "Cantor convolution absolutely continuous"
- "convolution of self-similar measures absolute continuity 2024"
- "fractal measure absolutely continuous λ < 1/2"
- "absolutely continuous self-similar contraction below half"

None of these returned a paper that addresses **fixed integer
parameters $\lambda = 1/a$ ($a\ge 3$) convolved with dim sum $>1$**.

## 5. Implications for the project

Given the Phase 1 audit (note 63) finding that Note 59's "AC ⟹
Erdős 124" reduction does *not* go through cleanly, the situation
is now:

- The **L² density conjecture** about $\mu_A$ is a genuinely open
  problem in fractal geometry, of independent interest, not directly
  reduced to by any 2023–2026 result.
- The **link from L² density to Erdős 124** is itself an open
  problem (the audit found the natural Parseval bridge is trivial).

So the project has two **independent** open problems where it
previously claimed one reduction:

1. **(Fractal-geometry side)** Prove L² density of $\mu_A$ for
   hypothesis-meeting $A$.
2. **(Combinatorial bridge)** Prove that L² density of $\mu_A$
   implies $c(T) = o(T)$.

Either could be the easier of the two.  Both could be hard.

## 6. Recommendations

From this literature pulse:

**(i) Kittle-Kogler 2024 is the right vehicle for Direction (1).**
Attempting to verify their Garsia-entropy + separation hypotheses for
$\mu_A$ (or a relaxed separation form they could be willing to handle)
is the most concrete path forward in fractal geometry.

**(ii) Cold-email Kittle or Kogler** with the explicit conjecture and
ask if their framework can be made to apply.  Either gets a
"yes, here's how" (huge), a "no, here's why" (also useful), or no
response (modest information loss).

**(iii) Direction (2) is now its own project.**  The Erdős-Turán
integer-discrepancy approach proposed in note 63 §8 should be
investigated independently.

**(iv) Do not over-claim** "this is reducible to a known framework."
The most honest current statement is: the conjecture connects to the
Kittle-Kogler framework as the nearest neighbor, but is not implied
by it without additional work.

## 7. Status

Phase 2 complete.  No external theorem found that closes either
direction (fractal AC or combinatorial bridge).  Confidence in the
AC conjecture itself: unchanged at ~75% based on empirics alone.
Confidence in connection-to-Erdős-124: dropped to ~25% after note 63
audit; this note confirms no off-the-shelf bridge exists either.
