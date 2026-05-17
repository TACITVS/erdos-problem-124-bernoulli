# A self-contained partial bound for the (3, 4) pair

This note attacks the off-resonance equidistribution obligation (item III
in `notes/48_characteristic_function_bound.md`, item (b) in the strategy
update) by attempting to prove an explicit decay bound on
\(|\varphi_{(3,4)}(\theta)|\) using only elementary tools and the
continued-fraction data of \(\alpha=\log3/\log4\).

The honest outcome: a clean *second-moment* bound that gives exponential
decay for \(\theta\) outside an exceptional set of bounded measure, but does
*not* by itself suffice for the LLT.  The note records both the partial
positive result and the precise gap that remains.

## 1. The target bound

For \(\theta\in[\delta,1/2]\) we want

\[
|\varphi_{(3,4)}(\theta)|
=
\prod_{n=k}^{N_3-1}\bigl|\cos(\pi 3^n\theta)\bigr|
\cdot\prod_{n=k}^{N_4-1}\bigl|\cos(\pi 4^n\theta)\bigr|
\le e^{-cN}
\]

for some \(c>0\) and \(N=N_3+N_4\).

Using \(|\cos(\pi x)|^2\le e^{-\sin^2(\pi x)}\),

\[
\log|\varphi_{(3,4)}(\theta)|
\le
-\tfrac12\sum_{a\in\{3,4\}}\sum_{n=k}^{N_a-1}\sin^2(\pi a^n\theta)
=
-\tfrac{N}{2}\cdot\tfrac12+\tfrac12 W(\theta),
\]

with

\[
W(\theta)=\sum_{a\in\{3,4\}}\sum_{n=k}^{N_a-1}\cos(2\pi a^n\theta).
\]

So the target is: \(W(\theta)\le(1-\eta)\cdot N\) for some \(\eta>0\).
Equivalently, the multiplicative Weyl sum \(W(\theta)\) is bounded away
from \(N\).

## 2. Second-moment identity

**Lemma (exact).**  For \(\theta\) uniform on \([0,1)\) and any base \(a\ge2\),
let \(W_N^{(a)}(\theta)=\sum_{n=1}^N\cos(2\pi a^n\theta)\).  Then

\[
\mathbb E[W_N^{(a)}(\theta)^2]=\frac{N}{2}.
\]

*Proof.*  Expanding the square,

\[
W_N^{(a)}(\theta)^2
=
\sum_{n,m=1}^N\cos(2\pi a^n\theta)\cos(2\pi a^m\theta)
=
\frac12\sum_{n,m}\bigl[\cos(2\pi(a^n-a^m)\theta)+\cos(2\pi(a^n+a^m)\theta)\bigr].
\]

Integrate over \(\theta\in[0,1)\): each term contributes 1 if and only if
the argument's coefficient vanishes.  The coefficient \(a^n-a^m\) vanishes
exactly when \(n=m\) (so \(N\) diagonal contributions of 1).  The
coefficient \(a^n+a^m\) is strictly positive, so never vanishes.  Hence

\[
\mathbb E[W_N^{(a)}(\theta)^2]=\frac12\cdot N\cdot1=N/2.\qed
\]

The CAS verifies this empirically in
`scripts/cas_self_contained_34_bound.py`: averaging \(W_N^{(a)}(\theta)^2\)
over 200 random \(\theta\) gives values within \(\sim 10\%\) of \(N/2\) for
\(N\in\{10,20,30,50\}\) and \(a\in\{3,4\}\).

## 3. Chebyshev tail bound

**Corollary.**  For any \(K>0\),

\[
\operatorname{meas}\bigl\{\theta\in[0,1):\ |W_N^{(a)}(\theta)|>K\sqrt N\bigr\}
\le \frac{1}{2K^2}.
\]

Off this exceptional set, \(|W_N^{(a)}|\le K\sqrt N\) and hence

\[
\sum_{n=1}^N\sin^2(\pi a^n\theta)
\ge\tfrac{N}{2}-\tfrac{K}{2}\sqrt N,
\qquad
\prod_{n=1}^N|\cos(\pi a^n\theta)|
\le
\exp\!\Bigl(-\tfrac{N}{4}+\tfrac{K}{4}\sqrt N\Bigr).
\]

For \(N\gg K^2\) this is exponentially small.  Summing the two bases gives
the same shape for \(|\varphi_{(3,4)}(\theta)|\).

This proves: **off an exceptional set of measure \(O(1/K^2)\), the
characteristic function decays exponentially in \(N\).**

## 4. The gap relative to the LLT target

The LLT integral target (note 48) requires

\[
\int_{[\delta,1/2]}|\varphi_A(\theta)|\,d\theta=o\!\left(\frac{1}{\sigma}\right),
\qquad
\sigma\sim T.
\]

The Chebyshev splitting gives

\[
\int|\varphi_{(3,4)}|\,d\theta
\le\operatorname{meas}(\text{exceptional})\cdot 1+\operatorname{meas}(\text{typical})\cdot e^{-cN}
\le\frac{1}{2K^2}+e^{-cN}.
\]

For the bound to be \(o(1/T)\), one needs \(K\gtrsim\sqrt T\), which then
spoils the typical exponential bound \(e^{-cN+K\sqrt N/4}=e^{-cN+(NT)^{1/2}/4}\).
For balanced frontiers \(N\asymp\log T\), this is
\(e^{-c\log T+(T\log T)^{1/2}/4}\), which is *not* small.

