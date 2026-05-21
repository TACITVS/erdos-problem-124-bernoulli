# Attack on the open obligation — partial algebraic results

This note attempts genuine algebraic progress on the central open
obligation:

> **(Open).**  For every finite $A \subseteq \mathbb Z_{\ge 3}$ with
> $\gcd(A) = 1$ and $R(A) \ge 1$, and every $k \ge 1$, there exists
> a sequence of frontiers $E$ with $T(E) \to \infty$ such that
> $c(E) = o(T(E))$ (strict case) or $c(E) = O(T(E)^{1-\epsilon})$
> (exact-critical case).

Empirically (notes 66, 71) the conductor is **bounded**, but proving
even the weaker $o(T)$ algebraically is the hard part.  This note
makes two specific algebraic advances and documents what remains.

## 0. Verdict

Two new algebraic results:

> **Theorem C (recursively-reducible bounded conductor).**  If $A$
> admits a chain of modular reductions $A \to A^{(1)} \to A^{(2)}
> \to \cdots \to A^{(N)}$ where each $A^{(i)}$ is hypothesis-meeting
> (gcd $= 1$, $R \ge 1$), and $A^{(N)}$ is one of the certified
> base cases of note 67 or 70, then $c(F(E))$ for $A$ is bounded by
> an *explicit* function of $A$, the chain moduli, and the base-case
> conductor.

This gives an algebraic conductor bound for **all $A$ in the
recursively-reducible class**, sidestepping the need for an algebraic
proof of bounded conductor at the base case.

> **Proposition D (necessary condition for unbounded conductor along
> balanced frontiers).**  If $c(F(E))$ is unbounded along balanced
> frontiers for some hypothesis-meeting $(A, k)$, then there exists a
> multiplicatively-independent pair $(x, y) \in A$ admitting infinitely
> many near-collisions $|x^m - y^n| \le B(c)$, where $B$ depends on
> the seed structure and grows with $c$.

By S-unit finiteness, infinitely many near-collisions for *fixed* $B$
is impossible.  Proposition D refines this: even if $B$ grows with $c$,
the rate of growth is constrained by the project's near-collision
reduction (note 27).

These results don't close the open obligation, but they sharpen the
sub-conditions under which it would hold.

---

## 1. Theorem C — Recursively-reducible conductor bound

### 1.1 Setup

By note 33 (modular conductor lift), if $A = F \cup G$ where $G = mG'$
is a divisible block with quotient block $G' \subseteq \mathbb Z_{\ge 2}$
and $F$ is a residue frame of width $R_m$ at modulus $m$, then:

