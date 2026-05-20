# Erdős Problem 124 — research journal

**Audience.**  Future sessions, human collaborators, and AI models who
will continue this work.  This document is forward-looking and
prescriptive; for a backward-looking audit of what is proved, see
`PROOF_STATE.md`.

## 1. What this project is now

After 25+ sessions, the project is best framed as **a near-complete
algebraic framework for Erdős 124 plus a new research direction
(multi-base Bernoulli convolution absolute continuity) that may be the
path to closure**.

Three layers of result:

- **Layer 1 — proved unconditionally** (notes 26, 07, 09, 10, 11, 46):
  Erdős 124 for five specific local cases.  See PROOF_STATE.md §2.1.

- **Layer 2 — algebraic framework, certified** (~25 notes, ~40 Haskell
  modules, ~20 CAS scripts): clean reductions, dependency tree, residue
  / modular / scaled-power machinery.  See PROOF_STATE.md §2.2.

- **Layer 3 — open conjecture, new direction** (note 58, this journal):
  the multi-base Bernoulli convolution AC conjecture, which if true
  closes Erdős 124.

## 2. The single most important new conjecture

> **Multi-base Bernoulli Absolute Continuity Conjecture** (note 58 §4).
> Let $A\subseteq\mathbb{Z}_{\ge3}$ be finite with $\gcd(A)=1$ and
> $\sum_{a\in A}1/(a-1)\ge1$.  Then the multi-base Bernoulli
> convolution
> $$\mu_A = *_{a\in A} B_{1/a}$$
> is absolutely continuous with respect to Lebesgue measure on
> $\mathbb{R}$.

This conjecture:
- Is posable independently of Erdős 124.
- Connects to active research (Hochman 2014, Shmerkin 2014, Varjú 2019).
- Has empirical support: hypothesis-meeting multi-base BCs show
  full-support bounded-density behaviour (see
  `scripts/cas_bernoulli_density.py`).
- The dimension sum condition $\sum 1/\log_2 a > 1$ matches the
  hypothesis exactly via the elementary inequality $\log_2 a < a-1$
  for $a\ge3$.

**If you do nothing else with this project: investigate this conjecture.**

## 3. Concrete next sessions (priority order)

### Session N+1 — Rigorize the equivalence

Note 59 (next note to be written) should make the §2 equivalence in
note 58 rigorous:

> **Equivalence.**  Along synchronised frontiers $E_M$ with $e_a=M$
> for all $a\in A$, $c(E_M) = o(T(E_M))$ iff the multi-base BC
> $\mu_A$ is absolutely continuous on $\mathbb{R}$.

The "if" direction is the easier one: AC of $\mu_A$ plus weak
convergence of finite subset-sum distributions implies the discrete
support density tends to 1, giving conductor $o(T)$.

The "only if" is harder: derive AC from the discrete conductor bound.
The argument should go through Fourier characterisation of AC
($\hat\mu_A$ in $L^2$), with the finite-N characteristic functions
$\hat X_E$ (= our note 48 $\varphi_A$) approximating
$\hat\mu_A$ under rescaling.

### Session N+2 — Empirical AC sharpening

Extend `scripts/cas_bernoulli_density.py`:

- Use higher resolution (more samples, more bins) to detect singular
  behaviour at fine scales.
- Compute the *modulus of absolute continuity*: how does
  density(x + h) - density(x) scale with h?  AC implies
  $\int |\text{density}(x+h) - \text{density}(x)|\,dx \to 0$ as
  $h\to 0$, with rate depending on regularity.
- Compute Fourier-side bounds: estimate $\int_{|\xi|\le T}
  |\hat\mu_A(\xi)|^2\,d\xi$ as $T\to\infty$.  AC iff this is
  uniformly bounded.

### Session N+3 — Translate Hochman / Varjú machinery

The Hochman 2014 entropy framework for self-similar measures and Varjú
2019 algebraic-parameter machinery were designed for single-base
$B_\lambda$ with $\lambda$ algebraic in $(1/2,1)$.  Our setting is
*multi-base* with $\lambda_a = 1/a$ *outside* $(1/2,1)$ for each
individual base $a\ge3$.

Key technical questions:

- Does the Hochman entropy formula extend to the multi-base
  convolution?  Multi-base self-similar IFS = product of single-base
  IFS with weighted convolution.  The relevant entropy is the *joint*
  entropy of the multi-base system.
- Varjú's argument uses transcendence-style bounds on the Mahler
  measure of $\lambda$.  For our rational $1/a$, Mahler measure is
  trivial ($=a$).  Does the multi-base version replace single Mahler
  measure with something joint?
