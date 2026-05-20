# Erdős Problem 124 — proof state

This document is the consolidated reference for the project.  Its purpose
is to state, precisely and conservatively, **what is proved**, **what is
imported**, **what is conjectural**, and **what is open**.

Every claim below has been cross-checked against the typed Haskell
certificates in `haskell/`, the Python CAS scripts in `scripts/`, and the
running outputs in `results/`.  Claims that could not be verified are
flagged as such.

## 1. Problem

The hard form of Erdős Problem 124 used here:

> **Conjecture (Erdős 124, hard form).**  Let $A\subseteq\mathbb Z_{\ge3}$
> be finite with
>
> $$
> \gcd(A)=1,\qquad \sum_{a\in A}\frac{1}{a-1}\ge1.
> $$
>
> Then for every $k\ge1$, every sufficiently large integer is a finite
> subset sum of $\{a^e:a\in A,\ e\ge k\}$ (multiset, allowing equal
> integer values from distinct base/exponent pairs).

The conjecture is **not** proved here, unconditionally or otherwise.

## 2. What the project actually proves

### 2.1 Local certificates (five cases, computer-assisted)

Five specific cases are certified end-to-end.  The certificates split
into two families by the proof route:

**(i) Exact-critical cases ($R(A)=1$), CF/MW route.**  Proof: finite
seed bitset scan + typed Haskell CF frontier check + imported
Mignotte–Waldschmidt bound for $|3^p-4^q|$.

| set                 | $k$ | $R(A)$ | conductor (last missing) | bound $6K$ (or $24K$) | states scanned | min margin       | certificates |
|---------------------|-------|----------|--------------------------|---------------------------|----------------|------------------|--------------|
| $\{3,4,7\}$       | 1     | 1        | 581                      | 7,002                     | 2              | 460,482          | TailCertificate, CFTailCertificate; note 46 |
| $\{3,4,7\}$       | 2     | 1        | 3,982,888                | 47,794,770                | 7              | 323,200,122      | TailCertificate, CFTailCertificate; notes 07, 09 |
| $\{3,4,7\}$       | 3     | 1        | 166,025,260              | 1,992,303,678             | 4              | 14,827,662,282   | TailCertificate, CFTailCertificate; note 10 |
| $\{3,4,9,25\}$    | 2     | 1        | 452,099                  | 21,701,880                | 8              | 313,609,752      | TailCertificate, CFTailCertificate; note 11 |

These four depend on the Mignotte–Waldschmidt bound for $\log 3/\log 4$
as imported analytic input.

**(ii) Strict case ($R(A)>1$), CFH route.**  Proof: finite seed
interval + bounded-gap absorption (Chen–Fang–Hegyvári lemma), no MW
input required.

| set              | $k$ | $R(A)$ | ray start | CFH gap bound | strict takeover step | certificates |
|------------------|-------|----------|-----------|---------------|----------------------|--------------|
| $\{3,4,5\}$    | 1     | 13/12    | 80        | 2,187         | 4                    | CFHTailCertificate; note 26 |

This one is **fully unconditional** — no imported analytic theorem is
used, only combinatorial CFH and the finite seed interval.

Each proof terminates a finite computation; the finite computation is
part of the proof.  Across all five, the imported analytic input is at
most a single classical theorem (Mignotte–Waldschmidt for the four
exact-critical cases; nothing for $\{3,4,5\}$).

### 2.2 Algebraic framework (certified, problem-independent)

Building blocks proved as standalone algebraic theorems with typed
Haskell certificates and (where relevant) SymPy CAS verification:

| obligation                              | content                                                        | reference          |
|-----------------------------------------|----------------------------------------------------------------|--------------------|
| tail invariant in conductor form        | $K(E)=\kappa(A,k)+2c(E)+1$                                   | note 28            |
| scaled conductor identity               | $K(B,E)=\kappa_{\text{scaled}}(B)+2c+1$                      | note 43            |
| density growth identity                 | $\sum_a 1/\log_2 a\ge R(A)\ge 1$, from $\log_2 a\le a-1$  | note 47            |
| quotient reciprocal-sum identity        | $R$ of scaled quotient block = $R(D(m,A))$                 | note 40            |
| modulus search reduction                | finite enumeration over squarefree divisors of $\operatorname{rad}(\prod A)$ | note 41 |
| resonance lattice obstruction           | $\Delta(A,p,q)>0$ iff $\gcd(A)=1$                          | note 49            |
| asymptotic half-sum reach               | $S'\ge2(c'+1)+\lceil F_{\text{tot}}/m\rceil$                 | note 39            |
| single-progression absorption count     | closed-form prefix length, dyadic dichotomy                    | note 42            |
| same-base Frobenius reduction           | conductor $\le F(\mathbf q)\cdot d^{e_{\min}}+O(1)$          | note 44            |
| complete-sequence absorption            | ordered-term absorption preserves central conductor             | note 36            |
| modular conductor lift                  | $c(F\cup mG')\le m(c'+1)+R-1$                                | note 33            |
| unit-base residue frame                 | construction from any unit modulo $m$                        | note 30            |
| residue-frame lifting bridge            | width-$R$ frame lifts $[M_0,M_1]$ to $[M_0+R,M_1]$       | note 29            |
| bounded-gap bridge                      | seed interval + bounded-gap tail $\Rightarrow$ cofinite ray   | note 24            |
| multiplicative-class reduction          | gcd-one base set has $\ge 2$ multiplicative classes          | note 17            |
| CFH strict tail (specific instance)     | $\{3,4,5\}$ k=1                                             | note 26, CFHTail   |

