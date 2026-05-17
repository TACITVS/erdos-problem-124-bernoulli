# Off-resonance equidistribution

This note attacks item (III) from `notes/48_characteristic_function_bound.md`:
the bound on \(|\varphi_A(\theta)|\) for \(\theta\) away from low-denominator
rationals.  It is the *only* remaining analytic obligation in the
generating-function framing; resonances and density-growth conditions are
already handled by notes 47 and 49.

The framing engages with a disparate area: ergodic theory of the \(\times a\)
action on the torus, with Furstenberg's \(\times p,\times q\) rigidity
theorem as the conceptual lens.

## 1. The generic decay rate

For irrational \(\theta\), the orbit \(\{a^n\theta\bmod 1\}_{n\ge0}\)
equidistributes on \([0,1)\) by Weyl's theorem.  Therefore, by Birkhoff's
ergodic theorem applied to the doubling-like map \(x\mapsto ax\bmod 1\),

\[
\lim_{N\to\infty}
\frac{1}{N}\sum_{n=0}^{N-1}\log\bigl|\cos(\pi a^n\theta)\bigr|
=
\int_0^1\log\bigl|\cos(\pi x)\bigr|\,dx
=
-\log 2.
\]

The integral identity is standard
(\(\int_0^{\pi/2}\log\cos t\,dt=-(\pi/2)\log 2\) gives the half-period;
double for the full period).  CAS verification in
`scripts/cas_off_resonance.py` confirms it numerically.

**Generic per-base factor**:

\[
\beta_a(\theta)=\lim_{N\to\infty}\left(\prod_{n=0}^{N-1}\bigl|\cos(\pi a^n\theta)\bigr|\right)^{1/N}=\tfrac12
\quad\text{for almost every }\theta.
\]

## 2. Generic global decay rate

For the full subset-sum characteristic function and balanced frontiers
\(a^{N_a}\approx T\):

\[
|\varphi_A(\theta)|
\;\sim\;
\prod_{a\in A}\bigl(\tfrac12\bigr)^{N_a}
=
2^{-\sum_a N_a}
=
T^{-\sum_a 1/\log_2 a}
\]

for almost every \(\theta\).  The exponent is the *same* algebraic quantity
that appeared in note 47 as the density-growth exponent of the LLT
prediction.

This is striking: the density heuristic and the off-resonance decay rate are
controlled by the same algebraic invariant \(\sum_a 1/\log_2 a\), which is
\(\ge R(A)\ge 1\) by the elementary inequality \(\log_2 a\le a-1\).

So the *generic* off-resonance contribution to the LLT integral is

\[
\int_{\text{generic }\theta}|\varphi_A(\theta)|\,d\theta
\sim T^{-\sum 1/\log_2 a}
\ll T^{-1},
\]

vastly smaller than the Gaussian target \(1/\sigma\sim T^{-1}\).

## 3. The Diophantine bad set

The above is only "almost every \(\theta\)".  The bad set is
\(\theta\) close to low-denominator rationals.  Quantitatively:

For each \(p/q\), the orbit \(\{a^n\theta\bmod 1\}\) tracks
\(\{a^n p/q\bmod 1\}\) within an error \(\sim a^N|\theta-p/q|\) after \(N\)
steps.  Once this error exceeds 1, the orbit decorrelates from the
resonance.

So \(\theta\) at distance \(\eta\) from \(p/q\) "looks like" the resonance
\(p/q\) for the first \(\sim\log_a(1/\eta)\) iterations, then behaves like
generic equidistribution.

Cumulating: \(|\varphi_A(\theta)|\) is bounded by
\(\beta_a(p,q)^{\log_a(1/\eta)}\times(1/2)^{N-\log_a(1/\eta)}\), which
interpolates between the resonance value and the generic value.

## 4. Furstenberg connection

The map \(x\mapsto ax\bmod 1\) is the \(\times a\) action on the torus
\(\mathbb T\).  Multiplying together actions of different bases \(a,b\)
that are multiplicatively independent gives the joint \(\times a,\times b\)
action.

