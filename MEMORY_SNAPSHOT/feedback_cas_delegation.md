---
name: delegate mechanical verification to CAS
description: On the Knuth_124 / Erdős 124 project, reserve human-style reasoning for abstract framing and orchestration; delegate algebraic identity checks, generating-function expansions, numerical bounds, and similar mechanical work to SymPy or another CAS in Python scripts.
type: feedback
originSessionId: 5599ce40-2544-40b3-bf40-5abf9975f171
---
When working on this project:

- Use SymPy (or another Python CAS) for mechanical verification: algebraic
  identities, polynomial expansions, exact rational arithmetic, symbolic
  derivatives, numerical sweeps for sanity checks.
- Reserve in-conversation reasoning and notes for *abstract orchestration*:
  picking the right framing, identifying which disparate areas to engage
  with, isolating exactly which analytic input is needed, mapping how
  hypotheses translate into mathematical conditions.

**Why:** The user explicitly distinguished these layers — "computation
isn't proof, but it can do the mechanical verification while you do the
higher abstract orchestration."  A note that says "here is the algebraic
identity, verified by `scripts/foo.py`" is more honest than a note that
restates the identity in prose: the prose can hide errors, the script
cannot, and the human reasoning that remains is the framing — which is
what should be on display.

**How to apply:**

- Whenever a note states an inequality, identity, or numerical claim, pair
  it with a SymPy / CAS script that mechanically checks it.  Example:
  `notes/47_generating_function_density.md` is paired with
  `scripts/cas_density_check.py`.
- Avoid writing prose proofs of identities a CAS can handle in two lines.
- Avoid using "typed Haskell certificate" as a stand-in for a CAS check
  when the obligation is purely algebraic; Haskell certificates are
  appropriate for proof-tree audits and structural invariants, not for
  symbolic algebra.
- Reserve narrative writing in notes for: the framing question, why a
  particular reduction is the right one, what disparate-area connection
  is being attempted, what analytic input remains and where it comes from.

**Caveat from the same user turn:** computation, including CAS, *is not
proof*.  Use it to verify the bookkeeping, not to claim closure of an
obligation.  Imported analytic theorems (Mignotte–Waldschmidt, S-unit
finiteness, Subspace, characteristic-function bounds) and finite
subset-sum scans should be labelled as such in the audit, not conflated
with derived algebra.
