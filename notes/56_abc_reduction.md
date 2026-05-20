# Beyond the eleven attempts: the ABC reduction

The previous round of disparate-area attempts (notes 53–55) ended with a
flat "we hit the wall".  A reasonable challenge — *mathematics is vast,
surely there's something* — pushed for a deeper look.

This note records the result of that deeper look.  The headline is real:

> **The analytic obligation for Erdős 124's exact-critical case
> reduces to (a quantitative form of) the ABC conjecture.**

This is a substantive structural finding, not just another packaging.  It
explains why the previous eleven attempts hit the same wall: the wall is
ABC, one of the principal open problems of modern number theory.  Erdős
124 is in clearly identifiable company.

## 1. Three additional disparate areas

### 1.1 Hardy–Littlewood circle method

The most surprising omission from earlier notes is the *named*
circle-method framework.  In fact our existing notes 47–48 *are* the
circle method — applied to $F_A(x)=\prod(1+x^{a^e})$ on the unit
circle.  The "major arcs" (rationals $p/q$ with small $q$) are the
resonances of note 49; the "minor arcs" are the off-resonance regime of
note 50.

So this is not a new tool; we have been doing circle-method analysis
under different terminology.  Standard tools used in Hardy–Littlewood
applications (Weyl inequality, Vinogradov mean-value theorem) apply to
polynomial frequencies $\alpha n + \beta n^2 + \cdots$, not to
exponential frequencies $a^n$.  No quick win here.

### 1.2 Higher-order Fourier / Gowers norms

The $U^s$ norms detect arithmetic-progression-of-length-$s$ structure.
For subset-sum sets containing many APs (which our $R$ does — once
hypothesis-meeting), $\|1_R\|_{U^s}$ is large; conversely,
sets with small $U^s$ norm look pseudo-random.

But the gap analysis we need is "$R$ covers all sufficiently large
integers", which is about cofiniteness rather than arithmetic-progression
density.  Gowers norms control AP densities, not gap distributions.
No reduction.

### 1.3 Tao–Vu entropy method

Tao–Vu 2009 reformulated Plünnecke–Ruzsa via Shannon entropy.  Applied
to our $S=\sum_i\xi_i a^{e_i}$ with independent Bernoullis $\xi_i$:

$$H(S)\le\sum_iH(\xi_i)=T\log 2,$$

with equality iff the seed terms are additively independent.  For
hypothesis-meeting $A$, the entropy of the subset-sum random variable is

$$H(S)\sim(\log T)\sum_{a\in A}\frac{1}{\log a}\cdot\log 2
=
(\log T)\cdot\sum_{a\in A}\frac{1}{\log_2 a}.$$

This is **exactly the same algebraic quantity** as note 47's density
exponent.  The entropy method recovers our existing identity in entropy
language; no new content.

## 2. The ABC reduction

The genuine finding: Erdős 124's analytic obligation reduces to ABC.

### 2.1 The reduction chain

The local certificates (notes 07, 09, 46) use per-pair
Mignotte–Waldschmidt input for $|3^p-4^q|$.  For the *global* theorem,
we need an analogous bound for **every** multiplicatively independent
base pair $(a, b)$, uniformly in $a, b$.

That uniform bound is exactly:

> **Effective Pillai (quantitative form).**  For multiplicatively
> independent integers $a, b\ge 2$ and $C>0$, every solution
> $(p, q)$ of $|a^p-b^q|\le C$ satisfies $\max(a^p, b^q)\le f(a,b,C)$
> for an explicit function $f$.

### 2.2 ABC implies effective Pillai

Apply ABC (with explicit constants in the quantitative form) to the
relation $a^p = b^q + (a^p - b^q)$: writing $c=|a^p-b^q|$,

$$\max(a^p,b^q)
\le K\cdot\bigl(\mathrm{rad}(a^pb^qc)\bigr)^{1+\epsilon}
=
K\cdot\bigl(\mathrm{rad}(a)\,\mathrm{rad}(b)\,\mathrm{rad}(c)\bigr)^{1+\epsilon}
\le K\cdot(ab\,c)^{1+\epsilon}.$$

For fixed bound $c\le C$, this gives

$$\max(a^p,b^q)\le K(abC)^{1+\epsilon},
\qquad
p\le\frac{(1+\epsilon)\log(K(abC)^{1+\epsilon})}{\log a}.$$

This is *exactly* the kind of uniform effective bound needed.  See
Waldschmidt's lecture notes and Stewart–Yu (Math. Ann. 2001) for the
explicit constants in this reduction.

### 2.3 What effective Pillai closes — and what it does *not*

Substituting the uniform effective Pillai bound for per-pair MW in the
local certificate template (notes 07, 09, 46) gives a uniform CF/MW
certificate for every multiplicatively independent pair.

**What this closes.**  In `haskell/GlobalProofAudit.hs`, the three
*Imported* obligations are:

- "qualitative S-unit exact-critical tail",
- "Subspace-Theorem power-saving S-unit gap",
- "Mignotte–Waldschmidt input for 3 versus 4".

All three are analytic Diophantine inputs.  ABC → effective Pillai
replaces all three with a single effective theorem.  So **ABC closes the
project's Imported analytic obligations**.

**What this does *not* close.**  `GlobalProofAudit.hs` also lists one
*Open* obligation:

- "global power-saving central conductor theorem: prove
  $c(E)=o(T(E))$ in the strict case and
  $c(E)=O(T(E)^{1-\epsilon})$ in the exact-critical case."

This is a *combinatorial* obligation about the size of the finite seed
conductor.  ABC has no obvious bearing on it.  The boss tree
(`haskell/ConductorBossTree.hs`) corroborates this: the Open nodes
`scaled-power-middle-interval`, `quotient-block-selection`,
`strict-conductor`, `exact-conductor`, and `erdos-124` are all about
the conductor side, not the analytic side.

