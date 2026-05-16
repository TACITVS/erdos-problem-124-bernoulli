# Researcher’s Handout: Erdős Problem #124 — Current Proof/Certification Program

Tracked note: this handout is an imported project-state snapshot.  Subsequent
updates are in `notes/22_bibliography.md` through
`notes/34_conductor_boss_lemma_ladder.md`, especially the \(S\)-unit
exact-critical tail route, the power-saving central conductor target, the
residue-lift bridge, the unit-base residue-frame construction, the Raku residue
DSL, the manifest-based certificate architecture, the modular conductor lift,
and the conductor boss lemma ladder.

## 0. Purpose of this handout

This document is intended to onboard a human researcher or another AI model into the current state of the Erdős Problem #124 research program being developed here.

It summarizes:

- the mathematical problem;
- the current proof strategy;
- the computational/certification architecture;
- verified local cases;
- newly discovered modular-gate obstruction behavior;
- the exact remaining proof obligations;
- recommended next tasks.

This handout is deliberately conservative. It distinguishes:

- **certified local computations**;
- **proved reductions/lemmas within the current notes/code architecture**;
- **working conjectures suggested by computation**;
- **open global obligations**.

No claim here should be treated as a complete proof of Erdős #124 until the open global obligations are discharged.

---

## 1. Erdős Problem #124: working formulation

The active research target is the second, gcd-conditioned form of Erdős Problem #124.

Let

\[
A = \{a_1,\dots,a_r\}
\]

be a finite set of integer bases, typically with

\[
a_i \ge 3.
\]

For a fixed integer

\[
k \ge 1,
\]

consider the multiset of powers

\[
\mathcal P_{A,k} = \{a^e : a\in A,\ e\ge k\}.
\]

The important point is that this is a **multiset of terms indexed by pairs**

\[
(a,e),
\]

not merely the set of distinct integer values. For example, if

\[
A = \{3,4,9,25\},
\]

then

\[
3^2 = 9^1
\]

as integers, but the two occurrences are distinct available terms if both indices are permitted by the chosen lower exponent threshold.

The central question is whether, under suitable hypotheses on \(A\), all sufficiently large integers can be represented as a finite subset sum of these powers.

The working theorem statement is:

> **Target Theorem, informal.**
> If \(A\) is a finite set of integer bases with
> \[
> \gcd(A)=1
> \]
> and
> \[
> \sum_{a\in A}\frac{1}{a-1}\ge 1,
> \]
> then for every \(k\ge 1\), all sufficiently large integers are representable as subset sums of powers \(a^e\), with \(a\in A\), \(e\ge k\).

This is the theorem currently audited by the Haskell proof/certificate layer.

---

## 2. Basic notation

### 2.1 Power multiset up to a seed limit

Given a seed limit \(X\), define the finite seed multiset

\[
T_{A,k}(X)=\{(a,e): a\in A,
\ e\ge k,
\ a^e\le X\}.
\]

Its value multiset is

\[
V_{A,k}(X)=\{a^e : (a,e)\in T_{A,k}(X)\}.
\]

The finite seed sum is

\[
S_X = \sum_{(a,e)\in T_{A,k}(X)} a^e.
\]

The half-sum is

\[
H_X = \left\lfloor \frac{S_X}{2}\right\rfloor.
\]

### 2.2 Subset-sum set

Let

\[
R_X = \left\{\sum_{t\in U} t : U\subseteq V_{A,k}(X)\right\}.
\]

Again, multiplicities matter: two equal integer terms arising from different \((a,e)\) pairs may both be used, once each.

### 2.3 Central conductor

The finite central-conductor computation checks which integers up to \(H_X\) are represented.

Define

\[
C_X = \max\{n\le H_X : n\notin R_X\},
\]

if such an integer exists. If no such missing integer exists, set \(C_X=-1\).

If every integer in

\[
[C_X+1,H_X]
\]

is represented, then by complement symmetry every integer in

\[
[C_X+1, S_X-C_X-1]
\]

is represented.

This gives the central interval

\[
I_X = [C_X+1, S_X-C_X-1].
\]

### 2.4 Frontier powers

For each base \(a\in A\), let

\[
F_a(X)
\]

be the first power of \(a\) with exponent at least \(k\) that exceeds \(X\). Equivalently, it is the next unused power of \(a\) after the seed block.

