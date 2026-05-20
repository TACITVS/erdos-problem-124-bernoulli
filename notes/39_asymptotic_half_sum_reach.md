# Asymptotic half-sum reach

The conductor boss tree from `notes/34_conductor_boss_lemma_ladder.md` lists
`half-sum-reach` as an open cut.  The cut comes from
`notes/33_modular_conductor_lift.md`: the modular conductor bound

$$c(F\cup mG')\le m(c'+1)+R-1$$

is only valid when the lifted central interval

$$[m(c'+1)+R,\ m(S'-c'-1)]$$

reaches the whole half-sum

$$\left\lfloor{F_{\rm tot}+mS'\over 2}\right\rfloor,$$

where $F_{\rm tot}=\sum_{u\in F}u$ is the total of the residue frame and $S'$
is the quotient seed total.

This note states the exact algebraic threshold for half-sum reach and proves
that it is satisfied along every conductor sequence with sublinear or
power-saving quotient conductor.  This closes the qualitative side of the
`half-sum-reach` cut.

## Reach inequality

Right endpoint of the lifted interval:

$$\text{end}=m(S'-c'-1).$$

Half of the whole finite seed:

$$\text{half}=\left\lfloor{F_{\rm tot}+mS'\over 2}\right\rfloor.$$

Reach is the condition $\text{end}\ge\text{half}$.  Multiplying by $2$ and
using $\lfloor x/2\rfloor\le x/2$,

$$2m(S'-c'-1)\ge F_{\rm tot}+mS'-\pi,
\qquad
\pi\in\{0,1\}.$$

Equivalently

$$mS'\ge 2m(c'+1)+F_{\rm tot}-\pi.$$

A clean sufficient form drops the parity slack and clears the modulus:

$$S'\ge 2(c'+1)+\left\lceil{F_{\rm tot}\over m}\right\rceil.$$

Call this the **half-sum reach threshold** $S'_*(c',F_{\rm tot},m)$.  By the
ceiling identity

$$m\left\lceil{F_{\rm tot}\over m}\right\rceil\ge F_{\rm tot},$$

reaching the threshold gives

$$mS'\ge 2m(c'+1)+m\left\lceil{F_{\rm tot}\over m}\right\rceil
\ge 2m(c'+1)+F_{\rm tot},$$

which strictly exceeds the parity-shifted version and so always implies the
$\text{end}\ge\text{half}$ inequality.

## Asymptotic transfer

Now read the threshold against the conductor sizes used by
`notes/28_power_saving_central_interval_target.md`.

Fix a residue frame, so both $F_{\rm tot}$ and $m$ are fixed.  The
threshold is

$$S'_*(c',F_{\rm tot},m)=2(c'+1)+\left\lceil{F_{\rm tot}\over m}\right\rceil
=2c'+O_{F,m}(1).$$

Suppose the quotient seed satisfies

$$T'(S')\to\infty,
\qquad
c'(S')=o(T'(S')),$$

with $T'(S')$ the minimum frontier term of the quotient block (so
$T'(S')\le S'$).

Then for all sufficiently large $S'$,

$$S'\ge 2c'(S')+O_{F,m}(1)\ge S'_*(c',F_{\rm tot},m),$$

so half-sum reach holds.  The same conclusion holds in the exact-critical
power-saving case $c'(S')=O(T'(S')^{1-\epsilon})$, since the right-hand side
is still $o(S')$.

## Reach margin

For book-keeping it is useful to record the explicit reach margin

$$\mu(S',c',F_{\rm tot},m)
=
2m(S'-c'-1)-F_{\rm tot}-mS'+\pi
=
mS'-2m(c'+1)-F_{\rm tot}+\pi.$$

Reach holds iff $\mu\ge0$.  Passing the threshold
$S'\ge S'_*$ gives

$$\mu\ge m\left\lceil{F_{\rm tot}\over m}\right\rceil-F_{\rm tot}+\pi\ge\pi\ge0,$$

with the sharp value depending only on the residue frame.

## What this closes

The conductor lift in `notes/33_modular_conductor_lift.md` is now a complete
qualitative theorem:

> If a quotient seed has total $S'$, conductor $c'$, and satisfies
> $$S'\ge 2(c'+1)+\left\lceil F_{\rm tot}/m\right\rceil,$$
> then the ordinary seed obtained by combining the unit residue frame with the
> rescaled quotient block has conductor at most $m(c'+1)+R-1$.

For the asymptotic conductor theorems in
`notes/28_power_saving_central_interval_target.md`, this finishes the half-sum
reach piece: once a quotient conductor with the right growth rate exists, the
final ordinary conductor inherits the same growth modulo the fixed multiplicative
constant $m$ and additive constants $F_{\rm tot}$ and $R$.

The remaining open work in the conductor boss tree is therefore exclusively in
`scaled-power-middle-interval` and `quotient-block-selection`: producing the
quotient seed itself.  No further reach gap stands between a good quotient
conductor and a good ordinary conductor.

## Typed artifact

`haskell/HalfSumReach.hs` defines:

- `halfSumReachThreshold :: UnitFrame -> Integer -> Integer`, which returns
  $S'_*(c',F_{\rm tot},m)$;
- `halfSumReachMargin :: UnitFrame -> Integer -> Integer -> Integer`, which
  returns the explicit margin $\mu$ for given $S',c'$;
- `provesHalfSumReach :: UnitFrame -> Integer -> Integer -> Either String HalfSumReachWitness`,
  which checks the threshold inequality and produces a typed witness.

`haskell/HalfSumReachCertificate.hs` checks:

- the threshold formula against an explicit half-sum computation on small
  unit frames;
- threshold satisfaction at $S'=S'_*$ and slack at larger $S'$;
- correct rejection just below the threshold;
- consistency with the existing `ConductorLift.conductorBoundFromLift` test
  vectors so that no certified case regresses.