**Furstenberg's theorem** (1967): if \(S\subseteq\mathbb T\) is closed and
invariant under both \(\times a\) and \(\times b\) with \(\log a/\log b\)
irrational, then \(S\) is finite or \(S=\mathbb T\).

The measure-theoretic version (Lindenstrauss 2006, Host 1995): a
\(\times a,\times b\)-invariant ergodic probability measure on \(\mathbb T\)
is either atomic on rationals or Lebesgue.

For our problem: \(\gcd(A)=1\) with \(|A|\ge 2\) forces multiplicative
independence of at least one pair (note 17: gcd-one implies at least two
multiplicative classes).  So the joint orbit of \(\theta\) under
\(\times a_1,\times a_2,\dots\) equidistributes for almost every \(\theta\),
which is exactly the off-resonance equidistribution we need.

**Quantitative Furstenberg** (Bourgain–Lindenstrauss, Linnik-style mixing
bounds): explicit rates for the convergence of joint orbits to Lebesgue.
These give an explicit error term in \(|\varphi_A(\theta)|\le 2^{-T}+(\text{remainder})\) for off-resonance \(\theta\).

The remainder is the genuinely hard analytic input, and quantitative
Furstenberg-style theorems are the most promising machinery.

## 5. What this conceptually gives us

After notes 47, 48, 49, and this one, the proof structure for the
generating-function approach is:

(i) **Algebraic density growth**: \(\sum 1/\log_2 a\ge R(A)\ge 1\) gives
    the LLT density exponent (note 47).

(ii) **Quantitative LLT**: standard Esseen form (note 48).

(iii) **Resonance enumeration**: per-resonance polynomial decay
     \(\Delta(A,p,q)>0\) iff \(\gcd(A)=1\) (note 49).

(iv) **Off-resonance bound**: generic decay rate \(\beta=1/2\) by ergodic
     theorem; uniform quantitative version is the Furstenberg-Lindenstrauss
     input.

The total contribution of resonances and off-resonance generic decay is
both \(o(1/\sigma)\), giving the LLT and therefore the density of
representable integers \(\to 1\), and therefore Erdős 124.

The single analytic input — quantitative Furstenberg-style equidistribution
of joint multiplicative orbits — replaces the case-by-case
Mignotte–Waldschmidt input that pervades the current architecture.

## 6. CAS verification

`scripts/cas_off_resonance.py`:

- Verifies the integral identity \(\int_0^1\log|\cos(\pi x)|\,dx=-\log 2\)
  numerically to high precision.
- Computes \(\beta_a(p,q)\) for \(q\in[2,40]\), \(a\in\{3,4,5,7\}\), and
  histograms the values to confirm clustering near \(1/2\) as \(q\) grows.
- Computes generic \(|\varphi_A(\theta)|\) for irrational \(\theta\)
  (e.g., \(\theta=1/\sqrt2,\,1/\sqrt3,\,e/10\)) at multiple seed sizes \(T\),
  confirming the predicted \(T^{-\sum 1/\log_2 a}\) decay.

## 7. Status

This note adds nothing to the Certified ledger.  It identifies the precise
analytic obligation and points to quantitative Furstenberg–Lindenstrauss
theorems as the most promising disparate-area machinery.  Whether existing
versions are sharp enough for Erdős 124 — and whether new versions
specifically tuned to subset-sum characteristic functions are reachable —
are the actual open research questions.

The architecture of notes 47–50 makes the analytic obligation:

> *uniform quantitative bound on the joint multiplicative orbit
> \((a_1^n\theta,a_2^n\theta,\dots)\bmod 1\) away from the lattice of
> low-denominator rationals*.

This is a single, uniform Diophantine condition on the bases, not a
per-pair near-collision estimate.  Whether this packaging admits an
easier proof than the existing per-pair MW input is the strategic bet of
this note series.