The frontier vector is

\[
F(X)=(F_a(X))_{a\in A}.
\]

---

## 3. Reduction to hypothesis-minimal sets

A base set \(A\) satisfies the hypotheses if

\[
\gcd(A)=1
\]

and

\[
\sum_{a\in A}\frac{1}{a-1}\ge 1.
\]

A set is **hypothesis-minimal** if it satisfies the hypotheses, but removing any one base destroys the hypotheses.

The working reduction is:

> **Hypothesis-minimal reduction.**
> If a counterexample exists, then a hypothesis-minimal counterexample exists.

Therefore the computational search focuses heavily on hypothesis-minimal and exact-critical sets.

---

## 4. Exact-critical sets

A base set is **exact-critical** if

\[
\sum_{a\in A}\frac{1}{a-1}=1.
\]

Exact-critical sets are the delicate boundary cases.

If the reciprocal sum is strictly greater than \(1\), then there is positive slack, and the strict reciprocal-sum tail argument is easier.

If the reciprocal sum equals \(1\), then the tail extension requires a more refined invariant and near-collision analysis.

### 4.1 Exact-critical denominator and weights

For exact-critical \(A\), define

\[
D = \operatorname{lcm}\{a-1 : a\in A\}.
\]

For each base \(a\), define the denominator-cleared weight

\[
w_a = \frac{D}{a-1}.
\]

Exact-criticality becomes

\[
\sum_{a\in A} w_a = D.
\]

These weights are used in the exact-critical tail certificates.

---

## 5. Core proof architecture

The current proof strategy has three main layers.

### Layer 1: Finite seed bridge

Find a finite seed limit \(X\) such that the seed subset sums contain a long enough central interval

\[
[C_X+1, S_X-C_X-1].
\]

This is the finite bridge from small subset-sum behavior to the asymptotic tail.

### Layer 2: Interval extension / frontier absorption

If a represented interval has span \(L\), and the next unused power \(t\) satisfies

\[
t\le L+1,
\]

then adding \(t\) extends or preserves interval coverage. This is the Brown-style interval-extension mechanism.

Repeatedly absorbing frontier powers grows the represented interval.

### Layer 3: Tail takeover

Eventually, either:

- strict reciprocal-sum slack forces the interval to keep growing forever; or
- in the exact-critical case, failure would force frontier powers from independent multiplicative classes into bounded near-collisions.

The near-collision scenario is then excluded using continued-fraction and Diophantine approximation bounds.

---

## 6. Strict reciprocal-sum case

If

\[
\sum_{a\in A}\frac{1}{a-1}>1,
\]

then the tail has positive slack.

The code contains a strict interval certificate mechanism. Given a seed interval, it checks whether the interval can be extended until the strict reciprocal-sum lower bound takes over.

A verified example is

\[
A=\{3,4,5\},\quad k=1.
\]

Here

\[
\frac12+\frac13+\frac14=\frac{13}{12}>1.
\]

The certificate proves all sufficiently large integers are represented, with a reported ray start at \(80\) in the local benchmark.

---

## 7. Exact-critical tail invariant

For exact-critical sets, no positive slack exists. The current tail mechanism uses a frontier invariant.

Let the current interval span be \(H\), and let the frontier vector be \(E=(E_a)_{a\in A}\). Define the weighted frontier quantity

\[
C(E)=\sum_{a\in A}\frac{E_a}{a-1}.
\]

The invariant has the form

\[
K = C(E)-1-H.
\]

Along absorbed tail powers, this quantity remains invariant in the exact-critical case.

The key consequence is:

> If extension fails, then the frontier powers must remain within a bounded gap pattern.

This converts a possible tail failure into a near-collision problem between powers from different multiplicative classes.

---

## 8. Multiplicative classes

Two bases are multiplicatively dependent if they are powers of a common rational/integer base. In the code, a base is assigned a normalized prime-exponent vector called its `ClassKey`.

Examples:

- \(4,8,16\) are in one multiplicative class.
- \(9,27,81\) are in one multiplicative class.
- \(8\) and \(27\) are independent.
- \(12\) and \(72\) are independent under the implemented class-key test.

The certified local reduction is:

> Every gcd-one base set has at least two multiplicative classes.

This supplies an independent pair of bases for the near-collision reduction.

