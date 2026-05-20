# Characteristic function bound for the LLT

This note continues `notes/47_generating_function_density.md`.  The density
heuristic there needs a quantitative local limit theorem.  This note states
the LLT precisely, identifies the single analytic ingredient it requires —
a decay estimate on the characteristic function — and inspects that
function numerically for the local test cases.  All computations are in
`scripts/cas_characteristic_function.py`.

## 1. Esseen-style local limit theorem

Standard reference setup.  Let $X_1,\dots,X_T$ be independent integer-valued
random variables with means $\mu_i$, variances $\sigma_i^2$, and bounded
range.  Set

$$S=\sum_iX_i,\quad
\mu=\sum_i\mu_i,\quad
\sigma^2=\sum_i\sigma_i^2.$$

Let $\varphi(\theta)=\prod_iE[e^{2\pi i X_i\theta}]$ be the joint
characteristic function.  Then for every integer $N$,

$$\bigl|P(S=N)-g(N)\bigr|
\le
\int_{|\theta|\le1/2}\bigl|\varphi(\theta)-\hat g(\theta)\bigr|\,d\theta,$$

where $g$ is the Gaussian density at the mean and $\hat g$ its Fourier
transform.  Splitting the integral at a parameter $\delta>0$:

$$\bigl|P(S=N)-g(N)\bigr|
\le
\underbrace{\int_{|\theta|\le\delta}\bigl|\varphi(\theta)-\hat g(\theta)\bigr|\,d\theta}_{\text{near-zero (controlled by third moment)}}
+
\underbrace{\int_{\delta\le|\theta|\le1/2}|\varphi(\theta)|\,d\theta}_{\text{characteristic-function tail}}
+
\text{Gaussian tail}.$$

The first piece is controlled by classical Esseen smoothing
$(O(\sigma^{-2})$).  The third is exponentially small in $\delta\sigma$.
The only piece that demands non-trivial Diophantine input is the middle
**characteristic-function tail**.

## 2. The characteristic function for subset sums of powers

For our setup $X_i=\xi_{a,n}\in\{0,a^n\}$ Bernoulli with mean $a^n/2$,

$$E[e^{2\pi i\xi_{a,n}\theta}]
=
\frac{1+e^{2\pi ia^n\theta}}{2}
=
e^{\pi ia^n\theta}\cos(\pi a^n\theta).$$

Therefore

$$|\varphi_A(\theta)|
=
\prod_{a\in A}\prod_{k\le n<N_a}\bigl|\cos(\pi a^n\theta)\bigr|.$$

The bound we need is

$$\int_{\delta\le|\theta|\le1/2}|\varphi_A(\theta)|\,d\theta
=
o\!\left(\frac{1}{\sigma\sqrt{2\pi}}\right)$$

for some fixed $\delta>0$ as the seed grows.  Equivalently, the
characteristic-function tail must be smaller than the Gaussian density at
the mean, which is the order of the predicted representable-integer
density.

## 3. Resonance structure

$|\varphi_A|$ achieves its non-zero local maxima at rational
$\theta=p/q$, because $\cos(\pi a^n p/q)=\pm1$ iff $q\mid a^n$.  At such
a resonance, the factor for base $a$ collapses to $1$ on the powers
$a^n$ with $q\mid a^n$ and contributes only from the remaining powers.

### Worked resonances for $\{3,4,7\}$, $k=1$

At $\theta=1/2$:  some $a^n$ odd $\Rightarrow$ at least one factor is
$\cos(\pi\cdot\text{odd}/2)=0$, so $|\varphi_A(1/2)|=0$.

At $\theta=1/3$:  $3^n\equiv0\pmod3$, $4^n\equiv1\pmod3$,
$7^n\equiv1\pmod3$.  So 3-power factors are $\pm1$; 4- and 7-power
factors are $\pm1/2$.  Thus

$$|\varphi_A(1/3)|=2^{-(N_4+N_7)}.$$

At $\theta=1/4$:  $3^n\equiv3,1,3,1,\dots\pmod8$, $4^n\equiv0\pmod4$,
$7^n\equiv7,1,7,1,\dots\pmod8$.  So 4-power factors are $\pm1$;
3- and 7-power factors are $\pm\sqrt2/2$.  Thus

$$|\varphi_A(1/4)|=2^{-(N_3+N_7)/2}.$$

Both resonance values decay polynomially in the seed size (since
$N_a\propto\log T$, the decay is $T^{-c}$ for some $c>0$).

The CAS check (`scripts/cas_characteristic_function.py`) confirms these
formulas exactly for seed limits up to $10^5$.

## 4. Off-resonance decay

For $\theta$ at distance $\eta$ from every $p/q$ with $q\le Q$, the
sequence $a^n\theta\bmod 1$ is well-distributed on $[0,1]$ for large $n$
(this is the Weyl-style equidistribution argument and is the precise
content of the $\gcd(A)=1$ hypothesis: multiplicatively independent
bases generate equidistributing orbits).

