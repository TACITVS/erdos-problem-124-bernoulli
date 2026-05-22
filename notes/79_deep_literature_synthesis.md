# Deep literature synthesis on BC L² — finding new ideas

This note synthesizes results from a multi-agent bibliographical
search and identifies the **single most promising new attack
direction** for BC L² in our integer-Pisot setting.

## 0. Headline finding

> **The Damanik-Gorodetski-Solomyak 2015 (Duke) technique combined
> with Mignotte-Waldschmidt effective Diophantine bounds is the
> previously-unexplored attack direction** for the BC L² conjecture
> in our integer-Pisot multi-base setting.
>
> The missing ingredient in all prior frameworks is a "non-parametric
> transversality replacement" at fixed integer-Pisot ratios.  MW-style
> bounds on $|m \log a - n \log b|$ for multiplicatively-independent
> integer pairs $(a, b) \in A$ might provide this.

## 1. Comprehensive landscape map

Based on the deep literature search (agent 1 + targeted follow-ups):

### 1.1 Frameworks ruled OUT (and why)

| Framework | Reference | Why blocked for integer-Pisot multi-base |
|---|---|---|
| Solomyak 1995 transversality | Ann. Math. 142 | $\lambda > 1/2$ required |
| Hochman 2014 entropy | Ann. Math. 180 (arXiv:1212.1873) | Gives dim, not AC for Pisot |
| Shmerkin 2014 | GAFA 24 (arXiv:1303.3992) | Parametric; integer-Pisot in exceptional set |
| Varjú 2019 | JAMS 32 (arXiv:1602.00261) | Requires $\lambda$ near 1 |
| Kittle-Kogler 2024 | arXiv:2409.18936 | Separation hypothesis fails for overlap |
| Saglietti-Shmerkin-Solomyak 2018 | arXiv:1709.05092 | Parameter regime + Fourier non-decay |
| Algom-RHertz-Wang 2024 | arXiv:2407.16699 | Self-similar (linear) excluded |
| Bourgain Fourier dim | Various | No closed form for integer-ratio sums |
| Kahane-Salem 1958 | Coll. Math. 6 | Criteria for L², but Pisot reciprocals fail |
| Garsia 1962 | Trans. AMS 102 | Sufficient AC for specific algebraic $\lambda$, integer-Pisot $1/n$ is *singular* per Erdős 1939 |

### 1.2 Closest existing analogue: Nazarov-Peres-Shmerkin 2009

**arXiv:0905.3850** — "Convolutions of Cantor measures without resonance."

For $a, b \in (0, 1/2)$ with $\log b/\log a \notin \mathbb Q$ and any $\lambda \ne 0$:
$$\dim(\mu_a * (\mu_b \circ S_\lambda^{-1})) = \min(\dim C_a + \dim C_b, 1).$$

**Crucial observation:** they prove DIM = 1, but **NOT** AC.

**Critical warning from NPS:**
> "For uncountably many values of $\lambda$, the convolution
> $\mu_{1/4} * (\mu_{1/3} \circ S_\lambda^{-1})$ is **singular**
> despite the dimension sum exceeding 1."

This is a **negative result** showing dim = 1 doesn't imply AC.  Our
specific case ($\lambda = 1$, no rescaling) is not directly addressed
by NPS — it remains open whether $\mu_{1/3} * \mu_{1/4}$ is AC or
singular.

This is a real cautionary flag: **the BC L² conjecture may be FALSE for
some specific hypothesis-meeting cases**, despite empirical support
for 38 cases tested at $T \le 10^7$.

## 2. The newly-identified attack direction: DGS + MW

### 2.1 Damanik-Gorodetski-Solomyak 2015 (Duke)

**arXiv:1306.4284** — "Absolute Continuity of Convolutions of
Singular Measures"

The DGS technique proves AC of convolutions of:
- A singular measure $\mu$ arising from hyperbolic dynamics (exact-dimensional).
- An exact-dimensional measure $\nu$ from a parameter family.

