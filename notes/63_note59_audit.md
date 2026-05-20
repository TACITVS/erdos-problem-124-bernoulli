# Hostile audit of Note 59

Plan-mandated audit (Phase 1) of the chain in
`notes/59_rigorous_equivalence.md`.  Goal: convert "sketched chain" into
"every step fully written or explicit gap acknowledged."  This note
finds **three substantive issues** with Note 59 as written, all
patchable, and presents the patched chain.

## 0. Verdict

| step | status in Note 59 | finding in this audit |
|---|---|---|
| Lemma 3.1 (Fourier rescaling) | claims convergence on a sub-sequence with $\log_a T\in\mathbb Z$ | The naive sub-sequence is **empty** for $\lvert A\rvert\ge 2$ with distinct bases. **Patchable** via compactness on the torus |
| Lemma 4.1 (AC ⟹ support density) | uses "$\int_{\mathbb R}\lvert\hat X_T\rvert^2\,d\xi$" identity | That integral **diverges**; Parseval for $X_T$ lives on $[0,2\pi]$, not $\mathbb R$. **Patchable** by re-deriving via Parseval on $[0,2\pi]$, but the hypothesis needs **strengthening** to "$\mu_A$ has L² density," not merely AC |
| Lemma 5.1 (density ⟹ conductor) | states "$\rho_T\to 1 \iff c(T)/S(T)\to 0$" | The "$\Leftarrow$" direction is correct; the "$\Rightarrow$" direction is **false** — a single gap of size $\alpha S(T)$ plus full support elsewhere gives $\rho_T=1-1/S(T)\to 1$ with $c(T)/S(T)\not\to 0$. **Patchable** but needs the sub-interval density given by the strengthened Lemma 4.1, not the global density alone |

After patching, the chain reads:

> **Patched Theorem 7.**  If $\mu_A$ has L² density (i.e.\ $\hat\mu_A\in L^2(\mathbb R)$) and the density is bounded below on its support, then Erdős 124 holds for $A,k$.

The "L² density" hypothesis is **exactly what our empirical I(T)
saturation tests** (notes 60–62), so this strengthening is in fact a
clarification of what the project has actually been measuring, not a
weakening of what we can hope to prove.

The patched conclusion is what the user should cite going forward.
The unpatched chain in Note 59 should not be cited as written.

---

## 1. Lemma 3.1 — dilation sub-sequence is empty

### Issue

Note 59 lines 92–94 claim:

> The dilation constant arises from the factor-of-$a$ slop in
> $e_a(T)$; choosing a sub-sequence of $T$ with $\log_a T$ integer
> removes it.

This works for a *single* base $a$ (take $T=a^m$, $m\in\mathbb N$).
For *multiple* bases $A=\{a_1,\dots,a_n\}$ with distinct primes in the
factorisations, we need $\log_{a_i}T\in\mathbb Z$ *simultaneously* for
all $i$.  That requires $T = a_1^{m_1} = a_2^{m_2} = \dots = a_n^{m_n}$,
which for coprime distinct integers $a_i$ has the unique solution
$T=1$.  The sub-sequence is empty.

Concretely for $A=\{3,4\}$: we need $T = 3^m = 4^n$ for some
$m,n\in\mathbb N$, equivalently $3^m=2^{2n}$, which by unique
factorisation forces $m=n=0$, $T=1$.

### Patch

Replace "choose sub-sequence" with the following compactness argument:

**Patched Lemma 3.1.**  Define $\theta_a(T) := \log_a T - \lfloor\log_a T\rfloor
\in [0,1)$ (the "per-base offset").  As $T\to\infty$, the vector
$\theta(T) := (\theta_a(T))_{a\in A}$ traces a sequence in the torus
$\mathbb T^{|A|} = [0,1)^{|A|}$.  By Bolzano-Weierstrass, every
sub-sequence $T_k\to\infty$ has a sub-sub-sequence $T_{k_j}$ along
which $\theta(T_{k_j})\to\theta_*\in\mathbb T^{|A|}$.

Along such a sub-sub-sequence, $\hat X_{T_{k_j}}(\xi/T_{k_j})\to
\hat\mu_A^{\theta_*}(\xi)$ pointwise, where
$\mu_A^{\theta_*}$ is the multi-base BC measure dilated by the
limit-offset vector — specifically the law of
$\sum_a a^{-\theta_*(a)} Y_a$ where $Y_a$ is the standard $B_{1/a}$.

