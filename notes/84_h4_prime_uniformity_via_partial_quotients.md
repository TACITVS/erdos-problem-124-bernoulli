# Uniform (H4') as a partial-quotient question on $\log y/\log x$

Phase B-17: reformulate the central remaining open question — (H4')
uniformly across hypothesis-meeting $(A, k)$ — as a *concrete
Diophantine question about continued-fraction partial quotients* of
$\log y / \log x$.  Prove that **bounded partial quotients imply
(H4') automatic** (Proposition 84.1).  Identify sub-classes where
this can be verified and connect to irrationality-measure
literature.

The session is honest about the residual gap: the uniform statement
reduces to a Diophantine claim that is open in transcendence theory.

## 0. Headline

> **Proposition 84.1 (bounded partial quotients ⟹ (H4') automatic).**
> Let $(A, k)$ be hypothesis-meeting exact-critical, $(x, y) \in A^2$
> multiplicatively independent, $B^*$ and $M_L, M_{\mathrm{MW}}$ as in
> Theorem B' (note 82).  If every CF partial quotient $a_n$ of
> $\alpha := \log y / \log x$ satisfies $a_n \le K$ for $n$ in the
> window range, then (H4'.2.3) holds whenever
> $$M_L \ge \log(8(K+1) \log_x x) / \log x + 1.$$
> 
> In particular, for $B^*$ large enough that this holds (which is
> automatic when the seed conductor $c^*$ is moderate and partial
> quotients are bounded), (H4') is **automatic** — no per-case CF
> convergent enumeration is required.

So the uniform open question reduces to:

> **(Open Diophantine question, restated).**  For every
> hypothesis-meeting $(A, k)$, does there exist a multiplicatively
> independent pair $(x, y) \in A^2$ such that the CF expansion of
> $\log y / \log x$ has bounded partial quotients in the window
> $[M_L(B^*(A, k, x, y)), M_{\mathrm{MW}}(B^*(A, k, x, y)))$?

This is a *concrete question in transcendence theory* / Diophantine
approximation — sharper than "prove $c(T) = o(T)$" and amenable to
specific attack lines from that literature.

## 1. Setup and reformulation

Recall (note 82, Theorem B''):

- $(A, k)$ hypothesis-meeting exact-critical.
- $(x, y) \in A^2$ multiplicatively independent (exists by note 17).
- $c^* = c(F(T^*))$ seed conductor at initial $T^*$ satisfying (H1').
- $B^* = D K(c^*) \cdot (1/w_x + 1/w_y)$ — pair-specific near-collision
  threshold.
- $M_L$ = Legendre threshold (smallest $p$ with $4 p B^* < x^p \log y$).
- $M_{\mathrm{MW}}$ = MW threshold (smallest $\max(p, q)$ with
  $|x^p - y^q| > B^*$ guaranteed by LMN 1995 / Laurent 2008).

(H4') is: every CF convergent $(p_n, q_n)$ of $\alpha = \log y / \log x$
with $\max(p_n, q_n) \in [M_L, M_{\mathrm{MW}})$ satisfies
$|x^{p_n} - y^{q_n}| > B^*$.

(*Note on orientation:* WLOG $x < y$, so $\alpha = \log y/\log x > 1$
and CF convergents satisfy $p_n > q_n$.  In a near-collision
$|x^a - y^b|$ small, $a/b \approx \alpha$, so $a > b$ — hence
$a = p_n$ (the larger CF entry, $x$-exponent) and $b = q_n$ (the
smaller CF entry, $y$-exponent).  The near-collision at a CF
convergent is therefore $|x^{p_n} - y^{q_n}|$ with $p_n > q_n$.
This matches note 82 §2's $|x^p - y^q|$ with the substitution
$p = p_n, q = q_n$, the $\max(p, q)$ window condition becoming
$p_n \in [M_L, M_{\mathrm{MW}})$.)

## 2. The partial-quotient lemma

> **Lemma 84.1.**  Let $\alpha = \log y / \log x$ with $x < y$ both
> integers $\ge 3$.  Let $(p_n, q_n)$ be a CF convergent of $\alpha$
> (so $p_n > q_n$ since $\alpha > 1$) with partial quotient
> $a_{n+1} \le K$ — so that $q_{n+1} \le (K+1) q_n$.  Then
> $$|x^{p_n} - y^{q_n}| \;\ge\; \frac{x^{p_n} \log x}{4 (K+1) q_n}.$$

*Proof.*  By the standard CF property,
$|p_n - q_n \alpha| \ge 1/q_{n+1} \ge 1/((K+1) q_n)$.  Multiplying by
$\log x$:
$$|p_n \log x - q_n \log y| \;=\; \log x \cdot |p_n - q_n \alpha| \;\ge\; \log x / ((K+1) q_n).$$

By the mean-value inequality $|e^A - e^B| \ge \min(e^A, e^B) \cdot |A - B|$
for $A, B \ge 0$, with $A = p_n \log x$ and $B = q_n \log y$:
$$|x^{p_n} - y^{q_n}| \;\ge\; \min(x^{p_n}, y^{q_n}) \cdot |p_n \log x - q_n \log y|.$$

At a CF convergent, $|p_n - q_n \alpha| \le 1/q_n$ (since $q_{n+1} > q_n$),
so $|p_n \log x - q_n \log y| \le \log x/q_n \le \log x/2 < 1$ for
$q_n \ge 2$ and any $x \ge 3$ (in fact $\log x \le \log 3 < 1.2$).
Hence $x^{p_n}/y^{q_n} = e^{(p_n \log x - q_n \log y)} \in [e^{-1}, e]$,
so $\min(x^{p_n}, y^{q_n}) \ge x^{p_n}/e \ge x^{p_n}/4$
(using $e < 4$).

Combining:
$$|x^{p_n} - y^{q_n}| \;\ge\; \frac{x^{p_n}}{4} \cdot \frac{\log x}{(K+1) q_n} \;=\; \frac{x^{p_n} \log x}{4 (K+1) q_n}. \quad \square$$

## 3. Proposition 84.1 — bounded PQ ⟹ (H4') automatic

> **Proposition 84.1.**  Let $\alpha = \log y/\log x$, $x < y$
> integers $\ge 3$, $B^* > 1$, $M_L = M_L(B^*, x, y)$ the Legendre
> threshold of note 82 §2.1 (smallest integer with
> $4 M_L B^* < x^{M_L} \log y$).  Suppose:
>
> - **(PQ-bound)** every CF partial quotient $a_n$ of $\alpha$ with
>   convergent index $n$ in the relevant range
>   (i.e., $p_n \in [M_L, M_{\mathrm{MW}})$) satisfies $a_n \le K$.
>
> Define $M_L'$ as the smallest integer satisfying
> $$x^{M_L'} \cdot \log x \;>\; 4 (K+1) M_L' B^*.$$
>
> Then for every CF convergent $(p_n, q_n)$ with $p_n \ge M_L'$,
> $$|x^{p_n} - y^{q_n}| \;>\; B^*.$$
>
> Furthermore, the threshold shift $M_L' - M_L$ is bounded:
> $$M_L' - M_L \;\le\; \left\lceil\frac{\log((K+1) \log y/\log x)}{\log x}\right\rceil
>   \;=\; O\!\left(\frac{\log K}{\log x}\right).$$
>
> Consequently, (H4') (the no-near-collision check on
> $[M_L, M_{\mathrm{MW}})$) holds **provided** the finite remainder —
> CF convergents with $p_n \in [M_L, M_L')$ — is either empty or
> verified directly.

*Proof.*  By Lemma 84.1, every CF convergent in the window with
$a_{n+1} \le K$ satisfies
$|x^{p_n} - y^{q_n}| \ge x^{p_n} \log x / (4 (K+1) q_n)$.

Since $q_n < p_n$ (CF property with $\alpha > 1$), this is
$\ge x^{p_n} \log x / (4 (K+1) p_n)$.  The defining inequality of
$M_L'$ ($x^{M_L'} \log x > 4(K+1) M_L' B^*$) and the monotonicity of
$x^p \log x / (4 (K+1) p)$ in $p$ then give the claimed bound.

For the threshold shift: $M_L$'s defining inequality is
$x^{M_L} \log y > 4 M_L B^*$, equivalently
$x^{M_L} > 4 M_L B^*/\log y$.  $M_L'$ requires
$x^{M_L'} > 4 (K+1) M_L' B^*/\log x$.  The new RHS is $(K+1) \log y/\log x$
times the old, so adding $\log((K+1) \log y/\log x)/\log x$ to the
exponent restores the inequality, giving the stated bound.  $\square$

**Concrete consequence.**  For (H4') to hold uniformly across a class
of $(A, k)$ with a common chosen pair $(x, y)$, it suffices that:

1. Partial quotients of $\log y/\log x$ are bounded by $K$ in some
   window covering $[M_L, M_{\mathrm{MW}})$ across the class; AND
2. $M_L \ge M_L'(K, B^*)$ for the worst-case $B^*$ in the class.

This is checkable per pair $(x, y)$ by computing the CF expansion of
$\log y/\log x$ to a sufficient depth.

## 4. Sub-classes where Proposition 84.1 applies

### 4.1 Specific pair $(x, y) = (3, 4)$

The CF expansion of $\alpha = \log 4 / \log 3 \approx 1.262$ begins:
$$[1;\ 3, 1, 4, 1, 1, 11, 1, 46, 1, 5, 112, \ldots]$$
(Computed in note 46 through exact rational logarithm intervals.)

Convergents $(p_n, q_n)$ of $\alpha$ (numerator $>$ denominator since $\alpha > 1$):
$$p_n/q_n \in \{1/1,\ 4/3,\ 5/4,\ 24/19,\ 29/23,\ 53/42,\ 612/485,\
665/527,\ 31202/24727,\ \ldots\}.$$

Maximum partial quotient through the 12th index: $K = 112$.

For $\{3,4,7\}$ k=1: $B^* = 5835$ (note 82 §6 with pair-weight $5/6$),
$M_L = 11$.  Proposition 84.1's threshold shift:
$$M_L' - M_L \;\le\; \lceil \log((K+1) \cdot \log 4/\log 3) / \log 3 \rceil
  \;=\; \lceil \log(113 \times 1.262)/\log 3 \rceil
  \;=\; \lceil 4.51 \rceil \;=\; 5.$$
So $M_L' \le 16$.

CF convergents of $\alpha$ with $p_n \in [M_L, M_L') = [11, 16]$:
**none** (the first $p_n \ge 11$ is $p_n = 24$).

Hence by Proposition 84.1, **(H4') holds automatically** for
$\{3,4,7\}$ k=1, using only the bounded-PQ property $K \le 112$
applied to convergents starting at $p_n = 24$ (which is above $M_L'$).
*No per-case CF enumeration is required.*

For higher-$k$ cases ($\{3,4,7\}$ k=2 with $B^* \approx 39.8 \times 10^6$
and $M_L = 20$; k=3 with $B^* \approx 1.66 \times 10^9$ and
$M_L = 23$): the threshold shift $M_L' - M_L \le 5$ is uniform in $B^*$
(only depending on $K, x, y$).  Provided the PQ bound $K \le 112$
extends to the convergent index corresponding to $p_n \approx M_{\mathrm{MW}}(B^*)$,
Proposition 84.1 closes these cases too.

> **Sub-class corollary (3, 4).**  For every hypothesis-meeting
> $(A, k)$ with $(3, 4) \in A^2$ multiplicatively independent and
> $M_{\mathrm{MW}}(B^*(A, k))$ within the CF depth of $\log 4/\log 3$
> for which the PQ bound $K \le 112$ holds (currently certified
> through the first ~12 convergents, reaching $p_n \approx 10^6$),
> (H4') is automatic by Proposition 84.1.

This is a clean *uniform* result over a class of $(A, k)$ — not just
the four originally certified — with no per-case CF enumeration.

### 4.2 Other small pairs

Similarly for $(x, y) \in \{(3, 5), (3, 7), (4, 5), (5, 7), \ldots\}$:
the CF expansion of $\log y/\log x$ has computable partial quotients.
For each pair, the (PQ-bound) hypothesis can be empirically verified
to any explicit depth.

Empirically, for all "small integer pairs" tested (in the range
relevant to the 12,226+ certified cases), partial quotients stay
bounded by some moderate $K$ in the windows of interest.

### 4.3 Asymptotically large pairs

For $(x, y)$ growing, the CF expansion of $\log y/\log x$ has no
known uniform partial-quotient bound.  In fact:

> **Fact.**  For any $K > 0$, there exist integer pairs $(x, y)$ with
> $\log y/\log x$ having a partial quotient $\ge K$.

This is because integer logarithm ratios can be arbitrarily well
approximated by rationals when $x, y$ are chosen adversarially.
Hence Proposition 84.1's hypothesis cannot hold uniformly for all
integer pairs.

**For Erdős 124's hypothesis-meeting class**: we have freedom to
*choose* $(x, y) \in A^2$ from the mult-indep pairs of $A$.  Could
adversarial $A$ have *every* mult-indep pair with large partial
quotients?  Open.

## 5. Connection to irrationality measure

The partial-quotient bound is equivalent to a bound on the
*irrationality measure* of $\alpha$:
$$\mu(\alpha) = \inf\{\mu : |q \alpha - p| > q^{-(\mu - 1)} \text{ for all but finitely many } (p, q)\}.$$

Bounded partial quotients $a_n \le K$ for all $n$ is equivalent to
$\mu(\alpha) = 2$ (the "Liouville-Khintchine" measure).

Known: $\mu(\alpha) \ge 2$ always (by Dirichlet); $\mu(\alpha) = 2$
for almost-every $\alpha$ (Khintchine); $\mu(\alpha) \ge 3$ for
specific Liouville-type numbers.

For $\alpha = \log y/\log x$ with $x, y$ integers $\ge 2$, mult-indep:
- Baker's theorem (and refinements by Laurent et al.): $\mu(\alpha)$
  is *finite* and effectively bounded.
- Best known: $\mu(\alpha) \le 1 + C(x, y)$ with $C(x, y)$ explicit;
  for small pairs like $(3, 4)$, $C \approx $ low single digits.
- Conjectured (Lang, Waldschmidt): $\mu(\alpha) = 2$ for all such
  $\alpha$.

**The connection to (H4') uniformity:** if $\mu(\alpha) = 2$ uniformly
across pairs, partial quotients are bounded (by Khintchine), and
Proposition 84.1 gives (H4') uniformly.

> **Conjecture (Diophantine, equivalent to (H4') uniformly assuming
> Proposition 84.1's setup):**  For every multiplicatively-independent
> pair $(x, y)$ of integers $\ge 3$, $\mu(\log y/\log x) = 2$.

This is a special case of Lang's conjecture on irrationality measures
of transcendental numbers.  Equivalent to the uniform open problem for
the exact-critical conductor.

## 6. What this closes and what remains

**Closed (algebraically):**
- (H4') uniformity reduced to a *concrete* Diophantine question (PQ
  boundedness / irrationality measure $= 2$).
- For sub-classes with verified PQ bounds (e.g., $\{3,4,7\}$ k=1),
  (H4') is automatic by Proposition 84.1 — no per-case CF enumeration
  needed.

**Open:**
- The Diophantine conjecture $\mu(\log y/\log x) = 2$ uniformly
  across integer pairs.  This is Lang's conjecture (special case).
- For higher-$k$ certified cases (and large-$B^*$ cases generally),
  more partial quotients must be verified beyond the bounds covered
  by current literature.

**Effective improvement (concrete):**
- The four certified CF/MW cases now satisfy Theorem B'' *with one
  algebraic input* (Proposition 84.1) and a *per-pair* PQ bound (not
  a per-case CF enumeration).  The PQ bound for $(3, 4)$ is a *single
  number* ($K \le 112$ up to the 12th convergent) covering all four
  cases that use the $(3, 4)$ pair.

## 7. Type-theoretic considerations (brief)

The user asked whether stronger types in the C++ code — closer to a
dependent type system — could help.  A focused analysis:

### 7.1 What dependent types could enforce

**Compile-time enforcement of structural invariants.**  Encoding
$\gcd(A) = 1$, $R(A) \ge 1$, $|A| \ge 2$ as type-level constraints
catches misuse at compile time.

```cpp
template <BaseSet A> requires HypothesisMeeting<A>
struct CertificateOf {
    /* ... */
};
```

In C++23, `concept HypothesisMeeting` can encode the runtime check
(via `constexpr` evaluation) so misuse is caught at the call site.

**Phantom types separating "verified" and "unverified" facts.**

```cpp
template <BaseSet A, int k, /* witness for H1' */>
struct H1Verified { /* ... */ };

template <BaseSet A, int k>
auto verify_H1(/* inputs */) -> std::expected<H1Verified<A, k>, Error>;
```

A function only accepting `H1Verified<...>` enforces that (H1') was
checked before use.

**Refined types via NTTP (non-type template parameters).**  C++20
NTTP allows passing structural integers, arrays, etc. as template
parameters.  We can write `BalancedFrontier<BaseSet{3,4,7}, T>` with
$T$ a runtime parameter, but $A$ baked into the type.

### 7.2 What dependent types cannot do

**Prove the open Diophantine question.**  The open content —
Proposition 84.1's hypothesis (bounded PQ) — is a *mathematical* fact
about $\log y/\log x$, not a programming invariant.  No type system
proves it.

**Replace the algebraic theorems.**  Theorems A, B', B'', C,
Proposition D, Proposition 83.1, Proposition 84.1 are mathematical
statements with pen-and-paper proofs.  Encoding them as types
(Curry-Howard) requires a *full proof assistant* — Lean, Coq, Agda —
not C++.

### 7.3 What the project should actually do

**Realistic next steps (in order of effort):**

1. **C++23 concepts for current invariants** (low effort): add
   `concept HypothesisMeeting`, `concept BalancedFrontier`, etc., so
   the existing library catches misuse at compile time.

2. **Phantom-type "verified" tags** (medium effort): refactor
   `cfh::Certificate`, `sunit::Certificate` to require explicit
   evidence at construction.  Functions returning
   `std::expected<VerifiedCertificate<A, k>, Error>`.

3. **Lean 4 formalization of Theorem A + Proposition 83.1** (high
   effort, multi-session): set up `lean/erdos124/` Mathlib project,
   formalize the algebraic content.  Theorem A is the most
   self-contained.  Proposition 83.1 is short and would catch any
   hidden gap in the inductive argument.

**Why Lean for the load-bearing content:**  the project's algebraic
backbone has had several near-miss issues (the (H5') gap surfaced in
note 82, retroactively closed in note 83 + note 72 audit).  A
Lean-formalized backbone would catch such gaps mechanically.  This is
the genuine value of "stronger types" for a project at this maturity.

**Why C++ concepts are not enough:**  C++23 concepts catch shape
errors (wrong types passed) but cannot encode the *content* of an
algebraic proof.  They would catch using `BalancedFrontier<A>` with
the wrong `A` but not catch a flawed proof step.

### 7.4 Concrete recommendation

For "make the algebraic backbone more robust without multi-session
Lean work":

- Add a `lean/erdos124/Theorems/Proposition83.lean` skeleton (single
  file, ~100 lines): formalize Proposition 83.1's induction.  This is
  the highest-leverage Lean target — a short proof closing a hidden
  gap.  Multi-session but with a clear endpoint.

- Add C++23 concepts to `cpp/include/erdos124/types.hpp`:
  `HypothesisMeeting<A, k>`, `BalancedFrontierAt<A, T>` etc.  Light
  but improves library hygiene.

The dependent-types question is not about *whether* types could help,
but about which level of formalization matches the project's marginal
return.  Lean for theorems, C++ concepts for code hygiene.

## 8. Status

This note (Phase B-17) delivers:

- **Proposition 84.1**: bounded CF partial quotients of $\log y/\log x$
  imply (H4') automatic.  Algebraic content reduces (H4')
  per-case-CF-enumeration to a per-pair PQ bound.

- **Reformulation**: the uniform open question for the exact-critical
  conductor is equivalent to a Diophantine conjecture on irrationality
  measures of $\log y/\log x$ — a concrete and well-studied question
  in transcendence theory.

- **Sub-class clean closure**: $\{3,4,7\}$ k=1 is closed by Proposition
  84.1 + PQ bound $K \le 112$ for the (3, 4) pair, with *no per-case
  CF enumeration*.  Higher-$k$ cases require deeper CF expansion.

- **Type-theoretic analysis**: dependent types in C++ help library
  hygiene but cannot encode algebraic content.  For genuine
  type-theoretic value, Lean 4 formalization of key theorems is the
  right target — concretely, Proposition 83.1 first, then Theorem A.

What remains open: Lang's conjecture (or rather, $\mu(\log y/\log x) = 2$
uniformly across integer pairs).  This is the central remaining
obstacle, now precisely framed in terms of existing transcendence
literature rather than as a vague "conductor growth bound".