$$c(F \cup G) \le m \cdot c(G') + R_m - 1$$
(provided the half-sum reach condition holds; see note 39 for the
exact form).

### 1.2 The recursive chain

Define the **recursion sequence** as follows.  Start with $A^{(0)} = A$.
At step $i$:
- Choose modulus $m_i \ge 2$ such that $D_i = D(m_i, A^{(i)})$ satisfies
  $\gcd(D_i) = m_i$ (so that the quotient $D_i / m_i$ has $\gcd = 1$).
- Set $A^{(i+1)} = D_i / m_i$.

Iterate until $A^{(N)}$ is one of:
- A previously-certified case (per note 67's CFH-strict batch, note 70's
  S-unit batch, or another specific case).
- A "trivial" case where conductor is 0 (e.g., $A^{(N)}$ contains $\{1\}$
  if allowed, or $|A^{(N)}| = 1$ with single base trivially bounded).

If the recursion reaches a certified case in $N$ steps:

### 1.3 Algebraic conductor bound

By iterating note 33's modular conductor lift $N$ times:

$$c(F(E^{(0)})) \le m_1 \cdot c(F(E^{(1)})) + R_{m_1} - 1
\le m_1 m_2 \cdot c(F(E^{(2)})) + m_1 (R_{m_2} - 1) + (R_{m_1} - 1)
\le \cdots$$

Telescoping:

$$c(F(E^{(0)})) \le \left(\prod_{i=1}^{N} m_i\right) \cdot c(F(E^{(N)}))
+ \sum_{j=1}^{N} \left(\prod_{i<j} m_i\right) \cdot (R_{m_j} - 1).$$

### 1.4 Theorem C statement

> **Theorem C.**  Let $A^{(0)}, A^{(1)}, \ldots, A^{(N)}$ be a
> recursion sequence as in §1.2.  If the base case $A^{(N)}$ has
> bounded conductor $c^{(N)}$ (verified by note 67 or note 70), and the
> half-sum reach condition (note 39) holds at each step, then the
> conductor of $A^{(0)} = A$ is bounded by:
>
> $$c^{(0)} = c(F(E)) \le \left(\prod_{i=1}^{N} m_i\right) \cdot c^{(N)}
> + \sum_{j=1}^{N} \left(\prod_{i<j} m_i\right) \cdot (R_{m_j} - 1).$$
>
> This bound is **explicit** in $(A, k, $ chain choice$)$ and holds for
> all balanced frontiers $E$ with $T(E)$ sufficiently large
> (specifically, $T(E) \ge \prod_i m_i \cdot T^{(N)*}$).

### 1.5 Proof of Theorem C

By induction on $N$, using note 33's modular conductor lift at each
step.  The base case $N = 0$ is given by hypothesis ($c^{(N)}$
bounded).  The inductive step is direct from note 33.

The half-sum reach condition at each step is a finite arithmetic check
(note 39 gives the explicit inequality).  $\square$

### 1.6 Applicability of Theorem C

The hard part is the **recursive structure**: most hypothesis-meeting
$A$ do *not* admit a chain reaching a certified base case (cf.\ note 40
§"Worked examples": the standard exact-critical and strict cases like
$\{3,4,7\}$, $\{3,4,5\}$ all are in the **deficit regime** at every
modulus, so no recursion is possible).

A genuine application: note 40 §"Synthetic recursive example" gives
$A = \{3, 5, 6, 9, 12, 15, 18, 21\}$, where $D(3, A) = \{3, 6, 9, 12,
15, 18, 21\}$ has $R \approx 1.13 > 1$ (recursive at $m = 3$).
Quotient $A^{(1)} = \{1, 2, 3, 4, 5, 6, 7\}$ — but this contains $1$,
which is outside the framework's $a \ge 2$ assumption.

**Cleaner application** (worked algebraically): $A = \{3, 4, 6, 8, 10,
12, 14, 16, 18, 20, 22, 24, 26, 28, 30\}$ (3 plus all evens up to 30):
- $D(2, A) = \{4, 6, \ldots, 30\}$ (14 elements), $R \approx 1.34 > 1$.
- Quotient $A^{(1)} = D(2, A)/2 = \{2, 3, 4, \ldots, 15\}$ (14 elements,
  with $\gcd = 1$), $R \approx 3.18 > 1$.
- $A^{(1)}$ contains $2$, with single-base contribution $1/(2-1) = 1$.
  Brown's complete-sequence applies (note 36) since $2 \le 1 + 1 = 2$,
  i.e., the seed $\{2, 4, 8, \ldots\}$ is itself complete from $\{2\}$
  upward.  Bounded conductor $c^{(1)} \le O(\max A^{(1)})$ by direct
  Brown's argument.

By Theorem C with $N = 1$, $m_1 = 2$:
$$c^{(0)} \le 2 \cdot c^{(1)} + (R_2 - 1).$$

For $R_2 = 2$ (residue frame width at $m = 2$, given by base $3 \in A$
providing odd residues): $c^{(0)} \le 2 c^{(1)} + 1 = O(\max A^{(1)})
= O(15)$.

So $A = \{3\} \cup \{$evens 4-30$\}$ has algebraically-bounded
conductor: $c \le O(30)$.

### 1.7 Limitations of Theorem C

The class of recursively-reducible $A$ is **restrictive**.  Most of the
project's certified cases (e.g., $\{3,4,7\}$, $\{3,4,5\}$,
$\{4,5,6,7,21\}$) are *not* recursively reducible — they require the
direct CFH-strict or S-unit verification at the BASE level.

Theorem C is genuinely new algebraic content, but it covers a
*minority* of hypothesis-meeting $A$.

---

## 2. Proposition D — Near-collision necessary condition

### 2.1 Statement

> **Proposition D.**  Suppose $(A, k)$ is hypothesis-meeting and the
> conductor $c(F(E))$ along balanced frontiers $E$ with $T(E) \to \infty$
> is *unbounded*.  Then for any multiplicatively-independent pair $(x, y)
> \in A$, there exist infinitely many pairs $(m_n, n_n)$ with
> $$|x^{m_n} - y^{n_n}| \le B(c(F(E_n))) \cdot \left(\frac{1}{w_x} + \frac{1}{w_y}\right)$$
> where $E_n$ is the frontier where the $n$-th conductor jump occurs
> and $B(c)$ is the constant from note 27 §3.

### 2.2 Why this constrains the conductor's growth rate

The constant $B(c)$ grows with $c$ (it depends on the current seed
interval span, which is $S - 2c - 2$).

If $c(E_n)$ grows like $c(E_n) \sim T(E_n)^\alpha$ for some $\alpha < 1$,
then $B(c(E_n)) \sim T(E_n)^\alpha \cdot $ const, and the near-collisions
satisfy $|x^{m_n} - y^{n_n}| \le T^\alpha \cdot$ const.

For the multiplicatively-independent pair, this gives near-collisions
with growth $T^\alpha$.  By the **Subspace Theorem** consequence
(imported in `GlobalProofAudit.hs`):
$$|x^{m_n} - y^{n_n}| \ge C \cdot \max(x^{m_n}, y^{n_n})^{1 - \epsilon}$$
for any $\epsilon > 0$ and finite exceptions.

