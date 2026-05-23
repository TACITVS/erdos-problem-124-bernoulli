# Theorem B' — effective MW replacement of qualitative S-unit

Phase B-15: convert Theorem B (note 72, qualitative S-unit input) into
**Theorem B'**, which uses the effective Mignotte–Waldschmidt /
Laurent–Mignotte–Nesterenko lower bound as its only imported analytic
ingredient.  The proof is otherwise identical in structure.

The point is not a bigger certificate batch.  It is an **algebraic
improvement** to Theorem B: the conclusion strengthens from
"qualitative existence of $N_0$" to "effective $N_0$ with explicit
threshold", and the imported obligation list shrinks from
{qualitative S-unit, Subspace Theorem power-saving gap} to
{Mignotte–Waldschmidt (LMN 1995 / Laurent 2008)} — a single named
published theorem.

The four CF/MW certificates of notes 07, 09, 10, 11, 46 are then
recognised as four explicit verifications of Theorem B''s additional
hypothesis (H4') on specific $(A, k)$, not as standalone proofs.

## 0. Headline

> **Theorem B'.**  Let $A \subseteq \mathbb Z_{\ge 3}$ be finite with
> $\gcd(A) = 1$, $R(A) = 1$ (exact-critical), $|A| \ge 2$, and let
> $k \ge 1$.  Suppose there exists $T^* > 1$ such that, writing
> $F^* = F(T^*)$, $S^* = S(T^*)$, $c^* = c(T^*)$:
>
> - **(H1')** $2 c^* + 2 \le S^*$ (central interval non-empty);
> - **(H4')** for some multiplicatively-independent pair
>   $(x, y) \in A^2$ (existing by note 17), the CF/MW three-step check
>   at the pair-specific threshold
>   $B^* := (D\,\kappa(A, k) + 2 D\, c^* + D)(1/w_x + 1/w_y)$ holds
>   (§2 below).
>
> Then every integer $N \ge c^* + 1$ is a subset sum of
> $\{a^e : a \in A,\ e \ge k\}$.  The conclusion is **effective**:
> the threshold above which all integers are represented is
> $N_0 = c^* + 1$, and the frontier $E$ achieving the representation
> for any specific $N$ is bounded by an explicit function of
> $N, B^*, x, y$.

This replaces Theorem B's (note 72) appeal to the qualitative S-unit
finiteness theorem (Evertse–Schlickewei–Schmidt 2002;
Beukers–Schlickewei 1996) and to the Subspace-Theorem power-saving
gap (the project's third imported obligation in
`haskell/GlobalProofAudit.hs`) by a single named effective
Diophantine bound:

> **Imported (Mignotte–Waldschmidt; LMN 1995 / Laurent 2008).**  For
> multiplicatively-independent integers $x, y \ge 2$ and positive
> integers $p, q$ with $\max(p, q) \ge 2$,
> $$\log|x^p - y^q| \;\ge\; \max(p \log x,\ q \log y)
>   \;-\; C \cdot \log\max(x, y) \cdot (8 + \log \max(p, q))^2,$$
> with $C$ an explicit absolute constant ($C \le 500$ by LMN 1995;
> sharper constants by Laurent 2008).

Equivalently, $|x^p - y^q| \le B$ forces $\max(p, q) \le M_{\mathrm{MW}}(B, x, y, C)$
for an explicit computable $M_{\mathrm{MW}}$.

## 1. Notation and setup

We use the conventions of note 28 (the *tail invariant* in conductor
form):

- $A = \{d_1, \ldots, d_r\} \subseteq \mathbb Z_{\ge 3}$ with
  $\gcd(A) = 1$ and $R(A) := \sum_i 1/(d_i - 1) = 1$ (the exact-critical
  hypothesis).
- $k \ge 1$ fixed.
- For $T > 1$, the balanced frontier $E(T) = (E_i(T))_{i=1}^r$ has
  $E_i(T) = d_i^{e_i(T)}$ with $e_i(T) = \lceil \log_{d_i} T \rceil$,
  so $T \le E_i(T) < d_i T$.
- The seed $F(T) := \{d_i^j : 1 \le i \le r,\ k \le j < e_i(T)\}$,
  sum $S(T)$, conductor $c(T)$, central interval $[c(T)+1, S(T)-c(T)-1]$
  (non-empty iff (H1') holds).
- Tail invariant (note 28):
  $K(E) := \kappa(A, k) + 2 c(E) + 1$
  where $\kappa(A, k) := \sum_i d_i^k / (d_i - 1)$.
- Set $D := \mathrm{lcm}_i (d_i - 1)$ and $w_i := D/(d_i - 1)$ (note 27).
- The **cleared-denominator scalar** at a frontier $E$ is
  $$DK(E) \;=\; D\,\kappa(A, k) + 2 D\, c(E) + D,$$
  a linear function of $c(E)$ with coefficients depending only on
  $(A, k)$.
- For a pair $(i, j)$, the **pair-specific near-collision threshold**
  is $B_{ij}(E) := DK(E) \cdot (1/w_i + 1/w_j)$.  By note 27
  §Consequence (algebraically certified in `haskell/CFTail.hs`'s
  NearCollisionLemma), any frontier failure forces, for some pair
  $(i, j)$,
  $$\bigl|E_i - E_j\bigr| \;\le\; B_{ij}(E).$$
- We set $B^* := B_{xy}(E^*) = (D\,\kappa + 2 D\, c^* + D)(1/w_x + 1/w_y)$
  — the pair-$(x, y)$ near-collision threshold at the initial seed,
  an explicit (positive integer or rational) number in $A, k, c^*, x, y$.

The pair $(x, y)$ in (H4') is any multiplicatively-independent pair
from $A^2$, which exists by note 17 (multiplicative-class reduction)
under $\gcd(A) = 1, |A| \ge 2$.

## 2. The CF/MW three-step check (hypothesis (H4'))

(H4') is a **finite arithmetic check** on the pair $(x, y)$ at the
fixed threshold $B^* = B_{xy}(E^*) = (D\kappa + 2Dc^* + D)(1/w_x + 1/w_y)$.
It has three parts plus a seed-size condition.

### 2.1 Legendre threshold $M_L$ and the enlarged-seed condition

By Legendre's theorem on best rational approximation:

> *If $|\alpha - q/p| < 1/(2 p^2)$ for positive integers $p, q$ and an
> irrational real $\alpha$, then $q/p$ is a convergent of the continued
> fraction of $\alpha$.*

Apply with $\alpha = \log x / \log y$.  A near-collision
$|x^p - y^q| \le B^*$ implies, by the elementary inequality
$|u - v| \ge \min(u, v) \cdot |{\log u - \log v}|$ for positive $u, v$:
$$|p \log x - q \log y| \;\le\; B^* / \min(x^p, y^q).$$
Without loss of generality $x \le y$; near a collision $x^p \approx y^q$
so $\min(x^p, y^q) \ge x^p (1 - o(1))$, and conservatively
$\min \ge x^p / 2$.  Dividing by $\log y$:
$$\bigl| (\log x/\log y) - q/p \bigr| \;\le\; 2 B^* / (p \, x^p \log y).$$
The Legendre hypothesis $2 B^* / (p \, x^p \log y) < 1/(2 p^2)$,
equivalently $4 p B^* < x^p \log y$, holds once
$$p \;\ge\; M_L,
\quad \text{where } M_L = M_L(B^*, x, y)
\text{ is the smallest integer with } 4 M_L B^* < x^{M_L} \log y.$$
For $p \ge M_L$, every near-collision forces $q/p$ to be a convergent
of the continued fraction of $\log x / \log y$.

$M_L$ is **elementary** in $B^*, x, y$: computable by exact binary
search using integer arithmetic on $x^p$ and rational arithmetic on
$\log y$ (bounded above and below by exact rationals).

**Seed-size condition.**  We require additionally that the initial
seed scale $T^*$ satisfies
$$T^* \;\ge\; \max(x, y)^{M_L}. \tag{H4'.SS}$$
Under (H4'.SS), the frontier exponents at $T^*$ already satisfy
$e_x(T^*), e_y(T^*) \ge M_L$, hence so do all subsequent frontier
exponents (frontier exponents are non-decreasing under advancement).
Therefore **every failure pair $(m, n)$ along the post-$T^*$ tail has
$\min(m, n) \ge M_L$**, eliminating the small-exponent regime by
construction.

(Practical note: (H4'.SS) is mild.  For the four certified cases, the
seed range chosen in notes 46, 07, 09, 10, 11 already comfortably
exceeds $\max(x, y)^{M_L}$.  The Legendre thresholds $M_L \in \{11, 20, 23\}$
correspond to $4^{M_L} \in \{4 \cdot 10^6, 10^{12}, 7 \cdot 10^{13}\}$,
all below the per-case seed limits used in the verifications.)

### 2.2 MW threshold $M_{\mathrm{MW}}$

By the imported MW bound (LMN 1995 / Laurent 2008): for all positive
integers $p, q$ with $\max(p, q) \ge M_{\mathrm{MW}}$,
$|x^p - y^q| > B^*$.  The threshold $M_{\mathrm{MW}}$ is computable
by solving
$$\max(p \log x, q \log y) - C \log\max(x, y) (8 + \log\max(p, q))^2 > \log B^*$$
for $\max(p, q)$, again by binary search.

For $\max(p, q) \ge M_{\mathrm{MW}}$, no near-collision $\le B^*$ is
possible.

### 2.3 CF window

Enumerate the convergents $p_n/q_n$ of $\log y/\log x$ in the window
$q_n \in [M_L, M_{\mathrm{MW}})$.  This is a finite list (the CF
expansion is computed by exact rational arithmetic on rational
lower/upper bounds for $\log y/\log x$, as in `scripts/erdos124.py`'s
`cf_window` routine; correctness is purely number-theoretic).

For each convergent $(p_n, q_n)$ in the window, compute the exact
gap $|x^{p_n} - y^{q_n}|$ (integer arithmetic).  (H4') is the assertion
that every gap in the window exceeds $B^*$.

### 2.4 Why (H4') is a clean *arithmetic* hypothesis

All three steps use only integer or rational arithmetic, plus the
single imported LMN/Laurent bound to fix the upper window endpoint.
No CAS algebraic identities, no Fourier numerics, no bitset scans.
Per-case, (H4') is the analogue of (H1)–(H3) for Theorem A: a
finite, verifiable hypothesis.

## 3. Theorem B', precise statement

> **Theorem B' (effective MW form of Theorem B).**  Let $A, k, T^*,
> F^*, c^*, B^*, x, y$ be as in §1.  Suppose (H1'), (H4'.SS), and
> (H4').  Then every $N \ge c^* + 1$ is a subset sum of
> $\{a^e : a \in A,\ e \ge k\}$.
>
> *Effective form.*  Set $E^\dagger := \max(x, y)^{M_{\mathrm{MW}} + 1}$
> with $M_{\mathrm{MW}}$ from §2.2.  For every $N$ in the cofinite ray
> $[c^* + 1, \infty)$, the representing frontier $E$ has
> $T(E) \le \max(N, E^\dagger) \cdot \prod_i d_i$.

## 4. Proof of Theorem B'

We follow the algebraic skeleton of Theorem B (note 72 §Theorem B
proof), replacing the qualitative-S-unit finiteness Step 4 by the
effective MW + CF-window + Legendre Steps 3-4 below.

**Step 1 (multiplicative-class reduction; note 17).**  $\gcd(A) = 1$
forces $A$ to contain a multiplicatively-independent pair.  Fix the
pair $(x, y)$ of (H4').  $\square$

**Step 2 (near-collision bound at any failure; from note 27
§Consequence).**  Suppose, for contradiction, that interval
extension fails at some balanced frontier $E$ with $T(E) \ge T^*$.
Let $c(E)$ be the conductor of the seed $F(E)$ at frontier $E$.

By the near-collision reduction of note 27 §Consequence (algebraically
certified in `haskell/CFTail.hs`'s NearCollisionLemma) and the
explicit conductor identity of note 28, there exist positive integers
$m, n$ — the exponents of the frontier elements $E_x = x^m, E_y = y^n$
participating in the failure — with
$$|x^m - y^n| \;\le\; B_{xy}(E) \;=\; DK(E) \cdot (1/w_x + 1/w_y).$$

The conductor $c(F)$ is **monotone non-increasing** under set inclusion:
adding elements to $F$ cannot increase its largest missing value
(note 36 §completeness lemma; this is the elementary direction of the
subset-sum semigroup structure).  Since $F(E) \supseteq F^*$ for
$T(E) \ge T^*$, we have $c(E) \le c^*$, hence
$DK(E) \le DK(E^*)$ and $B_{xy}(E) \le B_{xy}(E^*) = B^*$.  Therefore
$$|x^m - y^n| \;\le\; B^*. \quad\square$$

**Step 3 (Legendre regime via (H4'.SS)).**  At any frontier $E$ with
$T(E) \ge T^*$, the frontier exponents satisfy
$$e_i(T(E)) \;\ge\; e_i(T^*) \;\ge\; \log_{d_i}(T^*) \;\ge\;
  \log_{d_i}\bigl(\max(x, y)^{M_L}\bigr)
\;=\; M_L \cdot \log_{d_i}\!\max(x, y) \;\ge\; M_L$$
for $d_i \in \{x, y\}$ (using (H4'.SS) and $\log_{d_i}\max(x, y) \ge 1$
in both directions $d_i = x \le y$ and $d_i = y \le x$).  Hence the
failure pair $(m, n) = (e_x(T(E)), e_y(T(E)))$ has $\min(m, n) \ge M_L$.

By §2.1, $\min(m, n) \ge M_L$ combined with $|x^m - y^n| \le B^*$
forces $n/m$ to be a continued-fraction convergent of $\log x/\log y$.
$\square$

**Step 4 (exclusion of all candidates by (H4')).**  By Step 2,
$|x^m - y^n| \le B^*$.  By §2.2 (the MW threshold), this forces
$\max(m, n) < M_{\mathrm{MW}}$.  By Step 3, $(m, n) = (p_j, q_j)$ is
one of the finitely many convergents of $\log x/\log y$ with
$\max(p_j, q_j) \in [M_L, M_{\mathrm{MW}})$.

But (H4') (§2.3) verifies $|x^{p_j} - y^{q_j}| > B^*$ for every such
convergent, contradicting $|x^m - y^n| \le B^*$.

Hence no failure pair exists; interval extension succeeds at every
$T(E) \ge T^*$.  $\square$

**Step 5 (single-term absorption and cofinite ray; identical to
Theorem B Steps 5–6).**  By Step 4, no frontier failure occurs for
any $T(E) \ge T^*$.  By the single-term absorption lemma (note 36)
applied inductively across the advance sequence of frontier elements
$(E_i)_i$, the central interval extends to a cofinite ray
$[c^* + 1, \infty)$.

Concretely, for any $N \ge c^* + 1$, choose
$T(E) \ge \max(N \cdot \prod_i d_i,\ T^*)$;
then $N \in [c^* + 1, S(E)/2]$ and $N$ is a subset sum of
$F(E) \subseteq \{a^e : a \in A,\ e \ge k\}$.  $\square$

**Effective form.**  The bound $T(E) \le \max(N, E^\dagger) \cdot
\prod_i d_i$ in §3 follows directly: $E^\dagger = T^*$ from (H4'.SS),
and for $N \ge T^*$ the representing $T(E)$ is bounded by
$N \cdot \prod_i d_i$.  $\square$

## 5. Where the qualitative S-unit input has gone

In Theorem B (note 72) the qualitative S-unit input enters at Step 4
to assert "the failure set is finite, but the bound on $\max(m, n)$
is non-effective".  In Theorem B':

| Theorem B Step 4 substep | Theorem B' Step 3/4 replacement | Imported ingredient |
|---|---|---|
| Apply S-unit finiteness theorem at $B^* = D\kappa + 2Dc^* + D$ | Apply MW bound (LMN/Laurent) at $B^*$ | LMN 1995 / Laurent 2008 |
| Conclude finite $\mathcal M$ of pairs $(m, n)$ with $|x^m - y^n| \le B^*$ | Conclude $M_{\mathrm{MW}}$-effective bound on $\max(m, n)$ | (effective, no further input) |
| Set $M_*$ as a non-effective upper bound of $\mathcal M$ | Set $M_{\mathrm{MW}}, M_L$ effectively; enumerate CF window | (effective; CF enumeration is integer arithmetic) |
| Threshold $\max(x, y)^{M_* + 1}$ is non-effective | Threshold $\max(x, y)^{M_{\mathrm{MW}} + 1}$ is effective | — |

The Subspace-Theorem power-saving input of `GlobalProofAudit.hs`
(used in Proposition D / note 73 for $c$ varying with $T$) is **not**
needed in Theorem B' because the bound $|x^m - y^n| \le B^*$ uses
$c(E) \le c^*$ (the monotonicity from Step 2), not a varying $c$.
The point is that monotonicity gives a *one-shot* upper bound
sufficient for the Diophantine argument; Subspace's power-saving is
needed only when $c$ might be varying in a way that defeats finite
bounds.

## 6. The four CF/MW specific cases as instances of (H4')

Notes 46, 07, 09, 10, 11 are each verifications of (H4') for one
specific $(A, k)$:

| $(A, k)$ | $(x, y)$ | $c^*$ | $DK(E^*)$ | $B^* = \tfrac{5}{6} DK$ | $M_L$ | CF window size | (H4') in |
|---|---|---:|---:|---:|---:|---:|---|
| $\{3,4,7\}, 1$ | $(3, 4)$ | 581 | 7,002 | 5,835 | 11 | 8 | note 46 |
| $\{3,4,7\}, 2$ | $(3, 4)$ | 3,982,888 | 47,794,770 | 39,828,975 | 20 | 7 | notes 07, 09 |
| $\{3,4,7\}, 3$ | $(3, 4)$ | 166,025,260 | 1,992,303,678 | 1,660,253,065 | 23 | 4 | note 10 |
| $\{3,4,9,25\}, 2$ | $(3, 4)$ | 452,099 | 21,701,880 | (pair-weight differs)| (see note 11) | 8 | note 11 |

All four share the same $(x, y) = (3, 4)$ pair.  For $\{3,4,7\}$, the
pair-weight $(1/w_x + 1/w_y) = 5/6$, so $B^* = (5/6) \cdot DK$;
$\{3,4,9,25\}$ has $D = \mathrm{lcm}(2,3,8,24) = 24$, $w_3 = 12, w_4 = 8$,
$1/w_3 + 1/w_4 = 1/12 + 1/8 = 5/24$, hence $B^* = (5/24) \cdot 21{,}701{,}880
= 4{,}521{,}225$.

In every certified case, notes 46/07/09/10/11 verify $|3^p - 4^q| > DK$
(the stronger, looser-pair-weight bound), which implies
$|3^p - 4^q| > B^*$ (H4'.2.3) since $B^* \le DK$ for the (3,4) pair.

The per-case work is computing $c^*$, $DK(E^*)$, $B^*$, $M_L$,
$M_{\mathrm{MW}}$ and checking every gap in the CF window exceeds
$B^*$.

Theorem B' subsumes notes 46, 07, 09, 10, 11 as **four explicit
verifications of (H4')**, with the algebraic theorem now stated once
and proved once.

## 7. Remarks

### 7.1 Comparison to Theorem A

Theorem A (note 72, strict case $R > 1$) uses the strict-slack tail
closure (note 28 §strict) and needs no Diophantine input.  Its
hypotheses (H1)–(H3) are arithmetic.

Theorem B' (exact-critical $R = 1$) needs Diophantine input — the
exact-critical case has zero slack and a single near-collision can
destroy interval extension.  MW/LMN supplies that input effectively.

Together, Theorem A + Theorem B' provide **effective unconditional
Erdős 124** for every hypothesis-meeting $(A, k)$ satisfying their
respective per-case hypotheses, with imports {none} for strict and
{MW/LMN} for exact-critical.

### 7.2 What Theorem B' does not do

Theorem B' does **not** close the open obligation
(`GlobalProofAudit.hs`: global power-saving central conductor
theorem).  It still requires (H1'), i.e., a per-case verified $T^*$
with $2 c^* + 2 \le S^*$.

Proposition D (note 73, §2) showed that, modulo Subspace, the open
obligation reduces to ruling out linear conductor growth $c \sim T$.
Theorem B' does not advance this — its near-collision argument
fixes $c$ at $c^*$ and so is structurally inapplicable to the
variable-$c$ growth question.

### 7.3 Why the CF window is finite

The continued-fraction expansion of $\log y / \log x$ is infinite, but
the convergents in any bounded denominator window $[M_L, M_{\mathrm{MW}})$
are finite by the standard CF growth $q_{n+1} \ge q_n + q_{n-1}$, so
$q_n \ge F_n$ (Fibonacci).  Hence the window contains $O(\log M_{\mathrm{MW}})$
convergents, all computable by exact rational arithmetic on
lower/upper bounds for $\log y/\log x$ (the project's
`scripts/cas_continued_fraction.py` implements this without
floating-point).

### 7.4 Explicit form of $B^*$

The threshold $B^* = D\,\kappa(A, k) + 2 D\, c^* + D$ is elementary in
$A, k, c^*$:
- $D = \mathrm{lcm}_i(d_i - 1)$ is the lcm of the shifted bases.
- $\kappa(A, k) = \sum_i d_i^k / (d_i - 1)$ is rational; multiplying
  by $D$ clears the denominators to give the integer
  $D \kappa = \sum_i d_i^k \cdot D/(d_i - 1) = \sum_i d_i^k w_i$.

For $\{3,4,7\}$, $k = 1$, $(x, y) = (3, 4)$:
- $D = \mathrm{lcm}(2, 3, 6) = 6$, $w = (3, 2, 1)$, so
  $1/w_x + 1/w_y = 1/3 + 1/2 = 5/6$.
- $D \kappa = 3 \cdot 3 + 4 \cdot 2 + 7 \cdot 1 = 24$.
- $DK(E^*) = 24 + 12 c^* + 6 = 12 c^* + 30$.  At $c^* = 581$:
  $DK(E^*) = 7002$, matching note 46's "cleared obstruction".
- $B^* = 7002 \cdot 5/6 = 5835$.

Note 46 verifies the stronger statement $|3^p - 4^q| > 7002$ for all
CF convergents in the window, which implies $|3^p - 4^q| > 5835 = B^*$
(H4'.2.3).  This stronger verification is a slack of $\approx 20\%$
and is harmless — the four certified cases all verify the looser
(cleared, no pair-weight) threshold $DK$, which automatically
dominates $B^* = DK \cdot (1/w_x + 1/w_y)$ when $(1/w_x + 1/w_y) \le 1$
(equivalently $d_x + d_y \le D + 2$).  For pairs where
$(1/w_x + 1/w_y) > 1$, the existing $> DK$ verification still
suffices iff the CF-window minimum gap exceeds $B^* = DK(1/w_x + 1/w_y)$.

This identity is verifiable by SymPy in one line; no numerical
appeal is needed.

## 8. Status

This note (Phase B-15) replaces Theorem B (note 72) by **Theorem B'**,
an effective MW form.

Algebraic content:
- The proof in §4 uses only previously-certified project lemmas
  (notes 17, 27, 28, 36, 39, 47) plus one named imported theorem
  (Mignotte–Waldschmidt; LMN 1995 / Laurent 2008).
- The qualitative S-unit obligation in `GlobalProofAudit.hs` is no
  longer needed for exact-critical cases satisfying (H4').  (S-unit
  finiteness remains a project-imported obligation in the strict
  variant of Theorem B if used; but Theorem A handles strict without
  any Diophantine input.)
- The Subspace-Theorem power-saving obligation, also imported, is
  used only by Proposition D (note 73), not by Theorem B'.

Effective improvement:
- $N_0 = c^* + 1$ is the explicit threshold above which every integer
  is represented.
- The frontier achieving the representation of $N$ has
  $T(E) \le \max(N, E^\dagger) \cdot \prod_i d_i$ for explicit
  $E^\dagger$.

The four CF/MW certificates (notes 46, 07, 09, 10, 11) are now
recognised as four explicit verifications of (H4') on specific
$(A, k)$, instances of one algebraic theorem rather than ad hoc
proofs.

## 9. What is genuinely closed and what remains open

**Closed:** the imported obligation list for unconditional Erdős 124
on the four CF/MW cases is reduced from {qualitative S-unit, Subspace
Theorem power-saving gap} (Theorem B's imports) to {Mignotte–Waldschmidt
(LMN 1995 / Laurent 2008)}, a single named published bound.  All four
specific cases are now witnesses of one algebraic theorem.

**Still open:** the global power-saving central conductor theorem
(`GlobalProofAudit.hs`).  Theorem B' requires (H1') and (H4') per
case; the uniform algebraic bound on $c(T)$ remains.

**Not addressed:** any case where the only multiplicatively-independent
pair $(x, y)$ has (H4'.2.3) failing — i.e., where the CF window
contains a convergent gap below $B^*$.  Empirically, for all four
verified cases this does not happen.  A theorem ruling it out
uniformly would be valuable; absent that, (H4') is a per-case
arithmetic hypothesis.