Caution: the current Haskell file verifies this for known exact-critical and sanity cases and implements the general class-key logic, but the global theorem “every gcd-one set has at least two multiplicative classes” should remain in the proof notes as a short standalone lemma.

A simple proof idea:

If all bases lie in one multiplicative class, then all bases are powers of a common integer core, and therefore share a nontrivial common factor. That contradicts \(\gcd(A)=1\).

---

## 9. Near-collision reduction

In the exact-critical case, a hypothetical tail failure forces powers from independent classes to remain within a bounded gap.

For a pair of independent bases \(x,y\), the relevant obstruction is of the form

\[
|x^p-y^q|\le B
\]

for a known bound \(B\) derived from the seed conductor and denominator-cleared weights.

For the local certified cases, the key pair is \((3,4)\).

The continued-fraction machinery certifies that all relevant near-collisions exceed the required gap bound.

---

## 10. Continued-fraction certification for \(3\) versus \(4\)

The Haskell certificates avoid floating-point logarithms. They compute rational intervals for logarithms using

\[
\log x = 2\sum_{j\ge 0}\frac{y^{2j+1}}{2j+1},
\qquad
 y=\frac{x-1}{x+1},
\]

with a rational tail bound.

This gives a certified interval for

\[
\alpha=\frac{\log 3}{\log 4}.
\]

The expected continued-fraction prefix is

\[
[0,1,3,1,4,1,1,11,1,46,1,5,112].
\]

The relevant convergents for the local \(3/4\) window are recorded as pairs \((p,q)\), corresponding to comparisons of \(4^p\) and \(3^q\):

\[
(19,24),
(23,29),
(42,53),
(485,612),
(527,665),
(24727,31202),
(25254,31867),
(150997,190537).
\]

The next convergent after the imported analytic/Mignotte-Waldschmidt threshold is

\[
(16936918,21372011).
\]

For the local certified windows, the minimum exact gap among the relevant convergents is

\[
7551629537.
\]

This exceeds the needed local gap bounds.

---

## 11. Local certified cases

The current local proof/certificate infrastructure certifies the following important exact-critical cases.

### 11.1 \(A=\{3,4,7\}, k=2\)

- Seed limit: \(50{,}000{,}000\)
- Conductor to half: \(3{,}982{,}888\)
- Exact-critical denominator: \(6\)
- Weights: \((3,2,1)\)
- Cleared obstruction bound: \(47{,}794{,}770\)
- Start exponents: \((17,13,10)\)
- Continued-fraction gate uses the \(3/4\) window.

### 11.2 \(A=\{3,4,7\}, k=3\)

- Seed limit: \(5{,}000{,}000{,}000\)
- Conductor to half: \(166{,}025{,}260\)
- Exact-critical denominator: \(6\)
- Weights: \((3,2,1)\)
- Cleared obstruction bound: \(1{,}992{,}303{,}678\)
- Start exponents: \((21,17,12)\)
- Tail simulation reaches the imported analytic threshold with positive margin.

The central interval is

\[
(166025261,13097655510).
\]

### 11.3 \(A=\{3,4,9,25\}, k=2\)

- Seed limit: \(10{,}000{,}000\)
- Conductor to half: \(452{,}099\)
- Exact-critical denominator: \(24\)
- Weights: \((12,8,3,1)\)
- Cleared obstruction bound: \(21{,}701{,}880\)
- Start exponents: \((15,12,8,6)\)
- Continued-fraction gate again uses the \(3/4\) window.

The central interval is

\[
(452100,27868079).
\]

---

## 12. Exact-critical small-case scans

Several computational scans have been performed.

### 12.1 Max base 30, size at most 5

There are fourteen exact-critical gcd-one cases in this window.

Important examples include:

\[
(3,4,7),
\]

\[
(3,4,9,25),
\]

\[
(3,4,10,19),
\]

\[
(3,4,11,16),
\]

\[
(3,5,6,21),
\]

\[
(3,5,7,13).
\]

The hardest \(k=2\) case in this small window is \((3,4,7)\), followed by \((3,4,9,25)\).

### 12.2 Max base 100, size up to 6 or 7

An expanded scan found new nuisance cases, especially modular-gate cases involving large bases.

A particularly important example is

\[
A=(3,6,9,12,21,45,89).
\]

