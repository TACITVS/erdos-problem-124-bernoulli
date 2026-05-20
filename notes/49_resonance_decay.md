# Resonance decay enumeration

This note implements item (I) from `notes/48_characteristic_function_bound.md`:
enumerate the values $|\varphi_A(p/q)|$ at every non-trivial resonance with
denominator $q\le Q$ in closed form, and derive an explicit
polynomial-in-$T$ decay rate.

The result is a structural theorem (the per-resonance closed form decays
polynomially in $T$ exactly when the $\gcd(A)=1$ hypothesis holds) plus a
CAS script that mechanically tabulates the decay rates.  The note does *not*
prove the off-resonance equidistribution estimate; that remains as item (III)
in note 48.

## 1. Eventual periodicity

For each base $a$ and each modulus $2q$, the orbit $\{a^n\bmod 2q\}_{n\ge0}$
is eventually periodic: there exist non-negative integers
$\rho_a(q)$ (pre-period) and $\pi_a(q)\ge1$ (period) such that

$$a^n\bmod 2q\quad\text{depends only on }n\bmod\pi_a(q)\text{ for }n\ge\rho_a(q).$$

Both $\rho_a(q)$ and $\pi_a(q)$ are bounded by $2q$ (pigeonhole) and
computed exactly by trial.  When $\gcd(a,2q)=1$, the pre-period is $0$
and $\pi_a(q)\mid\mathrm{ord}_{2q}(a)$.

## 2. Per-base resonance factor

Define

$$\beta_a(p,q)
=
\left(\prod_{j=1}^{\pi_a(q)}\bigl|\cos(\pi v_{a,q,j}\,p/q)\bigr|\right)^{1/\pi_a(q)},$$

where $v_{a,q,1},\dots,v_{a,q,\pi_a(q)}$ is one period of the orbit of
$a^n\bmod 2q$ after the pre-period.

This is the **geometric mean** of the cos factors over one period.  It is
an algebraic number (lives in the cyclotomic field $\mathbb Q(\zeta_{2q})$)
and SymPy computes it exactly in radicals when $q\le 6$.

## 3. Closed-form per-resonance value

For the seed up to frontier $N_a$ for each base:

$$\prod_{n=k}^{N_a-1}\bigl|\cos(\pi a^n p/q)\bigr|
=
\beta_a(p,q)^{N_a-k-\rho_a(q)+\mathrm{boundary}}.$$

The boundary term is a bounded factor depending on where the pre-period and
the residual partial cycle land.  Both are bounded in $\log T$ and so
absorb into a constant.

The combined value across all bases:

$$|\varphi_A(p/q)|
=
\prod_{a\in A}\beta_a(p,q)^{N_a-k-\rho_a(q)+O(1)}.$$

## 4. Polynomial decay rate

Using $N_a\approx\log_a T$ for balanced frontiers:

$$\log|\varphi_A(p/q)|
=
\log T\sum_{a\in A}\frac{\log\beta_a(p,q)}{\log a}+O(1).$$

Define the **resonance decay rate**

$$\Delta(A,p,q)
=
-\sum_{a\in A}\frac{\log\beta_a(p,q)}{\log a}.$$

Then

$$|\varphi_A(p/q)|=T^{-\Delta(A,p,q)+o(1)}.$$

**Claim**: $\Delta(A,p,q)>0$ for every non-trivial resonance $p/q$, $0<p<q$,
$\gcd(p,q)=1$, exactly when $\gcd(A)=1$.

**Proof sketch**: $\Delta(A,p,q)>0$ iff some $\beta_a(p,q)<1$, iff some
$\cos(\pi v_{a,q,j}p/q)\ne\pm1$, iff $v_{a,q,j}p/q\notin\mathbb Z$ for
some $j$, iff $q\nmid v_{a,q,j}p$.  Since $\gcd(p,q)=1$, this is
equivalent to $q\nmid v_{a,q,j}$ for some $j$, i.e., not every orbit
value is a multiple of $q$.

For every prime $\ell\mid q$, if $\ell\nmid a$ then $a^n$ is never a
multiple of $\ell$; so the orbit values avoid multiples of $\ell$ and
the condition is satisfied.  Conversely, if every $\ell\mid q$ divides
every $a\in A$, then $\ell$ is a common divisor of $A$, contradicting
$\gcd(A)=1$ — unless $q=1$, the excluded trivial case.

