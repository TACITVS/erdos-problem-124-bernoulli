# Complete-sequence absorption for scaled blocks

The previous note made quotient blocks into scaled progressions $q d^n$.  The
next question is how such blocks can produce central intervals without relying
on a brute-force subset-sum scan.

This note isolates a standard complete-sequence idea, often called Brown's
criterion in this area, in the exact form needed by the conductor ladder.

## Interval absorption lemma

Assume a finite seed multiset represents every integer in an interval

$$[L,U].$$

Let $t>0$ be a new unused term.  If

$$t\le U-L+1,$$

then the old interval and its translate by $t$,

$$[L,U]\quad\text{and}\quad [L+t,U+t],$$

overlap or touch.  Therefore the enlarged multiset represents every integer in

$$[L,U+t].$$

Iterating this proves the following finite complete-sequence criterion.

## Complete-sequence criterion over a seed interval

Let $b_1,\ldots,b_s$ be positive terms, ordered so that

$$b_1\le b_2\le\cdots\le b_s.$$

Starting from $[L,U]$, suppose that for every $i$,

$$b_i\le U-L+1+\sum_{j<i} b_j.$$

Then after adjoining all $b_i$, every integer in

$$\left[L,\ U+\sum_{i=1}^s b_i\right]$$

is represented.

This is the same mechanism as Brown's complete-sequence theorem, but with an
arbitrary represented seed interval instead of only the interval $[0,0]$.

## Central conductor preservation

Now suppose the original seed has total $S_0$ and central conductor $c$, so
it represents

$$[c+1,\ S_0-c-1].$$

If a finite scaled block $B$ satisfies the complete-sequence inequalities over
that interval, then adjoining $B$ gives the interval

$$\left[c+1,\ S_0-c-1+\sum_{b\in B} b\right].$$

The new total is

$$S_1=S_0+\sum_{b\in B} b,$$

so the new interval is exactly

$$[c+1,\ S_1-c-1].$$

Thus the central conductor bound $c$ is preserved.

This is a useful "death by a thousand cuts" reduction: the scaled middle
interval theorem can now be attacked by proving that enough quotient-block terms
can be ordered to satisfy these complete-sequence inequalities.

## Scaled block corollary

Let $B$ be a finite union of scaled progressions

$$q_i d_i^n.$$

Sort the finite selected terms of $B$ into increasing order.  If the sorted
terms satisfy the complete-sequence inequalities over an existing central
interval, then adjoining this scaled block preserves the old central conductor
bound.

This does not prove the global scaled middle interval theorem.  It splits that
theorem into two smaller jobs:

1. produce or import a seed interval;
2. prove that the selected scaled quotient terms are complete over that seed
   interval.

The second job is now a clean inequality problem on an ordered list of terms.

## Typed artifact

`haskell/CompleteSequence.hs` implements the interval absorption criterion and
the central-conductor preservation wrapper.

`haskell/ScaledCompleteSequenceCertificate.hs` checks:

- binary complete sequences from $[0,0]$;
- a two-scale dyadic scaled block;
- preservation of a nonzero conductor bound;
- rejection of a sparse scaled block whose first term does not touch the seed
  interval.
