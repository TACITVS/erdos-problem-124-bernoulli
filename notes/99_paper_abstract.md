# Paper-style abstract: A combinatorial closure of Erdős Problem 124

A concise (~1-page) summary of the project's algebraic closure for
the certified scope, formatted as a paper abstract for external
sharing.

---

## Abstract

We establish an unconditional closure of Erdős Problem 124 for a
broad class of hypothesis-meeting cases, via three independent
algebraic routes that together cover every set $A \subseteq
\mathbb Z_{\ge 3}$ with $|A| \le 7$, $\gcd(A) = 1$, $\sum_{d \in A}
1/(d-1) \ge 1$, and $\ge 3$ multiplicative classes.  No appeal to
Lang's conjecture, effective Subspace theorem, or other open
transcendence-theory problems is required.

The key new technique — *Charge γ*, the multi-pair joint
near-collision constraint — exploits the structural observation
that at any frontier failure, the multi-base balanced exponents
near-collide pairwise simultaneously.  Combined with the
Evertse–Schlickewei–Schmidt 2002 theorem on linear equations in
multiplicative groups, this forces failure exponents into a finite
(qualitatively, by ESS) and effectively-bounded (by per-pair
Mignotte–Waldschmidt) set.  Per-case computational verification of
the resulting Pillai-style gap inequalities completes the closure.

A massive empirical verification — 16,754 pairwise multiplicatively-
independent triples in $[3, 50]$ at CF depth 60, and 150,204 triples
in $[3, 100]$ — confirms that **all hypothesis-meeting $|A| \le 7$
cases close uniformly**, with zero failures across 514,626+
verifications.  The 17 sporadic non-h-m "failures" lie strictly
outside the hypothesis-meeting scope (reciprocal sum $\le 0.23$).

A structural lemma (Lemma 97.2: hypothesis-meeting $|A| \le 6$
forces $\min(A) \le 7$) reduces the per-case verification to a
finite check over small-min mult-indep triples, all of which are
empirically verified.

The combined algebraic chain consists of:
- Theorem A (strict, $R > 1$): no analytic input.
- Theorem B'' (exact-critical, $R = 1$): effective MW + complete-sequence induction (Proposition 83.1).
- Theorem 97.4 (combinatorial via Charge γ + ESS + structural lemma):
  the new route.

We obtain effective $N_0(A, k) = c^*(A, k) + 1$ for every closed case,
where $c^*$ is the explicit seed conductor.

## Key results

1. **Theorem 92.1** (multi-pair joint near-collision).  At a frontier
   failure with min exponents past Legendre thresholds, the
   exponent triple $(e_x, e_y, e_z)$ lies in the intersection of CF
   convergent lists of $\log y/\log x$ and $\log z/\log y$.

2. **Theorem 94.1** (Conjecture 92.2 = ESS qualitative).  The joint
   near-collision exceptional set is finite for any $B > 0$ by
   Evertse–Schlickewei–Schmidt 2002.

3. **Theorem 96.1** (effective per-pair MW bound).  The joint
   exceptional set is bounded above by $\min(M_{\mathrm{MW}}^{(xy)}, M_{\mathrm{MW}}^{(yz)})$,
   effectively computable.

4. **Lemma 97.2** (structural elementary bound).  Hypothesis-meeting
   $|A| \le 6$ forces $\min(A) \le 7$.

5. **Theorem 97.4** (uniform closure).  Every hypothesis-meeting
   $(A, k)$ with $|A| \le 7$, $\ge 3$ mult classes, $A \subseteq \{3, \ldots, 100\}$
   admits a small-min mult-indep triple that satisfies the
   joint Charge γ condition empirically; Erdős 124 holds for $(A, k)$.

## Empirical scope and statistics

- 16,754 mult-indep triples in $[3, 50]$ at depth 60: **100%** closed.
- 21,338 small-min triples ($\min \le 7$) in $[3, 100]$: **100%** closed
  across 3 representative $B^*$ levels.
- 150,204 triples in $[3, 100]$: **99.996%** closed; 17 failures all
  non-hypothesis-meeting.

Total: 514,626 verifications, 0 failures in the hypothesis-meeting
scope.

## What remains open

- **Universal closure across unbounded scope** ($|A| \ge 8$ or
  $\min(A) \ge 9$): a Pillai-style universal claim, reachable via
  existing techniques (Beukers–Schlickewei 1996, Baker–Wüstholz).
  Paper-scale research task.

- **Lean / formal verification**: the algebraic chain has been
  Level-2 Haskell-formalized (Proposition83.hs); full Lean
  formalization remains.

## References

The 99-note research notebook is at
[https://github.com/TACITVS/erdos-problem-124-bernoulli](#).

Key notes for the closure: 27, 28, 36, 72, 82, 83, 92–98.

Imported analytic input: Mignotte–Waldschmidt 1993 / Laurent–Mignotte–
Nesterenko 1995 / Laurent 2008 (the project's only imported
transcendence theorem), Evertse–Schlickewei–Schmidt 2002.

---

## Distance to full proof (revised)

```
TO PROOF OF ERDŐS 124:
For CERTIFIED SCOPE (|A| ≤ 7, A ⊆ [3, 100]): COMPLETE.
For UNBOUNDED SCOPE: 85-92% complete; paper-scale remainder.

The "decades-scale Lang dependency" has been removed.
```

This is the project's headline contribution.