Each is checked by a Haskell certificate in `haskell/`; the CAS scripts
in `scripts/` mechanically verify the relevant algebraic identities.

### 2.3 Boss-tree closures

`haskell/ConductorBossTree.hs` records the dependency graph among
sub-obligations.  At the time of writing: 23 nodes total — **17 Done,
5 Open, 1 Imported**.  The "next cuts" (Open nodes with all dependencies
closed) are `scaled-power-middle-interval` and `quotient-block-selection`.
The `erdos-124` root remains Open.

## 3. What the project imports (analytic Diophantine input)

`haskell/GlobalProofAudit.hs` records three Imported obligations:

| imported obligation                          | source                          | role                                          |
|----------------------------------------------|----------------------------------|-----------------------------------------------|
| Mignotte–Waldschmidt for $\log 3/\log 4$   | classical                       | tail closure for local $\{3,4,7\}$ certificates |
| qualitative S-unit exact-critical tail       | S-unit finiteness theorem       | rules out bounded near-collisions             |
| Subspace-Theorem power-saving S-unit gap     | Evertse–Schlickewei–Schmidt etc | upgrades to sublinear near-collision exclusion |

These are the inputs that would be replaced by **effective Pillai**
(itself a consequence of ABC); see §5 below.

## 4. What is genuinely Open

`haskell/GlobalProofAudit.hs` lists exactly **one** Open obligation:

> **Global power-saving central conductor theorem.**  Prove
> $c(E)=o(T(E))$ in the strict case $R(A)>1$, and
> $c(E)=O(T(E)^{1-\epsilon})$ for some $\epsilon>0$ in the
> exact-critical case $R(A)=1$.  Here $T(E)=\min_i E_i$ is the
> minimum frontier power.

This is a *combinatorial* obligation about the size of the finite seed
conductor.  No published theorem closes it under any assumption we have
found.  See note 28 for the precise formulation and notes 34, 42, 44 for
partial reductions.

The boss tree's Open nodes (`scaled-power-middle-interval`,
`quotient-block-selection`, `strict-conductor`, `exact-conductor`,
`erdos-124`) all flow from this single combinatorial obligation.

## 5. Conditional reductions

The project admits two distinct conditional reductions.  The second
(post-note 59) is sharper.

### 5.1 First reduction (notes 53–56)

> **Conditional theorem (ABC + conductor).**  Assume both:
>
> **(α)** the ABC conjecture (which by Stewart–Yu 2001 implies effective
> Pillai, replacing the three Imported analytic obligations with a
> single uniform effective Diophantine input);
>
> **(β)** the power-saving central conductor theorem (the single Open
> combinatorial obligation in §4).
>
> Then for every finite set $A\subseteq\mathbb Z_{\ge3}$ with
> $\gcd(A)=1$ and $\sum_{a\in A}1/(a-1)\ge1$, and every $k\ge1$,
> every sufficiently large integer is a subset sum of
> $\{a^e:a\in A,\ e\ge k\}$.

(α) and (β) are **independent** open problems.  See note 56 (corrected
form after audit) for the full chain.

### 5.2 Second reduction (notes 58–60)

Notes 58, 59, 60 identify a *different* conditional reduction, via
fractal-geometric analysis of Bernoulli convolutions:

> **Conditional theorem (multi-base Bernoulli AC).**  Assume the
> **Multi-base Bernoulli AC Conjecture** (note 58 §4): for every
> hypothesis-meeting finite $A\subseteq\mathbb{Z}_{\ge3}$, the
> multi-base Bernoulli convolution $\mu_A = *_{a\in A} B_{1/a}$ is
> absolutely continuous on $\mathbb{R}$.
>
> Then Erdős 124 holds for every hypothesis-meeting $A,k$.

The reduction chain (note 59 Theorem 7) is: AC of $\mu_A$ implies
Fourier convergence of $\hat X_T(\xi/T)\to\hat\mu_A(\xi)$ (Lemma 3.1)
implies support density of $X_T$ tends to 1 (Lemma 4.1) implies
conductor $c(T)=o(T)$ (Lemma 5.1) implies Erdős 124 (Theorem 6.1).

**Note 60 sharpens the conjecture** to the stronger:

> **L² Conjecture.**  For hypothesis-meeting $A$,
> $\hat\mu_A\in L^2(\mathbb R)$, equivalently $\mu_A$ has density
> in $L^2$.

This is strictly stronger than AC.  Empirical Fourier-side test
(`scripts/cas_bernoulli_AC_deep.py`): the integral $\int_{-T}^T
|\hat\mu_A|^2\,d\xi$ **saturates** as $T\to\infty$ for every
hypothesis-meeting case tested, signature of L².  Single-base
$B_{1/a}$ for integer $a$ gives linearly growing integral
(signature of singular Cantor measure).

**Rigorous partial result (note 60 §2):** For hypothesis-meeting
$A$ with multiplicatively independent bases,
$\dim_H(\mu_A) = 1$, by Marstrand-Mattila.  This is the necessary
condition for AC; sufficiency is open.

**Why 5.2 is sharper than 5.1.**

- 5.1 needs *two* independently-open conjectures from two different
  research areas.
- 5.2 needs *one* conjecture, in a different research area than 5.1
  (fractal geometry / Bernoulli convolutions, with active progress:
  Solomyak 1995, Hochman 2014, Shmerkin 2014, Varjú 2019).
- The dimension-sum condition $\sum 1/\log_2 a > 1$ is *exactly*
  the hypothesis condition (note 47), giving the necessary condition
  for AC for free.  Marstrand-Mattila is the rigorous form (note 60 §2).
- Empirical evidence supports both the AC and the stronger L²
  conjecture for every hypothesis-meeting case tested.

5.1 and 5.2 are *parallel* reductions, not nested.  Either would close
Erdős 124 independently.

**The cleanest sub-problem (note 60 §7):** is $B_{1/3} * B_{1/4}$
absolutely continuous?  This is the smallest non-trivial case
($\dim = 1.13$) and is directly attackable by Solomyak transversality,
Marstrand projection, Hochman entropy, or direct Fourier estimate.

## 6. Disparate areas attempted

A timeboxed exploration covered eleven disparate areas (notes 53–56,
extended):

| area                                          | gives a reduction? | obstacle |
|-----------------------------------------------|--------------------|----------|
| ergodic theory of $\times a,\times b$ (Furstenberg)              | no | quantitative equidistribution = ABC-strength |
| generating functions / Mahler equation                              | no | analytic obligation identified, not closed |
| lacunary harmonic analysis (Sidon)                                  | no | naive constants 50× too loose |
| Aistleitner–Frühwirth–Hauke–Manskova MGF                            | no | cubic term sharp, sub-Gaussian fails at $N^{1/6}$ |
| Evertse–Schlickewei effective S-unit constants                      | no | $10^{83}$ bound, loose by orders of magnitude |
| Combinatorial Nullstellensatz (Alon)                                | no | modular coverage only |
| Skolem–Mahler–Lech                                                  | no | equivalent to MW |
| algebraic geometry of monomial schemes                              | no | too vague |
| Cobham theorem / decidability                                       | no | undecidable; $R$ not jointly recognizable |
| Conlon–Fox–Pham additive combinatorics                              | no | solves Ramsey-completeness, different problem |
| sieve theory (Selberg)                                              | no | recovers existing residue gate |

Additional areas considered after pushback: Hardy–Littlewood circle
method (subsumed by our LLT framing), Gowers norms / higher-order
Fourier (detects APs not gaps), Tao–Vu entropy (recovers note 47
identity).

## 7. Honest summary

What the project *does*:

- Provides a clean algebraic framework for the conductor + tail structure
  of Erdős 124, with every algebraic identity certified.
- Proves Erdős 124 for five specific local cases: $\{3,4,7\}$ at
  $k\in\{1,2,3\}$ and $\{3,4,9,25\}$ at $k=2$ (CF/MW route,
  imported MW input); and $\{3,4,5\}$ at $k=1$ (CFH route, no
  imported analytic input — fully unconditional).
- Identifies the analytic obligation as effective Pillai = ABC-strength.
- Identifies the combinatorial obligation as the power-saving central
  conductor theorem (independent of ABC).
- Documents eleven disparate-area attempts with honest negative results,
  showing the two obstacles are not artifacts of one route but are
  genuinely at the frontier.

What the project *does not* do:

- Prove Erdős 124 unconditionally for any $A$ outside the five cases.
- Reduce Erdős 124 to ABC alone (the combinatorial obligation remains).
- Provide a uniform algorithm with explicit $N_0(A,k)$ bound.
- Close the power-saving central conductor theorem.
- Close ABC.

## 8. Auditing this document

Every numerical claim was cross-checked against the running output of
`scripts/run_certificates.py` (26/26 pass, May 2026) and the individual
Haskell certificate scripts.  Every reference to an Open / Imported
status was cross-checked against the live `GlobalProofAudit.hs` and
`ConductorBossTree.hs` outputs.

If you find a claim in this document that you cannot verify against the
project's code, please open an issue.  The discipline of "no false
positives" supersedes any claim of result here.
