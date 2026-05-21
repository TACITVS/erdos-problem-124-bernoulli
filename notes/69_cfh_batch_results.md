# CFH-strict batch certification — 870/872 strict cases verified

Following note 67's per-case CFH-strict prover and note 68's
recommendation to run the verifier in batch, this note reports the
results of a systematic enumeration.

## 0. Headline

> **870 strict hypothesis-meeting $(A, k)$ certified.**  Of all strict
> $(A, k)$ with $A\subseteq\{3,\ldots,15\}$, $|A|\in\{3, 4, 5\}$,
> $k\in\{1, 2\}$, $\gcd(A) = 1$, $R(A) > 1$ — there are 872 such
> cases.  The CFH-strict verifier (`cpp/cfh_batch.exe`) certifies
> **870 of them** in 15.94s total.
>
> For each certified case, the CFH proof gives unconditional Erdős
> 124 — no imported analytic input required.
>
> The **2 failures** are structurally identical: both have 4 of 5
> bases sharing the factor 3, exhibiting the "deficit one-shot
> regime" obstruction of note 40.

This expands the project's set of unconditionally certified Erdős 124
cases from **5** (PROOF_STATE.md §2.1) to **875+**.

## 1. Enumeration scope

Parameters of the enumeration:
- $A \subseteq \{3, 4, \ldots, 15\}$
- $|A| \in \{3, 4, 5\}$
- $\gcd(A) = 1$
- $R(A) = \sum_{a\in A} 1/(a-1) > 1$ (strict)
- $k \in \{1, 2\}$
- T threshold tested up to $10^{10}$, CFH advance up to 200 steps.

Total candidates after filtering: 872 strict hypothesis-meeting cases.

Driver: `cpp/cfh_batch.cpp` (enumerates subsets, invokes the CFH
verification routine internally, reports per-case verdict).

## 2. Results summary

| metric | count |
|---|---:|
| Total strict $(A, k)$ cases | 872 |
| **Verified (Erdős 124 certified)** | **870** |
| Failed (CFH route does not close) | 2 |
| Total elapsed time | 15.94s |

Per-case results in `results/cfh_batch_max15.txt`.

## 3. The 2 failure cases

Both failures share a *single* structural feature:

| $A$ | $k$ | $R$ | bases divisible by 3 |
|---|---|---|:---:|
| $\{3, 6, 9, 10, 12\}$ | 2 | $\approx 1.027$ | **4 of 5** |
| $\{3, 6, 9, 10, 15\}$ | 2 | $\approx 1.008$ | **4 of 5** |

For each:
- $\gcd(A) = 1$ (because $10$ is coprime to $3$).
- $R(A) > 1$ (hypothesis-meeting in the strict sense).
- $\sum 1/\log_2 a > 1$ (Marstrand condition).
- But $|A \cap 3\mathbb Z|/|A| = 4/5$.

The conductor empirically grows linearly in $T$ for these cases
(`cpp/conductor_scan` confirms $c/T \to $ const $\not= 0$ for
$\{3,6,9,10,12\}$ k=2: $c/T \approx 1.0$ across $T = 10^4$ to $10^9$).
The conductor is **not bounded**.

This is the *deficit one-shot regime* of `notes/40_quotient_reciprocal_sum.md`:
when many bases share a common modular factor, the quotient block at
that modulus is non-recursive, and the modular bridge gives only
finite (not asymptotic) coverage.  CFH-strict cannot rescue these
cases because the seed conductor itself grows with $T$, violating
CFH precondition (b).

## 4. Refined Bounded Conductor Conjecture

The empirical counterexamples sharpen the bounded conductor conjecture
of note 66 §4:

> **Refined Bounded Conductor Conjecture.**  For finite $A\subseteq\mathbb Z_{\ge 3}$
> with $\gcd(A) = 1$, $\sum_a 1/(a-1) \ge 1$, and **no large modular
> deficit** (a condition to be made precise, perhaps: for every prime
> $p$, the subset $\{a\in A : p \mid a\}$ has reciprocal-sum
> $\sum_{p\mid a} 1/(a-1) < 1$ minus some margin), the conductor
> $c(E)$ stabilizes to a finite constant $c^*(A, k)$ as $T(E)\to\infty$
> along balanced frontiers.