If the unrescaled $\mu_A$ is AC, then $\mu_A^{\theta_*}$ is also AC
(dilation preserves AC).  By Lévy continuity,
$X_{T_{k_j}}/T_{k_j}\stackrel{d}{\to}\mu_A^{\theta_*}$.

The downstream Lemmas 4.1 and 5.1 must then be stated as: "along this
sub-sub-sequence, the density / conductor conclusion holds."  This is
fine for proving "every large $N$ is achievable" (Theorem 6.1) because
we just need *some* sub-sequence.

### Cost of the patch

Minimal — the conclusion of Note 59 (Erdős 124) is recovered
verbatim, because we only ever needed *some* sub-sequence of $T$ to
work.  But the proof must be re-written; the "$T\to\infty$ along
all of $\mathbb R_+$" framing must be replaced with "along a chosen
sub-sub-sequence."

---

## 2. Lemma 4.1 — Parseval lives on $[0,2\pi]$, not $\mathbb R$

### Issue

Note 59 lines 127–135 claim:

> A cleaner route via the *energy*: for AC $\mu_A$,
> $\int|\hat\mu_A(\xi)|^2\,d\xi<\infty$.  By Parseval,
> $\int(\hat X_T(\xi/T))^2/T^2\,d(T\xi)=\int|\hat X_T(\xi)|^2\,d\xi
> \to(\text{const})\int|\hat\mu_A|^2<\infty$.

Three problems:

**(2a) AC alone does not give $\hat\mu_A\in L^2(\mathbb R)$.**  AC means
$\mu_A$ has density $f\in L^1(\mathbb R)$.  This does *not* imply
$\hat f\in L^2(\mathbb R)$.  For $\hat f\in L^2$, we need
$f\in L^2$ (Plancherel: $\|f\|_2=\|\hat f\|_2$).  L² density is
**strictly stronger** than L¹ density (= AC).

A standard example: $f(x) = 1/(x\log^2 x)$ on $[2,\infty)$ is L¹ but
not L². So "AC + bounded density" is needed for $\hat\mu_A\in L^2$;
this is the same as L² density.

**(2b) $\int_{\mathbb R}|\hat X_T|^2 d\xi = \infty$.**  $X_T$ is
supported on $\mathbb Z$ (a discrete set in $\mathbb R$).  Its
characteristic function $\hat X_T(\xi)=\sum_n p_T(n) e^{2\pi i\xi n}$
is $2\pi$-periodic (not Fourier-of-distribution; the discrete-RV
characteristic function on the additive group $\mathbb Z$).  Hence
$\int_{\mathbb R}|\hat X_T|^2 d\xi = \infty$.

The correct Parseval identity is **on the torus** $[0,2\pi]$:

$$\int_0^{2\pi}|\hat X_T(\xi)|^2\,\frac{d\xi}{2\pi} = \sum_{n\in\mathbb Z} p_T(n)^2.$$

(Or equivalently, Parseval on $\mathbb Z$.)

**(2c) Change of variables is mis-scaled.**  The intended substitution
$\eta = T\xi$, $d\eta = T\,d\xi$ in the rescaled-RV integral was
written as "$\int(\hat X_T(\xi/T))^2/T^2\,d(T\xi)$".  This is
dimensionally wrong: the integrand $|\hat X_T(\xi/T)|^2$ is
dimensionless, and the change of variable replaces $d\xi$ with
$d(T\xi) = T\,d\xi$, giving an extra factor of $T$, not $1/T^2$.

### Patch (cleaner derivation from scratch)

Hypothesis: $\hat\mu_A\in L^2(\mathbb R)$ (i.e., $\mu_A$ has L² density).
Set $I_\infty := \|\hat\mu_A\|_{L^2(\mathbb R)}^2 < \infty$.

Define $\nu_T = \mathrm{Law}(X_T/T)$, supported on $\frac{1}{T}\mathbb Z$.
Its characteristic function is $\hat\nu_T(\eta) = \hat X_T(\eta/T)$ for
$\eta\in\mathbb R$.

**Step 1: $\hat\nu_T \to \hat\mu_A$ pointwise** (patched Lemma 3.1
along chosen sub-sub-sequence).

**Step 2: Parseval on $\nu_T$.**  $\nu_T$ is a discrete measure on
$\frac{1}{T}\mathbb Z\subset\mathbb R$, so it's not in $L^2(\mathbb R)$.
But we can still write the discrete Parseval identity scaled by $T$:

