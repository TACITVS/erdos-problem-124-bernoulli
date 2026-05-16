# Typed continued-fraction tail gate

The continued-fraction part of the tail proof now has a Haskell certificate in
`haskell/CFTailCertificate.hs`.

## Certified input

For

\[
\alpha={\log 3\over\log 4},
\]

the checker recomputes exact rational intervals for \(\log 3\) and \(\log 4\)
from

\[
\log x=2\sum_{j\ge0}{y^{2j+1}\over 2j+1},
\qquad y={x-1\over x+1},
\]

using the same geometric tail bound as the Python script.  It then extracts the
common continued-fraction prefix forced by the interval:

\[
[0,1,3,1,4,1,1,11,1,46,1,5,112].
\]

This gives the convergents needed for the finite gap between the Legendre
threshold and the Mignotte-Waldschmidt cutoff.

## Certified screen

For each current exact-critical tail certificate, the checker verifies:

- the exact Legendre threshold inequality \(2aB<3^a-B\) at the starting
  exponent;
- the relevant convergents of \(\alpha\) with
  \(a_0\le a<a_{\mathrm{MW}}\);
- the next convergent has denominator \(21372011\), above every current
  \(a_{\mathrm{MW}}\);
- exact integer gaps satisfy \(|3^a-4^b|>B\) for every relevant convergent.

The three checked cases are:

\[
\begin{array}{c|c|c|c}
\text{case} & B & a_0 & a_{\mathrm{MW}}\\
\hline
\{3,4,7\}, k=2 & 47794770 & 20 & 293904\\
\{3,4,7\}, k=3 & 1992303678 & 23 & 293907\\
\{3,4,9,25\}, k=2 & 21701880 & 19 & 293903
\end{array}
\]

The minimum exact gap among the eight relevant convergents is

\[
|3^{24}-4^{19}|=7551629537,
\]

which exceeds all three present values of \(B\).

## Boundary of the certificate

This certificate does not prove the Mignotte-Waldschmidt theorem.  It treats the
MW cutoff as an external analytic input, then checks the finite continued-
fraction window before that cutoff by exact rational and integer arithmetic.

The immediate proof spine is now:

1. C++ bitset scan certifies the finite central interval.
2. `haskell/TailCertificate.hs` certifies the small frontier states before
   Legendre applies.
3. Hasclid certifies reusable algebraic threshold side lemmas.
4. `haskell/CFTailCertificate.hs` certifies the exact CF window up to the MW
   cutoff.