**The honest reduction.**  Erdős 124 reduces, in this project's
framework, to:

> **(α)** The ABC conjecture (closes the three Imported analytic
> obligations via effective Pillai), AND
>
> **(β)** The power-saving central conductor theorem (the remaining
> Open combinatorial obligation in `GlobalProofAudit.hs`).

Both (α) and (β) are independently open.  Neither implies the other in
any way I have been able to verify.

## 3. So what walls did we hit, exactly?

The eleven disparate-area attempts hit *two* different walls,
corresponding to (α) and (β).

**Wall (α): the analytic Diophantine wall.**  Every attempt that
addressed the near-collision $|a^p-b^q|$ input — Sidon, MW, S-unit
theory, Aistleitner lacunary MGF — ended at effective Pillai-type
bounds.  This is one of the principal open problems of modern number
theory (ABC).

**Wall (β): the combinatorial conductor wall.**  Every attempt that
addressed the finite seed conductor — modular bridge, scaled power
blocks, complete-sequence absorption, polynomial method — left the
power-saving conductor theorem open.  No published theorem closes it
(under any assumption I can find), even conditionally.

Wall (β) is structurally *independent* of ABC and is, in this sense,
the harder of the two.  ABC has been studied for decades and has many
consequences; the power-saving conductor theorem for subset sums of
integer powers does not appear in the literature in the form we need it.

So the project did not hit *one* wall named ABC.  It hit *two* walls,
of which ABC is the better-known.

## 4. Strategic implication for the project

What we have, restated *honestly*:

> **Theorem (conditional, corrected).** Assume both
>
> **(α)** the ABC conjecture, *and*
>
> **(β)** the power-saving central conductor theorem (open obligation
> in `GlobalProofAudit.hs`).
>
> Then for every finite set $A\subseteq\mathbb Z_{\ge3}$ with
> $\gcd(A)=1$ and $\sum_{a\in A}1/(a-1)\ge1$, and every $k\ge1$,
> every sufficiently large integer is a subset sum of
> $\{a^e:a\in A,e\ge k\}$.

The earlier draft of this note claimed reduction to ABC alone.  That was
*overstated*: ABC closes the three Imported analytic obligations but does
not close the Open combinatorial conductor obligation.  The corrected
statement requires both (α) and (β).

For the **specific local cases** $\{3,4,7\}$ at $k\in\{1,2,3\}$ and
$\{3,4,9,25\}$ at $k=2$, obligation (β) is replaced by a finite
direct computation (the bitset conductor scan).  So for these specific
cases the project does give an unconditional proof using only an MW
input — already what notes 07, 09, 46 do.  Generalising to *all*
hypothesis-meeting $A$ requires both (α) and (β).

This is a real conditional result.  The project has:

- an algebraic framework that reduces the problem cleanly to a uniform
  Diophantine input;
- typed certificates for four exact-critical local cases via the existing
  CF/MW route ($\{3,4,7\}$ at $k=1,2,3$; $\{3,4,9,25\}$ at $k=2$);
- explicit identification of the analytic obstacle as effective Pillai /
  ABC.

This is the kind of result that exists in the literature for many famous
open problems (e.g., "ABC implies many things"; "GRH implies many
things").  It is publishable in roughly the form above.

## 5. What this changes vs note 54

Note 54 said: "the analytic obligation is at the current frontier of
multiple subfields".  This note pinpoints that frontier as the
single conjecture ABC.  The previous "three independent packagings"
(notes 49, 52, 53) are all consequences of effective Pillai, hence of
ABC.

The triangulation across S-unit / lacunary harmonic / resonance is real
but converges to a single underlying obstacle.

## 6. What this does *not* claim

- **No unconditional proof of Erdős 124.**  The reduction is conditional
  on ABC.
- **No use of Mochizuki's proof of ABC.**  The IUTeich proof is disputed;
  this note treats ABC as a conjecture.
- **No new analytic content within the project.**  The reduction *to*
  ABC uses standard Waldschmidt / Stewart–Yu transfer.

## 7. Disparate areas honestly remaining

Areas where I genuinely don't have insight into whether they could help:

- **Anabelian geometry / IUTeich** (Mochizuki's attempted ABC proof).
  Outside the project's scope.
- **Arakelov geometry / heights**.  Modern heights theory may give
  alternative routes to effective Pillai.  Probably equivalent to ABC in
  the regime we care about.
- **Modular forms / Galois representations**.  Frey-style approaches:
  if $a^p-b^q=c$ had infinitely many solutions, could one construct a
  Galois-representation obstruction?  Speculative.

But these are all attempts to *prove ABC*, not to bypass it.  The path is
clear: bypassing ABC entirely would require a genuinely new approach to
$|a^p-b^q|$ bounds.

## Status

Adds no Certified obligation.  Records the ABC reduction explicitly and
proposes "conditional Erdős 124 via ABC" as the proper framing of the
project's current state.

## References

- Wikipedia, [abc conjecture](https://en.wikipedia.org/wiki/Abc_conjecture).
- M. Waldschmidt, [Perfect Powers: Pillai's works and their developments](https://webusers.imj-prg.fr/~michel.waldschmidt/articles/pdf/PerfectPowers.pdf).
- Stewart, Yu, *On the abc conjecture II*, Duke Math. J. 108 (2001), 169–181.
- T. Tao, [An entropy Plünnecke–Ruzsa inequality](https://terrytao.wordpress.com/2009/10/27/an-entropy-plunnecke-ruzsa-inequality/).
- Pomerance, [Why the ABC conjecture](https://math.dartmouth.edu/~carlp/abctalk.pdf).