This case changes the understanding of the global seed bridge.

---

## 13. Modular-gate obstruction

The seed bridge is not only an interval problem. It also has a modular-residue saturation layer.

Let \(T\) be a finite seed multiset and define its subset-sum residues modulo \(q\):

\[
R_T(q)=\left\{\sum_{t\in U}t \pmod q : U\subseteq T\right\}.
\]

### 13.1 Residue Gate Lemma

> **Lemma.**
> If \(R_T(q)\ne \mathbb Z/q\mathbb Z\), then the represented subset sums of \(T\) cannot contain \(q\) consecutive integers.

Proof: \(q\) consecutive integers cover every residue class modulo \(q\). If one residue class is missing among subset sums modulo \(q\), such an interval cannot exist.

### 13.2 Central-conductor corollary

Let

\[
H=\left\lfloor \frac{\sum_{t\in T}t}{2}\right\rfloor.
\]

If subset-sum residues modulo \(q\) are incomplete, then the central conductor \(C_T\) must satisfy

\[
C_T\ge H-q+1.
\]

Otherwise \([C_T+1,H]\) would contain \(q\) consecutive represented integers, impossible by the residue gate.

---

## 14. The modular-gate example \((3,6,9,12,21,45,89), k=2\)

For

\[
A=(3,6,9,12,21,45,89)
\]

and

\[
k=2,
\]

consider modulus

\[
q=9.
\]

All bases except \(89\) contribute second and higher powers divisible by \(9\):

\[
3^2,6^2,9^2,12^2,21^2,45^2 \equiv 0 \pmod 9.
\]

The only base that changes residues modulo \(9\) is \(89\), with

\[
89\equiv -1\pmod 9.
\]

Thus

\[
89^e\equiv (-1)^e\pmod 9.
\]

Starting at \(e=2\), the available \(89\)-powers alternate residues \(1,-1,1,-1,\dots\) modulo \(9\).

The modular gate does not fully open until the term

\[
89^9=350356403707485209.
\]

The certificate checks:

- before including \(89^9\), only \(8\) of \(9\) residues are covered;
- the missing residue is \(5\);
- after including \(89^9\), all \(9\) residues are covered;
- the completion point is the 117th seed term, namely \(89^9\).

This explains why the central conductor can stay essentially at the half-sum boundary until a very large seed limit.

---

## 15. Revised global seed-bridge architecture

The old single open obligation

> global seed-bridge theorem

should now be split into two or three more precise obligations.

### 15.1 Global residue-saturation theorem

For every admissible exact-critical gcd-one base set \(A\) and lower exponent \(k\), there exists a finite seed limit \(X\) such that the seed powers up to \(X\) saturate all relevant modular obstructions.

The relevant moduli are not yet fully characterized. At minimum, they include moduli arising from common divisibility of large subfamilies of bases.

### 15.2 Post-saturation central-interval theorem

After residue saturation, prove that the seed subset sums contain a central interval large enough to begin frontier absorption.

This is the actual interval-growth part.

### 15.3 Tail-entry theorem

Once a sufficiently large central interval exists, the existing exact-critical or strict tail machinery proves all sufficiently large integers are represented.

The local tail-entry theorem is already well-certified for the current important small cases.

---

## 16. Current Haskell certificate/prover layer

The current Haskell files form a proof-audit/certification layer. They are small standalone programs, each checking one kind of certificate.

### 16.1 `GlobalProofAudit.hs`

This file lists proof obligations and their status.

Certified items include:

- theorem statement;
- monotonicity reduction;
- hypothesis-minimal reduction;
- interval extension;
- frontier invariant;
- strict reciprocal-sum tail;
- exact-critical near-collision reduction;
- multiplicative class reduction;
- generic pair continued-fraction window;
- local seed-bridge profiles;
- local residue-bridge profiles;
- local \(\{3,4,7\}\) and \(\{3,4,9,25\}\) certificates.

Imported item:

- Mignotte-Waldschmidt input for \(3\) versus \(4\).

Open items:

- global seed-bridge theorem;
- global exact-critical analytic bound.

Recommended update: split “global seed-bridge theorem” into residue saturation and post-saturation central interval obligations.

### 16.2 `TailCertificate.hs`

This is one of the strongest certificates.

It recomputes:

