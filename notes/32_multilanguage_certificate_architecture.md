# Multilanguage certificate architecture

This note makes the repository's proof-engineering boundary explicit.  The
project now uses several languages, but they should form one certificate body,
not a pile of independent scripts.

## Rule

Every executable proof artifact must have:

1. a mathematical note explaining the lemma or computation;
2. a typed or validated implementation;
3. an entry in `certificates/manifest.json`;
4. a result note under `results/` when it changes the proof state.

The manifest is the executable index.  Run the default suite with:

```text
python scripts\run_certificates.py
```

Run every listed entry, including optional external checks, with:

```text
python scripts\run_certificates.py --all
```

Run one entry by id with:

```text
python scripts\run_certificates.py --only raku-residue-dsl
```

## Language roles

Python is the shared finite-computation library and orchestration layer.  It is
allowed to run searches, bitset checks, and certificate manifests.  Python
outputs are evidence or finite checks unless independently certified elsewhere.

C++ is the accelerator for large exact bitset scans.  It is performance
infrastructure, not a separate mathematical proof language.

Haskell is the typed certificate layer.  Small algebraic lemmas, finite
profiles, and proof-obligation audits should be encoded here when the types can
prevent category mistakes.

Raku is the DSL/proof-object construction layer.  Its job is to make domain
objects ergonomic and right by construction.  The current Raku layer validates
residue frames, multiple intervals, and unit-base frames.  It is not yet an
RFLK kernel proof.

Hasclid/RFLK-style provers are external proof checkers.  They are useful only
when the statement is actually derived from their kernel rules or explicitly
classified as relying on trusted axioms.

Notes are the mathematical source of truth.  Code artifacts must point back to
the note whose lemma they implement.

## Current default certificate suite

The default suite covers:

- finite Python smoke tests;
- all current Haskell typed certificates;
- the Haskell global proof audit;
- the Raku residue DSL certificate.

The optional suite currently includes the Hasclid Legendre-threshold check.  It
is optional because it uses a separate Cabal project path and can be slower than
the daily certificate loop.

## Trust categories

The manifest uses explicit trust labels:

- `empirical finite check`: exact computation for bounded finite cases;
- `typed finite certificate`: finite data recomputed with typed invariants;
- `typed algebraic certificate`: algebraic lemma encoded in a typed checker;
- `proof-obligation audit`: a machine-readable status ledger;
- `executable certificate DSL`: validated proof objects, not kernel proof;
- `external theorem-prover check`: proof checked by a separate prover.

These labels are conservative.  A certificate passing in the manifest does not
prove Erdős 124 unless the global audit has no open obligations.

## Effect on the current proof route

The architecture does not change the remaining mathematical bottleneck:

\[
c(E)=o(T(E)) \quad\text{or}\quad c(E)=O(T(E)^{1-\epsilon}).
\]

It does make future work harder to silo.  A new conductor lemma should now land
as a note, a typed or DSL implementation, and a manifest entry that runs in the
default suite unless there is a clear reason to mark it optional.