By Jensen / convexity $(\log|\cos(\pi x)|\le-\tfrac12\sin^2(\pi x))$:

$$\log|\varphi_A(\theta)|
\le
-\tfrac12\sum_{a,n}\sin^2(\pi a^n\theta).$$

If the $\sin^2$ average tends to its uniform value $1/2$, the sum is
$\Omega(T)$ and $|\varphi_A(\theta)|\le e^{-cT}$, exponentially small.

The non-trivial input is uniform convergence to the uniform average:
quantitative equidistribution of $\{a^n\theta\bmod 1\}$ away from
rationals.  This is a Diophantine condition on $\theta$ tied to the
multiplicative independence of the bases — the same family of analytic
estimates that powers Mignotte–Waldschmidt, but formulated as a uniform
characteristic-function bound rather than a per-pair near-collision
estimate.

## 5. Integration vs the Gaussian density target

The LLT demands

$$\int_{\delta\le|\theta|\le1/2}|\varphi_A(\theta)|\,d\theta
\ll
\frac{1}{\sigma}.$$

Decompose by resonance: a finite union of small neighborhoods of resonance
points $p/q$ with $q\le Q$, plus a "smooth" region.

- On a neighborhood of size $\epsilon$ around $p/q$: integrand bounded
  by $|\varphi_A(p/q)|\cdot(1+O(\epsilon T))$, polynomial in $T$.
- On the smooth region: integrand exponentially small in $T$.

The smooth region dominates is small.  The total resonance contribution
must be controlled by:

(a) **finitely many resonances** with denominator below an explicit
    threshold $Q$ (we can enumerate them);

(b) **per-resonance decay** of the form $|\varphi_A(p/q)|=T^{-c(q)}$ with
    $c(q)$ bounded below;

(c) **uniform off-resonance equidistribution** in the complementary region.

Items (a) and (b) are elementary modular arithmetic on $\{a^n\bmod q\}$
and a CAS can evaluate them exhaustively.  Item (c) is the genuine
analytic obligation that this framing inherits from the existing CF/MW
infrastructure.

## 6. Numerical evidence

CAS verification for $\{3,4,7\}$, $k=1$ gives (with $N_4$ the count of
4-powers in the seed, etc.):

| seed limit | $N_3$ | $N_4$ | $N_7$ | $|\varphi_A(1/3)|$ | $|\varphi_A(1/4)|$ | max $|\varphi_A|$ on $[0.01,0.5]$ |
|------------|---------|---------|---------|----------------------|----------------------|----------------------------------------|
| 100        | 4       | 3       | 2       | $2^{-5}=0.03125$   | $2^{-3}=0.125$     | $\approx 0.160$                      |
| 1000       | 6       | 4       | 3       | $2^{-7}\approx7.8\!\cdot\!10^{-3}$ | $2^{-4.5}\approx0.044$ | $\approx 0.144$ |
| 10000      | 8       | 6       | 4       | $2^{-10}\approx9.8\!\cdot\!10^{-4}$ | $2^{-6}\approx0.016$ | $\approx 0.069$ |

The two leading resonances at $\theta=1/3$ and $\theta=1/4$ decay at
controlled exponential rates in $\log T$.  The empirical maximum of
$|\varphi_A|$ across the window $[0.01,0.5]$ decreases monotonically.

## 7. What this leaves open

The framing is now precise.  The remaining work is genuinely analytic:

(I) **Resonance enumeration.**  For each $Q$, enumerate the relevant
    $p/q$ with $q\le Q$ and compute $|\varphi_A(p/q)|$ exactly as a
    closed-form modular product.  Mechanical.

(II) **Per-resonance neighborhood width.**  Show the integrand cannot
    spike too far from $p/q$ — quantify the second derivative of
    $\log|\varphi_A|$ at resonance.  Algebraic but technical.

(III) **Smooth-region equidistribution.**  Prove
      $|\varphi_A(\theta)|\le e^{-c\,T}$ for $\theta$ at distance
      $>1/Q$ from every $p/q$ with $q\le Q$, uniformly in $T$.
      This is the analytic input; it requires Diophantine information
      similar to (but more uniform than) Mignotte–Waldschmidt.

Items (I) and (II) are CAS-friendly.  Item (III) is the actual remaining
analytic theorem.  The advantage over the current architecture is that
this is a *single* uniform statement rather than per-base-pair estimates
imported separately.

## 8. Status

This note adds nothing to the Certified ledger.  It packages the
analytic obligation differently.  The next concrete CAS-doable target is
item (I): produce the closed-form modular-product values for every
$|\varphi_A(p/q)|$ with $q\le 12$ (say) for each local test case, and
verify the polynomial-in-$T$ decay matches the count formulas above.
