# Erdős 124 and its connections to other open problems

A focused synthesis of how Erdős Problem 124 connects to other open
problems in number theory, transcendence theory, and analysis.

The connections are organized in three tiers by how *load-bearing*
each is for the project's reduction chain.

## 0. Headline

> **The single open question that closes Erdős 124 (modulo our
> algebraic chain Theorems A, B'', C, Prop D, Prop 83.1, 84.1, 84.2,
> 87.1) is:**
>
> > For every multiplicatively-independent pair $(x, y)$ of integers
> > $\ge 2$, $\mu(\log y/\log x) = 2$.
>
> This is a **special case of Lang's conjecture** on irrationality
> measures of transcendental numbers.  It is unresolved.
>
> Below, we trace how Lang's conjecture, the ABC conjecture, the
> Subspace Theorem (and its effective forms), Pillai's equation,
> Mihăilescu's theorem, and Schanuel's conjecture relate to our
> problem — and what closure of each would mean for Erdős 124.

---

## 1. Tier 1: load-bearing connections

These open problems are *directly* in our reduction chain.  Closure
of any one would (modulo the rest of the chain) close Erdős 124 or
substantially advance it.

### 1.1 Lang's conjecture on irrationality measure

**Statement.**  For every irrational number $\alpha$ that is
transcendental, $\mu(\alpha) = 2$, where $\mu(\alpha)$ is the
irrationality measure:
$$\mu(\alpha) \;=\; \inf\bigl\{\mu : |q\alpha - p| > q^{-(\mu-1)}
                                       \text{ for all but finitely many } (p, q) \in \mathbb Z_{>0}^2\bigr\}.$$

**Status.**  Open.  Known:
- $\mu(\alpha) \ge 2$ for all irrational $\alpha$ (Dirichlet).
- $\mu(\alpha) = 2$ for almost-every $\alpha$ (Khintchine).
- $\mu(\alpha) = 2$ for algebraic irrational $\alpha$ (Roth 1955;
  Roth got the Fields Medal for this).
- For specific transcendentals: explicit upper bounds via Baker /
  Laurent–Mignotte–Nesterenko, with $\mu(\log p/\log q)$ in the
  range $[2, \sim 10]$ for small integer pairs.
- Best known: $\mu(\log 2/\log 3) \le 5.117$ (Rhin 1987;
  sharpened since).