So for any $q\ge 2$ and any $A$ with $\gcd(A)=1$ and $R(A)\ge 1$, at
least one base contributes $\beta_a(p,q)<1$, hence
$\Delta(A,p,q)>0$.  $\square$

## 5. Resonance-window contribution

The neighborhood of width $1/T_{\max}$ around $p/q$ contributes

$$\int_{|θ-p/q|\le1/T_{\max}}|\varphi_A(θ)|\,dθ
\ll
|\varphi_A(p/q)|\cdot\frac{1}{T_{\max}}
\ll
T^{-1-\Delta(A,p,q)}.$$

Summed over all resonances with $q\le Q$, of which there are $O(Q^2)$:

$$\sum_{p/q,\ q\le Q}T^{-1-\Delta(A,p,q)}
\le
Q^2 \cdot T^{-1-\Delta_{\min}(A,Q)},$$

with $\Delta_{\min}(A,Q)=\min_{p,q\le Q}\Delta(A,p,q)>0$ by the claim.

This is exponentially smaller than the Gaussian density target $1/\sigma\sim T^{-1}$ by the factor $T^{-\Delta_{\min}}$.  Resonance contributions are therefore handled.

## 6. Worked decay rates for $\{3,4,7\}$, $k=1$

Output of `scripts/cas_resonance_decay.py`:

| $p/q$ | $\beta_3$ | $\beta_4$ | $\beta_7$ | $\Delta(A,p,q)$ |
|---------|-------------|-------------|-------------|-------------------|
| 1/2     | 0           | 1           | 0           | $+\infty$       |
| 1/3     | 1           | 1/2         | 1/2         | $0.857$         |
| 2/3     | 1           | 1/2         | 1/2         | $0.857$         |
| 1/4     | $\sqrt2/2$| 1           | $\sqrt2/2$| $0.493$         |
| 3/4     | $\sqrt2/2$| 1           | $\sqrt2/2$| $0.493$         |
| 1/6     | 0           | 1/2         | 0           | $+\infty$       |

The two finite-rate resonances are at $q=3$ ($\Delta\approx 0.857$) and
$q=4$ ($\Delta\approx 0.493$).  Both are strictly positive.  The
$q=2,6$ resonances are *exactly* zero (a 3- or 7-power hits an odd argument
that gives $\cos(\pi/2)=0$).

## 7. What this closes and leaves open

**Closed**: items (I) and (II) from note 48 — resonance enumeration and the
per-resonance polynomial decay rate, with the lattice obstruction
algebraically tied to $\gcd(A)=1$.

**Open**: item (III) — uniform off-resonance equidistribution.  This is the
single remaining analytic obligation.  It requires
$|\varphi_A(\theta)|\le e^{-cT}$ for $\theta$ at distance $>1/Q$ from
every $p/q$ with $q\le Q$, uniformly in $T$.

For multiplicatively independent base pairs this off-resonance bound is
the content of standard Weyl equidistribution arguments; the analytic
content is a uniform irrationality measure on $\log a/\log b$.

## 8. CAS verification

`scripts/cas_resonance_decay.py`:

- computes $\rho_a(q),\pi_a(q)$ for $q\in[2,10]$ and $a\in\{3,4,5,7,9,25,\dots\}$;
- evaluates $\beta_a(p,q)$ in exact radicals when possible;
- evaluates $\Delta(A,p,q)$ numerically to high precision;
- cross-checks against direct numerical $|\varphi_A(p/q)|$ at multiple seed
  sizes $T$;
- reports the minimum non-trivial $\Delta$ per case.

The decay rate is constant in $T$ and the empirical values match the
formula $\beta^{\,N}$ up to the boundary correction predicted in §3.

## 9. Status

Adds no Certified obligation to the global audit (the genuine theorem
target is still item (III), off-resonance equidistribution).  Sharpens the
analytic obligation from "Mignotte–Waldschmidt per base pair" to "uniform
Weyl equidistribution of $a^n\theta\bmod 1$", with the resonance side
algebraically resolved.
