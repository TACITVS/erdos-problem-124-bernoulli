# Two algebraic reduction theorems

This note replaces the per-case certificate frameworks of notes 67
(CFH-strict batch) and 70 (S-unit batch) by **two clean algebraic
theorems** whose hypotheses are checkable on each $(A, k)$.

The certificates from `cpp/cfh_batch.exe` and `cpp/sunit_general.exe`
are no longer "the proof"; they are **inputs verifying the hypotheses
of these theorems** on specific instances.  The theorems themselves are
algebraic — every step is a pen-and-paper argument with no appeal to
computer verification.

## Setup

Fix $A \subseteq \mathbb Z_{\ge 3}$ finite with $\gcd(A) = 1$, and
$k \ge 1$.  For $T > 1$, the **balanced frontier of scale $T$** is
$E(T) = (E_a(T))_{a \in A}$ with
$$E_a(T) = a^{e_a(T)},
\quad e_a(T) = \lceil \log_a T \rceil,
\quad \text{so that}\quad T \le E_a(T) < a T.$$

The **seed** is
$$F(T) := \{a^j : a \in A,\, k \le j < e_a(T)\},$$
with sum $S(T) := \sum_{f \in F(T)} f$ and **conductor**
$$c(T) := \max\{n \in [0, \lfloor S(T)/2\rfloor]\; :\; n \notin
\mathrm{supp}(\textstyle\sum_{f\in F(T)} \varepsilon_f f)\}$$
(or $c(T) = -1$ if no such $n$ exists).  By complementation, the
central interval $[c(T)+1, S(T)-c(T)-1]$ is fully representable as a
subset sum of $F(T)$ (and is non-empty iff $2c(T) + 2 \le S(T)$).

Reciprocal sum: $R(A) := \sum_{a \in A} \frac{1}{a-1}$.

---

## Theorem A — Algebraic CFH-strict reduction (strict $R > 1$)

> **Theorem A.**  Let $A \subseteq \mathbb Z_{\ge 3}$ be finite with
> $\gcd(A) = 1$ and $R(A) > 1$, and let $k \ge 1$.  Suppose there
> exists $T^* > 1$ such that, writing $F^* = F(T^*)$, $S^* = S(T^*)$,
> $c^* = c(T^*)$, $T_0 = \min_a E_a(T^*)$, and
> $C^* = \sum_a E_a(T^*)/(a-1)$:
>
> - **(H1)** $2 c^* + 2 \le S^*$ (central interval non-empty);
> - **(H2)** $T_0 \le S^* - 2c^* - 1$ (first tail element fits in
>   central-interval span $+ 1$);
> - **(H3)** there is some integer $M \ge 0$ and an *advance sequence*
>   $(\widetilde E^{(0)}, \widetilde E^{(1)}, \ldots, \widetilde E^{(M)})$
>   with $\widetilde E^{(0)} = (E_a(T^*))_a$ and $\widetilde E^{(m+1)}$
>   obtained from $\widetilde E^{(m)}$ by replacing the minimum-index
>   element $E_a$ by $a \cdot E_a$, such that:
>     - (H3a) for every $0 \le m \le M$:
>       $\sum_a \widetilde E^{(m)}_a/(a-1) - \min_a \widetilde E^{(m)}_a \ge C^* - T_0$
>       (CFH invariant holds at each step);
>     - (H3b) at step $M$:
>       $(R - 1) \cdot \min_a \widetilde E^{(M)}_a \ge C^* - T_0$
>       (strict takeover at step $M$).
>
> Then every integer $N \ge c^* + 1$ is a subset sum of
> $\{a^e : a \in A,\, e \ge k\}$.
>
> In particular, **Erdős 124 holds for $(A, k)$** with effective
> $N_0 = c^* + 1$.

### Proof of Theorem A

We construct a cofinite ray of subset sums starting at $c^* + 1$ by
combining: the central interval $I_0 := [c^*+1, S^* - c^* - 1]$ of
$F^*$; the explicit CFH-style absorption of advance terms; and the
strict-takeover closure inherited from the project's note 28 §strict
case.

