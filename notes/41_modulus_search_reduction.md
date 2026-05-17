# Modulus search reduction

The previous note `notes/40_quotient_reciprocal_sum.md` defined the modular
bridge regime for any pair \((m,A)\).  Selecting the modulus then looks like a
search over an infinite parameter.  This note proves the search is finite,
turns it into an algorithm, and records the search verdict for every
hypothesis-minimal local case.

## Radical invariance

Recall \(D(m,A)=\{d\in A:\ v_p(d)\ge1\ \forall p\mid m\}\).  Membership in
\(D(m,A)\) depends only on the prime support of \(m\), not on its higher
valuations:

\[
\operatorname{rad}(m)=\operatorname{rad}(m')\implies D(m,A)=D(m',A).
\]

Consequently the bridge regime and selection slack \(\sigma(m,A)\) defined in
note 40 are functions of \(\operatorname{rad}(m)\) alone.

## Finite search reduction

Let

\[
\operatorname{rad}_{\max}(A)=\prod_{p\,\in\,\operatorname{primes}(A)} p,
\qquad
\operatorname{primes}(A)=\bigcup_{d\in A}\operatorname{primes}(d).
\]

Any prime \(p\) that does not divide \(\operatorname{rad}_{\max}(A)\) is
missing from every \(d\in A\), so \(D(m,A)=\emptyset\) whenever any such
prime divides \(m\).  These degenerate moduli have slack \(\sigma=-1\) and
need not be enumerated.

Restrict the search to moduli \(m\) with \(\operatorname{rad}(m)\) dividing
\(\operatorname{rad}_{\max}(A)\).  The squarefree divisors of
\(\operatorname{rad}_{\max}(A)\) are in bijection with subsets of
\(\operatorname{primes}(A)\), so the number of distinct bridge regimes is at
most

\[
2^{|\operatorname{primes}(A)|}.
\]

This finite enumeration is the **modulus search reduction**.  For each
squarefree candidate \(r\), compute \(D(r,A)\), \(R(D(r,A))\), and the regime;
report the verdict.

## Verdict catalogue for local exact-critical sets

| set                                  | primes                | search size | best slack          |
|--------------------------------------|-----------------------|-------------|---------------------|
| \(\{3,4,7\}\)                        | \(\{2,3,7\}\)         | 8           | \(-1/2\) at \(r=3\) |
| \(\{3,4,9,25\}\)                     | \(\{2,3,5\}\)         | 8           | \(-3/8\) at \(r=3\) |
| \(\{3,4,5\}\)                        | \(\{2,3,5\}\)         | 8           | \(-1/2\) at \(r=3\) |
| \(\{3,5,7,13\}\)                     | \(\{3,5,7,13\}\)      | 16          | \(-1/2\) at \(r=3\) |
| \(\{3,6,9,12,21,45,89\}\)            | \(\{2,3,5,7,89\}\)    | 32          | \(-1/88\) at \(r=3\)|

For every recorded local hypothesis-minimal case the best slack is strictly
negative, so the modular bridge is one-shot for all of them.  This is the
algorithmic confirmation of the conclusion in note 40.

## Compatibility with p-adic well-formedness

The p-adic well-formedness lemma in `notes/37_p_adic_quotient_block_selection.md`
needs an actual exponent for each divisible base, including the higher-power
information \(\lceil\alpha_p/v_p(d)\rceil\).  Therefore the *quotient block
itself* depends on \(m\), not only on \(\operatorname{rad}(m)\); raising the
valuation of a prime in \(m\) raises the start exponent for the divisible
bases.

The selection slack reduction shows that this raising is irrelevant for the
*regime classification* but still matters for the *conductor magnitude* of
the resulting quotient seed.  The search reduction is therefore only the
first step: among moduli with the same radical the conductor sizes differ,
and a secondary tuning over the valuation profile is still possible.

## Consequences for the boss tree

This reduction closes the "is the search infinite" question for the cut
`quotient-block-selection`.  It does not yet pick *which* modulus is best for
asymptotic conductor work; that is now the residual problem of:

- choosing whether to use the modular bridge at all (recursive vs one-shot
  vs skip);
- if used, tuning the valuation profile within the chosen radical.

The cut is therefore narrower than before: an explicit finite search yields
the bridge regime, and the only remaining mathematical work is either (a)
producing a quotient conductor in the chosen regime, or (b) using a direct
attack on \(A\) without modular reduction.

## Typed artifact

`haskell/ModulusSearch.hs` defines:

- `radicalDivisors :: [Integer] -> [Integer]`: the squarefree divisors of
  \(\operatorname{rad}_{\max}(A)\);
- `searchAllRegimes :: [Integer] -> [(Integer, BridgeRegime, Ratio Integer)]`:
  enumerate all radicals with their regimes and slacks;
- `bestSlackModulus :: [Integer] -> Maybe (Integer, BridgeRegime, Ratio Integer)`:
  pick the recursive modulus with maximal slack if any, otherwise the
  deficit modulus with maximal slack.

`haskell/ModulusSearchCertificate.hs` checks:

- the squarefree divisor enumeration on small bases sets;
- best-slack picks for the local exact-critical and modular-gate cases;
- a positive-slack pick for the synthetic recursive example from note 40;
- correct rejection of empty input.
