# Hasclid fit for typed side lemmas

The Haskell prover at `C:\Users\baian\Haskell\Prover` is useful here, but not
as a direct prover for the full Erdos-124 statement.

## What it can certify

Hasclid is an exact rational/integer algebraic prover.  Its strongest fit in
this project is to certify side obligations after the number-theoretic argument
has reduced them to polynomial or integer inequalities.

The first useful target is the Legendre-threshold step in the continued-fraction
tail proof.  If a near-collision satisfies

$$|3^a-4^b|<B,$$

then the proof needs

$${B\over a\log 4(3^a-B)} < {1\over 2a^2}.$$

Since $\log 4>1$, it is enough to prove

$$2aB<3^a-B.$$

The file `prover/legendre_thresholds.euclid` asks Hasclid to prove the three
exact threshold instances now used by the local certificates:

$$\begin{array}{c|c|c}
\text{case} & B & a_0\\
\hline
\{3,4,7\}, k=2 & 47794770 & 20\\
\{3,4,7\}, k=3 & 1992303678 & 23\\
\{3,4,9,25\}, k=2 & 21701880 & 19
\end{array}$$

It also proves the abstract propagation lemma.  With $p=3^a$, $B>0$,
$a\ge1$, and $p-B>2aB$, Hasclid proves

$$3p-B>2(a+1)B.$$

This is the induction step because

$$3^{a+1}-B-2(a+1)B
=3(3^a-B-2aB)+4aB.$$

## Verified run

Command:

```text
cabal run prover-int -- C:\Users\baian\Math_Research\Knuth_124\prover\legendre_thresholds.euclid
```

Result:

```text
RESULT: PROVED  -- {3,4,7}, k=2 threshold
RESULT: PROVED  -- {3,4,7}, k=3 threshold
RESULT: PROVED  -- {3,4,9,25}, k=2 threshold
RESULT: PROVED  -- abstract propagation step
```

## What it should not be asked to do

Hasclid does not natively encode the full subset-sum frontier dynamics, rational
continued-fraction interval extraction, or the Mignotte-Waldschmidt exponential
lower bound.  Those remain better handled by the project-specific Haskell
certificate checker and exact arithmetic scripts.

The practical split is:

- Use `haskell/TailCertificate.hs` for domain certificates with explicit types
  for bases, exponents, weights, conductors, bounds, and margins.
- Use Hasclid for algebraic and integer side lemmas that arise after the proof
  has been reduced to exact formulas.
