# Unit-base residue frames

This note adds a first-principles residue-saturation lemma that feeds directly
into the residue-lift bridge in `notes/29_residue_lift_bridge.md`.

## Lemma

Let $m\ge1$, let $a\ge2$, and suppose $\gcd(a,m)=1$.  Fix an exponent
floor $k\ge0$.  Then the powers of $a$ with exponents at least $k$
contain a finite residue frame modulo $m$.

More explicitly, let $h$ be the multiplicative order of $a$ modulo $m$.
The $m-1$ powers

$$a^k,\ a^{k+h},\ a^{k+2h},\ldots,\ a^{k+(m-2)h}$$

are all congruent to the same unit $u=a^k\bmod m$.  Since multiplication by
$u$ permutes the residues modulo $m$, the subset sums of these $m-1$
powers contain representatives for every residue:

$$0,\ u,\ 2u,\ldots,\ (m-1)u \pmod m.$$

Thus a complete residue frame exists.

## Explicit width bound

The frame width can be bounded by the sum of the selected powers:

$$R\le
\sum_{j=0}^{m-2}a^{k+jh}
=
a^k {a^{(m-1)h}-1\over a^h-1}.$$

This bound is usually much larger than the minimal finite residue frames found
by bitset search, but it is algebraic and uniform.  It means that residue
coverage is not the serious obstruction whenever the chosen modulus has a unit
base available.

## Consequence for the conductor route

Combining this lemma with `notes/29_residue_lift_bridge.md` gives:

If $G$ represents all sufficiently large multiples of $m$, and some base
$a\in A$ is coprime to $m$, then the powers of $a$ alone remove the
congruence obstruction modulo $m$.  The resulting ray starts at the multiple
ray threshold plus the explicit frame width $R$.

For interval/conductor work, if $G=mG'$ and $G'$ has central conductor
$c'$, then the lifted interval starts no later than

$$m(c'+1)+R.$$

So a possible inductive attack on the power-saving central conductor theorem is
now more precise:

1. choose a modulus $m$;
2. reserve a unit base as an algebraic residue frame;
3. prove the needed conductor bound for the $m$-divisible block;
4. lift back with the fixed loss $R$.

This does not solve the global theorem.  It proves that a whole class of
residue-saturation subproblems can be eliminated by a simple unit-base
construction, leaving the divisible-block conductor as the real target.

## Typed artifact

`haskell/UnitResidueFrame.hs` constructs the frame and validates it through
`ResidueLift.mkResidueFrame`.

`haskell/UnitResidueFrameCertificate.hs` checks:

- base $7$ modulo $6$, matching the $\{3,4,7\}$ denominator;
- base $25$ modulo $24$, matching the $\{3,4,9,25\}$ denominator;
- base $3$ modulo $5$, a sample where the multiplicative order is not
  $1$.