**Key requirement.** A *transversality* condition on the parameter
family.  Specifically, the parameter-derivative of the relevant
quantities must satisfy a separation condition.

For our integer-Pisot multi-base $\mu_A = *_{a \in A} B_{1/a}$:
- Each $B_{1/a}$ is exact-dimensional (dimension $1/\log_2 a$,
  computable).
- $\mu_A$ is exact-dimensional by Marstrand-Mattila (assuming Marstrand
  hypothesis).
- **No parameter family** — bases $A$ are fixed integers.

The substantive missing input: a **non-parametric transversality
replacement**.

### 2.2 The proposed bridge: Mignotte-Waldschmidt effective bounds

For multiplicatively-independent pairs $(a, b) \in A$ (e.g., $a = 3,
b = 4$), Mignotte-Waldschmidt 1993 + Laurent et al.\ give effective
lower bounds:
$$|m \log a - n \log b| \ge \frac{C(a, b)}{\max(m, n)^{\kappa(a, b)}}$$
for explicit $C, \kappa > 0$ depending on $a, b$.

These bounds are **quantitative Diophantine** — they describe how
"transverse" the orbits $\{m \log a\}$ and $\{n \log b\}$ are in the
real line.

**Claim (proposed):** MW-type bounds for ALL pairs in $A$ provide a
**non-parametric transversality replacement** for the DGS framework.

The argument structure (to be verified):

1. The Fourier transform $\hat B_{1/a}$ has zeros at $\xi = (2k+1) a^j/2$.
2. Cross-pair zeros: $\hat B_{1/a}(\xi) \hat B_{1/b}(\xi)$ has zeros at
   the UNION of two sets of rationals with denominators powers of $a$
   and $b$.
3. MW-type bounds give: pairs of zeros from different bases are
   $|p/q_a - p'/q_b| \ge C/\max(q_a, q_b)^{\kappa}$ apart, in
   quantitative form.
4. This **quantitative separation** can substitute for the parameter
   family in DGS-style estimates.
5. Combined with the exact-dimensional structure, this would give AC
   (and possibly L²) of $\mu_A$ at fixed integer parameters.

### 2.3 Why this might work where prior frameworks failed

- **Solomyak/Hochman/Shmerkin/Varjú**: all need $\lambda > 1/2$ or
  algebraic-parameter genericity.  Don't use Diophantine input from
  $\log a / \log b$ ratios.
- **Kittle-Kogler**: needs separation, fails for overlapping IFS.
- **DGS**: needs transversality on parameter family.

The **MW-Diophantine input** is specifically designed for fixed
integer parameters $(a, b)$, gives quantitative gaps between rational
combinations, and is what the CF/MW route already uses in
notes 46, 07, 09, 10, 11.

So: combining the project's existing MW infrastructure with the DGS
framework structure might yield a NON-PARAMETRIC AC theorem.

## 3. What's NEEDED to pursue this direction

1. **Read the DGS Duke 2015 paper in full** — understand the
   transversality hypothesis precisely.  Pre-2026 references:
   Damanik-Gorodetski-Solomyak, "Absolutely Continuous Convolutions
   of Singular Measures," Duke Math. J. **164** (2015), 1603-1640.
2. **Reformulate DGS's transversality** as a quantitative Diophantine
   condition on the underlying measure's Fourier support.
3. **Apply MW bounds** to verify the Diophantine condition for
   integer-Pisot pairs.
4. **Quantify the resulting AC bound** — does it give L² density or
   just AC?

This is a **multi-session research program** at the level of a paper.
Not closable in one session, but a *new and concrete* direction not
previously identified.

## 4. The NPS warning: BC L² might be FALSE for some cases

NPS 2009's "uncountably many singular rescalings" observation means
that dimension = 1 does NOT guarantee AC.  For our setting:

- All 38 cases tested at $T \le 10^7$ show empirical L² saturation.
- But the NPS family of singular convolutions warns: there exist
  multi-base setups (in a near-by family) where AC fails.

**Could there be hypothesis-meeting $A, k$ where BC L² fails?**