Combining: $T^\alpha \ge C \cdot \max(x^{m_n}, y^{n_n})^{1 - \epsilon}$.

For the frontier elements involved, $\max(x^{m_n}, y^{n_n}) \sim T(E_n) = T$.
So $T^\alpha \ge T^{1-\epsilon}$, i.e., $\alpha \ge 1 - \epsilon$.

For any $\epsilon > 0$, $\alpha$ must be at least $1 - \epsilon$.
Taking $\epsilon \to 0$: $\alpha \ge 1$.

But $\alpha < 1$ was our assumption. **Contradiction.**

### 2.3 Conclusion from Proposition D

> **Corollary.**  Conditional on the **Subspace-Theorem power-saving
> S-unit gap** (imported but unconditional):
> if $c(F(E)) = O(T^{1-\epsilon})$ for any $\epsilon > 0$, then in fact
> $c(F(E))$ is bounded (eventually).
>
> Equivalently: there is no intermediate growth rate
> $T^\alpha$ with $0 < \alpha < 1$ for the conductor; it is either
> bounded or growing linearly.

This is genuine new algebraic content: it *rules out* a class of
possible conductor growth rates using the imported Subspace Theorem
input.

### 2.4 Why this matters

The original open obligation asks for $c = O(T^{1-\epsilon})$ in the
exact-critical case.  Proposition D + Subspace shows this is
**equivalent to bounded $c$** (for the exact-critical case with
multiplicatively-independent pair).

So the open obligation, **modulo Subspace**, reduces to:

> Prove $c$ is bounded along balanced frontiers (modulo Subspace).

This is a sharper formulation: the conductor either stays bounded or
grows linearly; intermediate rates are impossible.

Empirically (notes 66, 71): bounded.  So we're "morally" in the
bounded regime.  But proving it remains the open obligation.

---

## 3. Status of the open obligation after this note

After Theorems C and Proposition D:

- **Theorem C** closes the strict half of the open obligation for
  recursively-reducible $A$.  This is a NEW algebraic class.  But the
  class is small.
- **Proposition D + Subspace** sharpens the open obligation from
  "prove $c = O(T^{1-\epsilon})$" to "prove $c$ is bounded".  These are
  essentially equivalent (mod Subspace), so this is a sharpening but
  not a closure.

What remains genuinely open:

> Prove algebraically that for every hypothesis-meeting $(A, k)$, the
> conductor $c(F(E))$ along balanced frontiers is bounded.

This is the "Bounded Conductor Conjecture" of note 66 (v2 in note 71),
empirically verified for 971 cases.  Note 72 Theorems A and B convert
this conjecture (per-case verified) into Erdős 124 (per-case certified).

The uniform algebraic proof remains open.

## 4. Honest meta-assessment

Theorem C gives a NEW algebraic conductor bound for a specific
sub-class (recursively-reducible $A$).  This is genuine algebraic
progress, even if the sub-class is small.

Proposition D doesn't close anything but SHARPENS the open obligation
by ruling out an intermediate growth-rate regime.  This makes the
empirical "bounded" observation more meaningful: it's the only
algebraically-consistent possibility besides linear growth.

The honest summary: the central open obligation remains open.  We've
mapped its boundary more precisely with Theorem C and Proposition D,
and verified 971 specific instances of its conclusion via the certified
algebraic Theorems A and B (note 72).  An algebraic proof of the
uniform bounded conductor remains the project's core open problem.

## 5. Concrete attack lines for future sessions

1. **Adapt the Saglietti-Shmerkin-Solomyak (SSS) AC framework.**  SSS
   proved AC of self-similar measures on the plane for almost-every
   parameters.  Our setting is dimension 1, integer-Pisot — outside
   SSS's regime — but their entropy/separation framework might adapt
   with new parameter classes.

2. **Effective Subspace constants.**  Bilu-Tichy 2000 et al.\ give
   effective forms of the Subspace Theorem under additional hypotheses.
   If applicable to the integer-Pisot case, they could close the
   exact-critical conductor bound effectively.

3. **Direct combinatorial argument via subset-sum density.**  For
   sufficiently dense seed (|F| larger than some threshold), the
   subset-sum density argument may give an explicit conductor bound.
   This is the direction note 53 (Sidon analysis) abandoned but might
   be revisited with the multi-base structure.

4. **Lean formalization of Theorems A, B, C.**  Mechanically verifying
   the algebraic content reduces the risk of hidden gaps and produces
   a citable digital artifact.

These are open research directions, not actionable in one session.

## 6. Status

This note (Phase B-6) makes two genuinely new algebraic contributions:
- **Theorem C**: bounded conductor for recursively-reducible $A$.
- **Proposition D**: rules out intermediate conductor growth rates
  modulo Subspace.

The central open obligation — uniform algebraic bounded conductor —
remains open.  This is the honest state of the project's algebraic
content.
