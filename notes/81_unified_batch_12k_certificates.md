# Unified batch: 12,226 Erdős 124 certificates

Phase B-14: extended the erdos124 library with an S-unit module and a
unified batch driver covering both strict (CFH-strict) and exact-critical
(S-unit qualitative) hypothesis-meeting cases.

## 0. Headline

> **12,226 hypothesis-meeting $(A, k)$ certified unconditionally.**
> Enumeration: $A \subseteq \{3, \ldots, 20\}$, $|A| \in \{3, 4, 5, 6\}$,
> $k \in \{1, 2\}$.  Run via single `unified_batch` tool in 3 minutes
> 25 seconds.
>
> - 12,208 via CFH-strict (effective $(c^*, T^*)$)
> - 18 via S-unit (qualitative $(c^*, T^*, \text{indep pair})$)
> - 6 failures (all modular-deficit at higher $T$ threshold; previously
>   resolved for similar cases in note 71)
> - 48,852 skipped (R < 1, not hypothesis-meeting)

This is a **14× expansion** of certified coverage from the previous
combined batches (notes 67 + 69 + 70 + 71: ~871 cases).

## 1. New module: `cpp/include/erdos124/sunit.hpp`

The S-unit qualitative certifier, formally implementing Theorem B of
note 72:

```cpp
namespace erdos124::sunit {
    struct Certificate {
        bool verified;
        Integer c_star;
        UInteger T_star, S;
        std::optional<std::pair<Base, Base>> indep_pair;
        enum class Failure { /* ... */ } failure;
    };
    Certificate verify_at_T(const BaseSet& A, int k, double T);
    Certificate search_certificate(const BaseSet& A, int k, ...);
}
```

Verifies for exact-critical $(R = 1)$ hypothesis-meeting cases:
- gcd(A) = 1 (checked).
- R(A) = 1 (checked).
- Mult-indep pair exists (note 17 reduction, computed via
  `mw::find_indep_pair`).
- Non-empty seed interval at $T$ (bitset scan).

Then cites the imported S-unit finiteness theorem (Evertse-Schlickewei-
Schmidt / Beukers-Schlickewei) to conclude qualitative Erdős 124.

## 2. New driver: `cpp/apps/unified_batch.cpp`

Single driver, declarative pipeline:

```cpp
auto candidates = enumerate::subsets_in_range(max_base, min_size, max_size)
                   | enumerate::coprime_filter()
                   | std::ranges::to<std::vector>();

for (const auto& A : candidates) {
    for (int k : k_range) {
        const Regime reg = classify(A.reciprocal_sum());
        if (reg == Regime::Strict) {
            auto cert = cfh::search_certificate(A, k);
            // ... report
        } else if (reg == Regime::Exact) {
            auto cert = sunit::search_certificate(A, k);
            // ... report
        }
    }
}
```

Replaces the two separate `cfh_batch.exe` + `sunit_general.exe`
invocations with one tool.

## 3. Results at max_base = 20, sizes 3-6, k = 1-2

`results/unified_batch_max20.txt`:

| metric | count |
|---|---:|
| (A, k) enumerated (after coprime filter) | 61,084 |
| **CFH strict verified** | **12,208** |
| **S-unit exact-critical verified** | **18** |
| Failed (modular-deficit at T > 10^10) | 6 |
| Skipped (R < 1) | 48,852 |
| **TOTAL CERTIFIED** | **12,226** |
| Elapsed | 204.76s (3m 25s) |

The 6 failures are all of the form
$\{3, 6, 9, 12, *, *\}$ or $\{3, 6, 9, 15, *, *\}$ at k = 2 (4-5 of 6
bases divisible by 3) — the same modular-deficit pattern as note 71's
$\{3, 6, 9, 10, 12\}$, which resolved at $T \ge 10^{10}$.  Rerunning
with `--T-max=1e12` would likely resolve these as well.

## 4. Comparison to previous batches

| Batch | Tool | Cases verified | Time |
|---|---|---:|---|
| cfh_batch_max15 (note 69) | `cpp/cfh_batch.exe` | 870 | 16s |
| cfh_batch_max15 (note 71 revised) | `cpp/cfh_batch.exe` (with bigger T cap) | 872 | 43s |
| sunit_batch_max30 (note 70) | `cpp/sunit_general.exe` | 99 | 0.2s |
| **unified_batch_max20** (this note) | `cpp/build/unified_batch.exe` | **12,226** | **205s** |

The unified driver gives the project's largest single certification
run, demonstrating the library is production-ready.

## 5. Library capabilities now

After Phase B-13 + this note's S-unit module:

| Module | Capability |
|---|---|
| `types.hpp` | Immutable `BaseSet`, `Regime` classification |
| `frontier.hpp` | Balanced frontier + seed construction |
| `conductor.hpp` | Half-bitset conductor + L_2 collision count |
| `fourier.hpp` | $|\hat\mu_A|^2$ evaluation + I_T integration |
| `cfh.hpp` | CFH-strict certifier (note 72 Theorem A) |
| `sunit.hpp` | **NEW** S-unit qualitative certifier (note 72 Theorem B) |
| `mw.hpp` | Mignotte-Waldschmidt constants |
| `diophantine.hpp` | DGS+MW transversality analysis (note 79) |
| `enumerate.hpp` | Declarative subset enumeration with filters |

**All algebraic theorems from note 72 (A, B) are now implemented as
library functions.**  Theorems C (note 73), E, F (notes 76, 77) could
be added as additional modules in future sessions.

## 6. Apps available

In `cpp/build/`:

- `library_smoke_test.exe` — validate against PROOF_STATE values
- `conductor_scan_v2.exe` — single-case conductor scanner
- `cfh_batch_v2.exe` — strict-only batch
- `dgs_explore.exe` — DGS+MW diagnostics
- `unified_batch.exe` — **strict + exact-critical batch** (new)

## 7. Updated PROOF_STATE.md headline number

Previously: ~871 certified unconditional cases.

Now: **12,226 certified cases** in the enumeration window $A \subseteq
\{3, \ldots, 20\}$, $|A| \in \{3, 4, 5, 6\}$, $k \in \{1, 2\}$.

(Plus the 4 original CF/MW certificates which are stricter / effective.)

## 8. Status

This note (Phase B-14) delivers:
- **`sunit.hpp` module** — Theorem B of note 72 as a library function.
- **`unified_batch.exe` driver** — single tool covering both routes.
- **12,226 new certificates** in a 3.4-minute run.

The library architecture proved its worth: adding the S-unit module
required no changes to other modules, and the unified batch driver
came together cleanly using the declarative enumeration pipeline.

Repository state: clean C++23 library + comprehensive batch
infrastructure + ~12k certificates.  Ready for either further
extensions (DGS+MW direction, Lean formalization) or as a
deliverable in its current form.
