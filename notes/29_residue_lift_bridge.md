# Residue-lift bridge

This note records a reusable algebraic bridge for the new conductor-growth
target in `notes/28_power_saving_central_interval_target.md`.

The purpose is to split interval production into two pieces:

1. a finite residue frame with small representatives;
2. an interval or ray of multiples of the same modulus.

The bridge then lifts the multiple interval/ray to an ordinary integer
interval/ray with an explicit additive loss.

## Residue frame

Fix a modulus $m$.  A finite set $F$ gives a residue frame modulo $m$ if,
for every residue $r\bmod m$, there is a subset sum

$$\rho_r\in P(F),\qquad \rho_r\equiv r\pmod m.$$

Let

$$R=\max_r \rho_r.$$

The number $R$ is the width of the frame.

## Ray lift

Let $G$ be disjoint from $F$.  Suppose $P(G)$ contains every multiple of
$m$ from $M_0$ onward.  Then

$$[M_0+R,\infty)\subseteq P(F\cup G).$$

Proof.  Given $N\ge M_0+R$, choose $r\equiv N\pmod m$.  Then
$N-\rho_r$ is a multiple of $m$, and

$$N-\rho_r\ge M_0+R-\rho_r\ge M_0.$$

So $N-\rho_r\in P(G)$, hence $N\in P(F\cup G)$.

This is the bounded residue bridge from `notes/20_residue_bridge_profiles.md`,
now isolated as a typed Haskell lemma.

## Interval lift

The finite interval version is the useful new form for conductor work.

Suppose $P(G)$ contains every multiple of $m$ in the interval
$[M_0,M_1]$, with $M_0$ and $M_1$ divisible by $m$.  Then

$$[M_0+R,\ M_1]\subseteq P(F\cup G),$$

provided $M_0+R\le M_1$.

The proof is the same.  If $M_0+R\le N\le M_1$, choose
$\rho_r\equiv N\pmod m$.  Then $N-\rho_r$ is a multiple of $m$, and

$$M_0\le N-\rho_r\le M_1.$$

Therefore $N-\rho_r\in P(G)$.

## Conductor consequence

If every term of $G$ is divisible by $m$, write $G=mG'$.  If the scaled
set $G'$ has a central interval

$$[c'+1,\ U'-c'-1]\subseteq P(G'),$$

then $P(G)$ contains all multiples of $m$ in

$$[m(c'+1),\ m(U'-c'-1)].$$

The residue-lift bridge gives

$$[m(c'+1)+R,\ m(U'-c'-1)]\subseteq P(F\cup G).$$

Thus one possible attack on the power-saving central conductor theorem is:

1. choose a modulus $m$ and a small residue frame $F$;
2. put the $m$-divisible seed terms in $G$;
3. prove a conductor bound for the scaled object $G'$;
4. lift it back with only the additive loss $R$.

This is not yet a proof of Erdős 124.  It is a clean modular-induction route:
the conductor theorem can now be attacked by showing that the frame width
$R$ and the scaled conductor $m c'$ have the required sublinear or
power-saving growth.

## Typed artifact

`haskell/ResidueLift.hs` encodes:

- validated residue frames;
- validated multiple rays and intervals;
- ray lifting;
- interval lifting.

`haskell/ResidueLiftCertificate.hs` checks the bridge on current denominator
residue frames for $\{3,4,7\},k=1$ and
$\{3,4,9,25\},k=2$.
