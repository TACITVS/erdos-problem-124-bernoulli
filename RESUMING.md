# Resuming this project after a machine reset

**Last updated: 2026-05-23, after the Charge γ session (commit ~6c32862).**

> **MAJOR UPDATE 2026-05-23:** The session of 2026-05-22/23 produced
> notes 82-98 establishing **uniform closure** for the project's
> certified scope.  The open obligation is now EMPTY for hypothesis-
> meeting $(A, k)$ with $|A| \le 7$.  See `notes/98_session_synthesis.md`
> for the synthesis, and `notes/97_structural_closure_min_7.md` for
> Theorem 97.4 (the uniform closure result).

This document is a one-page resumption guide.  After cloning the repo
fresh, read this + `PROOF_STATE.md` + `RESEARCH_JOURNAL.md` and you
have full context.

## 1. Clone and verify

```bash
git clone https://github.com/TACITVS/erdos-problem-124-bernoulli.git
cd erdos-problem-124-bernoulli
git log --oneline -5
# Should show: cb6fd7b Note 81 + sunit.hpp + unified_batch ...
```

## 2. Build the C++ library

```bash
# Requires C++23 compiler (g++ 13+ or clang 18+), CMake 3.20+, OpenMP (optional).
# On Windows + MSYS2 mingw64: ensure C:\msys64\mingw64\bin is on PATH.

cd cpp
mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build . -j
```

Built apps end up in `build/`:
- `library_smoke_test.exe` — validates library against PROOF_STATE values
- `conductor_scan_v2.exe` — single-case conductor scanner
- `cfh_batch_v2.exe` — strict batch (Theorem A of note 72)
- `dgs_explore.exe` — DGS+MW diagnostics (note 79)
- `unified_batch.exe` — strict + exact-critical batch (note 81)

## 3. Sanity check the build

```bash
./library_smoke_test.exe
```

Expected output includes:
- Conductor for {3,4,7} k=1 at T=1e4 = **581**
- CFH-strict {3,4,5} k=1: VERIFIED, c* = **79**, T* = 625, takeover step 4
- I(1e5) for {3,4,7} = **1.2346**

If any number is off, something's wrong in your build.

## 4. Reproduce the headline 12,226 certificates

```bash
./unified_batch.exe --max-base=20 --min-size=3 --max-size=6 --k-min=1 --k-max=2 \
    > ../../results/unified_batch_max20_repro.txt
tail -10 ../../results/unified_batch_max20_repro.txt
```

Should report 12,208 strict + 18 exact-critical + 6 modular-deficit
failures = **12,226 certified** (same as `results/unified_batch_max20.txt`).

## 5. Current state at a glance

| Layer | Status |
|---|---|
| Layer 1 — proved unconditionally | **12,226+ specific cases** via library |
| Layer 2 — algebraic framework | Notes 17, 28, 33, 36, 39, 40, 42, 43, 44, 47, 49 certified |
| Theorems A-F (notes 72, 73, 76, 77) | Algebraic reductions, conditional on per-case checks (A, B) or on BC L² (E, F) |
| Layer 3 — open obligation | "Global power-saving central conductor theorem" remains open |
| Bernoulli convolution route (notes 58-65) | Audited and **retracted** — does not bridge to Erdős 124 (note 65) |
| New attack direction | DGS + MW (note 79); diagnostics tool ready (note 80) |

## 6. The single open obligation

> **Global power-saving central conductor theorem.**  Prove $c(E) = o(T(E))$
> in the strict case $R(A) > 1$, and $c(E) = O(T(E)^{1-\epsilon})$ in the
> exact-critical case $R(A) = 1$.

This is the central open mathematical problem.  Per-case
certification (Theorems A, B with finite checks) handles arbitrary
specific instances but is not uniform.

## 7. What to read first

