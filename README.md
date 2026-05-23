<div align="center">

# Erdős Problem 124

### Computational research notebook: bounded-conductor conjecture & combinatorial framework

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Status: open research](https://img.shields.io/badge/Status-open%20research-blue.svg)](PROOF_STATE.md)
[![Certificates](https://img.shields.io/badge/Certificates-26%2F26%20passing-brightgreen.svg)](certificates/manifest.json)
[![Sessions](https://img.shields.io/badge/Sessions-30%2B-informational.svg)](RESEARCH_JOURNAL.md)

</div>

---

## Headline (2026-05-22)

After 30+ sessions, the project has produced:

> **12,226+ hypothesis-meeting $(A, k)$ certified — Erdős 124 holds unconditionally for each.**

via the `erdos124` C++23 library ([notes 80](notes/80_erdos124_library_and_dgs_diagnostics.md), [81](notes/81_unified_batch_12k_certificates.md)) — a clean modular header-only library implementing the project's machinery, with a single `unified_batch` driver that completes the 12k-case enumeration in ~3.5 minutes.

Each per-case certification verifies the hypotheses of one of the project's algebraic theorems:
- **Theorem A** (strict CFH-reduction, [note 72](notes/72_algebraic_reduction_theorems.md)) — no analytic input.
- **Theorem B** (qualitative S-unit reduction, [note 72](notes/72_algebraic_reduction_theorems.md)) — qualitative S-unit finiteness, non-effective $N_0$.
- **Theorem B'** (effective MW form of Theorem B, [note 82](notes/82_theorem_b_prime_effective_mw.md), 2026-05-22) — replaces qualitative S-unit by Mignotte–Waldschmidt (LMN 1995 / Laurent 2008); effective $N_0$ for the four CF/MW cases. Surfaces a per-case conductor-stability hypothesis (H5') that Theorem B had left implicit.
- **Proposition 83.1 + Theorem B''** ([note 83](notes/83_h5_derivation_via_induction.md), 2026-05-23) — derives (H5') from (H1') + (H4'.SS) + (H4') by complete-sequence induction, so Theorem B'' has only three hypotheses (none of which is "conductor stays bounded"). Resolves the implicit assumption flagged in Theorem B' and retroactively closes the same gap in Theorem B (note 72).
- **Lemma 84.1 + Proposition 84.1** ([note 84](notes/84_h4_prime_uniformity_via_partial_quotients.md), 2026-05-23) — bounded CF partial quotients of $\log y/\log x$ imply (H4') automatic (on a window shifted by $O(\log K)$). Reduces the open obligation, in the exact-critical case, to a *concrete Diophantine question* on irrationality measures of integer-log ratios — a special case of Lang's conjecture. Closes a uniform sub-class (e.g., $(3, 4)$-pair cases) by Proposition 84.1 + the certified PQ bound $K \le 112$ for $\log 4/\log 3$.
- **Theorem C** (recursively-reducible bounded conductor, [note 73](notes/73_open_obligation_attack.md)) — for the recursive sub-class.
- **Proposition D** (conductor-growth dichotomy, [note 73](notes/73_open_obligation_attack.md)) — modulo Subspace, $c$ is bounded or grows linearly.

The theorems are proved pen-and-paper; the certificates verify their per-case hypotheses.

| family | count | route | analytic input | effectivity |
|---|---:|---|---|---|
| Strict CFH ($A \subseteq \{3,\ldots,15\}$, $\|A\| \in \{3,4,5\}$, $k \le 2$) | **872** | [`cpp/cfh_batch.cpp`](cpp/cfh_batch.cpp), notes [67](notes/67_cfh_generalized_proof.md), [69](notes/69_cfh_batch_results.md), [71](notes/71_modular_deficit_resolved.md) | **none** | effective $(c^*, T^*)$ |
| Exact-critical CF/MW ($\{3,4,7\}$ k=1,2,3; $\{3,4,9,25\}$ k=2) | 4 | finite CF + frontier check, [note 46](notes/46_347_k1_certificate.md) etc. | Mignotte–Waldschmidt | effective explicit $N_0$ |
| Exact-critical qualitative S-unit ($A \subseteq \{3,\ldots,30\}$, $\|A\| \le 6$, $k \le 3$) | **99** (95 new) | [`cpp/sunit_general.cpp`](cpp/sunit_general.cpp), [note 70](notes/70_sunit_exact_critical_batch.md) | qualitative S-unit finiteness (unconditional) | qualitative $N_0$ non-effective |

This expands the project's unconditionally certified set from 5 specific cases (the original PROOF_STATE.md table) to **~971**, spanning both strict and exact-critical regimes.

The 2 "modular-deficit failures" previously flagged in note 69 turned out **not** to be genuine failures — they just needed a higher $T$ threshold (~$10^{10}$ instead of the prior $10^9$) plus a half-bitset memory optimization to handle the larger seed. [Note 71](notes/71_modular_deficit_resolved.md) documents the resolution.

The empirical observation underlying this advance — the [Bounded Conductor pattern](notes/66_conductor_bounded_empirical.md) along balanced frontiers — combined with the generalized CFH-strict route (note 67) for strict cases, and qualitative S-unit (note 27) for exact-critical cases, gives a uniform per-case certification machinery.  A *uniform* (not per-case) proof of the [open obligation](haskell/GlobalProofAudit.hs) $c(E) = o(T(E))$ remains open.

### A previously-attempted route, honestly retracted

Notes 58–62 proposed a parallel reduction via fractal-geometric analysis of multi-base Bernoulli convolutions. A hostile audit ([notes 63–65, 2026-05-20](notes/63_note59_audit.md)) found that the Fourier bridge from L² density of $\mu_A$ to combinatorial conductor bounds **does not close** ($\hat\mu_A \notin L^1$ for integer-Pisot parameters, blocking the local limit theorem). The L² density conjecture remains an independently-interesting fractal-geometric problem [(see §The Bernoulli detour below)](#the-bernoulli-convolution-detour-honest-record), but it is **not** a path to Erdős 124. Notes 60–62 stand as a documented empirical exploration of an open question in fractal geometry — the 12th honest negative in [PROOF_STATE.md §6](PROOF_STATE.md).

📚 **For the audited state:** [`PROOF_STATE.md`](PROOF_STATE.md) — what is proved, imported, conjectural, open.
🧭 **For the next sessions:** [`RESEARCH_JOURNAL.md`](RESEARCH_JOURNAL.md) — forward-looking handoff.

---

## Table of contents

1. [The problem](#the-problem)
2. [What this project actually proves](#what-this-project-actually-proves)
3. [Bounded conductor empirical evidence](#bounded-conductor-empirical-evidence)
4. [The Bernoulli convolution detour (honest record)](#the-bernoulli-convolution-detour-honest-record)
5. [Quickstart](#quickstart)
6. [Documentation map](#documentation-map)
7. [Citing](#citing)
8. [References](#references)

---

## The problem

Let $A = \{d_1, \ldots, d_r\}$ be a finite set of distinct integers with $d_i \ge 3$.
For $k \ge 1$, let $P(d, k)$ be the set of finite sums of distinct powers $d^j$ with $j \ge k$.

The hard form of Erdős Problem 124 asks whether

$$\gcd(d_1, \ldots, d_r) = 1 \qquad \text{and} \qquad \sum_{i=1}^{r} \frac{1}{d_i - 1} \;\ge\; 1$$

imply that **every sufficiently large integer** lies in $P(d_1, k) + \cdots + P(d_r, k)$, for every $k \ge 1$.

The $k = 0$ case (each base contributes $1 = d^0$) has a short Brown-criterion proof. This repository focuses on the hard $k \ge 1$ version, open since [Burr–Erdős–Graham–Li 1996](https://www.math.ucsd.edu/~ronspubs/96_05_integer_powers.pdf).

---

## What this project actually proves

### Five local cases proved (computer-assisted)

The CF/MW + finite-bitset-scan template closes the following exact-critical and strict cases:

| set | $k$ | $R(A) = \sum \frac{1}{a-1}$ | largest missing integer | certificate |
|-----|----:|:---:|------------------------:|-------------|
| $\{3,4,5\}$  | 1 | $\tfrac{13}{12}$ | 79 (CFH, *unconditional*) | [Note 26](notes/26_cfh_strict_tail.md) |
| $\{3,4,7\}$  | 1 | 1 | 581 | [Note 46](notes/46_347_k1_certificate.md) |
| $\{3,4,7\}$  | 2 | 1 | 3,982,888 | [Note 07](notes/07_347_k2_certificate.md), [Note 09](notes/09_cf_tail_347_k2.md) |
| $\{3,4,7\}$  | 3 | 1 | 166,025,260 | [Note 10](notes/10_347_k3_certificate.md) |
| $\{3,4,9,25\}$ | 2 | 1 | 452,099 | [Note 11](notes/11_34925_k2_certificate.md) |

All five are checked by the typed Haskell verifiers (`haskell/TailCertificate.hs`, `haskell/CFTailCertificate.hs`). The first uses no imported analytic input; the others depend on the Mignotte–Waldschmidt bound for $\log 3 / \log 4$.

### Algebraic framework (problem-independent, certified)

The project develops a complete algebraic framework. Highlights:

| obligation | content | reference |
|------------|---------|-----------|
| Conductor identity | $K(E) = \kappa(A, k) + 2c(E) + 1$ | [Note 28](notes/28_power_saving_central_interval_target.md) |
| Density growth | $\sum_a \tfrac{1}{\log_2 a} \ge R(A) \ge 1$, from $\log_2 a \le a-1$ | [Note 47](notes/47_generating_function_density.md) |
| Resonance lattice | $\Delta(A, p, q) > 0$ iff $\gcd(A) = 1$ | [Note 49](notes/49_resonance_decay.md) |
| Quotient reciprocal sum | $R$ of scaled quotient block = $R(D(m, A))$ | [Note 40](notes/40_quotient_reciprocal_sum.md) |
| Modular conductor lift | $c(F \cup mG') \le m(c'+1) + R - 1$ | [Note 33](notes/33_modular_conductor_lift.md) |
| Half-sum reach threshold | $S' \ge 2(c'+1) + \lceil F_{\text{tot}}/m \rceil$ | [Note 39](notes/39_asymptotic_half_sum_reach.md) |
| Same-base Frobenius reduction | $c \le F(\mathbf{q}) \cdot d^{e_{\min}} + O(1)$ | [Note 44](notes/44_same_base_frobenius_reduction.md) |
| Single-progression absorption | closed-form prefix length | [Note 42](notes/42_single_progression_absorption.md) |

26 certificates, all passing — run `python scripts/run_certificates.py`.

### Open obligation

Exactly **one** Open obligation remains in `haskell/GlobalProofAudit.hs`:

> **Global power-saving central conductor theorem.** Prove $c(E) = o(T(E))$ in the strict case $R > 1$, and $c(E) = O\!\bigl(T(E)^{1-\epsilon}\bigr)$ in the exact-critical case $R = 1$.

Three Imported analytic obligations: Mignotte–Waldschmidt for $\log 3/\log 4$; S-unit finiteness; Subspace-Theorem power-saving S-unit gap.

---

## Bounded conductor empirical evidence

The C++ binary [`cpp/conductor_scan.cpp`](cpp/conductor_scan.cpp) computes $c(E)$ for balanced frontiers $E_a = a^{\lceil \log_a T \rceil}$ using a dynamic 64-bit shift-OR bitset.  At $S(E) \approx 2 \cdot 10^8$ a single case takes $\le 0.5$s.

### Stabilization across $T$, fixed $(A, k)$ — all hypothesis-meeting

| $A$ | $k$ | $R$ | $c(E)$ at $T = 10^4$ | $10^5$ | $10^6$ | $10^7$ | $10^8$ | $10^9$ | asymptotic $c^*$ |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|
| $\{3,4,5\}$ | 1 | $\tfrac{13}{12}$ | 79 | 79 | 79 | 79 | 79 | — | **79** |
| $\{3,4,5\}$ | 2 | $\tfrac{13}{12}$ | — | 77,613 | 77,613 | 77,613 | 77,613 | 77,613 | **77,613** |
| $\{3,4,7\}$ | 1 | $1$ | 581 | 581 | 581 | 581 | 581 | — | **581** ✓ |
| $\{3,4,7\}$ | 2 | $1$ | 8,999 → | 79,900 → | 785,743 → | 3,982,888 | 3,982,888 | — | **3,982,888** ✓ |
| $\{3,4,7\}$ | 3 | $1$ | — | — | — | 9,746,184 → | 57,751,591 → | 166,025,260 | **166,025,260** ✓ |
| $\{3,4,9,25\}$ | 2 | $1$ | 11,636 → | 129,167 → | 452,099 | 452,099 | 452,099 | — | **452,099** ✓ |
| $\{3,5,7,13\}$ | 1 | $1$ | 112 | 112 | 112 | 112 | 112 | — | **112** |
| $\{3,4,11,16\}$ | 1 | $1$ | 69 | 69 | 69 | 69 | 69 | — | **69** |
| $\{4,5,6,7,21\}$ | 1 | $1$ | 24 | 24 | 24 | 24 | 24 | — | **24** |
| $\{3,5,8,15,29\}$ | 1 | $1$ | 21 | 21 | 21 | 21 | 21 | — | **21** |
| $\{3,5,9,13,25\}$ | 1 | $1$ | 110 | 110 | 110 | 110 | 110 | — | **110** |

Cells marked **✓** match the previously-proved conductor in [PROOF_STATE.md §2.1](PROOF_STATE.md).  Cells marked **(bold)** without check mark are previously-unstudied hypothesis-meeting cases.

### Why it matters

The open obligation in [`GlobalProofAudit.hs`](haskell/GlobalProofAudit.hs) asks only $c(E) = o(T(E))$, but **empirically $c(E) = O(1)$ — bounded by an absolute constant** depending only on $(A, k)$.

If the Bounded Conductor Conjecture (note 66 §4) is provable:

- **Strict case** ($R > 1$): $T \cdot (R-1) > c^*$ holds for $T$ large; the strict-slack tail closure of [Note 28](notes/28_power_saving_central_interval_target.md) §strict-case immediately gives Erdős 124.  **No imported analytic input required.**
- **Exact-critical case** ($R = 1$): bounded $c$ + qualitative S-unit finiteness (already Imported and *unconditional*) gives Erdős 124 via the [Note 28 §exact-critical](notes/28_power_saving_central_interval_target.md) chain.

So the Bounded Conductor Conjecture, combined with the existing certified framework, would close qualitative Erdős 124 for every hypothesis-meeting case — with no need for ABC, Mignotte–Waldschmidt for each pair, or any new analytic input beyond unconditional S-unit finiteness.

The current attack target is detailed in [`notes/66_conductor_bounded_empirical.md`](notes/66_conductor_bounded_empirical.md) §9.

---

## The Bernoulli convolution detour (honest record)

Notes 58–62 proposed a different reduction: if the **multi-base Bernoulli convolution** $\mu_A = *_{a \in A} B_{1/a}$ has L² density, then Erdős 124 would follow via a Fourier convergence chain (Note 59 Theorem 7).  Three C++ binaries triple-checked the empirical L² signature across 38 hypothesis-meeting cases (33 exact-critical + 5 hand-picked), all saturating to 4+ decimal places by $T = 10^7$.

A hostile audit on **2026-05-20** showed the bridge from the L² density to the combinatorial conductor bound **does not close**:

| audit note | finding |
|---|---|
| [Note 63](notes/63_note59_audit.md) | Lemma 4.1 of Note 59 mis-applies Parseval — $\int_{\mathbb R} \|\hat X_T\|^2$ is infinite; correct Parseval on $[0, 2\pi]$ gives only the trivial bound $\|\mathrm{supp}(X_T)\| \ge T$, **not** an improvement from L² of $\hat \mu_A$ |
| [Note 64](notes/64_literature_pulse.md) | 2023–2026 literature pulse: no published theorem closes the conjecture for integer-Pisot parameters; Kittle–Kogler 2024 is the closest framework, but its separation hypothesis fails for our overlapping IFS |
| [Note 65](notes/65_LLT_bridge_attempt.md) | Erdős–Turán / local-limit-theorem bridge attempt: blocked by $\hat\mu_A \notin L^1$ (Erdős 1939: Pisot reciprocal does not decay); L² interpolation does not give L¹ |

The L² density conjecture about $\mu_A$ is a **genuinely interesting fractal-geometry question** of independent value (closest to Kittle–Kogler 2024), but it is **not** a reduction of Erdős 124.  The empirical work in [Notes 60–62](notes/61_cpp_triple_check.md) stands as documented evidence for that fractal-geometric conjecture.

### Empirical L² signature data (still real, just re-labelled)

For the fractal-geometric question alone, the C++ triple-check at $T = 10^7$:

| set | $R(A)$ | $I(10^7) = \int_{-10^7}^{10^7} \|\hat\mu_A\|^2$ | saturated? |
|-----|:---:|---:|:---:|
| $\{3,4,5\}$         | $\tfrac{13}{12}$ | 1.1628 | ✓ |
| $\{3,4,7\}$         | $1$ | 1.2351 | ✓ |
| $\{3,4,9,25\}$      | $1$ | 1.2601 | ✓ |
| $\{3,5,7,13\}$      | $1$ | 1.2342 | ✓ |
| $\{3,6,9,12,21,45,89\}$ | $1$ | 1.2857 | ✓ |
| ...33 more exact-critical sets, all saturate, [note 62](notes/62_exact_critical_sweep.md) | | | ✓ |

Single-base $\{a\}$ controls (Cantor-singular, Erdős 1939): $I(T)$ grows linearly. The bounded vs. unbounded distinction is robust across 38 hypothesis-meeting cases tested.

This is interesting *fractal geometry*. It does **not** give a route to Erdős 124. The current project lead is the [Bounded Conductor Conjecture](#bounded-conductor-empirical-evidence) above.

---

## Quickstart

### Reproduce the full certificate suite (~2 min)

```bash
python scripts/run_certificates.py
# Expected: 26 checked, 26 passed, 0 failed
```

### Reproduce the C++ Bernoulli triple-check (~10 min)

```bash
g++ -O3 -fopenmp -std=c++20 -march=native \
    cpp/bernoulli_fourier.cpp -o cpp/bernoulli_fourier.exe

cpp/bernoulli_fourier.exe default     # T up to 10^6, all cases
cpp/bernoulli_fourier.exe verify      # T up to 10^7, hypothesis-meeting only
cpp/bernoulli_fourier.exe per-scale   # dyadic-shell decomposition
cpp/bernoulli_fourier.exe monte-carlo # uniform MC cross-check
```

### Reproduce the empirical density signature (~30 s)

```bash
python scripts/cas_bernoulli_density.py
# Single-base: Cantor signature (high zero-bin fraction, huge density ratio).
# Hypothesis-meeting multi-base: full support, bounded density ratio.
```

### Inspect the proof audit and boss tree

```bash
runghc haskell/GlobalProofAudit.hs    # 1 open obligation, 3 imported, rest certified
runghc haskell/ConductorBossTree.hs   # 23 nodes: 17 Done, 5 Open, 1 Imported
```

### Reproduce the bounded-conductor empirical scan (~30 s for the whole table)

```bash
g++ -O3 -std=c++20 -march=native cpp/conductor_scan.cpp -o cpp/conductor_scan.exe

cpp/conductor_scan.exe --bases=3,4,7 --k=1 --T-list=1e4,1e5,1e6,1e7,1e8
# Expected: c(E) = 581 stable across all T

cpp/conductor_scan.exe --bases=4,5,6,7,21 --k=1 --T-list=1e4,1e5,1e6,1e7,1e8
# Expected: c(E) = 24 stable across all T

cpp/conductor_scan.exe --bases=3,4,7 --k=2 --T-list=1e4,1e5,1e6,1e7,1e8
# Expected: c(E) grows then stabilizes at 3,982,888 by T=1e7
```

---

## Documentation map

### Read first

- [**`PROOF_STATE.md`**](PROOF_STATE.md) — audited summary: what is proved, imported, conjectural, open.
- [**`RESEARCH_JOURNAL.md`**](RESEARCH_JOURNAL.md) — forward-looking handoff for next sessions, AI models, collaborators.

### Current lead — bounded-conductor program

- [**Note 66**](notes/66_conductor_bounded_empirical.md) — Bounded Conductor Conjecture, the new sharp target.  Stronger than the open obligation; closes Erdős 124 if provable.
- [Note 28](notes/28_power_saving_central_interval_target.md) — power-saving central conductor target (the open obligation it supersedes).
- [Note 34](notes/34_conductor_boss_lemma_ladder.md) — boss tree dependency ladder.
- [Note 44](notes/44_same_base_frobenius_reduction.md) — same-base sub-case closed via Frobenius.

### The Bernoulli convolution detour — explored, audit found it doesn't bridge

- [Note 58](notes/58_bernoulli_convolution_path.md) — original conjecture statement.
- [Note 59](notes/59_rigorous_equivalence.md) — claimed reduction AC ⟹ Erdős 124 (**audit notes 63 finds the bridge does not close**).
- [Note 60](notes/60_bernoulli_AC_deep_dive.md), [Note 61](notes/61_cpp_triple_check.md), [Note 62](notes/62_exact_critical_sweep.md) — empirical L² saturation across 38 cases (still real, just doesn't reduce Erdős 124).
- [**Note 63**](notes/63_note59_audit.md) — hostile audit of Note 59; finds 3 issues.
- [**Note 64**](notes/64_literature_pulse.md) — 2023–2026 literature pulse; conjecture remains genuinely open.
- [**Note 65**](notes/65_LLT_bridge_attempt.md) — Erdős–Turán / LLT bridge attempt; blocked by $\hat\mu_A \notin L^1$.

### Local certificates (five proved cases)

- [Note 26](notes/26_cfh_strict_tail.md) — $\{3,4,5\}$ k=1 via CFH (unconditional).
- [Note 46](notes/46_347_k1_certificate.md) — $\{3,4,7\}$ k=1 via CF/MW.
- [Note 07](notes/07_347_k2_certificate.md), [Note 09](notes/09_cf_tail_347_k2.md) — $\{3,4,7\}$ k=2.
- [Note 10](notes/10_347_k3_certificate.md) — $\{3,4,7\}$ k=3.
- [Note 11](notes/11_34925_k2_certificate.md) — $\{3,4,9,25\}$ k=2.

### Algebraic framework

- [Note 28](notes/28_power_saving_central_interval_target.md) — conductor identity & power-saving target.
- [Note 33](notes/33_modular_conductor_lift.md) — modular conductor lift.
- [Note 39](notes/39_asymptotic_half_sum_reach.md) — half-sum reach threshold.
- [Note 40](notes/40_quotient_reciprocal_sum.md) — quotient reciprocal-sum identity.
- [Note 47](notes/47_generating_function_density.md) — density growth & Mahler equation.
- [Note 49](notes/49_resonance_decay.md) — resonance lattice obstruction.

### Strategic / meta

- [Note 45](notes/45_strategy_revision.md) — strategy revision after the modular bridge limitation.
- [Note 55](notes/55_disparate_area_attempts.md) — eleven timeboxed disparate-area attempts.
- [Note 56](notes/56_abc_reduction.md) — alternative ABC + conductor reduction (notes 54–56).
- [Note 57](notes/57_energy_attempt_honest.md) — falsified optimistic claim, lessons.

### Repository structure

```
.
├── PROOF_STATE.md         Audited summary (read first)
├── RESEARCH_JOURNAL.md    Forward-looking handoff
├── README.md              This file
├── LICENSE                MIT
├── notes/                 60+ mathematical research notes
├── scripts/               Python CAS verification (SymPy/numpy)
├── haskell/               Typed certificates and proof-tree audit
├── cpp/                   C++ accelerators (bitset scans, Fourier triple-check)
├── results/               Timestamped output transcripts
├── certificates/          Manifest of default certificate suite
├── prover/                Hasclid side-lemmas
└── raku/                  Raku certificate DSL
```

---

## Citing

This is a working research notebook; reuse and citation are welcome but not required.

```bibtex
@misc{erdos124notebook,
  title  = {{Erd\H{o}s} Problem 124: bounded-conductor conjecture and
            combinatorial framework (computational notebook)},
  year   = {2026},
  url    = {https://github.com/TACITVS/erdos-problem-124-bernoulli},
  note   = {Empirical Bounded Conductor Conjecture (note 66) and
            audited disproof of the multi-base Bernoulli convolution
            reduction (notes 63--65).}
}
```

---

## References

**Erdős Problem 124 itself:**

- S. A. Burr, P. Erdős, R. L. Graham, W.-C. Li. *Complete sequences of sets of integer powers*. Acta Arithmetica 77 (1996), 133–138. [[pdf]](https://www.math.ucsd.edu/~ronspubs/96_05_integer_powers.pdf)
- G. Melfi. *On certain positive integer sequences*. arXiv:[math/0404555](https://arxiv.org/abs/math/0404555).
- Erdős Problems site: [erdosproblems.com/124](https://www.erdosproblems.com/124).

**Bernoulli convolutions (the new connection):**

- P. Erdős. *On a family of symmetric Bernoulli convolutions*. Amer. J. Math. 61 (1939).
- B. Solomyak. *On the random series $\sum \pm \lambda^n$*. Ann. Math. 142 (1995).
- M. Hochman. *On self-similar sets with overlaps and inverse theorems for entropy*. Ann. Math. 180 (2014). [[link]](https://annals.math.princeton.edu/2014/180-2/p03)
- P. Shmerkin. *On the exceptional set for absolute continuity of Bernoulli convolutions*. GAFA 24 (2014). [[link]](https://link.springer.com/article/10.1007/s00039-014-0285-4)
- P. Varjú. *Absolute continuity of Bernoulli convolutions for algebraic parameters*. J. AMS 32 (2019). [[pdf]](https://www.ams.org/journals/jams/2019-32-02/S0894-0347-2019-00916-1/S0894-0347-2019-00916-1.pdf)

**ABC and related Diophantine input (alternative path):**

- Wikipedia, [*abc conjecture*](https://en.wikipedia.org/wiki/Abc_conjecture).
- C. L. Stewart, K. Yu. *On the abc conjecture II*. Duke Math. J. 108 (2001).
- M. Waldschmidt. *[Perfect Powers: Pillai's works and their developments](https://webusers.imj-prg.fr/~michel.waldschmidt/articles/pdf/PerfectPowers.pdf)*.

---

<div align="center">

**License: MIT** · See [`LICENSE`](LICENSE).
**Status:** open research notebook · last active 2026-05.

</div>
