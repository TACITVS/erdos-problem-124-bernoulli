---
name: Clean algebraic proofs, not more certificates
description: For this project, deliver clean algebraic theorems with pen-and-paper proofs as the primary artifact; do not propose "let's compute more cases" as the main next step.
type: feedback
originSessionId: 0dddbfef-4188-456e-a4c2-99b4aa402d26
---
The user has explicitly pushed back when offered "extend the library to produce
more certificates / more verifications" as a next step.  Their words:

> "Yes, but we need clean algebraic proofs not more certificates"

**Why:** The project already has 12,226 computational certificates and four
specific MW-based unconditional cases.  Per `RESEARCH_JOURNAL.md` §4
lesson #3, "calling computational verification 'proof'" is one of the
project's named anti-patterns.  Adding certificates without algebraic
content does not move the central open obligation (the global
power-saving central conductor theorem) — it just shifts numbers.

**How to apply:**
- When the user picks a direction, default to producing a **note** (in
  `notes/`) containing a precisely-stated theorem and a complete
  pen-and-paper proof, using only previously-certified project lemmas +
  named imported analytic theorems.
- C++ library extensions / Haskell certificates are appropriate only as
  *companions* to an algebraic theorem (hypothesis checks for specific
  instances), not as the deliverable themselves.
- If a direction can only produce certificates, flag that honestly
  before starting and suggest an alternative direction that has
  algebraic content.
- Theorems A, B (note 72), C, Prop D (note 73), E, F (notes 76, 77) are
  the existing style: theorem statement, complete proof using only
  named project lemmas + imported theorems, no "by computation".
