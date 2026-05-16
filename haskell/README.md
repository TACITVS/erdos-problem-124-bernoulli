# Haskell typed certificate checker

`TailCertificate.hs` is a small typed checker for exact-critical tail
arithmetic.  It uses `newtype`s for bases, exponents, powers, denominators,
weights, conductors, cleared bounds, and margins so proof quantities are not
silently interchangeable.

`CFTailCertificate.hs` checks the continued-fraction tail gate for
`log(3)/log(4)` using exact rational log intervals and exact integer
near-collision gaps.

Run:

```text
runghc haskell/TailCertificate.hs
runghc haskell/CFTailCertificate.hs
```

This is not a replacement for C++ bitset scans.  Its job is to make the small
tail-arithmetic and continued-fraction certificates auditable and closer to
"right by construction."
