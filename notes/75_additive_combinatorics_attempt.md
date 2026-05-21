# Additive combinatorics attack on bounded conductor

Phase B-8: attempts to apply additive combinatorics tools
(Plünnecke-Ruzsa, Sárközy-Szemerédi, Folkman, semigroup/Frobenius,
Cauchy-Davenport-style sumset inequalities) to the open obligation.

## 0. Verdict

> **Additive combinatorics gives non-trivial cardinality bounds on
> the subset-sum set $P(F(E))$, but does NOT close the conductor
> question** — bounding $|P(F)|$ does not bound $\max\{n \le S/2 : n \notin P(F)\}$.
>
> The fundamental issue: every density-style argument gives "most
> integers in $[0, S/2]$ are representable", but the conductor is
> about the *single largest* missing integer, which is a worst-case
> quantity not controlled by density.

This is the project's 14th honest negative result.  Additive
combinatorics is the natural toolset for sumset density questions but
does not give pointwise representability.

## 1. Setup

For finite $A \subseteq \mathbb Z_{\ge 3}$ with $\gcd(A) = 1$ and
$R(A) \ge 1$, and balanced frontier $E$ at $T$:
- Seed $F = F(E) = \{a^j : a \in A, k \le j < e_a(T)\}$.
- $|F| = \sum_a (e_a - k) \approx \log T \cdot \sum_a 1/\log a - k|A|$.
- Sum $S = \sum_{f \in F} f \approx R(A) \cdot T$.
- Subset sum set $P(F) = \{\sum_{f \in F} \epsilon_f f : \epsilon \in \{0,1\}^F\}$.
- Conductor $c(F) = \max\{n \in [0, \lfloor S/2 \rfloor] : n \notin P(F)\}$.

The open obligation asks $c(F) = o(T)$.  The Bounded Conductor
Conjecture (note 66 v2) asks $c(F) = O(1)$.

## 2. Tool 1 — Sárközy-Szemerédi cardinality bound

**Theorem (Sárközy 1965).**  For a set $F$ of $n$ distinct positive
integers, $|P(F)| \ge \exp(c \, n^{1/2})$ for some absolute $c > 0$.

For our $F$ with $|F| \approx D \log T$ (where $D = \sum_a 1/\log a$),
this gives:
$$|P(F)| \ge \exp(c \, (D \log T)^{1/2}) = T^{c (D / \log T)^{1/2}}$$
... which is sub-polynomial in $T$.  **Too weak**: $|P(F)| / S \to 0$
under this bound, despite empirical density being high.

**Theorem (improved, Erdős-Sárközy-Szemerédi 1989).**  $|P(F)| \ge
\exp(c \, (\log |F|)^2 / \log \log |F|)$.  Even weaker.

**Theorem (trivial upper bound).**  $|P(F)| \le 2^{|F|} = T^{D \log 2}$.

For Marstrand-strict ($D > 1/\log 2 \approx 1.443$): $|P(F)| \le T^{D \log 2}$
where $D \log 2 > 1$.  So $|P(F)|$ can be at most polynomially large in $T$,
specifically $|P(F)| \in [T^{c/\sqrt{\log T}}, T^{D \log 2}]$ — a wide
range.

**Conclusion.** Cardinality bounds alone don't help.  $|P(F)|$ could
be anywhere in a broad range, and the actual conductor depends on the
fine structure.

## 3. Tool 2 — Plünnecke-Ruzsa for iterated sumsets

**Theorem (Plünnecke 1970).**  If $|F + F| \le K |F|$, then for any
$h, k \ge 0$, $|hF - kF| \le K^{h+k} |F|$.

For our $F$: doubling $K = |F+F|/|F|$ depends on additive structure.
For $F = \{a^j\}$ same-base: $|F+F| = |F|(|F|+1)/2 + |F|$ (essentially
all pairwise sums distinct due to base-$a$ digits).  $K \approx |F|/2$
— large doubling.

For multi-base $F$: $|F+F|$ can be smaller if different-base sums
coincide.  E.g., $3 + 4 = 7 = 4 + 3$ (trivial); $3 + 4 + 5 = 12 = 3 + 9$
(non-trivial coincidence at small scale).