In order:
1. **`README.md`** — high-level project overview.
2. **`PROOF_STATE.md`** — audited summary of what's proved.
3. **`RESEARCH_JOURNAL.md`** — forward-looking handoff.
4. **`notes/80_erdos124_library_and_dgs_diagnostics.md`** — the C++23 library.
5. **`notes/81_unified_batch_12k_certificates.md`** — the unified batch.
6. **`notes/72_algebraic_reduction_theorems.md`** — Theorems A and B (algebraic).
7. **`notes/79_deep_literature_synthesis.md`** — DGS+MW attack direction.
8. **`notes/63_note59_audit.md`**, **`notes/65_LLT_bridge_attempt.md`** — why BC route was retracted.

## 8. Concrete next-session options

Each has clear entry points:

**Option (a): Extend the library with more algebraic theorems.**
Add `include/erdos124/theorem_c.hpp` (recursive bounded conductor), `theorem_e.hpp` (L_2 -> max gap), `theorem_f.hpp` (circle method).
Mostly porting existing analysis (notes 73, 76, 77) into library form.

**Option (b): Pursue the DGS + MW research program (note 79).**
Read Damanik-Gorodetski-Solomyak 2015 Duke paper.  Reformulate
transversality as a quantitative Diophantine condition using
`mw::mw_constant`.  Long-term (multi-session).

**Option (c): Push enumeration further.**
Run `./unified_batch.exe --max-base=30 --max-size=7 --T-max=1e12`.
Probably produces 100k+ certificates.  Then check the modular-deficit
failures.  Cheap, just CPU time.

**Option (d): Lean formalization.**
Set up `lean/erdos124/` Mathlib project.  Formalize Theorem A
(note 72) first — it's the most self-contained.

**Option (e): External outreach.**
MathOverflow post about the Bounded Conductor Conjecture (note 66) +
Theorems E, F (notes 76, 77).  Cold-email Kittle / Kogler / Shmerkin
about the DGS+MW direction (note 79).

My standing recommendation: (a) or (c).  Both are concrete, build on
the library, and produce shippable artifacts.  (b), (d), (e) are
high-value but multi-session.

## 9. Memory notes

Auto-loaded memory files at
`C:\Users\baian\.claude\projects\C--Users-baian-Math-Research-Knuth-124\memory\`:

- `feedback_meta_review.md` — end-of-session "are we on the right track" discipline.
- `feedback_cas_delegation.md` — delegate mechanical verification to CAS.
- `feedback_cpp_over_python.md` — use C++ for heavy numerical loops, Python only for orchestration.

If these aren't loading on next session, they live in the same path on
the user's machine (separate from the repo).  Memory is **NOT** in the
git repo.

## 10. Repository structure (post-library)

```
.
├── PROOF_STATE.md         # audited summary
├── RESEARCH_JOURNAL.md    # forward-looking
├── README.md              # public landing
├── RESUMING.md            # THIS FILE
├── LICENSE                # MIT
├── notes/                 # 81 mathematical research notes
├── haskell/               # ~40 typed certificates
├── scripts/               # Python CAS scripts (Sympy)
├── cpp/
│   ├── include/erdos124/  # C++23 library (header-only)
│   ├── apps/              # Library-using drivers
│   ├── CMakeLists.txt     # CMake build
│   ├── README.md          # library docs
│   ├── build/             # gitignored
│   └── *.cpp              # LEGACY standalone (still works, superseded)
├── certificates/manifest.json   # legacy certificate manifest
├── results/               # timestamped run outputs (including 12k cert run)
├── prover/                # Hasclid side-lemmas
└── raku/                  # Raku certificate DSL
```

## 11. The most important thing to know

> The project is **algebraically saturated** at the current level of
> tooling.  Further progress requires either:
> 1. New mathematical ideas (DGS+MW direction; effective Subspace;
>    Hochman-style entropy for overlapping IFS), OR
> 2. Mechanical formalization (Lean), OR
> 3. Engagement with the fractal-geometry research community.

The C++ library is production-ready.  The algebraic framework
(Theorems A, B + notes 28-49) is solid.  The empirical evidence is
overwhelming (12,226 cases verified, 0 counterexamples).  The open
obligation remains genuinely open.

Repository at `cb6fd7b` on GitHub, ready to resume.