- exact-critical denominator;
- denominator-cleared weights;
- obstruction bounds;
- first frontier exponents above seed limit;
- frontier states up to a target exponent;
- positive margins for all checked states.

It covers:

- \(\{3,4,7\}, k=2\);
- \(\{3,4,7\}, k=3\);
- \(\{3,4,9,25\}, k=2\).

### 16.3 `CFTailCertificate.hs`

This certifies the \(3/4\) continued-fraction window.

It computes rational log intervals, derives the continued-fraction prefix, filters relevant convergents, checks the next convergent after the analytic threshold, and verifies exact near-collision gaps.

### 16.4 `PairCFTailCertificate.hs`

This generalizes the continued-fraction certificate to an arbitrary base pair.

It includes:

- imported \(3/4\) windows for the local major cases;
- a sanity finite window for \(5/13\).

This is the correct direction for the global exact-critical analytic bound, but the arbitrary-pair analytic threshold remains open.

### 16.5 `MultiplicativeClasses.hs`

This file computes multiplicative class keys using prime factorization and normalized exponent vectors.

It verifies known exact-critical cases and dependent sanity cases.

It should be paired with a short written lemma proving that gcd-one sets must contain at least two multiplicative classes.

### 16.6 `ResidueBridgeProfiles.hs`

This file verifies local residue-bridge profiles.

It recomputes:

- seed powers;
- exact-critical denominator as modulus;
- residue subset sums;
- completion index and term;
- minimal residue representatives;
- frontier powers.

This is a useful positive residue-saturation certificate for the small exact-critical profiles.

Recommended extension: allow arbitrary moduli, not only the exact-critical denominator.

### 16.7 `SeedBridgeProfiles.hs`

This file currently verifies arithmetic consistency of recorded seed profiles:

- half sum;
- central interval endpoints;
- central span;
- frontier length.

However, it does **not** recompute the subset-sum conductor itself.

This is a weak link.

Recommended upgrade: make it recompute the seed powers, subset-sum bitset up to half-sum, last missing value, and central interval.

### 16.8 `ModularGateCertificate.hs`

A new proposed file certifies the negative modular-gate obstruction for

\[
(3,6,9,12,21,45,89),\quad k=2,
\quad q=9.
\]

It checks that residue saturation modulo \(9\) fails before \(89^9\) and succeeds after including \(89^9\).

This should be generalized into a `ResidueGateCertificate.hs` framework.

---

## 17. Python/C++ experimental layer

The Python scripts provide exploration and exact finite computations.

Important scripts include:

### 17.1 `erdos124.py`

Core exact helper routines:

- gcd of bases;
- reciprocal sum;
- powers up to a limit;
- first powers above a limit;
- subset-sum bitset;
- missing positions;
- conductor by search;
- longest represented interval;
- strict interval certificate.

### 17.2 `seed_bridge.py`

Computes finite seed-bridge profiles:

- seed terms;
- seed sum;
- half sum;
- conductor to half;
- central interval;
- frontier;
- reciprocal sum.

### 17.3 `critical_tail_sim.py`

Simulates exact-critical interval extension after a finite central interval.

It computes the frontier invariant and reports whether extension fails within a finite number of steps.

### 17.4 `exact_critical_tail.py`

Computes exact-critical denominator-cleared weights, obstruction bounds, first exponents above seed limit, and margins before a target continued-fraction threshold.

### 17.5 `cf_near_collision.py`

Computes the continued-fraction near-collision reduction for \(\log 3/\log 4\), using rational log intervals rather than floating-point logarithms.

### 17.6 `cas_checks.py`

Uses SymPy for exact-critical enumeration and symbolic sanity checks.

### 17.7 `hypothesis_minimal.py` and `enumerate_minimal_sets.py`

Enumerate hypothesis-minimal or exact-critical base sets in finite windows.

### 17.8 `self_check.py`

Regression tests for the research codebase.

It checks known conductors, exact-critical set counts, continued-fraction convergents, obstruction bounds, start exponents, and seed-bridge profiles.

### 17.9 C++ accelerator

A C++ accelerator exists for fast conductor/central-interval search. It gives a large speedup over Python in large finite seed computations.

For example, the \(\{3,4,7\}, k=2\), limit \(50{,}000{,}000\) conductor computation runs roughly fifty times faster in C++ than the Python version in the recorded benchmark.