Empirically no, up to our test scope.  Theoretically: possible per
NPS-style construction.

**Specific question to test:** for $\mu_A * (\mu_{A'} \circ S_\lambda^{-1})$
with $A, A'$ disjoint and $\lambda$ varied, does NPS's singular
regime overlap with Erdős 124's hypothesis-meeting regime?

If yes: BC L² is provably FALSE for some cases ⟹ Erdős 124 doesn't
reduce to BC L² in the way we hoped.  Erdős 124 might still hold
(via different mechanism) or even fail (counterexample).

This is a **research-level question worth investigating**.

## 5. Other identified leads (lower priority)

### 5.1 Strichartz/Lau-Ngai Sobolev dimension framework

Strichartz, Taylor, Zhang and Lau-Ngai developed a Sobolev-dimension
framework for self-similar measures.  Computes Sobolev dim per base
$a$, aggregates under convolution.

For L² density: need Sobolev dimension > 1/2.

For our multi-base: aggregation under convolution gives sum of Sobolev
dims = $\sum 1/(2 \log_2 a)$ (heuristically).  For Marstrand strict:
this is $> 1/2$.  **Plausibly gives L² density**.

**Status:** Sobolev-dim aggregation under convolution would need to
be verified rigorously — not standard for overlapping multi-base.

### 5.2 Feng's multifractal analysis for Salem numbers

Feng (and others) have multifractal analysis of BC at Salem numbers.
Salem reciprocals are a different class than Pisot.

**Relevance:** maybe an indirect path.  Salem numbers are roots of
specific polynomials; integer-Pisot $\lambda = 1/n$ are not Salem.

### 5.3 Bourgain Fourier-dimension formulas

No closed-form Bourgain formula for $\dim_F(C_a + C_b)$ at fixed integer
ratios was found in the literature.  Open.

## 6. Recommendation

Pursue the **DGS + MW** direction (§2):
1. Read DGS 2015 Duke paper to understand precise transversality.
2. Reformulate as Diophantine condition.
3. Apply MW bounds to integer-Pisot pairs.
4. Quantify AC/L² conclusion.

This is the FIRST concrete attack direction that uses the project's
existing MW infrastructure in a fractal-geometric way, bridging
combinatorial Erdős 124 with Bernoulli convolution AC.

**Honest scoping:** this is a paper-length research program, requiring
multiple sessions of literature reading + technical work.  But it is
a NEW direction emerging from this deep literature search.

## 7. Status

This note (Phase B-12) synthesizes the deep bibliographical search.
Three parallel agents were launched but two hit rate limits; the
findings from the completed one (BC L² literature) plus targeted
follow-ups establish:

- **No existing technique directly closes** BC L² for integer-Pisot
  multi-base (15th honest negative).
- **NPS 2009's "uncountably singular rescalings"** is a warning that
  BC L² might fail for some specific cases.
- **DGS + MW** is the newly-identified attack direction worth a
  dedicated multi-session program.

The literature is now mapped.  The next session in this direction
should read DGS 2015 Duke paper carefully and attempt the
non-parametric transversality reformulation.

## Sources

- [Nazarov-Peres-Shmerkin 2009](https://arxiv.org/abs/0905.3850)
- [Damanik-Gorodetski-Solomyak 2015](https://arxiv.org/abs/1306.4284)
- [Solomyak "Sixty Years of Bernoulli Convolutions"](https://gauss.math.yale.edu/~ws442/papers/sixty.pdf)
- [Solomyak "Bernoulli convolutions 2023"](https://arxiv.org/pdf/2311.00569)
- [Kahane-Salem 1958 (cited via secondary)](https://eudml.org/doc/210272)
- [Garsia 1962](https://www.ams.org/journals/tran/1962-102-03/S0002-9947-1962-0137961-5/)
- [Kittle-Kogler 2024](https://arxiv.org/abs/2409.18936)
- [Shmerkin Annals 2019](https://arxiv.org/abs/1609.07802)
- [Algom-Rodriguez Hertz-Wang 2024](https://arxiv.org/abs/2407.16699)
