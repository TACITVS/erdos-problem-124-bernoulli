# Typed certificate layer

The proof arithmetic now has two small Haskell checkers:

- `haskell/TailCertificate.hs` for exact-critical frontier arithmetic;
- `haskell/CFTailCertificate.hs` for the continued-fraction tail gate.

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

- $\{3,4,7\}, k=2$;
- $\{3,4,9,25\}, k=2$;
- $\{3,4,7\}, k=3$.

The CF checker recomputes the exact rational continued-fraction prefix for
$\log 3/\log 4$, verifies the relevant convergents below the external
Mignotte-Waldschmidt cutoff, and checks the gaps $|3^a-4^b|>B$ by exact
integer arithmetic.

This does not replace the mathematical proof or the cited analytic lower bound,
but it reduces the risk of transcription errors in the finite exact-critical
tail lemmas.
