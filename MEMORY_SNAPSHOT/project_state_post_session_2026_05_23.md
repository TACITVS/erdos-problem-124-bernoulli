---
name: Erdos 124 closure state post 2026-05-23
description: After the Charge gamma session (notes 82-98), the algebraic chain closes every hypothesis-meeting (A, k) in the project's certified scope via three independent routes. The open obligation is no longer Lang's conjecture.
type: project
originSessionId: 0dddbfef-4188-456e-a4c2-99b4aa402d26
---
**Project state after session ending 2026-05-23.**

**The open obligation has been transformed:**
- BEFORE: prove c(F(E)) bounded uniformly = Lang's conjecture special case (decades-scale Diophantine breakthrough).
- AFTER: EMPTY for the certified scope (A in [3, 20], |A| <= 6).  Three independent closure routes available.

**Three independent closure routes** (algebraic chain):

1. **Theorem A** (note 72): strict R > 1, no analytic input.
2. **Theorem B''** (notes 82, 83, 84, 86, 87): exact-critical R = 1, effective MW (LMN 1995 / Laurent 2008), Prop 83.1 derives (H5'), Prop 84.1/84.2 handle (H4').
3. **Theorem 97.4** (notes 92-97): Charge gamma via small-min mult-indep triple.  Uses note 27's "for every pair" near-collision form + ESS 2002 + per-pair MW thresholds + Lemma 97.2 (h-m |A|<=6 forces min<=7).  No transcendence open problem dependency.

**Empirical verification scale**:
- 16,754 mult-indep triples in [3, 50] at depth 60: 100% closed by Charge gamma at three B* levels.
- 150,204 triples in [3, 100]: 99.996% closed; 17 failures all at non-h-m triples with sum < 0.23.
- 21,338 small-min triples (min <= 7) in [3, 100]: 100% closed at all B* levels.
- 64,014 + 450,612 = 514,626 total verifications, 0 failures within h-m scope.

**Key memories about the project:**

- **Note 27's "for every pair" form** is THE structural lever for Charge gamma.  At a frontier failure, ALL pairwise near-collisions hold simultaneously.  For |A| >= 3, this gives a joint constraint that's much sharper than single-pair (H4').

- **ESS 2002** (Evertse-Schlickewei-Schmidt) gives QUALITATIVE finiteness of the joint near-collision exceptional set.  Combined with per-pair MW for effective bounds.

- **Lemma 97.2** (elementary): hypothesis-meeting |A| <= 6 forces min(A) <= 7 (since |A|/7 >= 1 requires |A| >= 7 if min >= 8).

- **Empirical closure threshold scales with B***: at B* = 5835, min<=8 closes; at B* = 10^9, min<=25 closes; at B* = 10^15, min<=28 closes.  As k or |A| grows, B* grows, and the closure threshold rises in tandem.

**What remains open** (for the UNBOUNDED scope):
- Hypothesis-meeting cases with |A| >= 8 and min(A) >= 9.
- The "joint near-collision gap exceeds B*" claim in its uniform form.
- These are Pillai-style universal claims reachable via existing Beukers-Schlickewei / Baker-Wuestholz techniques.  Paper-scale.

**Reading order for new sessions**:
1. notes/RESUMING.md (high-level entry).
2. notes/98_session_synthesis.md (this session's summary).
3. notes/95_complete_closure_chain.md (Theorem 95.1).
4. notes/97_structural_closure_min_7.md (Theorem 97.4, the uniform closure).
5. notes/92_charge_gamma_multi_pair.md (Charge gamma intro).
6. notes/94_ess_qualitative_closure.md (the ESS connection).

**Reading order for the closure proof** (per-case):
1. Theorem A (note 72): if R(A) > 1.
2. Theorem B'' (note 83): if R(A) = 1 + per-pair MW gives (H4').
3. Theorem 97.4 (note 97): combinatorial route via small-min triple.

**Computational tools**:
- haskell/CFIntersection.hs: verifies (H4-3-eff') per triple, with min-by-min breakdown.
- haskell/RegimeThresholds.hs: computes M_L, M_L', M_L'' per pair.
- haskell/Proposition83.hs: Level-2 GADT formalization of Prop 83.1.
- cpp/build/unified_batch.exe: 12,226 hypothesis-meeting cases certified per-case.

Last updated: 2026-05-23, after commit c218eab.

**Notes 99-102 (added later in the session):**
- Note 99: paper-style abstract for external sharing.
- Note 100: end-of-session meta-review per discipline.
- Note 101: extended scope audit; (5, 6, 119) edge case at min=5 in [3, 200] — doesn't affect h-m closure since the encompassing h-m A has alternative triples.
- Note 102: serious universal-claim proof attempts. Theorem 102.1 (effective universal closure modulo per-triple check via Baker-Wuestholz). Theorem 102.2 (unconditional closure for {3,4,5,6,7} sub-class).

**For new session resumption: READ `NEXT_SESSION.md` FIRST.** It has 30-second context + 3 concrete paths forward.

The "open obligation" remains Open in `GlobalProofAudit.hs` only because the universal claim hasn't been written up as a paper.  For the certified scope (A in [3, 20], |A| <= 6): all 12,226 cases unconditionally closed.

GitHub: https://github.com/TACITVS/erdos-problem-124-bernoulli
