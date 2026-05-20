# Literature dive: explicit constants for lacunary MGF and S-unit bounds

This note records what an actual literature dive (per the strategy
revision and the meta-review of note 53) yields about explicit analytic
constants for our LLT obligation.  The answer is honest: the state of the
art is sharper than I had assumed, and it shows the lacunary route has a
genuine fundamental obstacle at the scale we need.

## 1. Lacunary moment generating function (Aistleitner et al., 2025)

The recent paper

> C. Aistleitner, L. Frühwirth, M. Hauke, M. Manskova,
> *Moment generating functions and moderate deviation principles for
> lacunary trigonometric sums*, Prob. Theory and Rel. Fields (2025) (arXiv:2502.20930),

settles the MGF behaviour for lacunary trig sums under only the Hadamard
gap condition.  Specifically, for any $\{n_k\}$ with
$n_{k+1}/n_k\ge q>1$, they prove

$$\int_0^1\exp\!\Bigl(\lambda\sum_{k=1}^N\sqrt2\cos(2\pi n_k x)\Bigr)\,dx
=
\exp\!\bigl(\lambda^2N/2+O(\lambda^3 N)\bigr),
\qquad \lambda\in[-1,1],$$

with implied constant depending only on $q$.

**For the canonical case $n_k=2^k$** they compute the limiting MGF explicitly:

$$\Lambda(\lambda)
=
\frac{\lambda^2}{2}+\frac{\lambda^3}{2\sqrt2}+\frac{3\lambda^4}{16}+\cdots$$

The cubic term $\lambda^3/(2\sqrt2)$ is **non-vanishing and sharp**.  So
the Gaussian behaviour $\Lambda(\lambda)=\lambda^2/2$ holds *only to
leading order*; beyond moderate deviations, the lacunary sum is genuinely
non-Gaussian.

## 2. The implied tail constraint

Apply Chernoff with this MGF: for $t=K\sqrt N$,

$$\Pr[|W^{(a)}_N|>K\sqrt N]
\le
\exp\!\bigl(-K^2+O(K^3/\sqrt N)\bigr).$$

**Sub-Gaussian regime**: $K\le N^{1/6}$.  Here the cubic correction is
$O(1)$ and the Gaussian tail $e^{-K^2}$ is valid.

**Beyond the sub-Gaussian regime**: $K\gg N^{1/6}$.  The cubic
correction dominates and the tail is genuinely larger than Gaussian.  The
AFP sharp-threshold paper (arXiv:2511.15595) confirms this is sharp: in
the regime $t>\sqrt{2\log g_N}$, arithmetic effects in
$\{n_k\}$ take over.

## 3. What this means for Erdős 124

For our LLT closure we need

$$\Pr[|W^{(a)}_N|>K\sqrt N]<\frac{1}{T},
\qquad N\asymp\log T.$$

Gaussian gives this for $K^2>\log T$, i.e., $K\gtrsim\sqrt{\log T}=\sqrt N$.

But the Gaussian validity of the MGF only extends to $K\le N^{1/6}=(\log T)^{1/6}$.

$\sqrt N=\sqrt{\log T}$ is exponentially larger than $N^{1/6}=(\log T)^{1/6}$.

**So the AFHM 2025 MGF, applied at face value, does not give the LLT
closure** for our problem.  The required deviation $K\sim\sqrt N$ is in
the "non-Gaussian arithmetic" regime where the cubic and higher terms
matter.

## 4. S-unit equation constants

The other route — fourth-moment / S-unit (notes 51, 52) — fares no better
with literature constants.

**Beukers–Schlickewei 1996** (S-unit equation $x+y=1$ in two variables, rank $r$): at most $2^{8r+16}$ solutions.  For our $\{3,4\}$, $r=2$: $\le 2^{32}$.

**Evertse–Schlickewei–Schmidt** (general $a_1x_1+\cdots+a_nx_n=0$, rank $r$): at most $e(6n)^{5n(r+1)}$ non-degenerate solutions.

