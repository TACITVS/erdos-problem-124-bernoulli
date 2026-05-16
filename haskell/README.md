# Haskell typed certificate checker

`TailCertificate.hs` is a small typed checker for exact-critical tail
arithmetic.  It uses `newtype`s for bases, exponents, powers, denominators,
weights, conductors, cleared bounds, and margins so proof quantities are not
silently interchangeable.

`CFTailCertificate.hs` checks the continued-fraction tail gate for
`log(3)/log(4)` using exact rational log intervals and exact integer
near-collision gaps.

`GlobalProofAudit.hs` records which parts of the full Erdos-124 proof are
certified, imported, or still open.

`MultiplicativeClasses.hs` checks the primitive prime-exponent class reduction
used before applying Baker-type bounds in the exact-critical case.

`PairCFTailCertificate.hs` checks finite continued-fraction windows for an
arbitrary independent base pair once an external analytic threshold is supplied.

`FiniteSeed.hs` contains shared finite-seed helpers for Haskell certificates:
power generation with multiplicity, frontiers, subset-sum bitsets, and residue
closure.

`SeedBridgeProfiles.hs` recomputes finite seed central-interval profiles for
small exact-critical and strict cases.

`ResidueBridgeProfiles.hs` independently checks finite residue-complete seed
profiles modulo the exact-critical denominator.

Run:

```text
runghc haskell/TailCertificate.hs
runghc haskell/CFTailCertificate.hs
runghc haskell/GlobalProofAudit.hs
runghc haskell/MultiplicativeClasses.hs
runghc haskell/PairCFTailCertificate.hs
runghc -ihaskell haskell/SeedBridgeProfiles.hs
runghc -ihaskell haskell/ResidueBridgeProfiles.hs
```

This is not a replacement for C++ bitset scans.  Its job is to make the small
tail-arithmetic and continued-fraction certificates auditable and closer to
"right by construction."
