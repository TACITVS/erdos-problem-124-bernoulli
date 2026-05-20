# Generating-function density framing

This note pursues option (a) from the strategy revision: engage with a
disparate-area technique that *might* eventually replace the
computer-assisted certificates with a clean algebraic argument.

The framing is via generating functions and a local-limit-theorem
heuristic.  Its main contribution is **not a new proof**; it is a cleaner
algebraic accounting that:

1. exhibits the Erdős reciprocal-sum hypothesis as the natural condition
   for a density heuristic;
2. exhibits the $\gcd(A)=1$ hypothesis as the lattice-avoidance condition
   for a local limit theorem;
3. isolates the analytic input as exactly one Diophantine condition on the
   characteristic function of the subset-sum measure, replacing the
   case-by-case Mignotte–Waldschmidt input by a more uniform requirement.

All algebraic identities below are verified mechanically in
`scripts/cas_density_check.py` using SymPy, so the human reasoning is
reserved for the framing and the connection between hypotheses and
analytic inputs.

## 1. Generating function

For $A=\{a_1,\dots,a_r\}\subset\mathbb Z_{\ge3}$ and $k\ge1$, the
subset-sum generating function is

$$F_A(x)
=
\prod_{a\in A}\prod_{n\ge k}\bigl(1+x^{a^n}\bigr).$$

The Erdős 124 theorem is equivalent to: $[x^N]F_A(x)\ge1$ for every
sufficiently large $N$.

The per-base factor satisfies a Mahler-type functional equation:

$$F_a(x)=(1+x^{a^k})F_a(x^a).$$

This relates $F_a$ at $x$ to $F_a$ at $x^a$, with an explicit
rational shift factor.  Such functional equations are classical in
transcendence theory (Mahler, Loxton–van der Poorten, Becker), but their
direct application to subset-sum density appears underexplored.

## 2. Probabilistic interpretation

Interpret each factor $(1+x^{a^n})$ as the generating function of the
Bernoulli random variable

$$\xi_{a,n}\in\{0,a^n\},
\qquad
\Pr[\xi_{a,n}=0]=\Pr[\xi_{a,n}=a^n]=\tfrac12.$$

The subset-sum random variable for the finite seed up to frontier
$N_a$ is

$$X_A
=
\sum_{a\in A}\sum_{k\le n<N_a}\xi_{a,n}.$$

Its mean and variance are

$$\mu = \tfrac12 S,
\qquad
\sigma^2=\tfrac14\sum_{a,n}a^{2n},$$

where $S=\sum_{a,n}a^n$ is the seed total.  The Erdős 124 statement is
equivalent to: for every $N$ in a cofinite range, the law of $X_A$
assigns positive mass to $N$.

## 3. Density heuristic

A local limit theorem for sums of independent bounded random variables —
when applicable — gives

$$\Pr[X_A=N]
\approx
\frac{1}{\sigma\sqrt{2\pi}}\exp\!\left(-\frac{(N-\mu)^2}{2\sigma^2}\right).$$

Near the mean $\mu$ this is approximately $1/(\sigma\sqrt{2\pi})$.  Since
the total mass is $2^{T}$ where $T=\sum_aN_a$, the *density of
representable integers* near $\mu$ is approximately

$$\rho \approx 2^{T}\Pr[X_A=N]
\approx
\frac{2^{T}}{\sigma\sqrt{2\pi}}.$$

If $\rho\ge1$ then every integer near the mean is representable; if
$\rho\to\infty$ then the redundancy makes representability robust.

## 4. The algebraic identity

For balanced frontiers $a^{N_a}\approx T$, one has

$$N_a=\log_a T,\qquad
\sum_aN_a=\log T\sum_a\frac{1}{\log a},\qquad
\sigma=\Theta(T).$$

Therefore

$$\rho \asymp
T^{\sum_a 1/\log_2 a - 1}.$$

So **the density grows polynomially in $T$ iff
$\sum_a 1/\log_2 a > 1$**.

The algebraic content sufficient for this is the elementary inequality

$$\log_2 a \le a-1
\qquad
\text{for every }a\ge3.$$

Indeed $f(a)=a-1-\log_2 a$ satisfies $f(3)=2-\log_2 3>0$ and
$f'(a)=1-1/(a\ln 2)>0$ for $a\ge 2$.  Summing the inequality
$1/\log_2 a \ge 1/(a-1)$ over $A$:

$$\sum_{a\in A}\frac{1}{\log_2 a}
\ge
\sum_{a\in A}\frac{1}{a-1}=R(A)\ge1.$$

**Conclusion**: the Erdős reciprocal-sum hypothesis $R(A)\ge1$
*automatically* gives the density-growth condition for the heuristic LLT.

## 5. What still has to be proved

The heuristic above is not a proof.  Making it rigorous requires a
quantitative local limit theorem for $X_A$, which in turn requires a
lattice-avoidance condition.  Standard Esseen / Petrov-style LLTs for sums
of independent bounded random variables need a bound on the characteristic
function

$$\varphi_A(\theta)
=
\prod_{a,n}\cos(\pi a^n\theta)$$

away from $\theta\in\mathbb Z$.  The lattice obstruction is
$\varphi_A(\theta)=\pm1$ for some non-trivial $\theta$, which is
equivalent to a non-trivial common divisor of the powers $a^n$, which
$\gcd(A)=1$ eventually rules out.

The quantitative bound

$$\sup_{\delta\le|\theta|\le1/2}|\varphi_A(\theta)|\le1-c(\delta)$$

for some explicit $c(\delta)>0$ is the analytic heart.  For
multiplicatively independent base pairs it is closely related to the
irrationality measure of $\log a/\log b$ — the same quantity that
appears in Mignotte–Waldschmidt.

So the analytic input has not disappeared; it has been *repackaged* as a
Diophantine condition on a characteristic function rather than on
near-collisions of integer powers.  The advantage of this repackaging is
that it is uniform across base pairs and amenable to additive-combinatorial
sharpening (Sárközy, Plünnecke–Ruzsa, Freiman).

## 6. Why this framing is worth preserving

- The two Erdős 124 hypotheses translate cleanly into the two preconditions
  of a local limit theorem: $R(A)\ge1$ controls the variance vs Bernoulli
  count, and $\gcd(A)=1$ controls the lattice obstruction.
- The Mahler functional equation $F_a(x)=(1+x^{a^k})F_a(x^a)$ is a real
  algebraic structure that the current proof architecture does not exploit.
- The remaining analytic input is a single uniform Diophantine bound on a
  characteristic function, rather than a per-base-pair Mignotte–Waldschmidt
  estimate.
- It engages with disparate areas (analytic combinatorics, Mahler functions,
  classical LLT theory) that were unused.

## 7. Concrete next targets

(a) **Quantitative LLT formulation.**  Write down the exact LLT statement
    (Esseen-style) needed: bound on
    $\int_{|\theta|>\delta}|\varphi_A(\theta)|d\theta$ translates to
    error in coefficient density.

(b) **Characteristic function bound.**  For the local cases ($\{3,4,7\}$,
    $\{3,4,9,25\}$), bound $|\varphi_A(\theta)|$ away from
    $\theta=0$ using only elementary algebra plus the existing
    continued-fraction data.

(c) **Mahler equation analytic structure.**  Use $F_a(x)=(1+x^{a^k})F_a(x^a)$
    to derive analytic properties of $F_a$ on the unit disk, possibly
    yielding singularity-analysis estimates of $[x^N]F_a(x)$.

(d) **Sárközy-style additive combinatorics input.**  Subset sums of
    geometrically-distributed integers were studied by Sárközy and others;
    extract whatever density bounds are already in the literature.

## 8. Verification

`scripts/cas_density_check.py` mechanically verifies:

- the inequality $\log_2 a \le a-1$ for $a\in[3,100]$ (numerical) and
  the symbolic derivative argument for $a\ge3$ (closed form);
- the identity $R(A)\le\sum_a 1/\log_2 a$ on every set in the project's
  test catalogue;
- the density growth $\rho(T)\asymp T^{\sum 1/\log_2 a-1}$ for the
  generating-function expansion of $\{3,4,7\}$ at $k=1$, seed limits
  up to 5000.

All computations are exact (rational arithmetic for the algebraic identity,
explicit polynomial expansion for the generating function).

## Status

This note adds no Certified obligation to the global proof audit.  It
introduces a candidate research direction.  The right next move is to
write down a precise quantitative LLT and check whether the characteristic
function bound it needs is within reach for the local cases.