In general, doubling $K$ for multi-base $F$ is some intermediate value.

Plünnecke bounds $|kF|$ for $k$-fold iterated sumsets.  For subset
sums (where each element used at most once), this doesn't directly
apply — we need element-wise binary choices, not iterated additions.

**Conclusion.**  Plünnecke-Ruzsa bounds iterated sumset sizes, not
subset-sum sizes.  No direct application to conductor.

## 4. Tool 3 — Folkman's theorem and complete sequences

**Theorem (Folkman 1969).**  For any partition of $\mathbb N$ into
finitely many classes, one class contains a Folkman set: a finite set
$F$ such that all subset sums of $F$ are in the same class.

For complete sequences (subset sums cover every integer above some
threshold), Folkman's theorem provides a structural framework but
doesn't bound the threshold (= conductor analog).

**Theorem (Erdős-Folkman).**  $F = \{f_1 < f_2 < \cdots\}$ is a
*complete sequence* (every sufficiently large integer is a subset
sum) iff $f_{n+1} \le 1 + \sum_{i \le n} f_i$ for all $n$
sufficiently large.

For our sorted multi-base $F$ (note 73 §5.4 analysis): the asymptotic
ratio $f_{n+1}/f_n = \exp(1/D)$ for $D = \sum 1/\log a$.  For
Marstrand-strict ($D > 1/\log 2$): ratio $< 2$.

Asymptotically the Folkman/Brown criterion HOLDS.  But Brown's
criterion requires a pre-existing represented interval to extend; for
our multi-base $F$ from scratch, the criterion fails at small $n$
(b_1 = $\min A^k \ge 3$ already violates $b_1 \le 1 + 0 = 1$).

**The technical gap.** Empirically, multi-base seeds DO produce a
"central interval" of representable integers (computed via bitscan).
Brown's then extends it.  But the EXISTENCE of the initial central
interval is exactly the open obligation — Folkman gives no help there.

**Conclusion.** Folkman / Brown / Erdős-Folkman complete-sequence
theory gives the right asymptotic intuition (sub-2 ratio implies
absorbable tail) but doesn't produce the initial interval.

## 5. Tool 4 — Semigroup / Frobenius bounds

**Theorem (Sylvester-Frobenius).**  For coprime positive integers
$q_1, q_2$, every integer $\ge q_1 q_2 - q_1 - q_2 + 1$ is a non-negative
integer combination of $q_1, q_2$.

For more generators: explicit Frobenius numbers $F(q_1, \ldots, q_r)$
are bounded by $\max q_i (q_i - 1)$.

For **same-base subset sums** (note 44): explicit Frobenius reduction.
For **multi-base subset sums**: no such clean theorem.

The fundamental difference: numerical semigroups allow repeated use
of generators; subset sums don't.  Frobenius bounds the former, not
the latter.

**Conclusion.** Same-base case is closed by note 44.  Multi-base case
doesn't admit Frobenius-style closure — this is the open problem.

## 6. Tool 5 — Cauchy-Davenport / Vosper / Freiman

**Theorem (Cauchy-Davenport).**  In $\mathbb Z / p\mathbb Z$,
$|A + B| \ge \min(p, |A| + |B| - 1)$.

For sumset sizes in $\mathbb Z$: similar bounds via Plünnecke or
Freiman-Ruzsa.

For our setup: $P(F)$ inside $\mathbb Z / m\mathbb Z$ for various $m$
gives information about residues.  Per note 71 §4 analysis, the
residues mod $m$ ARE eventually covered for large enough seed.

But mod-$m$ coverage doesn't bound pointwise gaps in $\mathbb Z$.

**Conclusion.**  Modular sumset theorems give residue coverage,
already empirically observed.  No direct conductor bound.

## 7. Tool 6 — Sárközy-Solymosi on APs in sumsets

**Theorem (Sárközy, Solymosi, et al.).**  Sumsets $A + B$ contain
long arithmetic progressions if $A, B$ are sufficiently dense.

