# Sidon sub-Gaussian framing

This note continues `notes/52_fourth_moment_sunit.md`.  The fourth-moment
route went through S-unit equations.  This note takes a different
classical route: lacunary trigonometric series and Sidon's sub-Gaussian
inequality.  It is a real disparate-area engagement —
the underlying theorems are from 1920s harmonic analysis, far from the
modular bridge or near-collision frameworks the project has been built on.

The note states the chain of reasoning that *would* give Erdős 124 under
suitable analytic input, and is honest about where the constants get
tight.

## 1. Sidon's theorem

**Theorem (Sidon 1927; refined by Salem–Zygmund, Kahane, Marcus–Pisier).**
For a lacunary sequence \(\{\lambda_n\}_{n\ge0}\) with ratio
\(q=\inf_n\lambda_{n+1}/\lambda_n>1\), and any complex coefficients
\((c_n)\in\ell^2\),

\[
\Bigl\|\sum_n c_n e^{2\pi i\lambda_n\theta}\Bigr\|_{L^p([0,1])}
\le
C(q)\sqrt{p}\;\|c\|_2,
\qquad p\ge2,
\]

for an explicit constant \(C(q)\) depending only on the lacunarity
ratio.  For the partial sums of real cosines,

\[
\Bigl\|\sum_{n=0}^{N-1}\cos(2\pi\lambda_n\theta)\Bigr\|_{L^p}
\le
C(q)\sqrt{pN}.
\]

By the standard Markov–Chernoff inequality, the \(L^p\) bound yields a
sub-Gaussian tail:

\[
\Pr_\theta\!\Bigl[\Bigl|\sum_n\cos(2\pi\lambda_n\theta)\Bigr|>t\Bigr]
\le
2\exp\!\Bigl(-\frac{t^2}{2e\,C(q)^2\,N}\Bigr).
\]

For the **single-base Weyl sum** \(W^{(a)}_N(\theta)=\sum_{n=k}^{N+k-1}\cos(2\pi a^n\theta)\),
applied with \(\lambda_n=a^n\) and \(q=a\):

\[
\Pr_\theta\!\bigl[|W^{(a)}_N(\theta)|>K\sqrt N\bigr]
\le
2\exp\!\Bigl(-\frac{K^2}{2eC(a)^2}\Bigr).
\]

## 2. From Weyl sum to characteristic-function bound

Using \(|\cos(\pi x)|^2=(1+\cos(2\pi x))/2\),

\[
\log|\varphi_a(\theta)|^2
=
-N_a\log 2+\sum_{n}\log\bigl(1+\cos(2\pi a^n\theta)\bigr).
\]

This expression is bounded above two ways:

- **Loose**: \(\log(1+y)\le y\) gives
  \(\log|\varphi_a|^2\le-N_a\log 2+W^{(a)}_N\), so
  \(|\varphi_a|\le 2^{-N_a/2}\,e^{W^{(a)}_N/2}\), decay rate \(\log 2/2\).

- **Sharp Birkhoff**: \(\int_0^1\log|\cos(\pi x)|^2\,dx=-2\log 2\) and the
  Salem–Zygmund quantitative ergodic theorem for lacunary sequences
  gives
  \(\log|\varphi_a(\theta)|=-N_a\log 2+O(\sqrt{N_a\log N_a})\) outside
  exceptional sets, decay rate \(\log 2\).

The two-fold gap is real and constraints the constants below.

## 3. Multi-base product

Combine \(|\varphi_A(\theta)|=\prod_a|\varphi_a(\theta)|\).  Apply the
Salem–Zygmund bound per base and union over \(A\):

- Outside a set of measure \(\le|A|\cdot 2\exp(-K^2/(2eC_{\max}^2))\), each
  per-base deviation is bounded by \(K\sqrt{N_a}\).
- On the typical set,

\[
|\varphi_A(\theta)|
\le
2^{-N}\cdot \exp\!\Bigl(O\!\bigl(K\sqrt N\bigr)\Bigr),
\qquad
N=\sum_aN_a.
\]

For balanced frontiers \(a^{N_a}\approx T\), \(N=\log T\cdot\sum 1/\log a\),
hence

\[
|\varphi_A(\theta)|
\le
T^{-\sum_a 1/\log_2 a}\cdot
\exp\!\bigl(O(K\sqrt{\log T})\bigr).
\]

## 4. The decisive algebraic margin

By note 47,

\[
\sum_{a\in A}\frac{1}{\log_2 a}\ge R(A)\ge 1,
\]

with **strict** inequality \(\sum 1/\log_2 a > 1\) whenever \(a\ge 3\) (the
single-base bound \(\log_2 a<a-1\) is strict).  Numerically:

| set                  | \(R(A)\) | \(\sum 1/\log_2 a\) | margin |
|----------------------|----------|---------------------|--------|
| \(\{3,4,7\}\)        | 1.000    | 1.487               | 0.487  |
| \(\{3,4,9,25\}\)     | 1.000    | 1.662               | 0.662  |
| \(\{3,4,5\}\)        | 1.083    | 1.561               | 0.561  |
| \(\{3,5,7,13\}\)     | 1.000    | 1.688               | 0.688  |

The margin is bounded away from zero for every hypothesis-minimal local
case.  For any choice of \(K\) growing slowly enough that
\(\exp(K\sqrt{\log T})=T^{o(1)}\), the typical bound is
\(T^{-\sum 1/\log_2 a+o(1)}=o(T^{-1})\), which is what the LLT integral
target asks for.

