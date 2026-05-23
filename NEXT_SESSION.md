# Next-session handoff (2026-05-23, after commit `c218eab`)

> **For an AI agent or human researcher picking this up cold.**
> Read this entire document first.  It's optimized for a 5-minute
> onboarding to "what's the state and what to do next?"
>
> Companion documents:
> - `RESUMING.md` — environment setup (build, test, etc.).
> - `PROOF_STATE.md` — audited claims summary.
> - `notes/98_session_synthesis.md` — full session summary.
> - `notes/89_research_structure_and_distance.md` — distance chart.

---

## 1. The 30-second context

**Erdős Problem 124** is a 1932 conjecture about subset sums of
power sets $\{a^e : a \in A, e \ge k\}$.

**Project status:** Closed unconditionally for the certified scope
($A \subseteq \{3, \ldots, 20\}$, $|A| \le 6$, hypothesis-meeting).
12,226+ specific cases proved.  Algebraic chain covers every
certified case via three independent routes.

**Open obligation:** No major transcendence-theory dependency
remains.  The truly universal claim (unbounded $A$) requires
paper-scale Pillai-style adaptation — concrete, well-defined,
not a major open problem.

---

## 2. The three closure routes

For any hypothesis-meeting $(A, k)$, **at least one** of these
routes closes Erdős 124 unconditionally:

### Route 1: Theorem A (strict, $R > 1$)
- Reference: `notes/72_algebraic_reduction_theorems.md`
- Hypothesis: $R(A) := \sum_{d \in A} 1/(d-1) > 1$ (strict).
- Mechanism: CFH-strict + strict-slack tail closure.
- Analytic input: **none**.
- Coverage: ~12,200 of the 12,226 certified cases.

### Route 2: Theorem B'' (exact-critical, $R = 1$)
- Reference: `notes/82_theorem_b_prime_effective_mw.md`,
  `notes/83_h5_derivation_via_induction.md`.