$$\sum_{n}p_T(n)^2 = \frac{1}{2\pi}\int_0^{2\pi}|\hat X_T(\xi)|^2\,d\xi
= \frac{1}{2\pi T}\int_0^{2\pi T}|\hat\nu_T(\eta)|^2\,d\eta
\quad(\text{sub. }\eta=T\xi).$$

**Step 3: Bound the RHS by the L² norm of $\hat\mu_A$.**  As $T\to\infty$:

$$\int_0^{2\pi T}|\hat\nu_T(\eta)|^2\,d\eta \;\longrightarrow\;
\int_0^\infty|\hat\mu_A(\eta)|^2\,d\eta = I_\infty/2,$$

provided we have uniform integrability / dominated convergence.
$|\hat\nu_T(\eta)|^2 \le 1$ for all $\eta$ (characteristic function of
a probability measure), so on bounded $\eta$ intervals dominated
convergence applies.  Tail control needs $|\hat\nu_T(\eta)|^2$
small for large $\eta$, which is **not automatic** from
$\hat\nu_T\to\hat\mu_A$ pointwise — it requires equicontinuity / tail
uniformity (e.g., uniform decay of $|\hat\nu_T(\eta)|^2$ for $\eta>R$).

**Step 4: Cauchy-Schwarz.**

$$1 = \sum_n p_T(n) \le |\mathrm{supp}(X_T)|^{1/2}\cdot
\Big(\sum_n p_T(n)^2\Big)^{1/2}.$$

So $|\mathrm{supp}(X_T)| \ge 1/\sum_n p_T(n)^2$.  Combined with steps 2
and 3:

$$|\mathrm{supp}(X_T)| \ge \frac{2\pi T}{\int_0^{2\pi T}|\hat\nu_T|^2\,d\eta}
\to \frac{2\pi T}{I_\infty/2} = \frac{4\pi T}{I_\infty}.$$

So $|\mathrm{supp}(X_T)|\gtrsim T$ as $T\to\infty$, with explicit
constant $4\pi/I_\infty$.  This is what the unpatched Lemma 4.1
wanted to conclude.

### Cost of the patch

The hypothesis is strengthened from "AC" to "L² density" — i.e., the
**stronger** of (AC, finite L² norm).  Equivalently:
$\hat\mu_A\in L^2(\mathbb R)$.

This is **exactly** what our empirical I(T) saturation tests measure:
$I(\infty) = \int|\hat\mu_A|^2 d\xi$.  Saturation means the integral
is finite, i.e., $\hat\mu_A\in L^2$, i.e., L² density.

So **the strengthened hypothesis matches the empirical evidence
exactly**.  This is in fact a *clarification*, not a weakening: what
notes 60–62 are really providing evidence for is the **L² density
conjecture**, not the weaker AC conjecture.

The L² density conjecture is what we should be stating going forward:

> **Multi-base Bernoulli L² Conjecture (revised note 58 §4).**  Let
> $A\subseteq\mathbb Z_{\ge 3}$ be finite with $\gcd(A)=1$ and
> $\sum_a 1/(a-1)\ge 1$ (Erdős hypothesis) or $\sum_a 1/\log_2 a > 1$
> (Marstrand condition).  Then $\hat\mu_A\in L^2(\mathbb R)$, i.e.,
> $\mu_A$ has an L² density.

This is **stronger** than AC, but it's what we can empirically test
and what the patched chain needs.

There's also a residual gap in Step 3 (tail uniformity for dominated
convergence).  Patchable but needs care — see §4 below.

---

## 3. Lemma 5.1 — the iff is wrong

### Issue

Note 59 lines 142–156: the proof concludes

> Density is at least $(S(T)-2c(T)-1)/S(T)\to1$ iff $c(T)/S(T)\to 0$.

The "$\Leftarrow$" direction (small $c(T)\Rightarrow$ density 1) is
correct.  The "$\Rightarrow$" direction (density 1 $\Rightarrow$
small $c(T)$) is **false** as a free-standing implication.

**Counterexample to the claimed iff.**  Suppose
$\mathrm{supp}(X_T) = [0,S(T)]\cap\mathbb Z \setminus \{c(T)\}$ for
some $c(T) = \alpha S(T)$ with $\alpha\in(0, 1/2)$.  That is, the
support is *every* integer in $[0,S(T)]$ except the single integer
$c(T)$.  Then:

- $\rho_T = (S(T))/S(T) = 1 - 1/S(T) \to 1$ as $T\to\infty$;
- $c(T) = \alpha S(T)$, so $c(T)/S(T) = \alpha \not\to 0$.

So density-1 *does not* imply conductor $o(S(T))$.

This isn't merely a theoretical pathology — it's a genuine logical
gap.  Density and largest-gap are different observables; one does not
control the other in general.

### Patch

The patched Lemma 4.1 (above) gives **more than** density-1: it gives
*sub-interval density*, via weak convergence:

> For every interval $[\alpha, \beta]\subset(0, M)$ with $0<\alpha<\beta<M
> =\sum_a 1/(a-1)$,
> $$|\mathrm{supp}(X_T)\cap [\alpha T, \beta T]| \ge c\cdot (\beta-\alpha)T$$
> for some $c>0$ and $T$ sufficiently large (where $c = \min f$ on
> $[\alpha,\beta]$, the L² density of $\mu_A$).

From this we can prove the corrected Lemma 5.1:

**Patched Lemma 5.1.**  Suppose for every $\epsilon\in(0, 1/2)$,
$|\mathrm{supp}(X_T)\cap[\epsilon T, T]|\ge c_\epsilon T$ for some
$c_\epsilon>0$ and $T$ sufficiently large.  Then $c(T) = o(T)$.

*Proof.*  Fix $\epsilon>0$.  Suppose $c(T_k) \ge \epsilon T_k$ for
some sub-sequence $T_k\to\infty$.  Then $c(T_k)\in[\epsilon T_k, S(T_k)/2]$
and is a missing point, contradicting that supp covers
$[c(T_k)+1, S(T_k)-c(T_k)-1]$ fully (so the missing $c(T_k)$ is
isolated below this interval).  But that's only one missing point,
which is fine.

The real argument: $c(T)$ is the LARGEST missing point ≤ S(T)/2.
The argument needs that no integers in $[\epsilon T, S(T)/2]$ are
missing, **except possibly the one at $c(T)$**.  Hmm, that doesn't
immediately follow from "$\rho_T \to 1$ in sub-intervals."

Let me re-examine.  Suppose $c(T)\ge\epsilon T$.  By definition,
$c(T)\not\in\mathrm{supp}(X_T)$ but every integer in
$(c(T), S(T)/2]$ is in $\mathrm{supp}(X_T)$.  By symmetry every integer
in $[S(T)/2, S(T)-c(T))$ is in $\mathrm{supp}(X_T)$.  So
$\mathrm{supp}(X_T)\supseteq[c(T)+1, S(T)-c(T)-1]$.

The only *gap* in the sense of "missing run" that we're guaranteed is
the single point $c(T)$.  Other missing points may exist in $[0,c(T)]$
or $[S(T)-c(T), S(T)]$.

So if $c(T)\ge\epsilon T$, the missing point at $c(T)\in[\epsilon T, T]$
contradicts "no missing points in $[\epsilon T, T]$" *only if* we know
*every* integer in $[\epsilon T, S(T)/2]$ is present.  But density in
$[\epsilon T, T]$ doesn't tell us that.

So **the patch above is still not enough**.  We need a stronger
density statement: not just "Ω(T) supp points in $[\epsilon T, T]$,"
but **"every integer in $[\epsilon T, S(T)/2]$ is in
$\mathrm{supp}(X_T)$ except for $o(T)$ many."**

That's a much stronger claim, and AC + weak convergence does NOT give
it.  We'd need:

> **Stronger hypothesis.**  For every $\epsilon>0$, the number of
> integers in $[\epsilon T, S(T)/2]$ *not* in $\mathrm{supp}(X_T)$
> is $o(T)$.

This is equivalent to: for every $\epsilon>0$, the missing-points
density on $[\epsilon T, S(T)/2]$ is $o(1)$.

Even this isn't enough to bound $c(T)$ — the LARGEST gap could be
$\Omega(T)$ even if the total missing count is $o(T)$.

### What this means

**Lemma 5.1 as stated in Note 59 is wrong, and the natural patches do
not recover it.**

The right object to control is **not** the density $\rho_T$ but the
**largest gap** in $\mathrm{supp}(X_T)\cap[0,S(T)/2]$, which is
$c(T)$ itself.  And the largest gap is a fundamentally different
quantity from density.

