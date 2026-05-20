# Erdős-Turán / local-limit-theorem bridge attempt

Plan-mandated Phase 3': attempt to prove

> **Target:** $\hat\mu_A \in L^2(\mathbb R)$ (L² density of $\mu_A$)
> ⟹ $c(T) = o(T)$.

This is the bridge Note 59 Lemma 4.1+5.1 *intended* to give but
the audit (note 63) showed does not.  The cleanest available tools are
the Erdős-Turán inequality and local limit theorems (LLT) for sums of
independent variables.  This note documents the attempt and the
obstacle hit.

## 0. Verdict

> **The bridge does not close from L² density alone.**

The Erdős-Turán inequality + Berry-Esseen for sums of independent
RVs gives **Kolmogorov-distance convergence** of $\nu_T\to\mu_A$
(stronger than weak convergence), which yields **sub-interval
average density** of $\mathrm{supp}(X_T)$.  But the bridge from
average density to **pointwise $p_T(n)>0$ for every $n$ in interior
of support** requires either:

- a stronger Fourier hypothesis ($\hat\mu_A\in L^1$, which **fails**
  for our integer-Pisot case — see §5),
- or genuinely combinatorial input about subset sums (the actual
  Erdős 124 question).

So **the L² density conjecture about $\mu_A$ does not, by Fourier-
analytic machinery alone, imply the conductor bound $c(T) = o(T)$**.
The bridge fundamentally requires combinatorial information about
representability that L² Fourier-decay does not capture.

This is consistent with the audit finding (note 63 §8) that the
"L² density of $\mu_A$" route reduces only to the trivial bound
$|\mathrm{supp}(X_T)|\gtrsim T$ via Parseval-on-the-torus.

## 1. Setup

As in note 59, fix finite $A\subseteq\mathbb Z_{\ge 3}$ with $\gcd(A)=1$
and $\sum 1/(a-1)\ge 1$.  Let

$$X_T = \sum_{a\in A}\sum_{j=k}^{e_a(T)-1}\varepsilon_{a,j}\,a^j,
\quad \varepsilon_{a,j}\sim\mathrm{Unif}\{0,1\}\,\mathrm{iid}$$

with $e_a(T) = \lceil\log_a T\rceil$, $S(T) = \sum_a(a^{e_a(T)}-a^k)/(a-1)$.

Let $p_T(n) = \mathbb P(X_T = n)$ and $\nu_T = \mathrm{Law}(X_T/T)$.

Goal: prove $c(T) = o(T)$ where $c(T)$ is the largest integer in
$[0, S(T)/2]$ not in $\mathrm{supp}(X_T)$.

Equivalently: for every $\epsilon>0$, every integer $n\in[\epsilon T,
S(T)/2]$ satisfies $p_T(n)>0$ for $T$ large.

## 2. Berry-Esseen / Erdős-Turán for $\nu_T$

The classical Berry-Esseen inequality (in the smoothing-inequality
form of Esseen) gives:

$$\mathrm{dist}_K(\nu_T,\mu_A)\le\frac{C}{M}+\frac{1}{\pi}\int_{-M}^{M}
\frac{|\hat\nu_T(\eta)-\hat\mu_A(\eta)|}{|\eta|}\,d\eta,$$

where $\mathrm{dist}_K$ is the Kolmogorov (sup-CDF) distance and $M>0$.

Taking $M\to\infty$, and using $\hat\nu_T\to\hat\mu_A$ pointwise
(Lemma 3.1 patched), with the bound $|\hat\nu_T-\hat\mu_A|\le 2$
controlled by $1/|\eta|$ near 0 (cancellation of the $1/|\eta|$
factor):

**Claim 2.1.** $\mathrm{dist}_K(\nu_T,\mu_A)\to 0$ as $T\to\infty$
along the sub-sub-sequence of Lemma 3.1.

*Proof sketch.*  Pointwise convergence on $\eta\in[-M, M]$ plus
$|(\hat\nu_T-\hat\mu_A)(\eta)/\eta|\le C$ near $\eta=0$ (since both are
characteristic functions, $\hat\nu_T(0)=\hat\mu_A(0)=1$, and their
derivatives at $0$ are bounded by the first moments of $\nu_T, \mu_A$
which are bounded uniformly).  Dominated convergence + take $M$
sufficiently large.  $\square$

So **$\nu_T$ converges to $\mu_A$ in Kolmogorov distance** (uniformly
on intervals).

## 3. Average density on sub-intervals

From Kolmogorov-distance convergence, for any interval $[a,b]\subset
[0, \sum_a a/(a-1)] = [0, M_*]$:

$$|\nu_T([a,b]) - \mu_A([a,b])| \le 2\,\mathrm{dist}_K(\nu_T,\mu_A)\to 0.$$

In particular, if $\mu_A$ has L² density $f_A$ bounded below by
$\delta>0$ on $[a,b]$, then for $T$ large:

$$\nu_T([a,b]) \ge \mu_A([a,b]) - \epsilon = (b-a)\bar f_A^{[a,b]} - \epsilon \ge (b-a)\delta/2.$$