For the four-variable equation $\sum\epsilon_i a_i^{n_i}=0$ over the
rank-2 group $\{2^\alpha3^\beta\}$: $\le e\cdot 24^{60}\approx 10^{83}$.

This is **finite but astronomically loose**.  CAS enumeration in note 52
showed the actual count is in the hundreds for moderate $n_{\max}$ — so
the truth is many orders of magnitude better than the proved bound.

For the LLT closure to follow from the fourth-moment route, we would need
to bound $\mathbb E[W^4]$ by $3N^2/4+cN$ with explicit small $c$.
The Evertse–Schlickewei constant gives $c\sim 10^{83}$, which is
useless: the resulting "polynomial" deviation bound has implicit constants
beyond the universe.

## 5. The honest conclusion

After this literature dive:

(a) **No "off-the-shelf" theorem closes the LLT** for our problem with the
    constants currently available in the literature.

(b) The cubic non-Gaussian term in the lacunary MGF is **sharp** — the
    sub-Gaussian regime really does terminate at $K\sim N^{1/6}$, not at
    $K\sim\sqrt N$.

(c) The Evertse–Schlickewei constants are finite but loose by 80+ orders
    of magnitude for our specific four-variable rank-2 equation.

(d) The existing CF/MW route in the project (notes 07, 09, 46) is in fact
    *sharper* for specific cases than any "general" theorem — the CF
    analysis is base-pair-specific and uses tight Diophantine information
    that general theorems cannot match.

## 6. Strategic implication

The Erdős 124 problem appears to be **genuinely beyond** the current
analytic state of the art in three independent directions:

- Lacunary MGF tail bounds (cubic term too large).
- Schmidt-Subspace effective S-unit constants (universe-sized).
- Per-pair MW for arbitrary base pairs (only effective for specific pairs
  via continued-fraction work).

The local certificates (notes 07, 09, 46) succeed precisely because they
exploit **pair-specific** continued-fraction information that general
theorems do not.  Extending this to *all* multiplicatively independent
pairs would require an effective MW-style theorem with explicit constants
uniform in the pair — which does not appear to exist.

## 7. What this changes in our project

- **Stop** writing notes that re-package the analytic obligation.  The
  obligation has been packaged enough; the literature confirms it is genuinely
  hard.
- **Accept** that the project's local CF/MW certificates are at the
  current frontier — they are sharper than general theorems for those
  specific cases.
- **Consider** publishable framing: "a unified algebraic framework for
  Erdős 124, certified for four exact-critical local cases, conditional on
  a uniform effective Mignotte–Waldschmidt-type theorem for arbitrary
  multiplicatively independent base pairs".  This is real progress even
  without closure.

## 8. CAS verification

No new CAS script for this note.  The empirical evidence in notes 49,
52, 53 already shows: actual S-unit counts and resonance decay rates are
WAY better than the literature's general upper bounds.  The gap between
actual sharpness and provable sharpness is the analytic frontier.

## Status

Adds no Certified obligation.  Closes the literature-dive direction with
an honest negative result: existing classical and modern analytic
constants do not close the LLT for Erdős 124 at the scale we need.  The
project's local CF/MW route remains the sharpest tool available.

## References

- Aistleitner, Frühwirth, Hauke, Manskova, *Moment generating functions and moderate deviation principles for lacunary trigonometric sums*, PTRF 2025 (arXiv:2502.20930).
- Aistleitner, *A sharp threshold for arithmetic effects on the tail probabilities of lacunary sums*, arXiv:2511.15595.
- Beukers, Schlickewei, *The equation $x+y=1$ in finitely generated groups*, Acta Arith. 78 (1996).
- Evertse, *On equations in S-units and the Thue–Mahler equation*, Invent. Math. 75 (1984).
- Evertse, Schlickewei, Schmidt, *Linear equations in variables which lie in a multiplicative group*, Ann. Math. 155 (2002).
- Schlickewei, *S-unit equations over number fields*, Invent. Math. 102 (1990).
