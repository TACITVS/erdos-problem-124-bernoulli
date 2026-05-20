<div align="center">

# Erdős Problem 124

### Computational research notebook & the multi-base Bernoulli convolution path

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Status: open research](https://img.shields.io/badge/Status-open%20research-blue.svg)](PROOF_STATE.md)
[![Certificates](https://img.shields.io/badge/Certificates-26%2F26%20passing-brightgreen.svg)](certificates/manifest.json)
[![Sessions](https://img.shields.io/badge/Sessions-25%2B-informational.svg)](RESEARCH_JOURNAL.md)

</div>

---

## Headline

After ~25 sessions of computational exploration, this project identifies a **new conditional reduction** of Erdős Problem 124 to a single conjecture in fractal geometry:

> **Multi-base Bernoulli AC Conjecture.** &nbsp; For finite $A \subseteq \mathbb{Z}_{\ge 3}$ with $\gcd(A) = 1$ and $\sum_{a \in A} \tfrac{1}{a-1} \ge 1$, the multi-base Bernoulli convolution
> $$\mu_A \;=\; \underset{a \in A}{*}\, B_{1/a}$$
> is absolutely continuous on $\mathbb{R}$.

A rigorous chain (Note 59 Theorem 7) shows that **this conjecture implies Erdős 124**. The empirical evidence from a C++ triple-check at $T = 10^7$ is strikingly supportive — see [the result table](#triple-checked-empirical-evidence).

📚 **For the audited state:** [`PROOF_STATE.md`](PROOF_STATE.md) — what is proved, imported, conjectural, open.
🧭 **For the next sessions:** [`RESEARCH_JOURNAL.md`](RESEARCH_JOURNAL.md) — forward-looking handoff.

---

## Table of contents

1. [The problem](#the-problem)
2. [What this project actually proves](#what-this-project-actually-proves)
3. [The new conditional reduction](#the-new-conditional-reduction)
4. [Triple-checked empirical evidence](#triple-checked-empirical-evidence)
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

## The new conditional reduction

After eleven timeboxed disparate-area attempts (notes 50–57), the project identified a single conjecture in fractal geometry that, if true, closes Erdős 124.

### The reduction chain (Note 59, Theorem 7)

For each base $a \in A$, define the single-base Bernoulli measure

$$B_{1/a} \;=\; \mathrm{Law}\!\left(\sum_{n=0}^{\infty} \zeta_n\, a^{-n-1}\right),\qquad \zeta_n \stackrel{\text{iid}}{\sim} \operatorname{Unif}\{0, 1\}.$$

By Erdős (1939), since every integer $a \ge 2$ is Pisot, **each $B_{1/a}$ is singular** (Cantor-like, dimension $1/\log_2 a$).

The multi-base convolution $\mu_A = *_{a \in A} B_{1/a}$ may nevertheless be **absolutely continuous** — and the empirics say it is, exactly when Erdős's hypothesis holds.

```
   Multi-base Bernoulli AC Conjecture (open)
     ⟹ μ_A has L¹ density
     ⟹ (Note 59 §3-§4) Fourier convergence ĥX_T(ξ/T) → ĥμ_A(ξ),
        weak-* convergence, support density ρ_T → 1
     ⟹ (Note 59 §5) conductor c(T) = o(T)
     ⟹ (Note 59 §6) Erdős 124 for hypothesis-meeting A
```

### Necessary condition is automatic

By Marstrand–Mattila ([Note 60 §2](notes/60_bernoulli_AC_deep_dive.md)),

$$\dim_H(\mu_A) \;=\; \min\!\Bigl(1,\; \sum_{a \in A} \tfrac{1}{\log_2 a}\Bigr).$$

The elementary inequality $\log_2 a < a - 1$ for $a \ge 3$ gives $\sum \tfrac{1}{\log_2 a} > R(A) \ge 1$ **strictly** under the Erdős hypothesis, so $\dim_H(\mu_A) = 1$.

The remaining gap — dimension 1 versus absolute continuity — is exactly the gap that recent breakthroughs by [Hochman](https://annals.math.princeton.edu/2014/180-2/p03), [Shmerkin](https://link.springer.com/article/10.1007/s00039-014-0285-4), and [Varjú](https://www.ams.org/journals/jams/2019-32-02/S0894-0347-2019-00916-1/) attacked for single-base $B_\lambda$ with $\lambda \in (1/2, 1)$. Our setting (multi-base, integer-Pisot $\lambda = 1/a$ for $a \ge 3$) is **not yet covered** by any published theorem.

---

## Triple-checked empirical evidence

The L² conjecture (stronger than AC): $\hat\mu_A \in L^2(\mathbb{R})$, equivalently $\mu_A$ has L² density.

This is equivalent to saturation of

$$I(T) \;:=\; \int_{-T}^{T} \bigl|\hat\mu_A(\xi)\bigr|^2\, d\xi \quad\text{as }T \to \infty.$$

The C++ binary [`cpp/bernoulli_fourier.cpp`](cpp/bernoulli_fourier.cpp) computes $I(T)$ by **three independent methods** (trapezoidal, per-scale summation, Monte Carlo) with OpenMP parallelism.

### Hypothesis-meeting cases — saturating (L² signature)

| set | $R(A)$ | $I(10^4)$ | $I(10^5)$ | $I(10^6)$ | $I(10^7)$ | $\frac{I(10^7)}{I(10^6)}$ |
|-----|:---:|---:|---:|---:|---:|:---:|
| $\{3,4,5\}$         | $\tfrac{13}{12}$ | 1.1585 | 1.1628 | 1.1628 | **1.1628** | **1.0000** |
| $\{3,4,7\}$         | $1$ | 1.2325 | 1.2346 | 1.2348 | **1.2351** | 1.0002 |
| $\{3,4,9,25\}$      | $1$ | 1.2538 | 1.2599 | 1.2600 | **1.2601** | 1.0001 |
| $\{3,5,7,13\}$      | $1$ | 1.2341 | 1.2342 | 1.2342 | **1.2342** | **1.0000** |
| $\{3,6,9,12,21,45,89\}$ | $1$ | 1.2857 | 1.2857 | 1.2857 | **1.2857** | **1.0000** |

The seven-base modular-gate case is **frozen at 1.2857 across six orders of magnitude in $T$** (from $T = 10^2$ to $T = 10^7$).

### Single-base controls — growing linearly (Cantor singular)

| set | $I(10^4)$ | $I(10^5)$ | $I(10^6)$ | growth/decade |
|-----|---:|---:|---:|:---:|
| $\{3\}$ | 36.86 | 83.14 | 188.25 | **2.26×** |
| $\{4\}$ | 126.34 | 497.02 | 1470.68 | **2.99×** |
| $\{7\}$ | 531.80 | 2491.10 | 15605.06 | **4.50×** |

Three independent integration methods all agree on the **bounded vs unbounded** distinction. The L² saturation is robust.

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

### Build the exact-arithmetic fast scanner

```bash
g++ -O3 -std=c++20 -march=native cpp/erdos124_fast.cpp -o cpp/erdos124_fast.exe
cpp/erdos124_fast.exe --mode=conductor --bases=3,4,7 --k=1 --limit=100000
# Largest missing = 581
```

---

## Documentation map

### Read first

- [**`PROOF_STATE.md`**](PROOF_STATE.md) — audited summary: what is proved, imported, conjectural, open.
- [**`RESEARCH_JOURNAL.md`**](RESEARCH_JOURNAL.md) — forward-looking handoff for next sessions, AI models, collaborators.

### The Bernoulli convolution direction (the headline finding)

- [Note 58](notes/58_bernoulli_convolution_path.md) — proposes the conjecture and identifies the new community connection.
- [Note 59](notes/59_rigorous_equivalence.md) — rigorous chain: AC ⟹ Erdős 124.
- [Note 60](notes/60_bernoulli_AC_deep_dive.md) — deep dive: L² strengthening, per-scale reduction, attack lines.
- [Note 61](notes/61_cpp_triple_check.md) — C++ triple-check methodology and findings.

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
@misc{erdos124bernoulli,
  title  = {{Erd\H{o}s} Problem 124: a computational notebook and the
            multi-base {Bernoulli} convolution path},
  year   = {2026},
  url    = {https://github.com/TACITVS/erdos-problem-124-bernoulli},
  note   = {Conditional reduction to a fractal-geometry conjecture
            with computational evidence.}
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
