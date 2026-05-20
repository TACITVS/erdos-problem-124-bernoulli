# Modular conductor lift

This note turns the residue-lift bridge into a direct conductor bound.

## Setup

Fix a modulus $m$.  Let $F$ be a finite residue frame modulo $m$, with
representatives

$$\rho_r\equiv r\pmod m,\qquad 0\le r<m,$$

and width

$$R=\max_r \rho_r.$$

Let $G=mG'$ be a disjoint finite block of terms all divisible by $m$.  Write
$S'$ for the sum of the quotient block $G'$, and suppose $P(G')$ contains
the central interval

$$[c'+1,\ S'-c'-1].$$

Then $P(G)$ contains every multiple of $m$ in

$$[m(c'+1),\ m(S'-c'-1)].$$

By the residue-lift bridge from `notes/29_residue_lift_bridge.md`,

$$[m(c'+1)+R,\ m(S'-c'-1)]\subseteq P(F\cup G).$$

## Conductor bound

Let

$$S=S_F+mS'$$

be the total sum of $F\cup G$.  If the lifted interval reaches the half-sum,

$$m(S'-c'-1)\ge \lfloor S/2\rfloor,$$

then every integer from

$$m(c'+1)+R$$

through $\lfloor S/2\rfloor$ is represented.  Therefore the conductor of
$F\cup G$, measured up to half the total sum, satisfies

$$c(F\cup G)\le m(c'+1)+R-1.$$

Equivalently,

$$c(F\cup G)\le mc' + O_{m,F}(1).$$

provided the right endpoint condition holds.

## Why this matters

This is the first direct bridge from the modular route to the power-saving
central conductor target in
`notes/28_power_saving_central_interval_target.md`.

If one can choose $m$ and a fixed residue frame $F$, and then prove a
sublinear or power-saving conductor bound for the quotient divisible block
$G'$, the same bound transfers to $F\cup G$ up to a constant depending only
on the frame.

The remaining difficulty is therefore not residue lifting.  It is to arrange a
divisible block $G=mG'$ whose quotient still has enough power-sequence
structure to prove the needed conductor bound.

## Typed artifact

`haskell/ConductorLift.hs` encodes:

- scaled central blocks $G=mG'$;
- the multiple interval represented by $G$;
- the lifted ordinary interval;
- the half-sum condition;
- the resulting conductor bound.

`haskell/ConductorLiftCertificate.hs` checks two examples with the
$\{3,4,7\}$ residue frame modulo $6$.  These are arithmetic certificates
for the lemma, not new Erdős 124 instances.