So **the second-moment bound is not strong enough** to close the LLT.  It
falls short by a polynomial factor in \(T\).

## 5. What would close the gap

Higher moments of \(W_N(\theta)\):

\[
\mathbb E[W_N^{(a)}(\theta)^{2k}]\le c_k\cdot N^k
\]

(consistent with subgaussian tails) would give
\(\operatorname{meas}\{|W_N|>K\sqrt N\}\le c_k/K^{2k}\) and make \(K\)
larger without losing the exceptional measure.  The needed bound is
\(K\sim T^{1/(2k)}\), and the exponential decay needs to dominate
\(KN^{1/2}\sim T^{1/(2k)}(\log T)^{1/2}\).

For \(k\) large, the exponent \(c\log T - T^{1/(2k)}(\log T)^{1/2}\) is
positive for \(\log T\) large.  So **higher-moment bounds on the
multiplicative Weyl sum would close the LLT**.

The fourth moment \(\mathbb E[W_N^4]\) is computable similarly to the
second:

\[
\mathbb E[W_N^4]
=
\frac{1}{16}
\sum_{n_1,n_2,n_3,n_4}
\sum_{\epsilon\in\{\pm1\}^4}
\mathbb 1\!\bigl[\epsilon_1 a^{n_1}+\epsilon_2 a^{n_2}+\epsilon_3 a^{n_3}+\epsilon_4 a^{n_4}=0\bigr].
\]

The zero set of \(\epsilon_1 a^{n_1}+\dots+\epsilon_4 a^{n_4}\) is **exactly
the kind of S-unit equation** whose solution set is controlled by the
Subspace Theorem.  For our purposes, only the trivial pairings
(\(\{n_1=n_2, n_3=n_4\}\) etc.) contribute, *unless* there are non-trivial
zero combinations.

So the higher-moment route hits the same analytic input as before, just
phrased differently: **bounding the number of S-unit solutions to
\(\sum\epsilon_i a^{n_i}=0\) is exactly what controls the fourth moment of
\(W_N\), and hence the LLT**.

## 6. Connection to the CF of \(\log3/\log4\)

For the pair \((3,4)\), an S-unit collision

\[
\epsilon_1 3^{n_1}+\epsilon_2 3^{n_2}+\epsilon_3 4^{n_3}+\epsilon_4 4^{n_4}=0
\]

with \(\epsilon_i\in\{\pm1\}\) requires \(3^{n_2}-3^{n_1}=\pm(4^{n_4}-4^{n_3})\)
(after sign-grouping).  In the most degenerate case (only two non-trivial
terms), this is the near-collision \(3^n=4^m\), governed by the CF of
\(\alpha=\log3/\log4\).

So the CF data we already have for \(\alpha\) — eight convergents in
\([11,293895)\), all with gap \(>7551629537\) — *does* enter the
fourth-moment estimate.  But the full fourth-moment computation requires
all quadruples \((n_1,n_2,n_3,n_4)\), not only the (3,4) collisions.

The honest conclusion: the CF data is *necessary* but not *sufficient* for
the off-resonance bound.  A full self-contained argument would need
quantitative S-unit bounds on equations with four unknowns, which is
strictly stronger than Mignotte–Waldschmidt.

## 7. What this note proves and does not prove

**Proved**:

- Exact second moment \(\mathbb E[W_N^{(a)}]=N/2\) by elementary Fourier
  argument.
- Chebyshev exponential decay of \(|\varphi_{(3,4)}|\) off an exceptional
  set of measure \(O(1/K^2)\).

**Not proved**:

- LLT-level decay (would need higher moments or S-unit input on
  four-variable equations).
- A self-contained bound on the multiplicative Weyl sum
  \(W_N^{(a)}(\theta)\) for *every* \(\theta\) (not just typical).

## 8. Strategic conclusion

The "use CF data alone" strategy for the (3,4) pair runs into a clean
mathematical wall: the second moment is elementary, but every stronger
bound requires either:

(a) effective S-unit equation theory for \(\epsilon_1 3^{n_1}+\dots\),
    which is genuinely beyond CF of \(\alpha\);

(b) quantitative Furstenberg / Lindenstrauss-style mixing, which is
    external analytic input;

(c) higher-moment computation that telescopes back to (a) anyway.

So the **self-contained CF approach for the off-resonance bound does not
close**.  The genuine analytic obligation is higher-moment / S-unit
control on the multiplicative orbit, repackaging — once again — the
Mignotte–Waldschmidt-type input.

This is informative: it shows the CF/MW input is not just one possible
analytic ingredient but is, in a precise sense, *minimal* for the
exact-critical case.  Any alternative route must supply equivalent S-unit
information.

## 9. CAS verification

`scripts/cas_self_contained_34_bound.py`:

- verifies the second-moment identity \(\mathbb E[W_N^2]=N/2\) by Monte
  Carlo;
- computes empirical histograms of \(|W_N|/\sqrt N\) showing
  subgaussian-like tails;
- computes the fourth moment empirically and compares to the prediction
  \(\le 3N^2/4+O(N)\) (the \(3N^2/4\) coming from trivial pairings, the
  \(O(N)\) from any non-trivial S-unit collisions in the range).

## Status

Adds no Certified obligation.  Records a *negative* meta-result:  the
self-contained CF route does not give the LLT, and the genuine analytic
obligation reduces to S-unit equation theory.  This sharpens the strategy
revision in note 45.
