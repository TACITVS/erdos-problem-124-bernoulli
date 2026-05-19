# Energy-method attempt for the strict conductor theorem: honest result

Last session I claimed the strict-case conductor theorem might close
"in 1–2 weeks of focused work" via an energy/anticoncentration argument
using the Evertse–Schlickewei S-unit bound.  This note carries out the
calculation carefully and reports what it actually gives.

**Headline: my optimistic claim was overstated.  The energy method
reduces precisely to the LLT obligation and does not bypass the analytic
input.**

## 1. Setup

For seed \(F=\{f_1,\dots,f_N\}=\{a^e:a\in A,\ k\le e<e_a\}\), let

\[
E_2(F)=\sum_n r(n)^2=\int_0^1|F_A(e^{2\pi i\theta})|^2\,d\theta,
\]

where \(r(n)\) is the number of subsets summing to \(n\).

By Cauchy–Schwarz, \(|R|\cdot E_2\ge\bigl(\sum r(n)\bigr)^2=4^N\), so

\[
|R|\ge\frac{4^N}{E_2}.
\]

The strict conductor theorem says \(|R|\ge S-o(T)\) where \(S\) is the
seed total.  So we want \(E_2\le 4^N/T\,(1+o(1))\).

## 2. The S-unit decomposition

Set \(\delta_i=1_A(i)-1_B(i)\in\{-1,0,+1\}\) for two subsets \(A,B\subseteq F\).  Then

\[
E_2=\sum_{\substack{\delta\in\{-1,0,+1\}^N\\ \sum_i\delta_if_i=0}}
2^{N-|\operatorname{supp}\delta|}.
\]

The trivial \(\delta=0\) contributes \(2^N\).  Non-trivial \(\delta\)
with \(\sum\delta_i f_i=0\) are signed S-unit equations of support
\(s=|\operatorname{supp}\delta|\), each contributing \(2^{N-s}\).

**Naive Evertse–Schlickewei plug-in.** If the number of non-trivial
S-unit equations of support \(s\) in our seed is bounded by some \(\nu_s\)
that grows only polylogarithmically in \(K\) (the per-base exponent
range), then

\[
E_2\le 2^N+2\sum_{s\ge 3}\nu_s\cdot 2^{N-s}
=2^N\bigl(1+O(\operatorname{polylog})\bigr),
\]

and the energy method would give \(|R|\ge T^{c-1-o(1)}\) (where
\(c=\sum 1/\log_2 a > 1\)).  For \(c>1\) and large \(T\), this would
*exceed* \(T\), forcing \(|R|=T-o(T)\) — the strict conductor theorem.

That is the optimistic chain I sketched.  It assumes
\(E_2/2^N=O(\operatorname{polylog})\).

## 3. The empirical check

`scripts/cas_energy_method.py` computes \(E_2\) directly by enumerating
subset sums for small seeds.  Results for \(\{3,4,5\}\) and \(\{3,4,7\}\)
at \(k=1\):

| set        | seed limit | \(N\) | \(T\sim S\) | \(2^N\)  | \(E_2\)      | \(E_2/2^N\) | \(4^N/T\)    | ratio to LLT |
|------------|-----------:|-----:|-----------:|--------:|------------:|-----------:|------------:|-------------:|
| \(\{3,4,5\}\) | 50      | 7    | 89          | 128      | 280          | 2.19        | 184          | 1.52         |
| \(\{3,4,5\}\) | 200     | 10   | 359         | 1,024    | 3,924        | 3.83        | 2,921        | 1.34         |
| \(\{3,4,5\}\) | 1,000   | 14   | 2,212       | 16,384   | 156,710      | 9.56        | 121,354      | 1.29         |
| \(\{3,4,5\}\) | 5,000   | 18   | 12,644      | 262,144  | 6,866,218    | 26.19       | 5,434,948    | 1.26         |
| \(\{3,4,7\}\) | 5,000   | 17   | 11,539      | 131,072  | 1,933,280    | 14.75       | 1,488,853    | 1.30         |

**The empirical \(E_2/2^N\) grows polynomially in \(T\)**, not
polylog.  Specifically, fitting the \(\{3,4,5\}\) data,
\(E_2/2^N\) grows roughly as \(T^{0.4}\).

