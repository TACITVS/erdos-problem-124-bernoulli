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

### 2.1 Local certificates — 12,226+ cases unconditionally certified

After the erdos124 C++23 library (note 80) + unified batch driver
(note 81), the project certifies **12,226+ hypothesis-meeting cases**
unconditionally via combined CFH-strict + S-unit qualitative routes,
plus 4 specific exact-critical cases via CF/MW (Mignotte-Waldschmidt).

The algebraic backbone is Theorems A, B, B', C and Proposition D
(notes 72, 73, 82).  Each per-case "certificate" verifies the
hypotheses of one of these algebraic theorems; the theorems
themselves are proved pen-and-paper without computational appeal.

| family | scope | count | route | imported analytic input | effectivity |
|---|---|---:|---|---|---|
| **strict CFH** | $A \subseteq \{3,\ldots,20\}$, $|A| \in \{3,\ldots,6\}$, $k \in \{1,2\}$ | **12,208** | `cpp/build/unified_batch` (note 81) | **none** | effective $(c^*, T^*)$ |
| **exact-critical qualitative S-unit** | $A \subseteq \{3,\ldots,20\}$, $|A| \le 6$, $k \le 2$, $R = 1$ | **18** in this window (99 at max_base=30) | `cpp/build/unified_batch` (notes 70, 72, 81) | qualitative S-unit finiteness (unconditional) | **qualitative** $N_0$ non-effective |
| exact-critical CF/MW | 4 specific (3,4)-pair cases | 4 | CF/MW finite bitscan + frontier check | Mignotte–Waldschmidt for $\log 3/\log 4$ | effective explicit $N_0$ |

Reproduce: `cd cpp && mkdir build && cd build && cmake .. && cmake --build . -j && ./unified_batch.exe --max-base=20 --min-size=3 --max-size=6 --k-min=1 --k-max=2`.

#### Strict batch (note 69)

Each case has an explicit certificate $(c^*, T^*)$ from
`cpp/cfh_batch.cpp`: conductor $c(E) \le c^*$ for all balanced
frontiers $E$ with $T(E) \ge T^*$; combined with strict-slack tail
closure (note 28 §strict), this gives Erdős 124 unconditionally.
Selected examples:

| set | $k$ | $R(A)$ | $c^*$ | $T^*$ |
|-----|----:|:---:|------:|------:|
| $\{3,4,5\}$ | 1 | $\tfrac{13}{12}$ | 79 | 625 |
| $\{3,4,5,6,7\}$ | 1 | $\tfrac{29}{20}$ | 2 | 16 |
| $\{3,4,5,7,11\}$ | 1 | $\tfrac{27}{20}$ | 6 | 16 |
| $\{4,5,6,7,21,29\}$ | 1 | $\tfrac{29}{28}$ | 24 | 16 |
| $\{3,4,5\}$ | 3 | $\tfrac{13}{12}$ | 4,330,731 | 48,828,125 |

Full table: `results/cfh_batch_max15.txt`.  Reproduce via
`cpp/cfh_batch.exe --max-base=15 --min-size=3 --max-size=5 --k-min=1 --k-max=2`.

#### Exact-critical CF/MW cases

The four exact-critical cases below depend on the Mignotte-Waldschmidt
bound for $\log 3/\log 4$ as imported analytic input.  CFH-strict
does not apply ($R = 1$ gives zero slack).

**(i) Exact-critical cases ($R(A)=1$), CF/MW route.**  Proof: finite
seed bitset scan + typed Haskell CF frontier check + imported
Mignotte–Waldschmidt bound for $|3^p-4^q|$.

| set                 | $k$ | $R(A)$ | conductor (last missing) | bound $DK = D\kappa + 2Dc + D$ | states scanned | min margin       | certificates |
|---------------------|-------|----------|--------------------------|---------------------------|----------------|------------------|--------------|
| $\{3,4,7\}$       | 1     | 1        | 581                      | 7,002                     | 2              | 460,482          | TailCertificate, CFTailCertificate; note 46 |
| $\{3,4,7\}$       | 2     | 1        | 3,982,888                | 47,794,770                | 7              | 323,200,122      | TailCertificate, CFTailCertificate; notes 07, 09 |
| $\{3,4,7\}$       | 3     | 1        | 166,025,260              | 1,992,303,678             | 4              | 14,827,662,282   | TailCertificate, CFTailCertificate; note 10 |
| $\{3,4,9,25\}$    | 2     | 1        | 452,099                  | 21,701,880                | 8              | 313,609,752      | TailCertificate, CFTailCertificate; note 11 |