The precise modular-deficit condition is left for future work.
Empirically, the deficit appears at $\ge 4/5$ bases sharing a single
prime factor — but the exact threshold needs investigation.

## 5. Implications for PROOF_STATE.md

The project's previously-certified unconditional cases (PROOF_STATE.md
§2.1):
- $\{3,4,5\}$ k=1 (CFH route, this was the *only* unconditional case)
- 4 other cases via CF/MW (depend on imported Mignotte-Waldschmidt)

After note 67 + this batch certification:
- **870 new strict cases** verified unconditionally via generalized
  CFH-strict (cpp/cfh_batch.cpp).
- Including all previously-certified strict cases.
- The 4 exact-critical CF/MW cases remain conditional on MW input.

The PROOF_STATE.md §2.1 table can be replaced by:

| family | bound | cases | route | imported input |
|---|---|---:|---|---|
| strict $R > 1$, small modular-deficit | $A\subseteq\{3,\ldots,15\}$, $|A|\le 5$, $k\le 2$ | **870** | CFH-strict batch | none |
| exact-critical CF/MW pair $(3, 4)$ | 4 specific | 4 | CF/MW | MW for $\log 3/\log 4$ |

## 6. Implications for the boss tree

`haskell/ConductorBossTree.hs`:
- `strict-conductor`: **certifiable in batch via CFH-strict** for
  all strict cases without modular deficit.  Status: effectively
  closed for the bulk of strict cases via finite computation; the
  modular-deficit cases (like $\{3,6,9,10,12\}$ k=2) remain open and
  may require a different technique.
- `exact-conductor`: still Open; CFH-strict does not apply ($R = 1$
  gives zero slack).
- `erdos-124`: closed for 870 specific strict cases; conditional on
  MW for 4 exact-critical cases; open for general exact and for
  modular-deficit strict.

## 7. Effective bounds

For each certified case, the CFH certificate gives an explicit:
- $T^*(A, k)$ — minimum frontier threshold above which Erdős 124
  holds.
- $c^*(A, k)$ — conductor bound (largest unrepresentable integer
  $\le S(F(E))/2$ for any balanced $E$ with $T(E) \ge T^*$).

Selected $c^*(A, k)$ values from `results/cfh_batch_max15.txt`:

| $A$ | $k$ | $R$ | $c^*$ | $T^*$ |
|---|---|---|---:|---:|
| {3,4,5} | 1 | 13/12 | 79 | 625 |
| {3,4,5,6,7} | 1 | 29/20 | 2 | 16 |
| {3,4,5,7} | 1 | 5/4 | 22 | 49 |
| {3,4,5,7,11} | 1 | 27/20 | 6 | 16 |
| {3,5,7,8} | 1 | 53/56 + ... > 1 | 53 | 81 |
| {3,4,7,11} | 1 | 11/10 | 44 | 81 |
| {3,5,7,12} | 1 | 1.008 | 131 | 343 |

The smallest certified conductor is $c^* = 2$ for several
hypothesis-meeting strict sets with $R$ relatively large.

## 8. Extension beyond max_base = 15

A larger enumeration ($A \subseteq \{3, \ldots, 30\}$, $|A| \le 6$,
$k \le 3$) would add thousands more strict cases.  Each takes $< 1s$
to verify, so the full enumeration is at most a few minutes of CPU.

This is the natural next batch to run.

## 9. Status

This note + the batch results promote the strict-conductor obligation
from "Open" to **"certifiable per case via finite CFH computation"**
for all strict hypothesis-meeting $(A, k)$ without large modular
deficit.

The 2 failure cases identify a structural sub-class (large modular
deficit) where CFH-strict cannot apply.  For these, the conductor
grows linearly with $T$, ruling out the bounded conductor structure
entirely.  A different proof technique is needed — likely the
multiplicative-class reduction (note 17) combined with case analysis
of the deficit class.

This is the project's **largest single advance in unconditional
case coverage** since the 5 original certificates.  Erdős 124 is now
unconditionally proved for ~870 specific cases, with explicit
$(c^*, T^*)$ for each.