- Hypothesis: $R(A) = 1$ + (H1') + (H4'.SS) + (H4').
- Mechanism: Effective MW (LMN 1995 / Laurent 2008) + induction.
- Analytic input: **Mignotte–Waldschmidt** (proved theorem).
- Coverage: 4 specific cases ($\{3,4,7\}$ k=1,2,3; $\{3,4,9,25\}$ k=2);
  + 18 cases at max_base=20 via S-unit qualitative.

### Route 3: Theorem 97.4 (combinatorial via Charge γ)
- References: `notes/92_charge_gamma_multi_pair.md`,
  `notes/94_ess_qualitative_closure.md`,
  `notes/97_structural_closure_min_7.md`.
- Hypothesis: $|A| \ge 3$, $\ge 3$ multiplicative classes, $|A| \le 7$
  (forces $\min(A) \le 8$).
- Mechanism: Multi-pair joint near-collision + ESS 2002 + per-pair
  MW + Lemma 97.2 (elementary).
- Analytic input: **MW + ESS 2002** (both proved theorems).
- Coverage: ALL hypothesis-meeting cases with $|A| \ge 3$ and
  $\ge 3$ mult classes — the *vast majority* of the 12,226 cases.

**Empirical backing:** 4M+ verifications across $[3, 200]$ at depth
60–80.  ZERO failures within hypothesis-meeting scope.

---

## 3. What was accomplished this session (commits e1be352 → c218eab)

| Notes | Phase | Key result |
|---|---|---|
| 82–83 | Theorem B' + (H5') derivation | Closed a hidden gap in Theorem B via induction |
| 84, 86, 87 | (H4') reformulation | Partial-quotient / irrationality-measure forms |
| 88 | Theorems E, F audit | Theorem E mis-stated (max-gap, not conductor); Theorem F withdrawn (proof gap + counterexample $r(10) = 0$) |
| 89 | Distance chart (revised) | 60-75% → 100% for certified scope |
| 90 | Connections to other open problems | Tier 1: Lang, ABC, ESS, MW |
| 91 | Demolition strategy | Identified Charge γ as highest-ROI move |
| **92** | **Charge γ deployed** | **Multi-pair joint constraint; major advance** |
| 93 | Synthesis Theorem 93.1 + scaling | Three routes formally combined |
| **94** | **ESS qualitative closure** | **Conjecture 92.2 (qual.) = ESS 2002 (proved)** |
| 95 | Complete closure chain | Theorem 95.1; massive empirical |
| 96 | Effective form via MW | Theorem 94.2 fully effective |
| **97** | **Structural lemma + uniform closure** | **Theorem 97.4: min ≤ 7 closes** |
| 98 | Session synthesis | Single-document summary |
| 99 | Paper-style abstract | For external sharing |
| 100 | End-of-session meta-review | Honest self-audit |
| 101 | Extended scope audit | (5, 6, 119) edge case identified, doesn't affect closure |
| 102 | Universal gap proof attempts | Baker-Wüstholz gives effective bound; sub-class closure |

**33 commits total this session.**

---

## 4. What to do next: three concrete paths

Each has independent value.  Pick based on session scope and
preference.

### Path A: Paper draft (5–10 sessions, highest external impact)

**Goal.** Produce a research paper adapting the algebraic chain
for peer review.

**Structure.**
1. Abstract + introduction (note 99 is a template).
2. Setup and notation (consolidating notes 28, 72).
3. Three closure routes with proofs (notes 72, 82, 83, 92, 94, 97).
4. ESS 2002 + MW + Lemma 97.2 details.
5. Effective bound via Baker-Wüstholz (note 102 §1).
6. Empirical verification statistics (notes 92, 95, 97, 101).
7. Universal closure path (note 102 §3-6).

**Key challenge.** The "universal joint gap claim" — adapting
Beukers–Schlickewei 1996 to two-pair systems.  This is the
paper's main technical content.

**Suggested approach.** Start by writing the section that's
clearest (algebraic chain), then attempt the joint gap proof for
specific sub-classes (Theorem 102.2 style), then full universal as
a stretch goal.

### Path B: Lean formalization (3–8 sessions, technical certainty)

**Goal.** Mechanically verify the algebraic chain in Lean 4.

**Prerequisites.** Lean 4 + Mathlib installed.  See note 85 §3
for the comparison of formalization levels.

**Priority order.**
1. **Proposition 83.1** ((H5') derivation) — short, induction-based.
   Already at Level-2 in `haskell/Proposition83.hs`.
2. **Theorem A** — strict case, no analytic input.
3. **Theorem 97.4** — combinatorial closure via Charge γ.
4. **Theorem B''** — effective MW case (depends on imported MW).
5. **Lemma 97.2** — elementary, easy.

**Why this matters.** The audit discipline this session caught
Theorems E, F errors via inspection.  Lean would catch *any*
remaining latent errors mechanically.

**Suggested approach.** Set up `lean/erdos124/` as a Mathlib
project.  Port Proposition 83.1 first (it's the shortest and
demonstrates the technique).

### Path C: Extended computational verification (1–3 sessions, empirical strengthening)

**Goal.** Push the empirical evidence to a level where the
universal claim is essentially established empirically.

**Concrete tasks.**
1. Run `haskell/CFIntersection.hs` at $[3, 1000]$ depth 100
   (~10–100M triples).
2. For each "failure" found (non-h-m triples at large min): verify
   that the encompassing h-m $A$ has alternative closing triples.
3. Profile the closure threshold scaling: for $B^* = 10^B$, what's
   the closure-min cutoff?

**Outcome.** Either:
- (a) Universal empirical at scale: $0$ failures in h-m scope → strengthens the empirical case.
- (b) Discover a new edge case: refines Theorem 102.1's verification
  procedure.

Either is valuable.

### Less recommended paths

**Pursuing Lang's conjecture directly.**  No longer needed (notes
84, 92, 94 removed the dependency).  Don't spend session-effort
on Lang.

**More computational certificates of the existing 12,226 cases.**
Per `feedback_algebraic_proofs_over_certificates.md`: the user
prefers clean algebraic content over more certificates.

**Refining the Bernoulli convolution direction (notes 58–65).**
Retracted in note 65; reinforced by note 88's audit.  Don't revisit
unless a fundamentally new bridge is identified.

---

## 5. Environment setup (quick refresher)

```bash
# 1. Clone and verify
git clone https://github.com/TACITVS/erdos-problem-124-bernoulli.git
cd erdos-problem-124-bernoulli
git log --oneline -5
# Should show: c218eab Note 102 ...

# 2. Build C++ library (Windows + MSYS2 mingw64)
cd cpp && mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build . -j

# 3. Verify Haskell modules
cd ../../haskell
ghc -O Proposition83Certificate.hs && ./Proposition83Certificate.exe
ghc -O CFIntersection.hs && ./CFIntersection.exe
ghc -O GlobalProofAudit.hs && ./GlobalProofAudit.exe

# 4. The unified batch (12,226 certifications, ~3.5 min)
cd ../cpp/build
PATH="/c/msys64/mingw64/bin:$PATH" ./unified_batch.exe --max-base=20 --min-size=3 --max-size=6 --k-min=1 --k-max=2
```

---

## 6. Memory and feedback files

The auto-memory system at
`C:\Users\baian\.claude\projects\C--Users-baian-Math-Research-Knuth-124\memory\`
contains:

- **MEMORY.md** — index.
- **feedback_meta_review.md** — end-of-session meta-review discipline.
- **feedback_cas_delegation.md** — delegate algebra to SymPy.
- **feedback_cpp_over_python.md** — C++ for heavy compute.
- **feedback_use_library_not_standalone.md** — extend the `erdos124`
  library, don't write scattered standalone code.
- **feedback_algebraic_proofs_over_certificates.md** — prefer clean
  proofs over more certificates.
- **project_state_post_session_2026_05_23.md** — snapshot of where
  we left off (read this on resumption).

**For machine resets:** the canonical snapshot is in
`MEMORY_SNAPSHOT/` in the repo.  Copy to the auto-memory dir.

---

## 7. The mathematical state in one sentence

> **Erdős 124 is closed unconditionally for every hypothesis-meeting
> $(A, k)$ with $A \subseteq \{3, \ldots, 20\}$ and $|A| \le 6$; the
> universal claim (all $A$, unbounded) requires paper-scale
> adaptation of existing transcendence techniques (Beukers–Schlickewei
> 1996, Bilu–Tichy 2000, Bugeaud–Mignotte) but NO major open
> transcendence problem.**

---

## 8. The audit discipline (important!)

The project has named anti-patterns from past sessions.  AVOID:

1. **Overstating reductions without checking dependency tree.**
   Example: note 56's original "ABC implies Erdős 124" was overstated.
   Always cross-check against `haskell/GlobalProofAudit.hs`.

2. **Predicting closure timelines optimistically.**  Empirical check
   should precede analytical claims.  See note 57.

3. **Calling computational verification "proof".**  Computation
   supports framing; only algebraic derivations count.  See
   `feedback_algebraic_proofs_over_certificates.md`.

4. **Writing more "framework" notes when the analytic obligation is
   the bottleneck.**  See journal §4 lesson 4.

5. **Computing without auditing.**  Theorems E, F audit (note 88)
   found a notational conflation AND a false theorem.  Every
   load-bearing theorem deserves a sanity check.

The audit discipline this session caught real issues.  Future
sessions should maintain it.

---

## 9. The single recommended next move

**If you have one session: extend the computational verification**
(Path C above) to base range $[3, 500]$ at depth 100.  This is a few
hours of compute (~50–500M verifications).  If all close: the
universal claim has overwhelming empirical support and writing the
paper becomes more confident.

**If you have multi-session capacity: start the paper draft**
(Path A).  The technical content is identified (notes 92–102);
the work is exposition + rigorous joint gap proof for specific
sub-classes.

**If formal verification is the priority: Lean formalization**
(Path B), starting with Proposition 83.1.

---

## 10. Closing thought

This session transformed Erdős 124 from "algebraically saturated,
waiting on Lang's conjecture (decades)" to "essentially closed for
the project's scope, with concrete paper-scale path forward".

The key insight was **Charge γ** (note 92): multi-pair joint
near-collision constraint, exploiting note 27's "for every pair"
form combined with ESS 2002.  This bypassed the Lang dependency
entirely.

Future sessions should build on this: extend the empirical scope,
formalize the chain, or write the paper.  The algebraic
infrastructure is solid; the work is in *delivery* (papers, Lean,
external review) more than in *invention* (new theorems).

Good luck.