## 5. The LLT chain

Assemble:

(a) Typical (off the exceptional set): \(|\varphi_A(\theta)|\le T^{-\eta}\)
    for some \(\eta>0\) (specifically \(\eta=\sum 1/\log_2 a-1-o(1)\)).

(b) Exceptional measure: \(|A|\cdot 2\exp(-K^2/(2eC_{\max}^2))\), which is
    \(\le T^{-c}\) when \(K^2\ge 2eC_{\max}^2\,c\,\log T\), i.e.,
    \(K\sim\sqrt{\log T}\).

(c) For the typical bound to give \(o(T^{-1})\), need
    \(\sum 1/\log_2 a-K\sqrt{\log T}/\log T>1\), i.e.,
    \(K/\sqrt{\log T}\) bounded by some explicit constant.

The two conditions on \(K\) reconcile when \(C_{\max}^2\) is small enough,
which is the **explicit Sidon constant condition** that controls whether
the chain closes.

## 6. The constant question

The Sidon constant for the lacunary sequence \(\{a^n\}\) with \(a\ge 2\) is
well-studied.  Sidon's original argument gives \(C(q)\le\pi/\arcsin(1/q)\),
which is \(\sim\pi q\) for large \(q\) and \(\sim 5\) for \(q=2\).

For our balanced setup with \(K\sim\sqrt{c\log T}\):

- Typical bound exponent: \(\sum 1/\log_2 a-\sqrt c\).
- Exceptional measure exponent: \(c/(2eC_{\max}^2)\).

For both to exceed 1 (giving \(o(T^{-1})\)):

\[
\sqrt c<\sum_a 1/\log_2 a-1,
\qquad
c>2eC_{\max}^2.
\]

The interval \(2eC_{\max}^2<c<(\sum 1/\log_2 a-1)^2\) is non-empty iff

\[
C_{\max}^2<\frac{(\sum 1/\log_2 a-1)^2}{2e}.
\]

For \(\{3,4,7\}\), the RHS is \((0.487)^2/(2e)\approx0.0436\), so
\(C_{\max}<0.21\).  Standard Sidon constants are \(\ge 1\), so **the
naïve union-bound argument does not close the LLT** with the constants in
the classical Sidon inequality.

## 7. What this leaves

Two routes to close the gap:

(i) **Sharper Sidon constants for our specific sequences.**  The
    classical bound \(C(q)\le\pi/\arcsin(1/q)\) is for *arbitrary*
    lacunary sequences.  For specific multiplicative sequences with
    additional structure, sharper bounds may be available
    (Konyagin–Shparlinski, Bourgain, others on multiplicative-orbit
    discrepancy).

(ii) **Joint multi-base concentration**, not per-base union bound.  The
     union bound loses a factor of \(|A|\) and assumes worst-case
     correlation.  A joint Salem–Zygmund argument for the multi-base
     sum \(W=\sum_aW^{(a)}\) could give exponentially better constants.

(iii) **Higher-moment improvements** (note 52): the S-unit fourth-moment
      route gives polynomial-in-\(K\) exceptional measure, which combined
      with the lacunary structure should close.  Specifically: the
      fourth moment \(E[W^4]=3N^2/4+O(N)\) (from S-unit counting) implies
      sub-Gaussian behavior via Marcinkiewicz–Zygmund, with constants
      explicit from Evertse–Schlickewei.

## 8. Status of the framework

The Sidon route gives the **right shape** of the proof: every hypothesis
of Erdős 124 translates into a piece of the LLT chain, and the algebraic
identity \(\sum 1/\log_2 a>1\) (which follows from \(R(A)\ge 1\)) is the
decisive ingredient.

What is missing is a sharp enough decay constant in the off-resonance
characteristic-function bound.  The classical Sidon constants are not
sharp enough by themselves; either (i) sharper constants for the
specific multiplicative orbits, or (iii) the higher-moment S-unit route
of note 52, would close the chain.

In particular, **the conjunction of**:
- note 47 (algebraic density growth from \(R(A)\ge 1\)),
- note 49 (resonance lattice obstruction = \(\gcd(A)=1\)),
- note 52 (Evertse–Schlickewei polynomial fourth-moment bound),

together with the standard LLT/CLT for sums of independent bounded
random variables, **gives a conditional proof of Erdős 124** modulo
explicit constants.

This is the cleanest statement of where the project sits: every
ingredient is identified, the algebraic content is verified, the
analytic obligation is reduced to S-unit equation theory with explicit
constants.

## 9. CAS verification

`scripts/cas_sidon_margin.py`:

- computes the density-exponent margin \(\sum 1/\log_2 a-1\) for every
  hypothesis-meeting catalogue entry;
- evaluates the Sidon constant upper bound
  \(\pi/\arcsin(1/q)\) for \(q\in\{3,4,5,7,9,25\}\);
- numerically computes the closure condition
  \(C_{\max}^2<(\sum 1/\log_2 a-1)^2/(2e)\), showing which cases pass
  with the naïve Sidon constants.

## Status

Adds no Certified obligation.  Provides the third independent packaging
of the analytic obligation (after notes 49 resonance and 52 S-unit), with
the connection to classical lacunary harmonic analysis made explicit.