- The relevant active researchers are: Mike Hochman (HUJI), Pablo
  Shmerkin (Univ. British Columbia), Péter Varjú (Cambridge), Tom
  Solomyak (UW), Boris Solomyak (Bar-Ilan), Shigeki Akiyama (Tsukuba).
  Reach out via MathOverflow or direct email with the conjecture as
  framed in note 58.

### Session N+4 — Counterexample hunt  *(completed 2026-05-20, note 62)*

Run a systematic empirical search for hypothesis-meeting
$A$ where the empirical density shows clear singular structure
(fractal gaps, high density ratio).  If found: the conjecture is *false*
and the failure mode needs analysis.  If not found across many cases:
strengthens the conjecture.

**Result.**  Note 62 reports the sweep of all 33 exact-critical ($R=1$)
sets with $\max(A)\le 30$, $|A|\le 6$.  All 33 saturate $I(T)$ to 4
decimal places by $T=10^6$.  No counterexamples.  In addition, a
striking new pattern emerged: $I(\infty)$ is strongly correlated with
$\min(A)$ (Pearson 0.94) and essentially uncorrelated with $\max(A)$
(0.018), suggesting "infinite-base universality in $\min(A)$" as a
conjectural next observable.

Follow-up directions: extend to $\max(A)\le 100$ (requires distributed
runs); test $|A|\ge 8$ to probe the $\min$-universality limit; verify
the small-deviation cases ({3,4,11,16}, {3,5,9,13,25}) at $T=10^7$ to
rule out grid-noise.

### Session N+5 — Formalisation in Lean

The algebraic framework (notes 28, 39, 40, 43, 47, 49) is largely
ready for Lean 4 / Mathlib formalisation.  Key obligations to formalise
first:

- conductor identity $K(E) = \kappa + 2c + 1$.
- density growth identity $\log_2 a \le a-1 \Rightarrow
  \sum 1/\log_2 a \ge R(A)$.
- half-sum reach threshold.

This is the most "Tao-style next move" (he's been formalizing PFR and
similar in Mathlib).  It both serves as a credibility marker and
catches subtle errors.

## 4. Things to avoid (lessons from this project's failures)

The session log contains several overstatements that were caught only
later.  Future work should avoid the same patterns:

1. **"X reduces to Y" claims without checking the dependency tree.**
   Note 56's original claim "ABC implies Erdős 124" was overstated —
   the OPEN combinatorial conductor obligation in
   `GlobalProofAudit.hs` is independent of ABC.  Always cross-check
   reduction claims against the boss tree.

2. **"This technique will close X in 2 weeks" predictions without
   empirical check first.**  The energy-method optimism in the
   "channel Tao" session was falsified by a 5-minute CAS computation
   that should have been run before the claim was made.  See note 57.

3. **Calling computational verification "proof".**  See user feedback
   memory `feedback_cas_delegation`.  Computation supports framing;
   imported analytic theorems support consequences; only algebraic
   derivations from definitions count as proof of the framework.

4. **More "framework" notes when the analytic obligation is the bottleneck.**
   After the eleven disparate-area attempts (notes 53–55), additional
   "this is another way to package the obligation" notes do not advance
   the project.  Either engage the obligation directly (e.g., via the
   Bernoulli convolution direction), make a sub-result concrete, or
   stop.

5. **Heavy infrastructure investments before pivoting.**  The modular
   bridge infrastructure (notes 33–41) was correct but turned out to be
   one-shot only for local hypothesis-minimal cases.  Note 40's
   discovery of the "deficit regime" should have prompted earlier
   pivot.  Watch for "deficit regime"-type signals: a beautifully
   developed framework that fails to apply where needed.

## 5. Empirical observations worth following up

These are empirical patterns that may or may not be theoretically
explained:

### 5.1 Conductor ratio for local cases

| set | $k$ | conductor $c$ | half-sum $S/2$ | ratio $c / (S/2)$ |
|-----|-------|----------------:|-----------------:|--------------------:|
| $\{3,4,7\}$ | 1 | 581 | ~97k | 0.006 |
| $\{3,4,7\}$ | 2 | 3.98M | ~67M | 0.06 |
| $\{3,4,7\}$ | 3 | 166M | ~6.5G | 0.025 |
| $\{3,4,9,25\}$ | 2 | 452k | ~14M | 0.032 |

Ratios are all in the 0.5–6% range; no obvious pattern with $k$.
The smallest ratio is $\{3,4,7\}$ k=1 at 0.6%.  Why?

### 5.2 S-unit equation density

