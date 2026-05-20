# Strategy revision

This note records a candid mid-program reassessment.  It is meant to keep the
project honest about what the current architecture proves, what it does not,
and where the remaining work actually lives.

It supersedes the framing in the README and
`erdos_124_researcher_handout_current_state.md` that implicitly treats the
modular conductor bridge as the main route to closure.

## What the current architecture actually proves

Genuine reductions and certified facts:

- finite-seed local certificates for $\{3,4,7\},k=2$, $\{3,4,7\},k=3$,
  $\{3,4,9,25\},k=2$ (computer-assisted, not closed-form);
- the tail invariant identity in pure-power and scaled forms
  (notes 28, 43);
- complete-sequence absorption and its single-progression count
  (notes 36, 42);
- the residue-frame / unit-frame construction and modular conductor lift
  (notes 29, 30, 33);
- the asymptotic half-sum reach threshold (note 39);
- the quotient reciprocal-sum identity (note 40);
- the modulus search reduction (note 41);
- the same-base Frobenius reduction (note 44);
- the strict and S-unit conditional tail engines (notes 26, 27 plus
  `CFHTail.hs`).

These are real algebraic and combinatorial theorems with typed certificates.

## What the architecture does not prove

- The **power-saving central conductor theorem** in
  `notes/28_power_saving_central_interval_target.md` remains Open.  Every
  recent advance is *infrastructure around* this open obligation; none has
  closed any portion of it.
- The **global exact-critical analytic bound** is Imported via S-unit /
  Subspace theorem inputs.  No effective version has been produced.
- The local certificates are computer-assisted exact verifications, not
  closed-form proofs.  They do not generalize.

## The bridge limitation

`notes/40_quotient_reciprocal_sum.md` proved a quiet but important fact:

> For every local hypothesis-minimal exact-critical and strict set
> ($\{3,4,7\}$, $\{3,4,9,25\}$, $\{3,4,5\}$, $\{3,5,7,13\}$,
> $\{3,6,9,12,21,45,89\}$), the modular conductor bridge is in the
> **deficit one-shot** regime at every nontrivial modulus.

A deficit one-shot bridge can transfer a quotient conductor bound to an
ordinary conductor bound, but it cannot recursively reduce the conductor
problem on $A$ to the same conductor problem on a strictly smaller base
set.  The bridge does not chain.

Consequence: the bridge route cannot, by itself, close the conductor problem
for any of these sets.  It is a one-shot translator, not a recursion engine.

This was not the original framing.  Earlier notes (33–38) and the
`GlobalProofAudit.hs` description implicitly treat the bridge as a route to
closure.  That framing is misleading after note 40 and should be retired.

## What the bridge is still good for

- Transferring a quotient conductor obtained by independent means (direct
  scan, Frobenius reduction, density argument) into an ordinary conductor
  bound, with the explicit $m(c'+1)+R-1$ formula.
- The half-sum reach lemma in note 39 makes the bridge's "reach" side a pure
  algebraic threshold.
- The modulus search in note 41 enumerates the finite candidate space.

In short: the bridge is a *plumbing* layer.  The *production* layer
underneath it — actually producing a quotient conductor — is the open work,
and the bridge does not constrain that work to be easier than the original
problem.

## What the open mathematics actually requires

Two genuinely open mathematical inputs:

1. **Mixed-base scaled middle-interval bound.**  The same-base case is
   handled by Frobenius (note 44).  The mixed-base case is the actual core.
   The single-progression absorption count (note 42) gives the per-round
   budget; iterating across distinct progressions while preserving the
   tail invariant remains open.

2. **Effective analytic bound for arbitrary independent base pairs.**  The
   local $\{3,4,7\}$ certificate uses Mignotte-Waldschmidt for
   $\log 3/\log 4$.  An effective theorem for arbitrary pairs would be
   needed to globalize this.  The Subspace-Theorem strengthening is
   non-effective and only suffices for *some*-frontier-sequence existence,
   not effective conductors.

These are the actual remaining mathematics.  The boss tree's open nodes
(`scaled-power-middle-interval`, `quotient-block-selection`,
`strict-conductor`, `exact-conductor`, `erdos-124`) all depend on these two
inputs.

## Strategy revision

Stop investing in further bridge infrastructure.  Concrete redirections:

### (a) Engage with the literature directly

`notes/22_bibliography.md` lists Burr-Erdős-Graham-Li 1996, Melfi,
Chen-Fang-Hegyvari, Sárközy.  These sources have been treated as
*references* rather than as *technique sources*.  The next step is to
extract:

- Sárközy-style density / Plünnecke-Ruzsa bounds for subset sums of integer
  power sequences;
- the exact form of BEGL's interval-growth lemmas to see which generalize
  beyond their local cases;
- Schinzel-Tijdeman and Mihailescu-style direct bounds for $|x^p-y^q|$
  that could replace the Mignotte-Waldschmidt input in the exact-critical
  near-collision step.

### (b) Closed-form test case

Try to prove $c(\{3,4,7\},k=1)\le 581$ from first principles.  The
finite-seed scan already certifies the value; the question is whether a
*closed-form* proof exists.  Either we find one (giving a template) or we
identify the precise missing ingredient.

This is a single small experiment.  Its success or failure is more
informative than another building-block note.

### (c) Reconsider the conductor target

Empirically the conductor grows much more slowly than
$O(T^{1-\epsilon})$; the data is closer to $O(\operatorname{polylog} T)$
or even $O(1)$ along the natural frontier sequence.  Aiming for a
stronger bound might force cleaner additive structure and make the proof
easier rather than harder.

Conversely, the qualitative goal of "some sequence of frontiers with
$c=o(T)$" (existential rather than universal) suffices for the
Subspace-Theorem tail engine and might be reachable by an averaging or
density argument that the current architecture does not attempt.

### (d) Accept partial / weaker results as targets

If full Erdős 124 closure is out of reach, partial publishable results
include:

- explicit conductors for all hypothesis-minimal sets with maximum base up
  to some explicit bound;
- the qualitative tail-extension theorem assuming a black-box conductor
  bound;
- a unified framework note that itself is a contribution.

These would already be more than the current architecture *proves*, even if
none of them is Erdős 124.

## Audit-side adjustments

Concrete changes to make next session, when not under "produce visible
forward motion" pressure:

- `GlobalProofAudit.hs`: weaken the "modular bridge" obligations from
  Certified to a clearly conditional note ("conditional on producing a
  quotient conductor bound by other means").
- `ConductorBossTree.hs`: split `quotient-block-selection` into
  `bridge-plumbing` (Done) and `bridge-production` (Open) to make the
  one-shot character explicit.
- `README.md` and the researcher handout: add a sentence at the top that
  this is a near-proof framework whose central asymptotic engine is not
  proved.

## Process change

After every working session on this project, run a short meta-review with
the questions:

> Are we on the right track?  Are our methods the best available?  Can we do
> better?  Would I change anything?

The reviewing is the unblocker.  Without it, a long session naturally biases
toward producing visible commits (infrastructure, audits, tree edits) at the
expense of contact with the central open mathematics.  This session is a
documented example of that bias.

## Status

No certificate has been retracted.  Every Certified fact in the boss tree
and audit remains independently checked.  This note only revises the
*framing* and *strategic priorities* of the next sessions.