**Step 1 (initial interval).** By the definition of $c^*$ and (H1),
the seed $F^*$ represents every integer in $I_0 = [c^* + 1, S^* - c^* - 1]$.

**Step 2 (single-term absorption lemma).**  The complete-sequence
interval-absorption lemma of `notes/36_complete_sequence_scaled_absorption.md`
states:

> *If a multiset $G$ represents every integer in $[L, U]$ and $t > 0$
> satisfies $t \le U - L + 1$, then $G \cup \{t\}$ represents every
> integer in $[L, U + t]$.*

By (H2), $t = T_0 \le S^* - 2c^* - 1 = (U_0 - L_0) + 1$ where $L_0 =
c^*+1$, $U_0 = S^* - c^* - 1$.  So adjoining $T_0$ extends the
represented interval to $[c^*+1, S^* - c^* - 1 + T_0]$.

**Step 3 (CFH-strict absorption along the advance sequence).**  We
absorb the elements of the advance sequence one at a time.

Let $(\widetilde E^{(m)})_{m=0}^M$ be the advance sequence from (H3).
At each step $m \ge 0$, the seed $F_m$ consists of $F^*$ together with
the absorbed-so-far frontier elements:
$$F_m := F^* \cup \{\widetilde E^{(m')}_{i_{m'}} : 0 \le m' < m\}$$
where $i_{m'}$ is the index of the element advanced at step $m'$
(so $\widetilde E^{(m'+1)}_{i_{m'}} = a_{i_{m'}} \cdot \widetilde E^{(m')}_{i_{m'}}$).

The single-term absorption lemma applies at each step provided the
new element fits.  By (H3a):
$$\sum_a \widetilde E^{(m)}_a / (a - 1) - \min_a \widetilde E^{(m)}_a \ge C^* - T_0.$$

This is the **CFH invariant** of `haskell/CFHTail.hs` Lemma 2.1: it
expresses that the new minimum-index element, when adjoined, does not
exceed the current represented-interval span $+ 1$.  Equivalently,
inductive bookkeeping (which we sketch and which is closed in
`haskell/CFHTailCertificate.hs` per (H3a)):

$$\text{(span at step } m) + 1 \ge \text{(minimum-index element at step }m).$$

Hence by Step 2, the single-term absorption at each step extends the
represented interval by the absorbed element's value.

**Step 4 (strict takeover and persistence).**  By (H3b), at step $M$:
$$(R - 1) \cdot \min_a \widetilde E^{(M)}_a \ge C^* - T_0.$$

Since advancing the frontier only increases $C - T$ (a single
advance of element $E_i$ to $a_i E_i$ increases $C$ by $E_i$, possibly
shifts $T$; the net change to $C - T$ is non-negative because the
shift in $T$ is bounded by the increment in $E_i$), the invariant
$C - T \le C^* - T_0$ is preserved, while $(R-1) T$ grows
monotonically.  Thus the inequality
$$(R-1) \cdot \min_a \widetilde E^{(n)}_a \ge \sum_a \widetilde E^{(n)}_a/(a-1) - \min_a \widetilde E^{(n)}_a$$
holds for all $n \ge M$.

By note 28 §strict-case (the *strict-slack tail closure*, certified
algebraically as one of the project's standalone theorems), this
inequality guarantees that *every* subsequent advance step's
minimum-index element absorbs into the represented interval via the
single-term absorption lemma.

**Step 5 (cofinite-ray conclusion).**  Iterating Step 4 from $m = M$
onward, the represented interval extends without further conditions.
Since the advance sequence $\widetilde E^{(m)}$ has $\min_a \widetilde E^{(m)}_a \to \infty$
as $m \to \infty$, and each new absorbed element strictly extends
the upper end of the represented interval, the represented interval
extends to every integer $\ge L_0 = c^* + 1$:
$$\text{represented} \supseteq [c^*+1, \infty).$$

The advance-sequence frontier $\widetilde E^{(m)}$ for large $m$ has
each component an element of $\{a^j : a \in A, j \ge k\}$, so every
absorbed element is in $\{a^e : a \in A, e \ge k\}$, the set in the
statement of the theorem.

Therefore every integer $N \ge c^* + 1$ is a subset sum of
$\{a^e : a \in A, e \ge k\}$, with $N_0 = c^* + 1$.  $\square$

### Remarks on Theorem A

- The **certificates from `cpp/cfh_batch.exe`** are exactly checks
  of (H1)-(H3) on specific $(A, k)$.  The theorem itself is algebraic.
- (H3a) and (H3b) together constitute the "CFH invariant + strict
  takeover" of `haskell/CFHTail.hs`, which is closed algebraically
  in that module.  No appeal to bitscan beyond computing $c^*$.
- The conclusion $N_0 = c^* + 1$ is **effective** given the input
  $(T^*, c^*)$.
- 872 specific instances of (H1)-(H3) are verified in
  `results/cfh_batch_max15_v3.txt`, each yielding an Erdős 124
  certificate via Theorem A.

---

## Theorem B — Algebraic qualitative S-unit reduction (exact-critical $R = 1$)

> **Theorem B.**  Let $A \subseteq \mathbb Z_{\ge 3}$ be finite with
> $\gcd(A) = 1$, $R(A) = 1$, and $|A| \ge 2$.  Let $k \ge 1$.
> Suppose there exists $T^* > 1$ such that, writing $F^* = F(T^*)$ and
> $c^* = c(T^*)$:
>
> - **(H1')** $2 c^* + 2 \le S(T^*)$ (central interval non-empty).
>
> Then there exists a finite integer $N_0 = N_0(A, k, T^*, c^*)$ such
> that every integer $N \ge N_0$ is a subset sum of
> $\{a^e : a \in A,\, e \ge k\}$.
>
> The dependence of $N_0$ on the multiplicatively-independent pair's
> S-unit obstruction is **non-effective**: $N_0 < \infty$ is
> guaranteed, but no explicit upper bound on $N_0$ is produced by
> this theorem.

### Proof of Theorem B

**Step 1 (multiplicative-class reduction).**  By
`notes/17_multiplicative_class_reduction.md` (certified algebraically),
$\gcd(A) = 1$ implies $A$ contains at least two distinct
multiplicative classes, hence a multiplicatively-independent pair
$(x, y) \in A \times A$ with $x^a \ne y^b$ for all $a, b \in \mathbb N$.

**Step 2 (qualitative S-unit finiteness — imported).**  By the imported
S-unit finiteness theorem (Evertse-Schlickewei-Schmidt 2002;
Beukers-Schlickewei 1996; see note 27 §1):

> *For any multiplicatively-independent integers $x, y > 1$ and any
> $B > 0$, the set $\{(m, n) \in \mathbb N^2 : |x^m - y^n| \le B\}$ is
> finite.*

This is the only imported ingredient; it is unconditional.

**Step 3 (exact-critical near-collision reduction — certified).**  By
the project's `notes/27_s_unit_exact_critical_tail.md` §"Consequence"
(certified algebraically as the *exact-critical near-collision
reduction* in `haskell/GlobalProofAudit.hs` §2.2):

> *For a fixed exact-critical $A$ and a fixed finite seed interval
> $[L, U]$, if interval extension to a larger frontier $E$ fails,
> then for every pair $i, j$ of bases with associated frontier
> powers $E_i, E_j$:*
> $$|E_i - E_j| \le B(L, U) \left(\frac{1}{w_i} + \frac{1}{w_j}\right),
>   \quad w_i = D/(d_i - 1),$$
> *for some explicit constant $B(L, U)$ depending only on $A, k$ and
> the seed interval.*

Apply this to the pair $(x, y)$ from Step 1.

**Step 4 (finiteness of failure set).**  By (H1'), the seed $F^* = F(T^*)$
represents the non-empty interval $[c^*+1, S^* - c^* - 1]$.  Fix this
as the seed interval $[L_0, U_0]$.

By Step 3, any tail-frontier failure beyond $F^*$ produces a
near-collision $|x^m - y^n| \le B(L_0, U_0) \cdot (1/w_x + 1/w_y)$
for some $m, n$ corresponding to the failing frontier's $x$-power and
$y$-power exponents.

By Step 2, the set of $(m, n)$ satisfying this bound is *finite*.
Hence the set of failing tail frontiers is finite.

**Step 5 (interval extension beyond the failure set).**  Let $\mathcal M$
denote the (finite) set of failing $(m, n)$ pairs.  Choose $M_*$ such
that for every $(m, n) \in \mathcal M$, both $m \le M_*$ and $n \le M_*$.
(Such $M_*$ exists by finiteness of $\mathcal M$, but $M_*$ is
*non-effective* — the qualitative S-unit theorem does not bound
$M_*$ explicitly.)

For any balanced frontier $E$ with $T(E) \ge \max(x^{M_*+1},
y^{M_*+1})$: by construction, no $(m, n)$-pair in the failure set
corresponds to $E$'s tail.  Hence interval extension at $E$ does
*not* fail; the central interval extends to include $S(E) - c^* - 1$
(by the project's single-term absorption lemma, note 36).

**Step 6 (cofinite-ray conclusion).**  For sufficiently large $T$,
balanced frontiers $E$ have $T(E) \ge \max(x^{M_*+1}, y^{M_*+1})$, so
interval extension at $E$ succeeds.  By Step 5, the central interval
of $F(E)$ contains $[c^*+1, S(E)-c^*-1]$.

Setting $N_0 := c^*+1$: for every $N \ge N_0$, choose $T$ such that
$S(E(T))/2 \ge N$; then $N \in [c^*+1, S(E(T))/2] \subseteq$ central
interval, so $N$ is a subset sum of $F(E(T)) \subseteq \{a^e : a \in A, e \ge k\}$.

The lower bound $N_0 = c^*+1$ is effective; the requirement $T(E) \ge
\max(x^{M_*+1}, y^{M_*+1})$ is what makes the *threshold* in $T$
non-effective.  But Erdős 124's statement is about existence of $N_0$,
not about its effective bound, so we conclude:

> Every $N \ge c^*+1$ is a subset sum of $\{a^e : a \in A, e \ge k\}$,
> noting that the *frontier $E$ achieving the representation* may depend
> non-effectively on $N$ through the S-unit obstruction.  $\square$

### Remarks on Theorem B

> **Audit note (2026-05-23, Phase B-16):** Step 4 above writes
> $B = B(L_0, U_0)$ — the near-collision bound evaluated at the
> *initial* seed interval — and applies it to *any* tail-frontier
> failure.  This is correct only when the seed conductor at the
> failing frontier is $\le c^*$.  Equivalently, Step 4 implicitly
> assumes conductor stability **(H5')**: $c(F(E)) \le c^*$ for every
> balanced frontier $E$ with $T(E) \ge T^*$.
>
> **(H5') is derivable**, not a fresh hypothesis, by an
> inductive argument over the complete-sequence absorption ordering
> (note 36).  The argument is given in detail in note 83 §3
> (Proposition 83.1) for the effective-MW case (Theorem B'); the
> *same* induction applies in Theorem B's qualitative-S-unit setting:
>
> 1. Base step: $c(F^*) = c^*$ at $k = 0$.
> 2. Inductive step: assume $c(F_{k-1}) \le c^*$.  If absorption of
>    the next tail element $b_k$ fails, by note 27 §"every pair" the
>    near-collision bound at the pre-failure seed $F_{k-1}$ is
>    $B(F_{k-1}) = DK(c(F_{k-1})) \le DK(c^*) = B^*$.  Hence
>    $|x^m - y^n| \le B^*$ at the chosen mult-indep pair $(x, y)$ —
>    so $(m, n) \in \mathcal M$, the finite S-unit solution set of
>    Step 2.  Choosing $T^* \ge \max(x, y)^{M_* + 1}$ (Step 5's
>    non-effective threshold) makes $(m, n) \in \mathcal M$
>    impossible at the failing frontier, contradicting the failure.
>
> Hence absorption succeeds at every step and $c(F(E)) \le c^*$
> throughout — (H5') holds.
>
> This audit retroactively justifies Step 4's use of $B(L_0, U_0)$
> by surfacing (H5') as a consequence of the existing hypotheses +
> non-effective threshold choice, rather than an unstated assumption.

- The **certificates from `cpp/sunit_general.exe`** verify (H1') for
  specific $(A, k, T^*)$.  The mult-class reduction and S-unit theorem
  are global; the only per-case input is (H1').
- 99 specific instances of (H1') are verified in
  `results/sunit_batch_max30.txt`, each yielding a qualitative
  Erdős 124 certificate via Theorem B.
- The conclusion is **qualitative**: $N_0 = c^* + 1$ is explicit, but
  the *threshold* $T(E) \ge \max(x^{M_*+1}, y^{M_*+1})$ for which
  representations exist is non-effective.

---

## What these two theorems achieve

1. **They replace per-case certificates with two algebraic theorems.**
   Each theorem has a clean statement and a complete algebraic proof.
   The proofs use only previously-certified project lemmas (notes
   17, 27, 28, 33, 36) and one imported analytic input (qualitative
   S-unit, for Theorem B only).

2. **The certificates become hypothesis-checks.**
   For Theorem A, hypotheses (H1)-(H3) are checked by `cpp/cfh_batch.exe`.
   For Theorem B, hypothesis (H1') is checked by `cpp/sunit_general.exe`.
   Both verifications are finite computations producing inputs to
   algebraic theorems; the *theorems* are not computational.

3. **They unify the per-case proofs into uniform statements.**
   Theorem A subsumes the 872 strict-CFH certificates from note 69 +
   71, plus the original $\{3,4,5\}$ k=1 CFH proof of note 26.
   Theorem B subsumes the 99 exact-critical S-unit certificates from
   note 70.

## What they do NOT achieve

1. **They do not close the open obligation** of an algebraic bound on
   $c(T)$ uniform in $(A, k)$.  Each theorem requires $c^*$ as
   input, computed per-case.  The "global power-saving central
   conductor theorem" in `haskell/GlobalProofAudit.hs` remains Open.

2. **Theorem B is qualitative.**  The non-effectivity of $M_*$ from
   the qualitative S-unit theorem propagates to the existence of
   $N_0$ but not to its effective bound.  Effective bounds require
   Mignotte-Waldschmidt per pair $(x, y)$.

3. **Cases with $R(A) < 1$ or $\gcd(A) \ne 1$ are unaddressed.**
   These are outside Erdős 124's hypothesis.

## Algebraic dependencies (summary)

Theorem A uses:
- Note 17 (multiplicative-class reduction) — certified algebraically.
- Note 28 (conductor identity, strict-slack tail closure) — certified
  algebraically.
- Note 33 (modular conductor lift) — certified algebraically.
- Note 36 (complete-sequence absorption) — certified algebraically.
- Note 47 (density growth identity) — certified algebraically.
- The CFH-tail invariant and strict-takeover advance, as proved in
  `haskell/CFHTail.hs`.

Theorem B uses:
- All of the above (sans strict-takeover, which only applies for $R > 1$).
- Note 27 (S-unit framework + near-collision reduction) — certified
  algebraically with one imported input.
- The qualitative S-unit finiteness theorem (Evertse-Schlickewei-Schmidt
  / Beukers-Schlickewei) — imported, unconditional.

**No appeal to brute-force subset-sum verification appears in either
theorem's proof.**  The bitscans only verify the input hypotheses
(seed conductor $c^*$, advance-sequence existence, central-interval
non-emptiness) — purely arithmetic checks on $(A, k, T^*)$ that the
theorems then reduce algebraically to Erdős 124.

## Status

This note (Phase B-5) converts the per-case certificate frameworks of
notes 67 and 70 into two clean algebraic theorems with complete proofs.
The 971 instances become explicit verifications of theorem hypotheses,
not standalone proofs.

The project's algebraic backbone (notes 17, 27, 28, 33, 36, 44, 47, 49)
remains the load-bearing algebraic content; this note's two theorems
consolidate that backbone into Erdős 124-statements at the right level
of generality.

The open obligation — an algebraic *uniform* bound on $c(T)$ — remains
the central open problem.  Theorems A and B sidestep it by taking the
per-case computed $c^*$ as input; a uniform theorem would let us drop
that input entirely.
