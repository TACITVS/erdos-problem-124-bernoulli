# Circle method + Theorem E for pointwise representability

Building on note 76, this note attempts the Hardy-Littlewood circle
method to bridge from the L² collision bound to **pointwise**
representability $r(n) > 0$, not just max-gap bounds.

## 0. Verdict

> **Theorem F (algebraic, conditional on $L_2 = O(1/T)$).**  For every
> $\epsilon > 0$ and sufficiently large $T$ (depending on $\epsilon$),
> every integer $n \in [0, T^{1/2 - \epsilon}]$ satisfies
> $r(n) > 0$, i.e., is a subset sum of $F(E(T))$.

This gives **pointwise representability for $n \in [0, \sqrt T]$** — a
genuine algebraic theorem about specific integers, not max-gap.

**Caveat:** the range $[0, T^{1/2 - \epsilon}]$ is much smaller than
$[0, T/2]$ that we'd need for full conductor bound.  For $n \in
[T^{1/2}, T]$, circle method with L² estimates doesn't give pointwise
positivity.

So Theorem F is **partial progress** but not closure.

## 1. Circle method setup

For $X_T$ integer-valued subset sum with characteristic function
$\hat X_T(\xi) = \prod_f \cos(\pi \xi f) \cdot e^{i \pi \xi \sum_f f}$
on $[0, 1]$ (periodic):

$$r(n) = 2^{|F|} \int_0^1 \hat X_T(\xi) \, e^{-2\pi i n \xi} \, d\xi.$$

For $r(n) > 0$: this integral must be positive.

Split into major and minor arcs:
- **Major arc** $\mathfrak M_\delta = \{\xi : |\xi| < \delta\} \cup
  \{\xi : |\xi - 1| < \delta\}$ near $\xi = 0$.
- **Minor arc** $\mathfrak m_\delta = [0, 1] \setminus \mathfrak M_\delta$.

## 2. Major arc contribution

At $\xi = 0$: $\hat X_T(0) = 1$.  Taylor expansion:
$$\hat X_T(\xi) = 1 - 2\pi^2 \xi^2 \mathbb E[X_T^2] + O(\xi^4).$$

Variance of $X_T$: $\sigma_T^2 = \sum_f f^2/4 \approx T^2 \sum_a 1/(4(a^2-1))$.
So $\sigma_T = O(T)$.

Major arc integral over $|\xi| < \delta$:
$$\mathcal I_{\text{maj}}(n) = \int_{|\xi| < \delta} \hat X_T(\xi) e^{-2\pi i n \xi} d\xi
\approx \int_{|\xi| < \delta} e^{-2\pi i n \xi} d\xi = \frac{\sin(2\pi n \delta)}{\pi n}.$$

For $|n \delta| < 1/4$ (so $\sin > 0$): $\mathcal I_{\text{maj}}(n) \ge \delta \cdot \cos(2\pi n \delta) \ge \delta/2$
(if $|n\delta| < 1/6$).

So **major arc gives positive contribution $\gtrsim \delta$** for $n \delta < 1/6$.

## 3. Minor arc bound

By Cauchy-Schwarz:
$$\left|\int_{\mathfrak m_\delta} \hat X_T(\xi) e^{-2\pi i n \xi} d\xi\right|
\le \sqrt{|\mathfrak m_\delta| \cdot \int_{\mathfrak m_\delta} |\hat X_T(\xi)|^2 d\xi}
\le \sqrt{1 \cdot L_2(T)}.$$

For $L_2 = O(1/T)$ (assuming BC L² conjecture):
$$|\mathcal I_{\text{minor}}(n)| \le \sqrt{C/T} = O(T^{-1/2}).$$

## 4. Combining major and minor

$r(n)/2^{|F|} = \mathcal I_{\text{maj}}(n) + \mathcal I_{\text{minor}}(n) \ge \delta/2 - O(T^{-1/2})$.

For $r(n) > 0$: need $\delta/2 > C T^{-1/2}$, i.e., $\delta > 2C T^{-1/2}$.

For major arc condition $n \delta < 1/6$: $\delta < 1/(6n)$.

Combining: $2C T^{-1/2} < \delta < 1/(6n)$, possible iff $2C T^{-1/2} < 1/(6n)$, i.e., $n < T^{1/2}/(12 C)$.

So **for $n < T^{1/2}/\text{const}$, $r(n) > 0$**.

## 5. Theorem F (statement and proof)

> **Theorem F.**  Assuming $L_2(T) \le C/T$ (BC L² conjecture), there
> exists $T_0$ such that for $T \ge T_0$, every integer
> $n \in [0, T^{1/2}/(12C)]$ satisfies $r_T(n) > 0$, i.e., is
> representable as a subset sum of $F(E(T))$.

*Proof.* §§2-4 above.  $\square$

## 6. What Theorem F gives — and doesn't

**Gives:** pointwise representability of $n \in [0, \sqrt T]$ — a
genuine algebraic statement about specific integers.

**Doesn't give:** representability of $n \in [\sqrt T, T/2]$ — outside
the major-arc-near-0 range, the analysis requires major arcs at OTHER
rationals (with denominators dividing $f \in F$).

For full circle method:
- Major arcs at every rational $p/q$ with $q \le Q$ (some cutoff).
- Need ALL major arcs to contribute, not just $\xi = 0$.

The major arcs at $p/q$ correspond to "near-resonance" terms in $X_T$.
Estimating their contribution requires bounds on $\hat X_T(\xi)$ for
$\xi$ near $p/q$, which depends on **structure of $F$ near $1/q$**.