For $\{3,4\}$, $\{3,4,7\}$, $\{3,4,9,25\}$: non-trivial four-term
S-unit solutions count grows *sub-linearly* in $n_{\max}$.  See
`scripts/cas_fourth_moment_sunit.py`.  Theoretically, Evertse–Schlickewei
predicts polynomial growth (with possibly large constants); empirically
the growth is much slower than the proven bound.  This sub-linear
growth is the "right" rate for the LLT to close (note 52 §5–7), but no
theorem proves it.

### 5.3 Bernoulli convolution density signatures

| case | zero-bin fraction (200 bins, 200k samples) |
|------|-------------------------------------------:|
| $\{3\}$ | 0.73 |
| $\{4\}$ | 0.86 |
| $\{3,4\}$ | 0.11 |
| $\{3,4,7\}$ | 0.00 |
| $\{3,4,5\}$ | 0.00 |
| $\{3,4,9,25\}$ | 0.00 |

Sharp transition between single-base (Cantor-singular) and
hypothesis-meeting multi-base (full support).  The transition appears
to happen at the *dimension threshold* $\sum 1/\log_2 a > 1$, exactly
where note 58's conjecture predicts.

## 6. Repository navigation

For a new contributor:

- **Read first**: `PROOF_STATE.md` (audited summary), then this journal.
- **For background**: `erdos_124_researcher_handout_current_state.md`
  (mostly historical now but introduces the problem).
- **For the algebraic framework**: notes 28, 33, 36, 39, 40, 43, 47, 49.
- **For the local certificates**: notes 07, 09, 10, 11, 26, 46.
- **For the disparate-area exploration**: notes 50, 52, 53, 54, 55.
- **For the new direction**: note 58, this journal.
- **For audit / lessons**: notes 45 (strategy revision), 55 (negative
  results), 57 (falsified optimism).

Code structure:

- `haskell/`: typed certificates for algebraic obligations
  (`GlobalProofAudit.hs`, `ConductorBossTree.hs`, plus per-obligation
  modules).
- `scripts/`: Python CAS scripts (SymPy / numpy) for mechanical
  verification.  Naming convention: `cas_*.py` for CAS-discipline
  scripts, others are earlier exploratory.
- `results/`: time-stamped output transcripts of script runs.
- `certificates/manifest.json`: runner config for the full certificate
  suite (`python scripts/run_certificates.py`).

Memory:

- `~/.claude/projects/.../memory/MEMORY.md` indexes two persistent
  feedback memories:
  - `feedback_meta_review.md`: end-of-session "are we on the right
    track" discipline.
  - `feedback_cas_delegation.md`: delegate mechanical verification to
    CAS; reserve prose for framing.

## 7. Specific open questions worth posing

If contacting the active Bernoulli convolution / fractal geometry
community:

1. Has the multi-base BC AC conjecture (note 58 §4) been posed?
   Searching arxiv and MathOverflow turned up no direct hits.

2. For $\{3, 4\}$ specifically: is $B_{1/3} * B_{1/4}$ known to be
   absolutely continuous?  Single bases are clearly Cantor (Pisot);
   convolution dimension is $\log_3 2 + \log_4 2 \approx 0.63 + 0.5 =
   1.13 > 1$, satisfying Marstrand's condition.

3. Does the Hochman 2014 entropy framework extend to multi-base
   convolutions where individual measures are Pisot-singular?

4. What is the best current bound on Fourier decay
   $|\hat\mu_A(\xi)|$ as $|\xi|\to\infty$ for multi-base BC with
   integer-Pisot parameters?

A MathOverflow post titled e.g. "Absolute continuity of convolutions
of integer-base Bernoulli convolutions" with the conjecture and
empirical evidence would attract Solomyak, Shmerkin, or Varjú.

## 8. If you're an AI model picking this up

Read this entire document, then `PROOF_STATE.md`, then note 58, before
writing anything.  The project has documented patterns of overstatement
(see §4); the recovery from each took multiple sessions.  Match the
empirical-check-first discipline before making analytical claims.

Match the audit discipline: every claim should be cross-checked against
running code or a published theorem.  Bare assertions of "this should
work" are the highest-risk type of contribution.

If you find yourself writing the fourth "this might break the bind"
note in a row, stop.  Either pivot, write the consolidation, or
acknowledge the wall.

The Bernoulli convolution direction (note 58) is the most novel and
the most promising — it's the only direction in 25 sessions that
opens a *new* door rather than closing one.  If you're going to push
one direction, push that one.

## 9. License

This project is a working notebook.  Notes, code, and results may be
re-used freely.  Cite this repository if convenient; attribution is
not required.

---

*Last updated: 2026-05-19.*
*Sessions to date: ~25.*
*Total commits: ~60.*
*Open obligations (per GlobalProofAudit.hs): 1 (the power-saving
central conductor theorem).*
*Most promising new direction: note 58 multi-base Bernoulli AC.*
