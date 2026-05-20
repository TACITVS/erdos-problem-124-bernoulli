# Scaled conductor identity

The tail invariant identity in
`notes/28_power_saving_central_interval_target.md`,

$$K(E)=C(E)-1-H(E)=\kappa(A,k)+2c(E)+1,$$

is stated for pure-power blocks $d_i^j$.  The quotient ladder in
`notes/34_conductor_boss_lemma_ladder.md` runs on scaled blocks $qd^n$.
This note generalizes the identity to scaled blocks, so that conductor
production on a scaled block automatically supplies the tail invariant
input needed by `notes/28`.

## Setup

Let $B$ be a scaled block: a finite union of scaled progressions

$$(q_i,d_i,n_i),\qquad q_i\ge1,\ d_i\ge2,\ n_i\ge0,$$

with terms

$$b_{i,j}=q_id_i^{j},\qquad n_i\le j<e_i.$$

Pick frontiers $E=(E_i)$ with $E_i=q_id_i^{e_i}$ so that the finite seed
multiset is

$$F(E)=\{b_{i,j}:\ n_i\le j<e_i\}.$$

## Seed total and capacity

For each progression,

$$\sum_{j=n_i}^{e_i-1}q_id_i^j
=
{q_id_i^{e_i}-q_id_i^{n_i}\over d_i-1}.$$

So the seed total is

$$S(B,E)
=
\sum_i {q_id_i^{e_i}-q_id_i^{n_i}\over d_i-1}.$$

Define the scaled capacity

$$C(B,E)=\sum_i {q_id_i^{e_i}\over d_i-1},$$

and the scaled tail residue

$$\kappa_{\rm scaled}(B)=\sum_i {q_id_i^{n_i}\over d_i-1}.$$

Then by direct subtraction

$$C(B,E)-S(B,E)=\kappa_{\rm scaled}(B).$$

This is exactly the scaled analogue of the pure-power identity
$C(E)-S(E)=\kappa(A,k)$.

## Tail invariant

Let $c(B,E)$ be the central conductor: the largest integer
$\le\lfloor S(B,E)/2\rfloor$ not represented by subset sums of $F(E)$.
The central interval is $[c(B,E)+1,\ S(B,E)-c(B,E)-1]$, with span

$$H(B,E)=S(B,E)-2c(B,E)-2.$$

Then

$$K(B,E)=C(B,E)-1-H(B,E)
=
\kappa_{\rm scaled}(B)+2c(B,E)+1.$$

So the scaled tail invariant is again exactly controlled by the central
conductor, up to the fixed constant $\kappa_{\rm scaled}(B)$ determined
only by the coefficients, bases, and exponent floors.

## Consequences

### Strict tail

The strict tail mechanism in note 28 used

$$T(E)(R-1)\ge K(E)$$

with $R=\sum1/(d_i-1)$ the pure-power reciprocal sum.  Because each scaled
progression contributes asymptotically $1/(d_i-1)$ (see
`notes/40_quotient_reciprocal_sum.md`), the same inequality controls the
scaled tail with the *same* reciprocal-sum $R_{\rm scaled}(B)
=\sum_i1/(d_i-1)$.

So the strict-tail closure node `strict-tail` in the boss tree applies
verbatim to scaled blocks, provided the conductor input is supplied for
scaled blocks.

### Exact-critical tail

Likewise the S-unit tail closure applies once the conductor input is given.
The scaled identity changes only the *additive* constant
$\kappa_{\rm scaled}(B)$, not the structural shape of the invariant.

### Reduction target

Producing the scaled middle-interval theorem
(`scaled-power-middle-interval`) is therefore *exactly* the same kind of
target as in the pure-power case: prove $c(B,E)=o(T(B,E))$ (strict) or
$c(B,E)=O(T(B,E)^{1-\epsilon})$ (exact-critical), where
$T(B,E)=\min_iE_i$.

## Typed artifact

`haskell/ScaledConductorIdentity.hs` defines:

- `seedTotal :: ScaledBlock -> [(Integer,Integer)] -> Integer`: seed total
  for given exponent windows $[n_i,e_i)$;
- `scaledCapacity :: ScaledBlock -> [Integer] -> Integer`: capacity
  $C(B,E)$;
- `kappaScaled :: ScaledBlock -> Integer`: tail residue
  $\kappa_{\rm scaled}(B)$;
- `tailInvariant :: ScaledBlock -> ConductorWitness -> Integer`: returns
  $K(B,E)$ from a conductor witness.

`haskell/ScaledConductorIdentityCertificate.hs` verifies:

- the identity $C(B,E)-S(B,E)=\kappa_{\rm scaled}(B)$ on small dyadic and
  ternary blocks;
- the tail invariant $K(B,E)=\kappa_{\rm scaled}(B)+2c+1$ at chosen
  conductor values;
- consistency with the pure-power identity in note 28 when each
  progression has coefficient 1.