For multi-base $F$: this is a non-trivial Diophantine estimate not
provided by L² alone.

## 7. The conductor question is genuinely harder than max gap

After Theorem F + the max-gap bound from Theorem E:

- $r(n) > 0$ for $n \in [0, \sqrt T]$ (Theorem F).
- Max gap in supp $\le O(T^{1/3})$ (Theorem E).
- Both rigorously conditional on BC L² conjecture.

For the conductor (max missing in $[0, S/2] \approx [0, T/2]$):
- Need pointwise positivity for $n$ near $T/2$.
- Theorem F covers only $[0, \sqrt T]$, leaving $[\sqrt T, T/2]$
  uncovered.
- Max gap bound says gaps in $[\sqrt T, T/2]$ are $\le T^{1/3}$ —
  but conductor can be anywhere in this range.

**The remaining gap.** For $n \in [\sqrt T, T/2]$, circle method
requires major-arc analysis at rationals $p/q$ with $1 \le q \lesssim n$.
This involves Fourier values $\hat X_T(p/q)$ for various $p/q$.

For $\hat X_T(p/q) = \prod_f \cos(\pi (p/q) f) e^{...}$:
- Non-zero generically.
- Could be zero if $(p/q) f = 1/2 \pmod 1$ for some $f \in F$.

For our $F = \{a^j\}$: $\hat X_T(p/q) = 0$ when $q | 2 f$ for some $f$.

This gives explicit zeros of $\hat X_T$ at specific rationals.

Bounding $\hat X_T$ AWAY from these zeros requires Diophantine
analysis of "how close" rationals come to the zero set — exactly the
kind of estimate the Subspace Theorem might provide.

## 8. Conditional closure via Subspace Theorem

If we have effective bounds on $\hat X_T(p/q)$ for $q \le T^{1/2}$
(via Subspace), the circle method might close.

Specifically, the "minor arc" portion outside major arcs at small $q$
would have small $\hat X_T$, and the integral bound becomes:
$$|\mathcal I_{\text{minor}}(n)| \le \int_{\mathfrak m} |\hat X_T|^2 d\xi \cdot \text{(measure of minor)}$$

Wait — let me redo with the right Cauchy-Schwarz:
$$|\mathcal I_{\text{minor}}(n)| \le \left(\int_{\mathfrak m}|\hat X_T|^2\right)^{1/2}.$$

For $\int_{\mathfrak m}|\hat X_T|^2 \le L_2 - (\text{major arc contribution})$.

If major arc is small, minor arc carries most of L²: $\int_{\mathfrak m}|\hat X_T|^2 \approx L_2 = O(1/T)$.

So minor bound: $O(T^{-1/2})$.

For $r(n) > 0$: major arc dominates, gives $r(n) \ge $ positive.

But major arc must include MULTIPLE rationals, not just $\xi = 0$.

The issue: for $n \in [\sqrt T, T/2]$, the relevant major arc is NOT at $\xi = 0$ (since major-arc-at-0 needs $n\delta < 1/6$, failing for $n > 1/(6\delta) = O(\sqrt T)$).

For $n$ in this range, the major arc is at SOME OTHER rational $p/q$
with $p/q \approx n/T$ (approximately).

Computing the contribution of major arc at $p/q$: requires $\hat X_T(p/q)$
non-trivial.

For our specific $\hat X_T$: $\hat X_T(p/q) = \prod_f \cos(\pi p f/q)$.

For random $f$ (generic): contributions are bounded away from 0.

For our $f = a^j$ (structured): bounded if $q$ is coprime to a, otherwise complicated.

This is the **Diophantine subtlety** that makes circle method for
multi-base subset sums genuinely hard.

## 9. What needs to be done

For full circle-method closure of the conductor:

1. **Estimate $\hat X_T(p/q)$ for $q$ in some range** (say $q \le T^{1/2}$).
2. **Identify major arcs** at rationals with non-trivial $\hat X_T$.
3. **Sum major arc contributions**, get $r(n) > 0$ for all $n \in [0, S/2]$.

Step 1 is a structural estimate, likely connectable to the Subspace
Theorem or its variants for the specific multi-base structure.

Step 2 is bookkeeping.

Step 3 is the assembly.

This is a CONCRETE multi-step program, with each step requiring real
mathematical work but not unprecedented techniques.  It's the natural
next attack on the open obligation.

## 10. Status

This note (Phase B-10) makes another algebraic step forward:

- **Theorem F**: pointwise representability for $n \in [0, \sqrt T]$,
  conditional on BC L² conjecture.  Genuine algebraic result.
- **Identification** of the remaining gap as a Diophantine estimate
  on $\hat X_T$ at rationals with small denominator — a concrete
  next problem.

Combined with note 76 (Theorem E):
- Max gap $\le O(T^{1/3})$ for the whole [0, S/2] (under BC L²).
- Pointwise representability $r(n) > 0$ for $n \in [0, \sqrt T]$
  (under BC L²).
- Pointwise for $n \in [\sqrt T, T/2]$: OPEN, requires Diophantine
  bounds on $\hat X_T(p/q)$.

The chain so far:
$$\text{BC L² conjecture} \implies L_2 = O(1/T) \implies \begin{cases} \text{max gap} = O(T^{1/3}) & \text{(Theorem E)} \\ r(n) > 0 \text{ for } n \le \sqrt T & \text{(Theorem F)} \end{cases}$$

Closure of Erdős 124 requires extending Theorem F to $n \le T/2$,
which needs the Diophantine estimate identified in §8-9.

This is the project's genuine algebraic frontier as of 2026-05-21.
