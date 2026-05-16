# Strategy after the first reduction

The project should keep two possibilities alive:

1. Prove the conjectured cofiniteness.
2. Find a genuine infinite obstruction.

The computations so far favor proof, but they do not rule out a counterexample.

## Proof route

The strict reciprocal-sum case has a finite interval certificate plus eventual
linear slack.  The exact-critical case is the real problem.

For exact-critical sets, once a finite central interval is known, the infinite
tail is controlled by the invariant

\[
K=C(E)-1-H,
\]

where \(E_i\) are the first unused powers, \(H\) is the interval span, and
\(C(E)=\sum_iE_i/(d_i-1)\).  The tail extends whenever

\[
C(E)-\min_i E_i\ge K.
\]

For \(\{3,4,7\}\), after clearing denominators this is one of the following
near-collision exclusions, depending on which frontier power is smallest:

\[
-3\cdot 3^a+2\cdot 4^b+7^c\ge 6K,
\]

\[
3\cdot 3^a-4\cdot 4^b+7^c\ge 6K,
\]

\[
3\cdot 3^a+2\cdot 4^b-5\cdot 7^c\ge 6K.
\]

The next mathematical target is a lower bound for these expressions over all
future frontier states.  Plausible tools:

- modular sieving to remove exact or very small near-collisions;
- continued fractions for pairwise logarithm ratios;
- LLL/PSLQ searches for suspicious linear forms in logs;
- explicit lower bounds for linear forms in logarithms if a fully rigorous
  global bound is needed.

## Disproof route

A counterexample would likely come from one of:

- a persistent modular obstruction;
- an infinite family of dangerous frontier states where the interval cannot
  cross the next power;
- a sparse exact-critical family with worse spacing than the small examples.

The current finite searches have not found this behavior.  The next disproof
search should therefore focus on residues and frontier recurrences, not just
larger subset-sum limits.

