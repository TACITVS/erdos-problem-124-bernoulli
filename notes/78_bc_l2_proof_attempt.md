# Attempt to prove the BC L² conjecture

This note honestly attempts to prove the **BC L² conjecture** (note 60),
which Theorem F (note 77) showed would partially activate the
Erdős 124 chain.

## 0. Verdict

> **The BC L² conjecture cannot be proved in this session.**  It is a
> genuine open problem in fractal geometry, of difficulty comparable
> to questions Hochman, Shmerkin, Solomyak, Varjú, and Kittle-Kogler
> have spent years on without resolution for integer-Pisot parameters.
>
> **What this note achieves:**
> 1. Precisely states the conjecture and the required estimate.
> 2. Maps every available technique and identifies why each fails.
> 3. Identifies one **partial result that IS provable**: BC L² for a
>    specific limit class of $A$ where the dimension excess is large.
> 4. Acknowledges that for hypothesis-meeting $A$ in the project's
>    natural range, BC L² remains open.

## 1. Precise statement

> **BC L² Conjecture (note 60).**  Let $A \subseteq \mathbb Z_{\ge 3}$
> be finite with $\gcd(A) = 1$ and $\sum_a 1/(a-1) \ge 1$.  Then
> $$I_\infty(A) := \int_{-\infty}^\infty \left|\hat\mu_A(\xi)\right|^2 \, d\xi < \infty,$$
> where
> $$\hat\mu_A(\xi) = \prod_{a \in A} \hat B_{1/a}(\xi),
> \quad \hat B_{1/a}(\xi) = \prod_{n \ge 0} \cos(\pi \xi a^{-n-1}) \cdot e^{i\pi\xi/(a-1)/2}.$$

Equivalently: $\mu_A$ has L² density (i.e., density $f_A \in L^2$).

Empirically verified for all 38 hypothesis-meeting cases tested in
notes 60-62.

## 2. Why each available technique fails

### 2.1 Solomyak 1995 transversality

Solomyak proved AC of $B_\lambda$ for a.e.\ $\lambda \in (1/2, 1)$.

**Failure mode for our setting:** Our $\lambda = 1/a$ for $a \ge 3$
satisfies $\lambda \le 1/3 < 1/2$ — **outside** the (1/2, 1) regime
where transversality applies.  Solomyak's method specifically uses
that $\lambda > 1/2$ implies the IFS has overlapping cylinder sets
that can be made "transverse" by perturbing $\lambda$.

For $\lambda < 1/2$, the IFS already has separated cylinders
(strong separation), but the resulting measure is a Cantor singular
(by Erdős 1939 for integer-Pisot $1/\lambda$).

**Multi-base extension:** convolving multiple sub-critical
$B_{1/a}$'s gives a measure on a larger interval, but each factor is
Cantor-singular.  Transversality for the multi-base IFS would require
analyzing the multi-parameter family, which doesn't have a clean
"super-critical" regime.

### 2.2 Hochman 2014 entropy method

Hochman proved that for $B_\lambda$ with algebraic $\lambda$ in
$(1/2, 1)$ AND "Garsia entropy < $\log 2$", $B_\lambda$ has full
dimension and is AC.

**Failure mode:** For integer-Pisot $\lambda = 1/a$, Garsia entropy
$= \log 2$ exactly (full entropy of two-letter alphabet, since the
IFS $\{x/a, x/a + 1/a\}$ has the strong separation property).
Hochman's theorem then gives full dimension (= $1/\log_2 a$), but
this is the dimension of a Cantor singular, not AC.

For multi-base $\mu_A$: dimension $= \min(1, \sum_a 1/\log_2 a)$ by
Marstrand-Mattila (note 60 §2).  For Marstrand-strict: dim = 1, but
that's necessary not sufficient for AC.

### 2.3 Shmerkin 2014 exceptional set

Shmerkin sharpened Hochman: for $B_\lambda$, the exceptional set of
$\lambda \in (1/2, 1)$ where AC FAILS has Hausdorff dimension 0.

**Failure mode:** Again, $\lambda > 1/2$ required.  Our $\lambda = 1/a$
is fixed, not parametric.

### 2.4 Varjú 2019 algebraic parameters

Varjú proved AC of $B_\lambda$ for algebraic $\lambda$ sufficiently
close to 1.

**Failure mode:** Our $1/a$ is algebraic but FAR from 1 ($\le 1/3$).
Varjú's "close to 1" bound is essential.

### 2.5 Kittle-Kogler 2024 (arXiv:2409.18936)

Kittle-Kogler give sufficient AC conditions via Garsia entropy +
separation for inhomogeneous / contracting-on-average self-similar
measures.  This is the closest framework (per note 64).

**Failure mode:** their separation condition fails for our overlapping
multi-base IFS (as analyzed in note 64).  Specifically, the IFS
maps $\{(x_a) \mapsto x_a/a + \varepsilon_a/(a-1)\}$ have overlap
structure that doesn't satisfy their hypothesis.