Equivalently, the sum of probabilities $p_T(n)/T$ for $n\in T\cdot[a,b]\cap\mathbb Z$:

$$\sum_{n\in T\cdot[a,b]\cap\mathbb Z} p_T(n) \ge (b-a)\delta/2.$$

Since the number of integers $n$ in $T\cdot[a,b]$ is approximately
$(b-a)T$, the **average value** of $p_T(n)$ on this interval is
$\gtrsim \delta/(2T)$.

**This is what Berry-Esseen / Erdős-Turán buys us: sub-interval
average density of order $1/T$.**

## 4. From average to pointwise: the obstacle

We want: $p_T(n) > 0$ for every integer $n\in T\cdot(a,b)\cap\mathbb Z$.

From §3 we have:
$$\frac{1}{|T\cdot[a,b]\cap\mathbb Z|}\sum_{n\in T\cdot[a,b]\cap\mathbb Z} p_T(n) \gtrsim \frac{\delta}{T}.$$

But this average can be achieved with **some** $p_T(n) = 0$, as long
as others compensate.  E.g., if $p_T(n) = \delta/T$ on half the
integers and $p_T(n) = 0$ on the other half, the average is $\delta/(2T)$
— consistent with §3, but $p_T = 0$ for half the integers (so $c(T)$
could be $\Omega(T)$).

So **Berry-Esseen / Kolmogorov distance does not give pointwise
positivity of $p_T(n)$**.

## 5. Why hat $\mu_A \in L^1$ would suffice (and why it fails)

If we had $\hat\mu_A \in L^1(\mathbb R)$, then by Fourier inversion
$\mu_A$ has a continuous bounded density $f_A$, and the local limit
theorem (Petrov, *Sums of Independent RVs*, Ch. 7) would give:

$$\sup_n |T\cdot p_T(n) - f_A(n/T)| \to 0$$

uniformly in $n$, by dominated convergence applied to
$p_T(n) = (1/T)\int \hat\nu_T(\eta)e^{-2\pi i\eta n/T}d\eta$.  Then
$f_A>\delta$ on $[a,b]$ forces $T\cdot p_T(n) > \delta/2$ for $T$
large, i.e., $p_T(n) > \delta/(2T) > 0$ pointwise.  Combined with
symmetry of $X_T$, this gives $c(T) = o(T)$.

**But $\hat\mu_A \notin L^1$ for our case.**  $\hat\mu_A$ is a finite
product $\prod_{a\in A}\hat B_{1/a}$.  Each factor $\hat B_{1/a}$:

- Has $|\hat B_{1/a}(\xi)| \le 1$ everywhere.
- For *Pisot* parameter $1/a$ with $a$ integer ≥ 2 (i.e., $1/a$ is the
  reciprocal of a Pisot number), Erdős 1939 showed $\hat B_{1/a}(\xi)
  \not\to 0$ as $|\xi|\to\infty$.
- A finite product of bounded factors that don't decay individually
  may decay due to "cancellation" — i.e., the zeros of one factor may
  be away from the zeros of others — but in general for a *finite*
  product, the resulting function need not be in $L^1(\mathbb R)$.

In particular for $A=\{3,4\}$:
$\hat\mu_A(\xi) = \prod_n\cos(\pi\xi/3^n)\cdot\prod_n\cos(\pi\xi/4^n)$.

Both factors are uniformly bounded by 1 and individually have
$\liminf_{|\xi|\to\infty}|\cdot|>0$ (Erdős 1939).  Their product is
bounded by $\min(1, 1) = 1$ from above, but lower-bounded by the
*product of individual lim infs* on a positive-density set of $\xi$.
So $\hat\mu_A \not\to 0$ on a positive-density set, hence
$\hat\mu_A \notin L^1$ (and not even $\to 0$ at infinity).

So **the L¹-Fourier route is closed off for integer-Pisot $A$.**

## 6. What about empirical Fourier decay?

A potentially testable question: does $|\hat\mu_A(\xi)|$ have
*small-density* sets of large values, but $\int|\hat\mu_A|\,d\xi$ is
still finite?  Hmm — that's impossible: $\hat\mu_A\not\to 0$ implies
$\hat\mu_A\notin L^1$.

What about $\hat\mu_A \in L^p$ for some $1<p<2$?  By interpolation, if
$\hat\mu_A \in L^2$ (empirics, notes 60–62) AND
$\hat\mu_A \in L^\infty$ (trivially, $|\hat\mu_A|\le 1$), then
$\hat\mu_A \in L^p$ for $2 \le p \le \infty$.  But the LLT needs $L^p$
for $p \le 1$, not $p \ge 2$.  Interpolating in the *wrong* direction.

So the empirical I(T) saturation (L² norm finite) does **not** imply
the L¹ control we'd need for LLT.

We have $\hat\mu_A \in L^2 \cap L^\infty$ from the empirics, but
$L^2 \cap L^\infty \not\subset L^1$ in general.  And specifically for
our $\mu_A$, $\hat\mu_A \notin L^1$ by Erdős 1939.