For the largest gap, the natural tool is a *finer Fourier estimate*:
the Erdős-Ko-Rado / Roth-type circle-method argument that gives
sub-interval representation counts.  This is much harder than the
weak-convergence argument Note 59 sketches.

### Bottom line on Lemma 5.1

The "AC ⟹ conductor $o(T)$" reduction is **not proved** by Note 59
and not easily patched.  This is the most serious issue in the chain.

What we have instead, after the patches:

- **L² density ⟹ $|\mathrm{supp}(X_T)|\gtrsim T$.**  Proved (patched
  Lemma 4.1).
- $|\mathrm{supp}(X_T)|\gtrsim T$ ⟹ "Erdős 124 holds with positive
  density" — i.e., a positive fraction of integers $\le S(T)/2$ are
  representable.  **This is weaker than Erdős 124**, which requires
  *every* sufficiently large integer to be representable.

So the patched chain proves a **weaker statement**:

> **Patched Theorem 7 (revised).**  If $\hat\mu_A\in L^2(\mathbb R)$,
> then a positive-density set of integers $\le S(T)/2$ are subset sums
> of $F(E(T))$, for $T$ along a sub-sub-sequence.

This is much weaker than the original Note 59 conclusion.  The gap
between "positive-density representable" and "all sufficiently large
representable" is real and is exactly the obstacle the
combinatorial-conductor framework was meant to overcome.

---

## 4. Reality check on a known case: $A=\{3,4,5\}$

Empirically (note 61), $I(T)\to 1.1628$ for $A=\{3,4,5\}$, strongly
suggesting $\hat\mu_A\in L^2$ with $\|\hat\mu_A\|_2^2 \approx 1.1628$.

Apply the patched chain:
- L² density ✓ (assumed, with empirical support).
- $|\mathrm{supp}(X_T)|\ge \frac{4\pi T}{1.1628} \approx 10.8\,T$ for
  $T$ large.  Since $S(T)\le \sum_a a/(a-1)\cdot T = (3/2 + 4/3 + 5/4)T
  \approx 4.08\,T$ for $A=\{3,4,5\}$, the support cardinality bound
  $10.8\,T$ **exceeds the available range $S(T)\approx 4\,T$**.

This is a problem: $|\mathrm{supp}| \le S(T) + 1 \le 4.08\,T + 1$.
But the patched Lemma 4.1 predicts $|\mathrm{supp}|\ge 10.8\,T$.
Contradiction.

So either:
- The constant in the patched Lemma 4.1 is wrong (an off-by-factor
  in the Parseval normalisation);
- The integral $\int_0^{2\pi T}|\hat\nu_T(\eta)|^2\,d\eta$ does *not*
  converge to $I_\infty/2$ as written;
- The hypothesis $\hat\mu_A\in L^2$ is being incorrectly applied.

Let me re-examine.  $\int_{\mathbb R}|\hat\mu_A|^2 d\xi = I_\infty$ by
definition of $I_\infty$.  Since $\hat\mu_A$ is even (real-valued
$\mu_A$), $\int_0^\infty|\hat\mu_A|^2 d\xi = I_\infty/2$.  So far so
good.

For the RHS bound on $|\mathrm{supp}|$: rederive Cauchy-Schwarz.

$$1 = \sum_n p_T(n)\cdot \mathbf 1[n\in\mathrm{supp}]
\le \Big(\sum p_T(n)^2\Big)^{1/2}\cdot|\mathrm{supp}|^{1/2}.$$

So $|\mathrm{supp}|\ge 1/\sum p_T(n)^2$.

Now $\sum p_T(n)^2 = \frac{1}{2\pi}\int_0^{2\pi}|\hat X_T(\xi)|^2 d\xi$
(Parseval on $\mathbb T$).

Substituting $\xi = \eta/T$, $d\xi = d\eta/T$:
$\sum p_T(n)^2 = \frac{1}{2\pi T}\int_0^{2\pi T}|\hat X_T(\eta/T)|^2 d\eta
= \frac{1}{2\pi T}\int_0^{2\pi T}|\hat\nu_T(\eta)|^2 d\eta$.

As $T\to\infty$, $\int_0^{2\pi T}|\hat\nu_T|^2 d\eta\to\int_0^\infty|\hat\mu_A|^2 d\eta = I_\infty/2$ (if we can swap limit and integral; see §2 caveat).

So $\sum p_T(n)^2\to \frac{1}{2\pi T}\cdot \frac{I_\infty}{2} = \frac{I_\infty}{4\pi T}$.