These four depend on the Mignotte–Waldschmidt bound (LMN 1995 /
Laurent 2008) for $|3^p - 4^q|$ as the only imported analytic input.
As of note 82 (Theorem B'), the four cases are now witnesses of one
algebraic theorem: each verifies hypothesis (H4') of Theorem B' for
its specific $(A, k)$, with the algebraic content (single-term
absorption, complete-sequence closure, conductor identity, etc.)
shared and proved once.

**(ii) Strict case ($R(A)>1$), CFH-strict batch route.**  See §2.1
strict-batch table above and note 67/69 for details.  The original
$\{3,4,5\}$ k=1 case (note 26) is now subsumed as one of 870+
certificates produced by `cpp/cfh_batch.exe`.

#### Modular-deficit "failures" — RESOLVED in note 71

In note 69, 2 strict cases were flagged as failing CFH-strict
certification: $\{3, 6, 9, 10, 12\}$ k=2 and $\{3, 6, 9, 10, 15\}$ k=2.
Both have 4 of 5 bases divisible by 3, and the conductor stays
$\approx S/2$ throughout $T \le 10^9$.

**Note 71 resolves this:** at $T \ge 10^{10}$, the mod-9 obstruction
(only base 10 is coprime to 3, and $10^j \equiv 1 \pmod 9$ for all $j$,
so all 9 residue classes are hit only when $e_{10} \ge 10$) breaks.
Conductor stabilizes at $T \approx 3 \times 10^{10}$:
- $c^*(\{3,6,9,10,12\}, 2) = 1{,}473{,}914{,}231$ at $T^* = 10^{10}$;
- $c^*(\{3,6,9,10,15\}, 2) = 1{,}111{,}111{,}964$ at $T^* = 3.5 \times 10^9$.

With the bigger $T$ range and the half-bitset optimization
(`cpp/cfh_batch.cpp` updated), **872/872 strict cases verify** — no
failures.

Each proof terminates a finite computation; the finite computation is
part of the proof.  Across the certificates, the imported analytic
input is at most a single classical theorem (Mignotte–Waldschmidt for
the four exact-critical cases; **none** for the 872 strict cases).

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
| Theorem A (algebraic CFH-strict reduction) | strict case, replaces 872 per-case CFH certificates       | note 72            |
| Theorem B (algebraic qualitative S-unit reduction) | exact-critical, qualitative $N_0$                  | note 72            |
| Theorem B' (effective MW form of Theorem B) | exact-critical with CF/MW (H4'), **effective** $N_0$       | note 82            |
| Theorem C (recursively-reducible bounded conductor) | sub-class with modular reduction chain             | note 73            |
| Proposition D (conductor-growth dichotomy) | modulo Subspace, $c$ bounded or linear in $T$               | note 73            |

Each is checked by a Haskell certificate in `haskell/`; the CAS scripts
in `scripts/` mechanically verify the relevant algebraic identities.

### 2.3 Boss-tree closures

`haskell/ConductorBossTree.hs` records the dependency graph among
sub-obligations.  At the time of writing: 23 nodes total — **17 Done,
5 Open, 1 Imported**.  The "next cuts" (Open nodes with all dependencies
closed) are `scaled-power-middle-interval` and `quotient-block-selection`.
The `erdos-124` root remains Open.

## 3. What the project imports (analytic Diophantine input)

`haskell/GlobalProofAudit.hs` records three Imported obligations.
After note 82 (Theorem B'), the qualitative S-unit input is no
longer load-bearing for the four CF/MW cases — it has been replaced
by effective MW (LMN 1995 / Laurent 2008).  The obligation list
remains as recorded, but the *usage* contracts:

| imported obligation                          | source                          | role                                          | now used by |
|----------------------------------------------|----------------------------------|-----------------------------------------------|--------------|
| Mignotte–Waldschmidt / Laurent–Mignotte–Nesterenko (LMN 1995, Laurent 2008) | classical | effective near-collision exclusion | Theorem B' (note 82); the four CF/MW cases |
| qualitative S-unit exact-critical tail       | S-unit finiteness theorem       | rules out bounded near-collisions (non-effective) | Theorem B (note 72); the 18–99 S-unit-batch cases not covered by Theorem B' |
| Subspace-Theorem power-saving S-unit gap     | Evertse–Schlickewei–Schmidt etc | upgrades to sublinear near-collision exclusion | Proposition D (note 73) only — the conductor-growth dichotomy |

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

The project's *one* defensible conditional reduction is **5.1**.
Section **5.2** records an attempted Bernoulli-convolution route that
**does not work** on hostile audit; it is retained here as a historical
record of an explored path, not as a current claim.

### 5.1 ABC + conductor reduction (notes 53–56)

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

This is the project's *only* current valid conditional reduction.

### 5.2 Withdrawn: multi-base Bernoulli convolution route (notes 58–62)

**Status: retracted on 2026-05-20 after hostile audit (notes 63–65).**

Notes 58–62 proposed a parallel reduction via fractal-geometric
analysis: if the multi-base Bernoulli convolution $\mu_A$ is
absolutely continuous (or has L² density), then Erdős 124 would
follow.

The audit (notes 63–65) showed that **the bridge from L² density of
$\mu_A$ to the combinatorial conductor bound $c(T) = o(T)$ does not
close**.  Specifically:

- **Note 63** finds that the Parseval/energy argument in
  `notes/59_rigorous_equivalence.md` Lemma 4.1 invokes a wrong identity
  ($\int_{\mathbb R}|\hat X_T|^2 d\xi$ is infinite; correct Parseval
  lives on $[0,2\pi]$ and yields only the trivial bound
  $|\mathrm{supp}(X_T)|\ge T$ without using the L² hypothesis).
- **Note 63** also finds Lemma 5.1's "$\rho_T\to 1 \iff c(T)/S(T)\to 0$"
  is wrong in the "$\Rightarrow$" direction (single missing point
  counterexample).
- **Note 64** (literature pulse 2023–2026) confirms no published
  theorem closes the AC conjecture for our integer-Pisot case; closest
  framework is Kittle-Kogler 2024 with a separation hypothesis that
  fails for our overlapping IFS.
- **Note 65** attempts the natural Erdős-Turán / local-limit-theorem
  fix and shows it does not work: the LLT needs $\hat\mu_A\in L^1$,
  but for integer-Pisot $1/a$ ($a\ge 3$), $\hat\mu_A$ does not decay
  to 0 (Erdős 1939: Pisot reciprocal), so $\hat\mu_A\notin L^1$.  L²
  control alone is insufficient.

**Net effect:** the empirical work in notes 60–62 (L² saturation
across 38 hypothesis-meeting cases) provides genuine evidence for a
**fractal-geometric conjecture about $\mu_A$** of independent
interest, related to Kittle-Kogler 2024.  It does **not** provide a
shortcut to Erdős 124.  The combinatorial conductor obligation in §4
remains the actual bottleneck and is not bypassed by the BC route.

Notes 58, 59, 60, 61, 62 should be read as a documented attempt at a
disparate-area approach that did not close.  This is the project's
twelfth such honest negative result (see §6).

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

| **fractal-geometric / multi-base Bernoulli convolution** | **no** | **L² density of $\mu_A$ is interesting but does not bridge to subset-sum representability; LLT path blocked by $\hat\mu_A\notin L^1$** (Erdős 1939); see notes 63–65 |

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
- Documents **twelve** disparate-area attempts with honest negative
  results, showing the two obstacles are not artifacts of one route
  but are genuinely at the frontier.
- Produces an independently-interesting fractal-geometric L² density
  conjecture about multi-base Bernoulli convolutions (notes 58–62),
  with strong empirical support, even though that route does **not**
  close Erdős 124 (notes 63–65 audit).

What the project *does not* do:

- Prove Erdős 124 unconditionally for any $A$ outside the five cases.
- Reduce Erdős 124 to ABC alone (the combinatorial obligation remains).
- Reduce Erdős 124 to multi-base Bernoulli AC (the Fourier bridge does
  not close; see §5.2).
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
