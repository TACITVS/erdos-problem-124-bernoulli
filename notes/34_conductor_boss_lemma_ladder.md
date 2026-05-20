# Conductor boss lemma ladder

This note breaks the remaining power-saving central conductor theorem into
smaller cuts.  The point is to avoid treating the conductor theorem as one
opaque boss fight.

The current open target from `notes/28_power_saving_central_interval_target.md`
is:

$$c(E)=o(T(E))$$

in the strict case, and

$$c(E)=O(T(E)^{1-\epsilon})$$

in the exact-critical case.

## Cut already made: modular conductor lift

`notes/33_modular_conductor_lift.md` proves:

If a fixed residue frame $F$ modulo $m$ has width $R$, and a disjoint
divisible block $G=mG'$ has quotient conductor $c'$, then, provided the
lifted interval reaches the whole half-sum,

$$c(F\cup G)\le m(c'+1)+R-1.$$

This separates residue work from conductor growth.

## New cut: fixed-frame asymptotic transfer

Assume $m$ and $F$ are fixed, so $R$ is fixed.  Let $T'$ be the minimum
frontier term in the quotient block $G'$, and let $T=mT'$ be the
corresponding minimum term in $G=mG'$.

### Strict transfer

If

$$c'(T')=o(T'),$$

then

$$c(F\cup G)\le m(c'(T')+1)+R-1.$$

Dividing by $T=mT'$ gives

$${c(F\cup G)\over T}
\le
{c'(T')\over T'}+{m+R-1\over mT'}.$$

Both terms tend to zero.  Therefore

$$c(F\cup G)=o(T).$$

### Exact-critical power-saving transfer

If for some $\epsilon>0$,

$$c'(T')=O((T')^{1-\epsilon}),$$

then

$$c(F\cup G)
\le
mC(T')^{1-\epsilon}+O_{m,R}(1).$$

Since $T'=T/m$,

$$mC(T')^{1-\epsilon}
=
Cm^\epsilon T^{1-\epsilon}.$$

The fixed additive term is absorbed into $O(T^{1-\epsilon})$ along any
frontier with $T\to\infty$.  Therefore

$$c(F\cup G)=O(T^{1-\epsilon}).$$

So a fixed residue frame preserves both kinds of conductor quality.

## Remaining cuts

The conductor boss now splits into the following smaller targets.

### 1. Scaled power block language

After quotienting $G=mG'$, terms are usually not pure powers.  They are
scaled power progressions:

$$q_i d_i^n.$$

The right general object is therefore a finite union of such progressions.
This language is now explicit in the lemma tree, but it still needs a robust
central-conductor theorem.

### 2. Middle interval theorem for scaled power blocks

Prove that suitable finite initial segments of scaled power blocks have
sublinear or power-saving central conductors.

This is the current sharp additive-combinatorial target.  It is the main open
cut.

The complete-sequence absorption subcut in
`notes/36_complete_sequence_scaled_absorption.md` gives a reusable sufficient
criterion: once scaled quotient terms can be ordered so that each term touches
the current central interval, the old conductor bound is preserved.

### 3. Quotient block selection

Find a modulus $m$, a residue frame $F$, and a divisible block $G=mG'$
so that the quotient block $G'$ keeps enough admissible structure for the
middle interval theorem to apply.

The unit-base frame lemma in `notes/30_unit_residue_frame.md` solves the
residue-frame part whenever some base is a unit modulo $m$.  It does not
solve the quotient block choice.

The p-adic front end in `notes/37_p_adic_quotient_block_selection.md` now
solves the well-formedness part of that choice: a quotient base $d$ is
eventually $m$-divisible exactly when every prime divisor of $m$ divides
$d$, with the first valid exponent given by a valuation maximum.

The bridge in `notes/38_quotient_conductor_bridge.md` composes this p-adic
choice with complete-sequence absorption and modular conductor lift.  It does
not choose the right $m$, but it turns any proposed choice into either a
certified conductor bound or a precise failed inequality.

### 4. Half-sum reach

The modular conductor lift requires

$$m(S'-c'-1)\ge \lfloor S/2\rfloor.$$

This should follow once the quotient interval is long enough compared with the
fixed frame, but it must be proved in the exact decomposition actually used.

### 5. Strict conductor theorem

Combine:

- scaled-block middle intervals;
- quotient block selection;
- half-sum reach;
- fixed-frame transfer.

Goal:

$$c(E)=o(T(E)).$$

### 6. Exact-critical conductor theorem

Use the same ladder, but retain a quantitative power saving:

$$c(E)=O(T(E)^{1-\epsilon}).$$

This is the conductor input needed before the S-unit/Subspace tail can close
the exact-critical case.

## Machine-readable tree

`haskell/ConductorBossTree.hs` records this dependency tree and checks that:

- every dependency points to an existing node;
- there are no dependency cycles;
- the current next open cuts are explicit.

Run:

```text
runghc haskell\ConductorBossTree.hs
```

The expected next cuts are:

```text
scaled-power-middle-interval, quotient-block-selection
```

These are the two places where new mathematics is now needed.