Hmm but that's $\to 0$ as $T\to\infty$ — which is consistent
with $|\mathrm{supp}|\gtrsim T$ via Cauchy-Schwarz.  And the explicit
constant is $|\mathrm{supp}|\ge \frac{4\pi T}{I_\infty}$.

For $A=\{3,4,5\}$ with $I_\infty\approx 1.16$: $|\mathrm{supp}|\ge
\frac{4\pi T}{1.16} \approx 10.8\,T$.  But $|\mathrm{supp}|\le S(T)+1
\approx 4.08\,T$.

So **the constants conflict**.  There's a mistake somewhere.

**Diagnosis:** the substitution $\xi=\eta/T$ converts an integral on
$[0,2\pi]$ to $[0,2\pi T]$, that's correct.  And
$\int_0^{2\pi T}|\hat\nu_T|^2 d\eta\to \int_0^\infty|\hat\mu_A|^2 d\eta$
in the limit *only* if $\hat\nu_T \to \hat\mu_A$ in $L^2_{\mathrm{loc}}$.
But $\nu_T$ is a discrete probability measure with atoms at $n/T$, so
$\hat\nu_T(\eta) = \sum p_T(n) e^{2\pi i\eta n/T}$, which is
$2\pi T$-periodic.  $\hat\mu_A$ is not periodic.

So as $T\to\infty$, the period of $\hat\nu_T$ goes to $\infty$, and on
each fixed bounded interval $[0,R]$, $\hat\nu_T\to\hat\mu_A$ pointwise.
But on $[0, 2\pi T]$ the period covers exactly *one* period of
$\hat\nu_T$, which by symmetry equals $T\cdot\int_0^{2\pi}|\hat X_T|^2/T
= \int_0^{2\pi}|\hat X_T|^2$ — but this is bounded by $2\pi$ (since
$|\hat X_T|\le 1$).

So $\int_0^{2\pi T}|\hat\nu_T|^2\,d\eta \le 2\pi$ (each period
contributes at most $2\pi$, and we cover exactly one period in
$[0, 2\pi T]$).

That gives $\sum p_T(n)^2 \le \frac{1}{2\pi T}\cdot 2\pi = \frac{1}{T}$.

By Cauchy-Schwarz: $|\mathrm{supp}|\ge \frac{1}{1/T} = T$.

OK so the *simpler* bound $|\mathrm{supp}|\ge T$ holds, without
invoking $\hat\mu_A\in L^2$ at all.  This is the **trivial bound**:
discrete supp on $[0,S(T)]$ with $S(T)\approx CT$ has support
cardinality at most $CT+1$, so the bound $|\mathrm{supp}|\ge T$ from
Parseval is consistent.

But the *strong* claim $|\mathrm{supp}|\gtrsim 4\pi T/I_\infty$ was
based on an erroneous limit-exchange.  The actual integral
$\int_0^{2\pi T}|\hat\nu_T|^2 d\eta$ does **not** converge to
$\int_0^\infty|\hat\mu_A|^2$; it converges to its *periodic average*
times $2\pi T$, which is just $\sum p_T(n)^2\cdot 2\pi T$ — tautology.

So **the "L² density ⟹ support cardinality $\gtrsim T$" claim is
trivial** (true without the L² hypothesis), and **the L² hypothesis
gives no improvement over the trivial bound** in this setup.

### Implication

The patched Lemma 4.1 gives only the trivial conclusion: support has
$\Omega(T)$ points.  This is automatic from $|\mathrm{supp}|\le
S(T)\approx CT$ and the obvious lower bound (at least one point per
unit interval after smoothing).

The L² density of $\mu_A$ is **not** captured by this Parseval-on-the-
torus argument.  The Fourier-analytic content of "L² density" is about
the *continuous* Fourier transform of $\mu_A$, not the discrete
characteristic function of $X_T$.

To translate continuous L² density into discrete combinatorics, we'd
need a different bridge — perhaps via *equidistribution of $X_T/T$ on
$[0,M]$ with explicit rate*, where the rate depends on the L² norm of
$\hat\mu_A$ via a Erdős-Turán-type inequality.

This is a **major issue**: the "AC/L²-density ⟹ Erdős 124" reduction
is much harder than Note 59 makes it look, and Note 59's argument
collapses into a triviality on closer inspection.

---

## 5. Honest gap log

After this audit:

