# Disparate-area attempts: short timeboxed exploration

This note records honest, short-timebox attempts at three disparate areas
not previously engaged with the project, per option (C) in the meta-review
following note 54.  The conclusion: none of the three gives a concrete
reduction for Erdős 124 within the timebox.  This is itself useful — it
narrows the search for novel approaches.

## 1. Combinatorial Nullstellensatz / Alon's polynomial method

**Setup.**  For seed terms \(t_1,\dots,t_n\) and target \(N\), variables
\(\epsilon_i\in\{0,1\}\), we want to find \(\epsilon\) with
\(\sum_i\epsilon_i t_i=N\).

**Modular reduction.**  Working in \(\mathbb F_p\): define
\(P(\epsilon)=\prod_{c\ne N\bmod p}\bigl(\sum_i\epsilon_i t_i-c\bigr)\).
This has degree \(p-1\).  Apply Alon's Combinatorial Nullstellensatz
(1999) with \(t_i\in\{0,1\}\), \(S_i=\{0,1\}\), \(|S_i|=2\): if
\(\sum t_i=p-1\le n\) and the coefficient of
\(\prod x_i^{t_i}\) (for some choice of \(p-1\) ones) is non-zero, then
\(P\) vanishes somewhere.

The coefficient of \(\prod_{i\in I}x_i\) for \(|I|=p-1\) in \(P\) is
\(\binom{p-1}{1,\dots,1}\prod_{i\in I}t_i=(p-1)!\prod_{i\in I}t_i\).  By
Wilson, \((p-1)!\equiv-1\pmod p\), so non-zero in \(\mathbb F_p\) whenever
all \(t_i\not\equiv 0\pmod p\), which holds when \(p>\max_i t_i\) or just
when \(p\) doesn't divide any seed term.

**Conclusion (modular)**: for \(n\ge p-1\), every residue mod \(p\) is a
subset sum mod \(p\).

**The integer gap.**  Subset sum mod \(p\) equal to \(N\bmod p\) means the
actual integer sum is \(N+jp\) for some integer \(j\ge 0\) (and bounded
above by the total seed sum).  We want \(j=0\) specifically.

**CRT attempt.**  For primes \(p_1,p_2,\dots\), Alon gives a subset for
each \(p_i\) — but possibly different subsets.  Probabilistic heuristic:
the number of subsets simultaneously summing to \(N\bmod p_i\) for all
\(p_i\) is \(\sim 2^n/\prod p_i\).  For this to be \(\ge1\) we need
\(2^n\ge\prod p_i\), and for the integer reconstruction to determine
\(N\) uniquely we need \(\prod p_i\ge N\).  Together:
\(2^n\ge N\), i.e., \(n\ge\log_2 N\).

For our seed \(n\asymp\log T\) terms in seed limit \(T\): the condition
becomes \(\log T\ge\log_2 N\), i.e., \(T\ge N\) — back to the trivial
"seed must reach the target" bound.

**Verdict.**  Alon's polynomial method gives modular coverage but does
not improve the integer coverage threshold below the trivial seed-must-cover bound, even via CRT.  No concrete reduction.

## 2. p-adic Skolem–Mahler–Lech

**Setup.**  SML: the zero set of a linear recurrence sequence is a union
of arithmetic progressions plus a finite set.  For \(|a^p-b^q|<C\) (the
near-collision obstruction): not a linear recurrence directly, but the
related equation \(a^p-b^q=c\) for fixed \(c\) has finite solution count
by Skolem-style p-adic analysis.

**Comparison to Mignotte–Waldschmidt.**  Effective Skolem (Schmidt 1991,
Evertse–Schlickewei refinements) gives the same asymptotic bound \(O(1)\)
solutions per \(c\) as MW does.  For our specific use (gap \(|a^p-b^q|<C\) summed over \(|c|\le C\)), the count is \(O(C)\) — matching MW.

**Verdict.**  Skolem-style methods don't improve on the per-pair MW input
that the project already uses.  No new analytic content.

## 3. Algebraic geometry of monomial schemes

**Setup.**  The seed \(\{a^e:a\in A,e\ge k\}\) defines a set in
\(\mathbb Z_{\ge0}\).  The subset-sum generating function
\(F_A(x)=\prod(1+x^{a^e})\) is the Hilbert series of a monomial-style
subscheme.

**Macaulay bounds.**  Hilbert function bounds from Macaulay's theorem
give upper bounds on \(\dim H^0\) of monomial subschemes.  These translate
to upper bounds on the number of subset sums, not the absence of gaps.

**Verdict.**  Vague analogies; the available algebraic-geometric tools
give upper bounds where we need lower bounds on density.  No concrete
reduction in the timebox.

## 4. Honest conclusion

After the timeboxed attempts on three disparate areas:

- **None** gives an immediate concrete reduction for Erdős 124.
- **Alon's polynomial method** has the cleanest framework but stops at
  modular coverage.  Lifting to integer coverage via CRT or related
  recovers only the trivial seed-must-cover bound.
- **Skolem-Mahler-Lech** is equivalent in strength to the existing
  MW-style per-pair Diophantine input.
- **Algebraic geometry of monomial schemes** is too vague to instantiate
  for this specific problem.

This is consistent with the literature-dive verdict in note 54: the
analytic obligation for Erdős 124 is genuinely at the current frontier
of multiple subfields, and no "off-the-shelf" tool quickly resolves it.

## 5. Other disparate areas worth flagging but not attempted

For completeness, other disparate areas that *could* be tried in
extended sessions, with low expected probability of success:

- **Sieve theory** (Selberg, Vaughan, Heath–Brown).  Would give upper
  bounds on \(|\{N<X:\text{missing}\}|\) but probably not strong enough.
- **Model theory** of \((\mathbb Z,+,\cdot,P_a)\) where \(P_a\) is the
  predicate "is a power of \(a\)".  Decidability of relevant fragments
  is unclear.
- **Random matrix and free probability** for sums of independent
  bounded random variables with arithmetic-coefficient constraints.
  Potentially relevant but speculative.
- **Tropical / additive geometry** of subset-sum semigroups.
  Mainly classical-Frobenius style, already covered by note 44.

None of these has an obvious quick connection.

## Recommendation

Option (C) in the meta-review of note 54 is now closed without success.
Per that meta-review, fall back to:

- **(A) consolidate the project as a publishable framework** — the
  primary recommendation.
- **(B) extend local certified cases** — cheap engineering side-track.
- **(D) accept that the project's existing state advances Erdős 124
  understanding in real ways** — also a legitimate end-state.

## Status

Adds no Certified obligation.  Records honest negative results for three
disparate-area attempts, narrowing the search for future approaches.
