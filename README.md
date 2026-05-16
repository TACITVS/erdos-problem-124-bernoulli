# Erdos Problem 124 research log

This repository is a working notebook for a computational and proof-oriented
attack on Erdos problem 124.

## Problem statement used here

Let \(A=\{d_1,\ldots,d_r\}\) be a finite set of distinct integers with
\(d_i\ge 3\).  For \(k\ge 1\), let \(P(d,k)\) be the set of finite sums of
distinct powers \(d^j\), \(j\ge k\).  The hard form of the problem asks whether

\[
\gcd(d_1,\ldots,d_r)=1,\qquad
\sum_{i=1}^r {1\over d_i-1}\ge 1
\]

imply that every sufficiently large integer lies in
\(P(d_1,k)+\cdots+P(d_r,k)\), for every \(k\ge 1\).

The nearby version with \(k=0\), where every base contributes a copy of
\(1=d^0\), has a short Brown-criterion proof.  This repository focuses on the
hard \(k\ge 1\) version.

## Current local results

- Implemented exact subset-sum bitset computations for bounded verification.
- Reproduced the published benchmark for \(\{3,4,7\}, k=1\): the largest
  missing integer is 581 in searches up to 100000.
- Found bounded-search conductors for several examples from Burr, Erdos,
  Graham, and Li:
  - \(\{3,4,7\}, k=1\): last missing 581.
  - \(\{3,5,7,13\}, k=1\): last missing 112 in the local computation.
  - \(\{3,6,7,13,21\}, k=1\): last missing 17.
  - \(\{3,4,5\}, k=1\): last missing 79.
- For \(\{3,4,7\}, k=2\), bounded search up to 50000000 found last missing
  3982888.  This is evidence only, not yet a proof of global cofiniteness.

## Source pointers

- Erdos problem page: https://www.erdosproblems.com/124
- R. Burr, P. Erdos, R. Graham, and W. Li, "Complete sequences of sets of
  integer powers", Acta Arithmetica 77 (1996), 133-138.
- G. Melfi, "On certain positive integer sequences", arXiv:math/0404555.