So the "naive Evertse plug-in" is *empirically wrong* — there must be
many more vanishing signed combinations than the naive S-unit count
suggests.

## 4. Where the naive estimate fails

The Evertse–Schlickewei theorem bounds the number of *non-degenerate*
S-unit solutions.  A solution is degenerate if a proper subsum already
vanishes.  Our seed has many *degenerate* vanishing combinations:

- Any non-trivial vanishing \(\delta_0\) of support \(s_0\) extends to
  \(\delta\) of support \(s\ge s_0\) by adding zero contributions
  outside.  But these "extensions" are the *same* \(\delta\) in the
  ambient space; they don't multiply the count.

Yet the empirical count *does* multiply.  Where does the multiplicity
come from?

Direct examination: for our seed, "vanishing signed combinations" are
much richer than algebraic S-unit equations.  Many \(\delta\) vanish
because of pseudorandom near-cancellations:
\(\sum_i\delta_i a^{e_i}=0\) holds for *many* combinations once
\(2^N\gg T\) (pigeonhole forces collisions).

The Evertse-Schlickewei theorem is about ALGEBRAIC vanishings — combinations
that vanish *as integers* via S-unit structure.  But a "collision" can
also be a *pigeonhole vanishing*: two distinct integer sums in
\([0,S]\) that happen to be equal.  These are dominated by the
*entropy* of the sum distribution, not by algebraic S-unit structure.

## 5. So the energy method = LLT

Once we see this, the energy method is no easier than the LLT.  The
quantity \(E_2 = 4^N\cdot\Pr[X=Y]\) (for independent random subset sums
\(X,Y\)) is anticoncentration of \(X-Y\), which is *exactly* what the
LLT off-resonance bound controls.

Concretely: \(\Pr[X-Y=0]=\int_0^1|F_A(e^{2\pi i\theta})|^2\,d\theta/4^N\),
and bounding this from above is bounding
\(\int|\varphi_A(\theta)|^2 d\theta\) — the *energy* of the
characteristic function.  This is the same off-resonance bound as the
LLT integral, just at second moment.

So the analytic obligation is identical: the strict conductor theorem
via energy method needs the same off-resonance anti-concentration
bound as the LLT closure does.  ABC-strength input is again the route.

## 6. What this changes vs the last session

Three corrections relative to my "Tao-style attack" sketch:

1. **The energy method does not bypass the analytic obligation.**  The
   strict conductor theorem is not 1–2 weeks of work via this route.

2. **The "S-unit count is small" intuition is misleading**: Evertse
   bounds the *algebraic* S-unit count, but \(E_2\) counts *all*
   anticoncentration events, which is dominated by pigeonhole when
   \(2^N\gg T\).

3. **The strict case is not easier than exact-critical via this method**.
   Both need the same off-resonance bound.

So my previous claim — "a careful mathematician could close the strict
case in 1–2 weeks via this energy route" — was wrong.  A careful
mathematician would have noticed the polylog-vs-polynomial gap in 30
minutes of running the script in §3 and pivoted.

## 7. What's still real

Two pieces of last session's analysis remain valid:

- The strict case might still be more accessible than exact-critical
  *for other reasons* (the bounded-gap CFH argument doesn't need
  analytic input, and note 26 already closes \(\{3,4,5\}\) k=1
  unconditionally).  The energy method is not the route, but the
  underlying optimism about strict might survive.

- Density-increment, Croot–Sisask, and Bohr-set methods (the other
  three "Tao-style attacks" I listed) were *not* attempted in this note
  and the energy-method failure does not say anything about whether
  they work.  They could still be productive — I haven't tried them.

## 8. Process note (CAS-discipline working as intended)

The empirical check in §3 took 5 minutes to write and caught a wrong
optimistic claim.  This is exactly the value of the
"CAS for mechanical verification" discipline (memory entry
`feedback_cas_delegation`).  Without it, I would have written several
more confident notes on top of the wrong claim.

Tao's actual methodology includes this kind of fast empirical check.
The fact that my "Tao impression" missed it is a signal that imitating
a top mathematician's *outputs* is much easier than imitating their
*epistemic discipline* — they would have run the script first.

## Status

Adds no Certified obligation.  Documents a falsified optimistic claim
from the previous session.  The strict-case conductor theorem remains
open, and the energy method is not the route.
