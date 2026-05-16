# Typed certificate layer

The proof arithmetic now has a small Haskell checker in
`haskell/TailCertificate.hs`.

The purpose is not speed.  It is to make certificate arithmetic harder to misuse
by giving separate types to:

- bases;
- exponents;
- powers;
- denominators;
- denominator-cleared weights;
- conductors;
- denominator-cleared obstruction bounds;
- margins.

The first compiler run caught a real design issue: the code tried to enumerate
exponents using Haskell range syntax, which would have required a loose `Enum`
instance.  Replacing that with an explicit typed successor loop is a better fit
for certificate code.

The checker currently verifies the small exact-critical tail arithmetic for:

- \(\{3,4,9,25\}, k=2\);
- \(\{3,4,7\}, k=3\).

This does not replace the mathematical proof, but it reduces the risk of
transcription errors in the finite exact-critical tail lemmas.

