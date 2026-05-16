# Residue-bridge profiles

The seed-bridge theorem still needs interval information.  This pass separates
one strictly weaker obstruction that any quotient-style bridge proof must
defeat: residues modulo the exact-critical denominator.

For an exact-critical base set \(A\), let

\[
D=\operatorname{lcm}_{d\in A}(d-1).
\]

The same \(D\) clears the reciprocal-sum equation

\[
\sum_{d\in A}{1\over d-1}=1.
\]

Given a finite seed \(S\), say that \(S\) is residue-complete modulo \(D\) if
the subset sums of \(S\) meet every residue class modulo \(D\).

## Lemma: bounded residue bridge

Let \(S,T\) be disjoint finite or infinite sets of nonnegative integers, and
let \(m\ge1\).  Suppose that for every residue \(r\bmod m\) there is a subset
sum \(s_r\in\Sigma(S)\) with

\[
s_r\equiv r\pmod m.
\]

Let

\[
R=\max_r s_r.
\]

If \(\Sigma(T)\) contains every sufficiently large multiple of \(m\), say every
multiple \(M\ge M_0\), then \(\Sigma(S)+\Sigma(T)\) contains every integer
\(N\ge M_0+R\).

Proof.  Choose \(r\equiv N\pmod m\).  Then \(N-s_r\) is a multiple of \(m\),
and \(N-s_r\ge M_0\).  Hence \(N-s_r\in\Sigma(T)\), and
\(N=s_r+(N-s_r)\).

This lemma does not prove the seed-bridge theorem.  It isolates a modular
piece: once a separate argument produces a tail theorem for large multiples of
the denominator, the residue-complete seed removes all congruence obstructions
with an explicit additive loss \(R\).

## Checked profiles

The shared library `scripts/finite_seed.py` computes residue completeness and
the least representative sum for each residue; `scripts/residue_bridge.py` is
only the command-line frontend.  The Haskell checker
`haskell/ResidueBridgeProfiles.hs` independently recomputes the same finite
facts using a base-only integer bitset and verifies that the modulus is exactly
the exact-critical denominator.

For the fourteen exact-critical sets with maximum base at most \(30\) and size
at most \(5\):

- at \(k=1\), seed limit \(1000\), every set is residue-complete modulo \(D\);
- at \(k=2\), seed limit \(4000\), every set is residue-complete modulo \(D\).

Representative examples:

- \(\{3,4,7\}, k=1\): \(D=6\), first completion after the term \(7\), and
  \(R=14\);
- \(\{3,4,7\}, k=2\): \(D=6\), first completion after the term \(49\), and
  \(R=74\);
- \(\{3,4,9,25\}, k=1\): \(D=24\), first completion after the term \(25\), and
  \(R=59\);
- \(\{3,4,9,25\}, k=2\): \(D=24\), first completion after the term \(243\),
  and \(R=359\).

The next real proof task is to replace the missing tail-multiple hypothesis in
the lemma by a theorem about powers past the seed frontier, or else to show
that such a tail-multiple theorem is false.
