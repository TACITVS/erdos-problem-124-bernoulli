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
- Added a C++ accelerator for large exact bitset conductor and central-interval
  scans.  On this machine, the `{3,4,7}, k=2, limit=50000000` conductor scan
  took about 0.13 seconds in C++ versus about 7.08 seconds through the Python
  prototype.
- Reproduced the published benchmark for \(\{3,4,7\}, k=1\): the largest
  missing integer is 581 in searches up to 100000.
- Found bounded-search conductors for several examples from Burr, Erdos,
  Graham, and Li:
  - \(\{3,4,7\}, k=1\): last missing 581.
  - \(\{3,5,7,13\}, k=1\): last missing 112 in the local computation.
  - \(\{3,6,7,13,21\}, k=1\): last missing 17.
  - \(\{3,4,5\}, k=1\): last missing 79.
- For \(\{3,4,7\}, k=2\), there is a computer-assisted certificate, combining
  exact finite verification with the Mignotte-Waldschmidt lower bound, that the
  largest missing integer is 3982888.  This is not a clean algebraic proof of
  the full Erdos-124 problem.  The tail scan has now been reduced to a
  continued-fraction lemma; see `notes/07_347_k2_certificate.md` and
  `notes/09_cf_tail_347_k2.md`.
- The same method now closes \(\{3,4,7\}, k=3\): the largest missing integer
  is 166025260.  See `notes/10_347_k3_certificate.md`.
- It also closes another exact-critical set, \(\{3,4,9,25\}, k=2\): the
  largest missing integer is 452099.  See
  `notes/11_34925_k2_certificate.md`.
- The seed-bridge work now has a separate residue-completeness layer:
  all fourteen exact-critical sets with maximum base at most 30 and size at
  most 5 are residue-complete modulo their exact-critical denominator at
  \(k=1,L=1000\) and at \(k=2,L=4000\).  See
  `notes/20_residue_bridge_profiles.md`.
- Finite seed tooling has been consolidated behind `scripts/finite_seed.py`;
  the central-interval and residue CLIs are thin frontends over that shared API.

## Source pointers

- Erdos problem page: https://www.erdosproblems.com/124
- R. Burr, P. Erdos, R. Graham, and W. Li, "Complete sequences of sets of
  integer powers", Acta Arithmetica 77 (1996), 133-138.
- G. Melfi, "On certain positive integer sequences", arXiv:math/0404555.

## Fast scans

Build the C++ accelerator with:

```text
g++ -O3 -std=c++20 -march=native cpp/erdos124_fast.cpp -o cpp/erdos124_fast.exe
```

Example checks:

```text
cpp/erdos124_fast.exe --mode=conductor --bases=3,4,7 --k=1 --limit=100000
cpp/erdos124_fast.exe --mode=central --bases=3,4,7 --k=2 --seed-limit=50000000
```

## Typed certificate checks

The Haskell checker in `haskell/TailCertificate.hs` verifies small exact-critical
tail arithmetic with separate types for bases, exponents, weights, conductors,
cleared bounds, and margins.

```text
ghc -Wall -Werror -fforce-recomp haskell\TailCertificate.hs -o haskell\TailCertificate.exe
runghc haskell\TailCertificate.hs
```

The Haskell checker in `haskell/CFTailCertificate.hs` verifies the exact
continued-fraction window for \(\log 3/\log 4\) used by the current tail
certificates.

```text
ghc -Wall -Werror -fforce-recomp haskell\CFTailCertificate.hs -o haskell\CFTailCertificate.exe
runghc haskell\CFTailCertificate.hs
```

The global proof audit is intentionally not marked complete yet.  It tracks the
remaining open obligations for the full theorem.

```text
runghc haskell\GlobalProofAudit.hs
runghc haskell\MultiplicativeClasses.hs
runghc haskell\PairCFTailCertificate.hs
runghc haskell\SeedBridgeProfiles.hs
runghc haskell\ResidueBridgeProfiles.hs
```

Hasclid side-lemma checks live in `prover/`.  They are not a replacement for the
domain certificate checker; they independently certify exact algebraic
obligations such as Legendre-threshold inequalities.

```text
cabal run prover-int -- C:\Users\baian\Math_Research\Knuth_124\prover\legendre_thresholds.euclid
```