**Connection to Erdős 124.**  Our **Proposition 84.1** (note 84)
shows: if $\alpha = \log y/\log x$ has bounded CF partial quotients
(equivalently $\mu(\alpha) = 2$), then (H4') is automatic in the
window of interest.

Our **Proposition 84.2** (note 86) gives the same conclusion in the
asymptotic regime from any *finite* $\mu_0$ bound — but the
intermediate window remains a per-case computation unless $\mu = 2$.

If Lang's conjecture is established for $\log y/\log x$ across all
mult-indep integer pairs uniformly: the intermediate window
collapses to zero, (H4') holds uniformly, hence (modulo our
algebraic chain) **Erdős 124 holds for every hypothesis-meeting
$(A, k)$**.

**What knowing it would buy.**  Closes Erdős 124 (the project's
single open obligation) at the cost of inheriting a *much more
famous* open problem.

### 1.2 ABC conjecture (Masser–Oesterlé)

**Statement.**  For every $\epsilon > 0$, there are only finitely
many triples $(a, b, c)$ of coprime positive integers with
$a + b = c$ and $c > \mathrm{rad}(abc)^{1+\epsilon}$, where
$\mathrm{rad}(n) = \prod_{p | n} p$.

**Status.**  Open.  (Mochizuki's proposed proof via inter-universal
Teichmüller theory remains unverified by the wider mathematical
community as of 2026.)

**Connection to Erdős 124.**  ABC implies **effective Pillai**
(Stewart–Yu 2001): the equation $a^x - b^y = c$ has effectively
boundable solutions for each fixed coprime $a, b, c$.  Effective
Pillai gives EXPLICIT bounds on $|x^p - y^q|$ for fixed $x, y$ and
varying $p, q$ — a *strong* form of MW.

For our problem: ABC + effective Pillai would replace
Laurent–Mignotte–Nesterenko's effective constants with sharper ones,
typically tight enough to close the intermediate window in (H4')
explicitly per case.

**What knowing it would buy.**  Sharper $\mu$ bounds for
$\log y/\log x$ (perhaps approaching $\mu = 2$ effectively), without
needing Lang's conjecture in full.  Would close Erdős 124 for *many
more* cases unconditionally, possibly all hypothesis-meeting ones.

### 1.3 Effective Subspace Theorem (Schmidt 1972)

**Statement (Schmidt).**  For $n \ge 2$, $\epsilon > 0$, and linear
forms $L_1, \ldots, L_n$ in $n$ variables with algebraic
coefficients in general position, the integer solutions $\mathbf x$
to
$$\prod_i |L_i(\mathbf x)| < |\mathbf x|^{-\epsilon}$$
lie in finitely many proper subspaces of $\mathbb Q^n$.

**Status.**  The qualitative theorem is **proved** (Schmidt; refined
by Schlickewei, Evertse).  **Effective** versions — giving explicit
bounds on solution sizes — are **open** in full generality.

**Partial effective forms exist:**
- For $n = 2$: Roth's theorem (effective for algebraic targets;
  ineffective for transcendental).
- Bilu–Tichy (2000): effective for special families.
- Evertse–Györy: effective for $S$-unit equations.

**Connection to Erdős 124.**  Proposition D (note 73) uses the
Subspace Theorem (qualitative) to derive the bounded-or-linear
dichotomy for $c(F(E_T))$.  An **effective** version would yield
explicit constants in Proposition D, possibly allowing the linear
case to be ruled out for specific $A$.

**What knowing it would buy.**  Effective Subspace at our level
would give the same effective gains as ABC — closing more cases of
Erdős 124 with explicit thresholds.

### 1.4 Mignotte–Waldschmidt / Laurent–Mignotte–Nesterenko

**Statement (LMN 1995).**  For multiplicatively-independent positive
integers $x, y \ge 2$ and positive integers $p, q$ with
$\max(p, q) \ge 2$:
$$\log |x^p - y^q| \;\ge\; \max(p \log x, q \log y) - C \log\max(x, y) \cdot (8 + \log\max(p, q))^2$$
for an explicit absolute constant $C$ (around 500 in LMN, sharpened
in Laurent 2008).

**Status.**  **Known** (proved unconditionally; this is a closed
theorem of transcendence theory).

**Connection to Erdős 124.**  This is the project's *single
imported analytic input* after note 82's Theorem B''.  It replaces
the qualitative S-unit finiteness theorem with an effective bound,
giving effective Erdős 124 per certified case.

**What knowing it would buy.**  Already used; sharpened forms
(Laurent 2008+) tighten the per-case thresholds but don't change
the fundamental closure picture.

---

## 2. Tier 2: closely related but not load-bearing

### 2.1 Pillai's equation and Pillai's conjecture

**Statement (Pillai 1945).**  For fixed $c \ne 0$ and integers
$x, y \ge 2$, the equation $a^x - b^y = c$ in positive integers
$(a, b)$ has only finitely many solutions.  *Strong form*: the
solutions are *effectively* boundable in $c, x, y$.

**Status.**  The qualitative finiteness for each *fixed* $(c, x, y)$
follows from MW.  The *strong* effective form is implied by ABC; not
known unconditionally.

**Connection to Erdős 124.**  Our near-collision bound
$|x^m - y^n| \le B^*$ for a *varying* $B^*$ is essentially Pillai's
equation with $c$ ranging over $[0, B^*]$.  Effective Pillai is
implicit in our reformulation.

The (H4') reformulation (note 84) is structurally a Pillai-style
question: for each pair $(x, y)$ and each $B^*$, count solutions
to $|x^p - y^q| \le B^*$ with $(p, q)$ a CF convergent.

### 2.2 Mihăilescu's theorem (formerly Catalan's conjecture)

**Statement (Mihăilescu 2002).**  $3^2 - 2^3 = 1$ is the only
solution to $x^p - y^q = 1$ in positive integers $x, y > 1$ and
$p, q > 1$.

**Status.**  **Proved** (Mihăilescu 2002).

**Connection to Erdős 124.**  A very specific instance of our
near-collision bound: $|x^p - y^q| \le 1$ for $x, y > 1$, $p, q > 1$
has the unique solution $(x, p, y, q) = (3, 2, 2, 3)$.  Our (H4')
question generalizes this from "$\le 1$" to "$\le B^*$".

Mihăilescu's proof used cyclotomic field methods specific to the
$c = 1$ case.  Generalizing his techniques to bigger $c$ is one
direction for sharper Pillai bounds (Beukers–Stuart style).

### 2.3 Roth's theorem

**Statement (Roth 1955).**  For algebraic irrational $\alpha$ and
$\epsilon > 0$, $|q\alpha - p| > q^{-(1 + \epsilon)}$ for all but
finitely many $(p, q)$.  Equivalently, $\mu(\alpha) = 2$ for
algebraic $\alpha$.

**Status.**  **Proved** (Roth 1955; Fields Medal).

**Connection to Erdős 124.**  Roth handles $\mu$ for *algebraic*
irrationals.  Lang's conjecture extends Roth to *transcendental*
irrationals, which is what we need for $\log y/\log x$.

The known $\mu(\log y/\log x)$ bounds via LMN are *much weaker* than
Roth's algebraic result; transcendence makes the question
genuinely harder.

### 2.4 Schanuel's conjecture

**Statement (Schanuel, ~1960).**  Let $z_1, \ldots, z_n$ be complex
numbers linearly independent over $\mathbb Q$.  Then the field
$\mathbb Q(z_1, \ldots, z_n, e^{z_1}, \ldots, e^{z_n})$ has
transcendence degree $\ge n$ over $\mathbb Q$.

**Status.**  Open.  Implies Lindemann–Weierstrass, Baker, and many
others.

**Connection to Erdős 124.**  Schanuel implies sharp transcendence
results for $\log p/\log q$ ratios.  Specifically, Schanuel ⟹ Lang's
conjecture for many cases (via applying Schanuel to $\log p, \log q$
and their relations).

If Schanuel were proved: Lang's conjecture for $\mu(\log y/\log x)$
would follow, closing our (H4') uniformly, hence (modulo our chain)
Erdős 124.

---

## 3. Tier 3: indirect connections and analogues

### 3.1 Furstenberg's $\times a, \times b$ conjecture

**Statement.**  For coprime $a, b \ge 2$, the only Borel
probability measures on $[0, 1]$ jointly invariant under
$x \mapsto ax \mod 1$ and $x \mapsto bx \mod 1$ and ergodic are
Lebesgue measure and Dirac masses on rational points with bounded
denominators.

**Status.**  Open in general; partial results by Host, Lindenstrauss,
Rudolph.

**Connection to Erdős 124.**  The multi-base structure $\{a^j\}_{a \in A}$
is exactly the setting where $\times a$-actions intersect.  Multi-base
ergodic theory ($\times 2, \times 3$, etc.) is the broader framework.

In the BC L² direction (notes 58–62, retracted in 63–65), Furstenberg
was one of the candidate connections.  Closure of Furstenberg would
give strong equidistribution results on $\{a^j\}$, but the bridge to
our subset-sum problem requires further input (which the retraction
showed isn't direct).

### 3.2 Erdős' original sum-of-reciprocals conjecture

**Statement.**  If $A \subseteq \mathbb N$ with $\sum_{a \in A} 1/a = \infty$,
then every sufficiently large integer is a sum of distinct elements
of $A$ (a "complete sequence" up to a finite set).

**Status.**  Proved for arithmetic progressions, primes, and many
specific cases.  General form open.

**Connection to Erdős 124.**  Our problem is the *power* version of
Erdős' original.  The hypothesis $\sum 1/(d-1) \ge 1$ is the power-set
analogue of $\sum 1/a = \infty$ (heuristically: the "density" of
powers $\{a^j\}_{j}$ in $\mathbb N$ is $\sim 1/(a-1)$).

The two conjectures share structural features but use different
techniques.  Closure of one wouldn't immediately close the other.

### 3.3 Continued fraction expansions of $\log p/\log q$

**Statement (folk conjecture / Khintchine-style).**  For
$\alpha = \log y/\log x$ with $x, y \ge 2$ multiplicatively
independent integers, the CF partial quotients $a_n$ satisfy
$a_n = O((\log n)^{1+\epsilon})$ for any $\epsilon > 0$ (i.e.,
Khintchine behavior).

**Status.**  Open.  Even the much weaker bound $a_n = O(n)$
(polynomial growth) is not known for specific pairs.

**Connection to Erdős 124.**  This is **exactly** what
Proposition 84.1 needs (note 84): bounded partial quotients of
$\log y/\log x$ uniformly across mult-indep pairs.

Khintchine behavior would give a *much sharper* version of
Lang's conjecture for our setting.  Even weaker bounds (PQ
$\le q_n^\epsilon$) would suffice.

### 3.4 Bernoulli convolution absolute continuity

**Statement (BC AC conjecture).**  For multi-base $A$ with
$\sum 1/\log_2 a > 1$, the multi-base Bernoulli convolution
$\mu_A = *_{a \in A} B_{1/a}$ is absolutely continuous (where
$B_\lambda$ is the Bernoulli convolution at parameter $\lambda$).

**Status.**  Open.  Strong empirical support (note 60–62, 80).
For integer-Pisot single-base, Erdős 1939 showed $\mu_a$ is
singular.  Multi-base behavior remains unresolved.

**Connection to Erdős 124.**  The project EXPLORED this direction
(notes 58–62) but **retracted it** (notes 63–65, reinforced by
note 88): even granting BC L² (a weaker statement than BC AC), the
bridge to Erdős 124's conductor bound does not close (LLT obstacle
from $\hat\mu_A \notin L^1$).

So BC AC is an **independently interesting fractal-geometry
problem** but is **not** a route to Erdős 124.

### 3.5 Sylvester–Frobenius / Numerical semigroups

**Statement.**  For coprime positive integers $a_1, \ldots, a_n$,
the largest integer not representable as a non-negative integer
combination $\sum c_i a_i$ (with $c_i \ge 0$) is finite — the
*Frobenius number*.

**Status.**  Closed-form for $n = 2$ (Sylvester: $g(a, b) = ab - a - b$);
no closed-form for $n \ge 3$.  Active area of computational
combinatorics.

**Connection to Erdős 124.**  The single-base version of our
problem (one fixed $a$) reduces to a Frobenius computation on powers
of $a$.  Note 44 reduces same-base sub-cuts to numerical-semigroup
Frobenius.

For multi-base, the structure is richer (powers grow exponentially),
and the Frobenius-like question is harder.  Numerical-semigroup
theorems give partial structural input but don't close the multi-base
case.

---

## 4. Visualizing the connection web

```
              ┌─────────────────────┐
              │ Schanuel conjecture │
              │   (transcendence)   │
              └──────────┬──────────┘
                         │ implies
                         ▼
              ┌─────────────────────┐                 ┌──────────────┐
              │  Lang's conjecture  │                 │ ABC          │
              │  μ(transcend.) = 2  │                 │ conjecture   │
              └──────────┬──────────┘                 └──────┬───────┘
                         │ (special case)                    │ implies
                         ▼                                   ▼
              ┌─────────────────────┐                 ┌──────────────┐
              │ μ(log y/log x) = 2  │                 │ Effective    │
              │ for mult-indep      │                 │ Pillai       │
              │ integer pairs       │                 └──────┬───────┘
              └──────────┬──────────┘                        │
                         │                                   │ sharpens
                         │  needed for                       ▼
                         │  (H4') uniform                ┌──────────────┐
                         │                              │ MW / LMN /   │
                         ▼                              │ Laurent 2008 │
              ┌─────────────────────┐ ◄──────uses──── └──────┬───────┘
              │  Erdős 124 closure  │                        │
              │  via (H4') + B''    │                  ┌─────┴────┐
              └─────────────────────┘                  │ Mihăilescu│
                         ▲                              │ (Catalan) │
                         │                              │ (closed)  │
                         │ via Theorem B''              └───────────┘
                         │
              ┌─────────────────────┐
              │ Proposition 83.1    │   (Proposition D
              │ + 84.1 + 84.2 + 87.1│    + Subspace Thm
              │ (this project)      │    qualitative)
              └─────────────────────┘
                         ▲
                         │
              ┌─────────────────────┐         ┌─────────────────────┐
              │ Effective Subspace  │         │ Roth's theorem      │
              │ Theorem (open)      │         │ (algebraic case;    │
              └─────────────────────┘         │  closed; doesn't    │
                                              │  cover our setting) │
                                              └─────────────────────┘
```

## 5. What this means for the project's positioning

The project's **central open question** sits in the heart of a
network of major transcendence-theory problems:

1. **Erdős 124 ⟸ Lang's conjecture** (special case for integer log
   ratios) — the cleanest reformulation.
2. **Erdős 124 ⟸ ABC** (via effective Pillai sharpening MW) — a
   different angle, sharper effective input.
3. **Erdős 124 ⟸ Schanuel** (via Lang) — the deepest framework.

These are all major open problems in their own right.  Erdős 124's
proof at this level **inherits the difficulty of one of these**.

**Consequence for project strategy:**

- *Direct attack on Erdős 124*: blocked by the above open problems.
- *Connection to community*: the project's reformulation as Lang's
  special case is a **valuable framing** for the transcendence-theory
  community (Solomyak, Shmerkin, Bugeaud, Wu, Saglietti).
- *Computational closure*: 12,226+ specific cases certified, with
  per-pair $\mu$ bounds extending to many more.  This is the
  project's tangible contribution.

The honest positioning: **Erdős 124 is not a single problem; it's a
window into the broader landscape of transcendence theory**, and the
project's algebraic chain makes the connection explicit.

## 6. Status

This note (Phase B-22) consolidates the connections between Erdős 124
and other open problems.  Three tiers:

- **Tier 1 (load-bearing):** Lang's conjecture, ABC, effective
  Subspace, MW/LMN.
- **Tier 2 (closely related):** Pillai, Mihăilescu, Roth, Schanuel.
- **Tier 3 (indirect):** Furstenberg, original Erdős, CF behavior of
  $\log$, BC AC, Sylvester–Frobenius.

The project's contribution: making the connection from Erdős 124 to
Lang's conjecture (special case) **algebraically explicit and tight**
via Theorems A, B'', C, Prop D, Propositions 83.1, 84.1, 84.2, 87.1.
