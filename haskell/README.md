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

`ResidueGate.hs` defines shared complete and quasi-complete residue predicates.
`ResidueGateCertificate.hs` smoke-tests that API against small literature-style
witnesses and current local exact-critical seed profiles.

`GapBridge.hs` defines the arithmetic bridge from a finite seed interval and a
bounded-gap tail to a cofinite ray, allowing a finite prefix to be absorbed by
ordinary interval extension first.  `GapBridgeCertificate.hs` checks the bridge
against small and current local seed-interval profiles.

`ResidueLift.hs` defines the modular lift from residue representatives plus a
ray or interval of multiples to an ordinary ray or interval.
`ResidueLiftCertificate.hs` checks the bridge against current denominator
residue frames.

`ConductorLift.hs` turns a residue frame plus a scaled central block into an
explicit finite-seed conductor bound.  `ConductorLiftCertificate.hs` checks the
arithmetic transfer examples.

`UnitResidueFrame.hs` constructs complete residue frames from powers of a single
base that is a unit modulo the chosen modulus.  `UnitResidueFrameCertificate.hs`
checks denominator examples and a nontrivial-order sample.

`CFHTail.hs` defines a Chen-Fang-Hegyvari tail-domination checker.
`CFHTailCertificate.hs` proves the `{3,4,5}, k=1` strict local sample by
combining finite prefix absorption, CFH bounded gaps, and strict reciprocal
slack.

Run:

```text
runghc haskell/TailCertificate.hs
runghc haskell/CFTailCertificate.hs
runghc haskell/GlobalProofAudit.hs
runghc haskell/MultiplicativeClasses.hs
runghc haskell/PairCFTailCertificate.hs
runghc -ihaskell haskell/SeedBridgeProfiles.hs
runghc -ihaskell haskell/ResidueBridgeProfiles.hs
runghc -ihaskell haskell/ResidueGateCertificate.hs
runghc -ihaskell haskell/GapBridgeCertificate.hs
runghc -ihaskell haskell/ResidueLiftCertificate.hs
runghc -ihaskell haskell/ConductorLiftCertificate.hs
runghc -ihaskell haskell/UnitResidueFrameCertificate.hs
runghc -ihaskell haskell/CFHTailCertificate.hs
```

This is not a replacement for C++ bitset scans.  Its job is to make the small
tail-arithmetic and continued-fraction certificates auditable and closer to
"right by construction."