---

## 18. Do-not-use / known pitfalls

### 18.1 Do not collapse equal powers

The power sequence is a multiset indexed by \((a,e)\). Collapsing equal integer values is wrong.

Example:

\[
3^2=9^1,
\]

but these are distinct sequence terms when both are allowed.

This mistake makes \(\{3,4,9,25\}\) appear falsely harder or changes conductor behavior.

### 18.2 Do not treat residue saturation as automatic

The modular-gate example shows that residue saturation can be delayed until astronomically large seed limits.

Any global seed-bridge theorem must handle this explicitly.

### 18.3 Do not claim the global theorem from local scans

The local cases are strong evidence, but they do not prove the global seed bridge.

### 18.4 Do not rely on floating-point logarithms in certificates

The certificate layer correctly uses rational log intervals. Continue this practice.

### 18.5 Do not let `GlobalProofAudit.hs` mark open obligations as certified prematurely

The audit should remain conservative. Its usefulness comes from making the proof gap explicit.

---

## 19. Current open obligations

### Open Obligation 1: Global residue-saturation theorem

Precisely characterize the relevant obstruction moduli and prove that every admissible exact-critical gcd-one base set eventually saturates the needed residue classes.

Questions:

- Which moduli must be considered?
- Are they generated by common divisibility of subfamilies?
- Is it enough to consider exact-critical denominators?
- How does one handle “one escape base” cases like \((3,6,9,12,21,45,89)\) modulo \(9\)?

### Open Obligation 2: Post-saturation central interval theorem

After residue saturation, prove that a central interval appears.

Possible approaches:

- Brown-type complete-sequence theorem adapted to multisets;
- residue-class lifting plus interval growth inside each class;
- additive-combinatorial covering lemma;
- finite automaton/semigroup stabilization.

### Open Obligation 3: Global exact-critical analytic bound

The local \(3/4\) near-collision window uses imported Mignotte-Waldschmidt input.

For a global proof, one needs explicit thresholds for arbitrary independent base pairs/classes.

Possible approaches:

- Use general linear forms in logarithms with explicit constants;
- specialize to integer bases and derive a usable threshold;
- for each certified independent pair, generate a finite CF window up to an analytic threshold;
- incorporate arbitrary-pair certificates into `PairCFTailCertificate.hs`.

---

## 20. Recommended next tasks

### Task 1: Upgrade `SeedBridgeProfiles.hs`

Make it recompute conductors from scratch.

Required functions:

- generate powers up to seed limit, preserving multiplicity;
- compute subset-sum bitset up to half-sum;
- compute last missing value;
- derive central interval;
- verify against embedded profile.

This will make the seed bridge layer a real certificate rather than a consistency check.

### Task 2: Generalize `ResidueBridgeProfiles.hs`

Add arbitrary-modulus support.

It should handle:

- exact-critical denominator modulus;
- modular-gate obstruction moduli such as \(9\);
- user-supplied moduli;
- positive saturation certificates;
- negative obstruction certificates.

A good target filename would be:

`ResidueGateCertificate.hs`.

### Task 3: Add modular-gate classifier

Given \(A,k\), search for moduli \(q\) such that many seed terms are \(0\mod q\), and only a small escape set controls residue saturation.

For each candidate \(q\), compute:

- residue coverage before saturation;
- first completion term;
- missing residues before completion;
- minimal representative maximum after completion.

### Task 4: Try to prove one-escape-base saturation lemma

Prototype lemma:

> Suppose all bases except \(b\) have powers divisible by \(q\) from exponent \(k\) onward. Then residue saturation modulo \(q\) is controlled by subset sums of
> \[
> b^k,b^{k+1},\dots,b^m.
> \]
> If \(b\) is a unit modulo \(q\), this becomes a finite cyclic subset-sum problem in \((\mathbb Z/q\mathbb Z,+)\).

For \(b\equiv -1\pmod q\), as in \(89\mod 9\), the problem reduces to subset sums of repeated \(1\) and \(-1\).

### Task 5: Build arbitrary-pair analytic certificates

Extend the pair CF certificate framework so that it can consume a pair \((x,y)\), a gap bound \(B\), and an imported/derived analytic threshold, then produce a certified finite CF window.

### Task 6: Formal proof notes

