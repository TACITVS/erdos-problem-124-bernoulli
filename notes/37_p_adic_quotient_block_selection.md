# P-adic quotient-block selection

The conductor ladder needs a modulus \(m\), a residue frame \(F\), and a block
of terms \(G\) all divisible by \(m\), so that \(G=mG'\) becomes a scaled power
block after quotienting.

This note records the exact divisibility criterion for choosing such a block.
It is a small p-adic cut inside the larger quotient-block-selection problem.

## Divisibility criterion

Write

\[
m=\prod_p p^{\alpha_p}.
\]

For a base \(d\), let \(v_p(d)\) be the exponent of \(p\) in \(d\).  Then

\[
m\mid d^e
\]

if and only if, for every prime \(p\mid m\),

\[
e\,v_p(d)\ge \alpha_p.
\]

Therefore a base \(d\) can contribute an eventually \(m\)-divisible pure-power
tail if and only if every prime dividing \(m\) also divides \(d\).

When this support condition holds, the first usable exponent at floor \(k\) is

\[
e_0(d;m,k)
=
\max\left(k,\ \max_{p\mid m}\left\lceil{\alpha_p\over v_p(d)}\right\rceil\right).
\]

Then

\[
{d^{e_0+j}\over m}
=
{d^{e_0}\over m}d^j,
\qquad j\ge0,
\]

so the quotient tail is the scaled progression

\[
\left({d^{e_0}\over m}\right)d^j.
\]

This is exactly the scaled language from
`notes/35_scaled_power_block_language.md`.

## Residue frame side condition

The same modulus also needs a residue frame.  The unit-base construction from
`notes/30_unit_residue_frame.md` supplies one whenever the chosen frame base
\(u\) satisfies

\[
\gcd(u,m)=1.
\]

Thus a first quotient-selection certificate consists of:

1. a modulus \(m\);
2. a frame base \(u\) with \(\gcd(u,m)=1\);
3. a nonempty list of quotient bases \(d_i\), each containing every prime
   divisor of \(m\);
4. the p-adically forced start exponents \(e_0(d_i;m,k)\).

The output is:

- a unit-base residue frame modulo \(m\);
- a finite union of scaled quotient progressions
  \[
  (d_i^{e_0}/m)d_i^j.
  \]

## What this proves and what it does not

This cut proves that the modular decomposition is arithmetically well-formed.
It does not prove that the selected quotient block has enough additive mass or
complete-sequence structure to satisfy the scaled middle-interval theorem.

The remaining hard part of quotient-block selection is now sharper:

> Choose \(m,u,\{d_i\}\) so that the p-adic quotient block is not merely valid,
> but strong enough for the complete-sequence absorption criterion from
> `notes/36_complete_sequence_scaled_absorption.md`.

## Typed artifact

`haskell/QuotientBlockSelection.hs` implements:

- exact factorization of the modulus;
- p-adic valuations \(v_p(d)\);
- the first divisible exponent \(e_0(d;m,k)\);
- construction of the unit residue frame and scaled quotient block.

`haskell/QuotientBlockSelectionCertificate.hs` checks:

- a prime-modulus cut for \(\{3,4,7\}\);
- a two-quotient-base cut for \(\{3,4,9,25\}\);
- a composite-modulus cut;
- a valuation-lift example where the exponent floor is increased by the
  modulus valuation;
- rejection when the frame base is not a unit;
- rejection when a quotient base is missing a prime divisor of the modulus.

The next composition layer is `notes/38_quotient_conductor_bridge.md`, which
takes a valid p-adic selection and tests whether complete-sequence absorption
and residue lifting actually produce a conductor bound.
