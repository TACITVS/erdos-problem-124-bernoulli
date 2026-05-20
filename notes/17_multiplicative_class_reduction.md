# Multiplicative-class reduction

This note narrows the exact-critical global obligation.

## Primitive exponent vectors

For an integer $n>1$, write

$$n=\prod_p p^{v_p(n)}.$$

Let

$$g(n)=\gcd_p v_p(n),
\qquad
\kappa(n)=\left(v_p(n)/g(n)\right)_p.$$

Then two integers $x,y>1$ are multiplicatively dependent, meaning
$x^a=y^b$ for some positive $a,b$, exactly when
$\kappa(x)=\kappa(y)$.

The Haskell checker `haskell/MultiplicativeClasses.hs` computes these class
keys by exact factorization.

## GCD-one sets contain an independent pair

If all bases in $A$ are in one multiplicative class, then there is an integer
$r>1$ and positive exponents $m_d$ such that each $d\in A$ equals
$r^{m_d}$.  Hence $r\mid d$ for every $d\in A$, so $\gcd(A)\ge r>1$.

Contrapositively, if $\gcd(A)=1$, then $A$ has at least two multiplicative
classes.  Therefore it contains multiplicatively independent bases.

## Use in the exact-critical tail

For exact-critical $A$, the current near-collision lemma says that a failed
frontier implies

$$|E_i-E_j|<B\left({1\over w_i}+{1\over w_j}\right)$$

for every pair $i,j$.  Choosing any pair from different multiplicative
classes converts a tail failure into a near-collision between multiplicatively
independent powers.

Thus the remaining analytic obligation is narrower than before:

> For every multiplicatively independent pair $x,y$, instantiate an explicit
> lower bound that makes $|x^a-y^b|>C$ beyond a computable exponent threshold.

After such a bound is fixed, the Haskell certificate layer only has to check
the finite frontier window below that threshold.

## Checked examples

`haskell/MultiplicativeClasses.hs` checks the fourteen exact-critical sets with
maximum base at most $30$ and size at most $5$, plus dependent sanity cases.
All gcd-one examples have at least two multiplicative classes.
