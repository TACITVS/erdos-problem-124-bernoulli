# Haskell typed certificate checker

`TailCertificate.hs` is a small typed checker for exact-critical tail
arithmetic.  It uses `newtype`s for bases, exponents, powers, denominators,
weights, conductors, cleared bounds, and margins so proof quantities are not
silently interchangeable.

Run:

```text
runghc haskell/TailCertificate.hs
```

This is not a replacement for C++ bitset scans.  Its job is to make the small
tail-arithmetic certificates auditable and closer to "right by construction."