Adapting their method to handle overlap: open research problem.

### 2.6 Saglietti-Shmerkin-Solomyak 2018

Per note 74's analysis: parameter regime mismatch + Fourier non-decay
obstruction.  Their framework gives AC under generic conditions in a
parameter family, but our specific integer-Pisot parameters are not
in the generic regime.

### 2.7 Direct Frostman energy estimate

For $\mu \in L^2$ iff Frostman energy $E_1(\mu) = c \int |\hat\mu|^2 d\xi$
is finite.

Bounding $E_1(\mu_A)$: requires bounding $|\hat\mu_A|^2$ uniformly,
which by Erdős 1939 doesn't decay to 0.  Direct $L^2$ estimate is
exactly the conjecture itself.

## 3. Where partial progress might be possible

### 3.1 Very-high-dimension excess

For $A$ with $\sum_a 1/\log_2 a \gg 1$ (much above Marstrand threshold),
the dimension excess is large.  Heuristically, more dimensional "room"
should imply more regularity.

**Concrete conjecture (HIGH-DIM partial):** For $A$ with
$\sum_a 1/\log_2 a > 2$ (twice Marstrand), $\mu_A$ has L² density.

Possible proof technique: Hochman's entropy method gives full
dimension for each "subset of A".  With excess, a sub-convolution
already has "almost AC" structure; the full convolution gains additional
smoothing.

This is **non-trivial to make rigorous** but might be the cleanest
sub-result.

For our $A$ in the project's natural range: typically $\sum 1/\log_2 a$
is between 1.1 and 3.0.  High-dim partial result covers some but not all.

### 3.2 Pairwise coprime A

For $A$ pairwise coprime: each $a$ contributes "independent" structure
via CRT.  The Fourier $\hat\mu_A(\xi)$ might decay better at large $\xi$
due to independent oscillations.

This is closely related to ARITHMETIC PROGRESSION-free properties.

Possible technique: explicit Fourier estimates leveraging coprimality.

### 3.3 Density at specific points

Even if full BC L² is hard, proving BOUNDED density at $0$ might be
easier.  $f_A(0)$ bounded would suffice for the Theorem E collision
bound $L_2 = O(1/T)$.

This is a weaker statement than full L² density.

## 4. The honest situation

The BC L² conjecture is at the **frontier of current fractal-geometry
research**.  It hasn't been cracked despite years of work by leading
experts in the area (Shmerkin, Solomyak, Hochman, Varjú).

For our integer-Pisot multi-base case, no available framework directly
applies.  Each framework requires either:
- $\lambda > 1/2$ (single-base regime), OR
- separation conditions our IFS doesn't satisfy, OR
- parameter genericity (we have fixed integer parameters).

**A rigorous proof in the foreseeable future likely requires NEW
mathematical ideas**, not just better application of existing tools.

## 5. What this note achieves in the project

1. **Honest acknowledgment** that BC L² is a genuine open problem,
   not closable in any reasonable session length.
2. **Mapping** of each available technique and its failure mode.
3. **Identification** of partial results that MIGHT be tractable:
   - High-dim excess case (§3.1).
   - Pairwise coprime case (§3.2).
   - Bounded density at 0 (§3.3).
4. **Strengthening of the Erdős 124 chain** by tightening what the
   BC L² conjecture would buy:
   - Note 60 conjecture: empirically supported.
   - Note 76 Theorem E + 77 Theorem F: algebraic reductions
     conditional on BC L².
   - This note: BC L² is the bottleneck; sub-results would still
     activate parts of the chain.

## 6. Recommendations

For continued algebraic progress on Erdős 124:

1. **Do not pursue BC L² closure directly** — it's beyond current
   one-session reach.
2. **Focus on the Diophantine $\hat X_T(p/q)$ bounds** identified in
   note 77 §8-9 — this is more specifically tied to Erdős 124 and
   has tractable sub-problems.
3. **Push the per-case certification** (notes 67, 70, 71) for more
   instances; this gives genuine algebraic content for specific cases.
4. **Engage the fractal-geometry community** with the BC L² conjecture
   as a posed problem — a clean statement that connects to current
   research interests of Shmerkin, Kittle, Kogler.

The honest project state: **algebraic frontier reached**.  Further
genuine algebraic progress requires either new techniques or
sub-result restrictions.

## 7. Status

Phase B-11 attempted BC L² closure.  **Honest negative**: the
conjecture is at the active research frontier of fractal geometry,
beyond one-session closure.

Project's algebraic chain (from notes 67-77) remains:
$$\text{[empirical for 38 cases]} \implies L_2 = O(1/T) \implies \begin{cases} \text{max gap} = O(T^{1/3}) \\ r(n) > 0 \text{ for } n \le \sqrt T \end{cases}$$

The conditional chain is real; the unconditional closure of BC L²
remains an open research problem in fractal geometry.