Write a separate proof note with:

- theorem statement;
- definitions;
- monotonicity;
- hypothesis-minimal reduction;
- strict case;
- exact-critical case;
- residue gate;
- central interval;
- tail invariant;
- near-collision exclusion;
- remaining global obligations.

This handout can be used as the source for that note.

---

## 21. Suggested theorem/lemma list for proof notes

The following lemma list would make the project easier to audit.

### Lemma A: Monotonicity

If \(A\subseteq B\), then representability by powers from \(A\) implies representability by powers from \(B\).

### Lemma B: Hypothesis-minimal reduction

Any counterexample has a hypothesis-minimal sub-counterexample.

### Lemma C: Finite complement symmetry

If a finite seed multiset has total sum \(S\), and every integer in \([C+1,\lfloor S/2\rfloor]\) is represented, then every integer in \([C+1,S-C-1]\) is represented.

### Lemma D: Interval extension

If \([L,H]\) is represented and a new term \(t\le H-L+1\), then adding \(t\) extends represented coverage to \([L,H+t]\).

### Lemma E: Strict reciprocal-sum tail

If \(\sum 1/(a-1)>1\), then after a finite bridge, frontier absorption continues forever.

### Lemma F: Exact-critical frontier invariant

In the exact-critical case, the quantity

\[
K=C(E)-1-H
\]

is invariant under absorbed tail powers.

### Lemma G: Exact-critical failure implies near-collision

If exact-critical frontier absorption fails indefinitely, independent frontier powers must remain within a bounded gap.

### Lemma H: Gcd-one implies at least two multiplicative classes

A gcd-one base set cannot lie entirely in one multiplicative class.

### Lemma I: Continued-fraction exclusion

For a given independent pair \((x,y)\) and gap bound \(B\), if all relevant convergents up to an analytic threshold have exact gaps greater than \(B\), and the analytic theorem excludes gaps beyond the threshold, then no near-collision obstruction exists.

### Lemma J: Residue Gate Lemma

If finite seed subset sums do not cover all residues modulo \(q\), then they cannot contain \(q\) consecutive integers.

### Lemma K: Residue-saturated seed bridge

Open. After relevant residue gates open, a central interval large enough for tail entry appears.

---

## 22. Recommended status labels

Use these labels consistently:

- **Certified:** independently recomputed by a small checker.
- **Imported:** relies on an external theorem or analytic bound.
- **Empirical:** supported by search but not proved.
- **Open:** known proof gap.
- **Unsafe:** should not be used.

Current status summary:

| Component | Status |
|---|---|
| Theorem statement | Certified as target statement |
| Monotonicity reduction | Certified/proof-note level |
| Hypothesis-minimal reduction | Certified/proof-note level |
| Strict reciprocal-sum local certificates | Certified |
| Exact-critical local tail certificates | Certified |
| \(3/4\) CF finite windows | Certified with imported analytic threshold |
| Multiplicative class computations | Certified locally; global lemma should be written |
| Local seed profiles | Partially certified; conductor recomputation needed in Haskell |
| Local residue profiles | Certified locally |
| Modular-gate obstruction | Newly certified/proposed |
| Global residue saturation | Open |
| Global post-saturation central interval | Open |
| Global arbitrary-pair analytic bound | Open/imported gap |

---

## 23. Final current assessment

This research program has moved from broad speculation into a proof-shaped architecture.

The strongest achievements so far are:

- a clean reduction to hypothesis-minimal/exact-critical behavior;
- exact finite seed/conductor computations for key local cases;
- certified exact-critical tail margins;
- rational continued-fraction certificates for the key \(3/4\) near-collision windows;
- multiplicative-class classification machinery;
- discovery and certification of a modular-gate obstruction mechanism.

The most important conceptual update is:

> The global seed bridge is not a single interval-growth problem. It factors into residue saturation followed by central interval formation followed by tail extension.

The most important next mathematical problem is:

> Prove a residue-saturated seed-bridge theorem, or find a counterexample to the proposed global theorem.

The most important next engineering task is:

> Upgrade the Haskell prover so that seed conductors and modular gates are recomputed, not merely recorded.

Until those tasks are complete, the project should be described as a **near-proof framework with certified local cases and clearly isolated global obligations**, not as a completed proof of Erdős #124.