| claim | status |
|---|---|
| Lemma 3.1 (Fourier rescaling along a sub-sub-sequence) | **OK** with the compactness patch (§1) |
| Lemma 4.1 (AC ⟹ $|\mathrm{supp}|\gtrsim T$) | **TRIVIAL** (true unconditionally; the L² hypothesis is not used) (§4) |
| Lemma 5.1 (density ⟹ conductor $o(T)$) | **FALSE as stated**, no easy patch (§3) |
| Theorem 6.1 (conductor $o(T)$ ⟹ Erdős 124) | **OK** as a tautology from the definition of conductor |
| Theorem 7 (AC ⟹ Erdős 124) | **NOT PROVED**; the chain collapses |

The strongest statement that survives the audit is:

> **Theorem (post-audit).**  If $\mathrm{supp}(X_T)\supseteq
> [c(T)+1, S(T)-c(T)-1]$ (by the definition of $c$) and $c(T) = o(T)$,
> then every sufficiently large $N$ is a subset sum of $F(E(T))$ for
> some $T$ in the sequence.

This is **Theorem 6.1 alone** — the combinatorial half — which was
already known and is not new content from Note 59.

**The genuinely new content of Note 59 — the reduction
"AC ⟹ conductor $o(T)$" — is unproven.**

## 6. Updated confidence assessment

Pre-audit confidence in Note 59: **55-65%**.

Post-audit confidence: **15-25%**, and this confidence is *not* in the
chain as written but in the *possibility* of a different, harder chain
that could connect L² density to conductor bounds.  The chain Note 59
presents does not work.

## 7. Implications for downstream notes

- **Note 58 (BC AC Conjecture as a path).** The path is now much
  longer than note 58 advertised.  Even if the AC/L² conjecture is
  true, it does NOT obviously imply Erdős 124.  The bridge from
  continuous AC to discrete conductor remains an open problem in
  itself.
- **Notes 60, 61, 62 (empirical L² saturation evidence).** Still
  valuable as evidence for the **L² density conjecture about $\mu_A$**.
  But that conjecture is no longer a one-step reduction to Erdős 124;
  it's a fascinating fractal-geometric question that may or may not
  connect to Erdős 124 by a more subtle argument.
- **PROOF_STATE.md §5.2.** The post-note-59 entry claiming
  "AC conjecture ⟹ Erdős 124 via note 59" should be retracted or
  marked as "speculative; chain not yet rigorously established."
- **RESEARCH_JOURNAL.md.** Session N+1 (rigorize equivalence) is
  **NOT** complete; this audit shows the equivalence is much harder
  than Note 59 made it look.

## 8. What to do next

Three options ranked by leverage:

1. **Try to rigorously prove the bridge with a different technique.**
   The right tool is probably an Erdős-Turán inequality (bounds on
   integer discrepancy from the Fourier transform).  Specifically:
   if $|\hat\mu_A(\xi)|^2$ has small L² norm on bounded intervals,
   then $\nu_T$ approximates $\mu_A$ in *Kolmogorov distance* (not just
   weak-*), which gives sub-interval density and hence small max gap.
   This is the natural fix but requires a careful Erdős-Turán-style
   write-up.

2. **Accept that AC/L² ⟹ conductor $o(T)$ is open** and reframe the
   project: the L² conjecture is interesting *as a fractal-geometric
   conjecture*, independent of Erdős 124.  This is the honest
   reframing.

3. **Look for a direct combinatorial conductor argument** that
   bypasses the AC/L² bridge entirely.  This was the original
   PROOF_STATE.md §5 program, which Note 58 tried to replace.  Reviving
   it is option C.

The user should choose between (1)-(3) before further investment.  My
recommendation: **(1) first** (one focused session attempting
Erdős-Turán), then **(2)** if (1) fails, since (3) returns to a path
the project had already plateaued on.

## 9. Meta lesson

This audit exemplifies the **end-of-session meta-review** memory:
*"are we on the right track / are our methods best / can we do
better / would I change anything?"*  The answer here is sobering:
Note 59 was confidently asserted across sessions 22-25 without
hostile audit, and on close reading the central new claim does not
survive.  The empirical work in notes 60-62 has been measuring
something real (L² density), but its connection to Erdős 124 is
weaker than advertised.

**Going forward:** every "X ⟹ Y" claim in a note should be subject
to an audit pass *within the same session*.  This protects against
exactly the failure mode caught here.
