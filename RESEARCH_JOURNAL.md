# Erdős Problem 124 — research journal

**Audience.**  Future sessions, human collaborators, and AI models who
will continue this work.  This document is forward-looking and
prescriptive; for a backward-looking audit of what is proved, see
`PROOF_STATE.md`.

## 1. What this project is now

After 30+ sessions including a hostile audit of the Bernoulli
convolution direction (notes 63–65, 2026-05-20), the project's state
is:

- **Layer 1 — proved unconditionally** (notes 26, 07, 09, 10, 11, 46):
  Erdős 124 for five specific local cases.  See PROOF_STATE.md §2.1.

- **Layer 2 — algebraic framework, certified** (~25 notes, ~40 Haskell
  modules, ~20 CAS scripts): clean reductions, dependency tree, residue
  / modular / scaled-power machinery.  See PROOF_STATE.md §2.2.

- **Layer 3 — single combinatorial bottleneck**: the *global
  power-saving central conductor theorem*
  (`GlobalProofAudit.hs` Open obligation).  Closing this — combined
  with imported analytic input (or ABC) — closes Erdős 124.

The **multi-base Bernoulli convolution direction** (notes 58–62) was
explored as a potential shortcut.  Notes 63–65 hostile audit showed
the Fourier bridge from L² density of $\mu_A$ to subset-sum
representability **does not close** (the natural Parseval, Berry-Esseen,
and LLT routes all fail at the integer-level combinatorial gap).  The
fractal-geometric L² conjecture remains an independently interesting
open problem, but it is **not** a route to Erdős 124.

## 2. The single combinatorial obligation that closes Erdős 124

> **Global power-saving central conductor theorem.**  Prove
> $c(E) = o(T(E))$ in the strict case $R(A) > 1$, and
> $c(E) = O(T(E)^{1-\epsilon})$ for some $\epsilon > 0$ in the
> exact-critical case $R(A) = 1$, where $T(E) = \min_i E_i$ is the
> minimum frontier power.

This is the **one** Open obligation in `haskell/GlobalProofAudit.hs`,
and the bottleneck for both conditional reductions (§5 of PROOF_STATE).

The next cuts in `haskell/ConductorBossTree.hs` are:

- `scaled-power-middle-interval`: middle interval theorem for scaled
  power blocks (same-base sub-cut is now reduced to numerical
  semigroups via `SameBaseFrobenius.hs`; mixed-base case open).
- `quotient-block-selection`: choose useful modular quotient blocks
  (modulus search is finite; remaining work is valuation-profile
  tuning or attacking the conductor on $A$ directly).

**If you do nothing else with this project: attack the mixed-base
scaled-power-middle-interval theorem.**

## 3. Concrete next sessions (priority order)

After the 2026-05-20 audit (notes 63–65) retracted the BC route, the
priorities re-centred on the combinatorial conductor program.

### Session N+1 — Audit the mixed-base middle-interval cut

`scaled-power-middle-interval` (boss tree) is the next cut: the
same-base sub-case is reduced to numerical-semigroup Frobenius
(`SameBaseFrobenius.hs`), and the mixed-base case is the open
remainder.

Read notes 33, 34, 42, 44 and the Haskell modules
`ScaledPowerBlock.hs`, `SameBaseFrobenius.hs`,
`SingleProgressionAbsorption.hs`, `QuotientConductorBridge.hs`,
`ConductorLift.hs`.  Write the precise mixed-base sub-obligation as a
standalone claim; this becomes the target for Session N+2.

### Session N+2 — Attack the mixed-base middle-interval theorem

Concretely: for $E = (E_a)_{a\in A}$ balanced with $T(E) = \min E_a$,
show that the union of scaled blocks $\bigcup_a q_a d_a^{\,n}$
(with $d_a \in A$, multiple $a$'s present) admits a central interval
with conductor $\le T^{1-\epsilon}$ for some $\epsilon = \epsilon(A,k)>0$.

Approach candidates:
- Apply `QuotientConductorBridge` recursively across two-base
  sub-blocks; track how the conductor compounds.
- Use the modular bridge's deficit-one-shot regime: although
  individual deficit-one-shot bounds are weak, an "iterated deficit"
  argument across multiple radicals may yield power saving.
- Apply Sárközy / Solymosi-style additive combinatorics to the
  multi-base union (the union is a "structured Sidon-like" set
  whose representation function has nontrivial density on the
  central interval).

Document the attempt honestly in note 67; if blocked, identify the
specific obstacle.

### Session N+3 — Sharpen `quotient-block-selection` past the deficit regime

`ModulusSearch.hs` certifies that local hypothesis-minimal cases land
in the "deficit one-shot" regime — meaning the modular bridge gives
only finite (not asymptotic) coverage.  To get sub-linear conductor
from the modular bridge, we need either:

- a recursive regime (where the quotient block has $R \ge 1$, so the
  bridge composes with itself), or
- direct analytic input on the conductor of $A$.

Investigate: for which non-hypothesis-minimal $A$ does the quotient
block enter the recursive regime?  This may give a clean sub-family
where the modular bridge alone closes the conductor theorem.

### Session N+4 — Direct local certificates beyond {3,4,7}

The five proved cases all use either CF/MW (for $\{3,4,7\}$-type
sets sharing the 3,4 pair) or CFH for the strict case.  Push the
local certificate machinery to:

- $\{3,4,11\}$, $\{3,4,13\}$ (similar 3,4 pair, larger third base).
- Strict cases beyond $\{3,4,5\}$: $\{3,4,6\}$, $\{3,5,6\}$, etc.

If the same machinery generalises, this adds unconditional cases.  If
it breaks, the failure mode is informative.

### Session N+5 — Formalisation in Lean (deferred)

The algebraic framework (notes 28, 39, 40, 43, 47) remains
formalisable in Lean 4 / Mathlib.  Start with the conductor identity
$K(E) = \kappa + 2c + 1$.  Lower-priority than direct conductor
attack, but a credibility marker.

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

6. **Reductions where the Fourier transform "encodes" subset-sum
   structure.**  Notes 58–62 tried to bridge L² density of $\mu_A$ to
   the discrete conductor bound via continuous Fourier inversion.
   Notes 63–65 hostile audit showed this does NOT work: continuous L²
   Fourier captures average behaviour, not integer-level
   representability.  The natural Parseval, Berry-Esseen, and LLT
   routes all fail at the same obstacle ($\hat\mu_A\notin L^1$).
   General principle: if your reduction depends on continuous Fourier
   data certifying discrete combinatorial facts, audit the bridge
   *before* investing in empirical evidence for the continuous
   conjecture.  The 6-session investment in BC notes was largely
   independent-area research, not Erdős 124 progress.

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

The Bernoulli convolution direction (notes 58–62) was the most novel
exploration, but the 2026-05-20 audit (notes 63–65) showed it does NOT
close Erdős 124 — the Fourier bridge from L² density to subset-sum
representability fails ($\hat\mu_A\notin L^1$ for integer-Pisot
parameters, blocking the LLT).  The BC L² density conjecture stands as
an independently-interesting fractal-geometric problem but is no
longer the project's "most promising" Erdős 124 lead.

The actual lead is **the mixed-base scaled-power-middle-interval
theorem** (the next-cut Open node in `ConductorBossTree.hs`),
which together with `quotient-block-selection` closes both
`strict-conductor` and `exact-conductor`, hence closes the single
remaining `GlobalProofAudit.hs` open obligation, hence closes Erdős
124 (modulo imported analytic input).  Push that one.

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