## 7. The combinatorial nature of the obstacle

A cleaner way to see the obstacle: $X_T$ is a subset sum of the seed
$F(E(T)) = \{a^j : a\in A, k\le j<e_a(T)\}$.  Erdős 124 is *exactly*
the question "is every large $n$ a subset sum of some $F(E)$?"  Asking
whether $p_T(n)>0$ for every $n\in[\epsilon T, S(T)/2]$ is Erdős 124.

So **trying to derive Erdős 124 from L² density of $\mu_A$ via Fourier
inversion is trying to extract subset-sum information from a measure-
theoretic property of the continuous limit measure.**

The continuous measure $\mu_A$ encodes the *average* behaviour of
subset sums after rescaling.  It does NOT encode the *integer-level*
structure of which specific subset sums are realised.

To extract integer-level structure, we'd need either:
- Sufficiently fine Fourier decay of $\hat\mu_A$ (LLT path, blocked).
- Combinatorial input about the subset-sum problem on $F(E(T))$.

The second is exactly what the project's earlier conductor-machinery
work in `PROOF_STATE.md` §3-§5 attempted, and where the open
"global power-saving conductor theorem" obligation lives.

## 8. Therefore: the L²-density-to-Erdős-124 bridge does not close

Combining note 63 (Lemma 4.1/5.1 audit) and §§4-7 above:

> **There is no Fourier-analytic / Berry-Esseen / Erdős-Turán
> argument that bridges L² density of $\mu_A$ to $c(T) = o(T)$.**

The integer-level combinatorial structure required for $c(T) = o(T)$
is fundamentally beyond what continuous Fourier machinery at L² level
provides.  The project's earlier combinatorial conductor program was
not actually replaced by the Bernoulli-AC path; rather, the BC path
shifted the open problem to fractal geometry without solving the
underlying combinatorial obligation.

## 9. Updated framework status

After notes 63, 64, 65:

| component | pre-audit | post-audit |
|---|---|---|
| Note 58 BC AC conjecture (statement) | open conjecture in fractal geometry | open conjecture in fractal geometry (unchanged) |
| Note 59 "AC ⟹ Erdős 124" reduction | claimed proved, 55-65% | **NOT proved**, 15-25% |
| L² density of $\mu_A$ (refined conjecture) | empirically supported, 75% | empirically supported, 75% (independent) |
| L² density ⟹ Erdős 124 | implicit in Note 59 | **NOT proved**, $\le 25\%$ — needs new combinatorial input |
| Empirical I(T) saturation across 38 cases | strong evidence for AC of $\mu_A$ | strong evidence for **L² density of $\mu_A$**, but not directly for Erdős 124 |
| Erdős-Turán / LLT bridge | proposed as fix | **does not work** from L² hypothesis alone |

So the project's correct status, after this audit chain:

- **The empirical work in notes 60-62 is genuine evidence for an
  L² density conjecture about $\mu_A$ — a fractal-geometric
  conjecture of independent interest, related to Kittle-Kogler 2024.**
- **The project does NOT have a route from this conjecture to Erdős
  124.**  The earlier claim of such a route (note 58, codified in
  note 59) was based on a Parseval argument that does not work on
  closer inspection.
- **The combinatorial conductor obligation** in `PROOF_STATE.md` §5
  remains open and is essentially independent of the BC AC question.

## 10. What this means for next steps

The recommended next steps, in priority order:

1. **Retract the over-claim.**  Update `PROOF_STATE.md` and
   `RESEARCH_JOURNAL.md` to remove the "AC ⟹ Erdős 124" claim from
   note 58/59.  Mark these notes as historical record of an attempted
   path that did not pan out.  This is honesty about the project state.

2. **Reframe Notes 58-62 honestly.**  The L² density conjecture about
   $\mu_A$ is a fractal-geometric conjecture connected to current
   research (Kittle-Kogler 2024).  Notes 60-62 provide strong
   empirical evidence for it.  This is a valuable contribution **to
   fractal geometry**, not to Erdős 124.

3. **Return to the combinatorial conductor program.**  The original
   `PROOF_STATE.md` §3-§5 framework — conductor identity, density
   growth, half-sum reach threshold — is where Erdős 124 is actually
   bridged.  Reviving that program (or honestly marking it as open)
   is the correct posture for the actual problem.

4. **Do not pretend the BC path is closing Erdős 124.**  It is not.
   The audits show it is not.  Continuing to chase the BC path under
   the pretense of "almost closing Erdős 124" would be exactly the
   kind of overstatement the project's prior feedback memory warns
   against ("computation isn't proof"; "delegate mechanical
   verification to CAS").

## 11. Status

Phase 3' (this note) completes the audit triangle.  Combined with
notes 63 and 64, the project's "conditional reduction to Bernoulli AC"
narrative is dismantled.  The L² density conjecture stands as
independent fractal-geometric content, but Erdős 124 is not closer to
proof than before the BC excursion.

Adds no Certified obligation.  Removes one over-claimed conditional
reduction.  Net effect: project's honesty rating up, project's
proximity to closure unchanged.