For our $P(F)$: density depends on $T$.  Asymptotically dense
($|P(F)| / S \to ?$ depending on whether Marstrand condition implies
density 1).

Empirically density is close to 1, so $P(F)$ contains long APs.  But
existence of long APs doesn't bound the LARGEST gap.

**Conclusion.**  AP-structure theorems give qualitative density
results, no quantitative gap bound.

## 8. The fundamental obstacle (again)

All additive combinatorics tools considered give **density-type
results**: $|P(F)|$ is large, $P(F)$ contains APs, $P(F)$ covers
residues mod $m$, etc.

The conductor is a **worst-case gap** — the maximum of a quantity
that density bounds don't control.

For a set of density $1 - \delta$ in $[0, S]$, the max gap could be
anywhere from $1$ to $\delta S$.  Density doesn't pin it down.

For our integer subset sum problem, the gap structure depends on
fine-grained additive structure (which base contributes which
"digits"), and standard tools don't access this.

## 9. Where this leaves the open obligation

After this analysis + notes 63-65 (Bernoulli convolution bridge), 74
(SSS adaptation):

| Tool | What it gives | Gap to Erdős 124 |
|---|---|---|
| Continuous Fourier / SSS / Kittle-Kogler | AC of $\mu_A$ (best case) | AC ≠ Hölder, blocks LLT |
| Sárközy-Szemerédi | $|P(F)| \gtrsim \exp(c \sqrt{|F|})$ | Sub-poly bound, doesn't reach pointwise |
| Plünnecke-Ruzsa | Iterated sumset sizes | Wrong shape (no subset sum) |
| Folkman/Brown | Asymptotic absorption if ratio < 2 | Needs initial interval (= conductor bound itself) |
| Frobenius (same-base) | Note 44 closed | Multi-base open |
| Cauchy-Davenport | Modular density | No pointwise gap |
| Sárközy-Solymosi APs | Long APs in $P(F)$ | Existence ≠ max gap |

**Every existing tool either gives density information (not pointwise)
or fails in the multi-base regime.**  The conductor question is
fundamentally **combinatorial** in a way that current additive-combinatorics
toolbox doesn't handle.

## 10. What might genuinely advance

After ruling out:
- Fractal-geometric AC frameworks (notes 63-65, 74).
- Standard additive combinatorics density tools (this note).

What remains:

1. **Modular obstruction quantification.**  For specific $(A, k)$
   with deficit at prime $p$ (note 40 deficit regime), the modular
   structure forces gaps at specific residues.  Quantifying this
   gives an UPPER bound on the conductor in terms of the modular
   structure — possibly the right algebraic theorem.
2. **Effective Erdős-Turán for discrete Bernoulli sums.**  An
   integer-discrete Erdős-Turán inequality bounding the worst-case
   pointwise gap by a Fourier-like average.  Hard but not as
   blocked as the continuous version.
3. **Hochman-style entropy increase for the multi-base subset sum.**
   Hochman 2014's entropy method gives dimension increases under
   non-resonance.  Adapted to discrete subset sums: would give
   density growth and possibly pointwise representability.
4. **Direct verification at very large $T$.**  Push the bitscan to
   $T = 10^{15}$ or beyond, verify the Bounded Conductor Conjecture
   on more cases.  Doesn't close, but increases empirical confidence.

Direction (2) — effective integer-discrete Erdős-Turán — is the most
specifically relevant to the conductor question and the most
underexplored.  It would be the natural next attack if pursued.

## 11. Status

This note (Phase B-8) is the **14th** documented negative result.
After exhausting fractal-geometric (note 74) and standard additive-
combinatorics (this note) attacks, the open obligation remains.

The honest summary: Erdős 124's hard form requires **new combinatorial
ideas** — neither current fractal-geometric machinery nor standard
additive combinatorics provides the pointwise representability bound
that the conductor question demands.

The empirical evidence (971 cases via Theorems A and B) remains the
project's strongest support for the conjecture; a uniform algebraic
proof would require techniques beyond the standard toolboxes
explored here.

This is the project's algebraic frontier as of 2026-05.
