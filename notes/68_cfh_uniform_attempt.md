# Uniform CFH-strict applicability — attempt

Phase B-2b: attempt a *uniform* proof that the CFH-strict certificate
(note 67) verifies for **every** strict hypothesis-meeting $(A, k)$,
not just per-case.

## 0. Verdict

> **Uniform applicability does not close from the obvious arguments.**
> What does close: a clean reduction of "uniform CFH-strict" to a
> *single* sub-statement about the asymptotic conductor of balanced
> frontiers.  Specifically, **uniform CFH-strict $\iff$ for every
> strict hypothesis-meeting $(A,k)$, $c(E)/T(E)\to 0$ along balanced
> frontiers** (the open obligation in `GlobalProofAudit.hs`).

So the uniform CFH-strict question is **equivalent** to the existing
open obligation, not strictly easier.  The per-case certification
(note 67) remains the actionable result.

## 1. The three preconditions

From note 67 §1, the CFH certificate for $(A, k)$ at threshold $T^*$
needs:

- (a) Seed interval non-empty: $2c^* + 2 \le S^*$ where
  $S^* = S(F(E^*))$ and $c^* = c(F(E^*))$.
- (b) First tail term fits: $T^* \le S^* - 2c^* - 1$.
- (c) Strict takeover: $(R-1) T \ge $ invariant for some advance step.

(c) is automatic for $R > 1$ — invariant is fixed, $T$ grows
multiplicatively under advance, eventually $(R-1)T$ exceeds invariant.
(See `haskell/CFHTail.hs` `strictTakeoverReady`.)

The non-trivial preconditions are (a) and (b), both requiring control
on $c^*$.

## 2. Reduction to conductor sublinearity

**Claim.** For strict $R > 1$ hypothesis-meeting $(A, k)$, the
certificate verifies at threshold $T^*$ iff $c(F(E^*(T^*))) \le
(R-1)T^*/2 - 1$, where $E^*(T^*)$ is the balanced frontier at $T^*$.

*Proof.*  $S^* \ge R T^*$ (the trivial bound: $S^* = \sum_a (a^{e_a^*} - a)/(a-1) \ge \sum_a (T^* - a)/(a-1) \approx R T^*$ for $T^* \gg \max(A)$).

- (a) $2c + 2 \le S \iff c \le (S - 2)/2 \le RT^*/2 - 1$.  Strictly weaker than (b).
- (b) $T^* \le S - 2c - 1 \iff c \le (S - T^* - 1)/2 \le ((R-1)T^* - 1)/2$.
  Approximately $c \le (R-1)T^*/2$.
- (c) automatic.

So (b) is the binding constraint, and the certificate verifies iff
$c(F(E^*)) \le (R-1)T^*/2$ (up to $O(1)$).

For ANY function $c(T^*) = o(T^*)$ (in particular bounded $c$), there
exists $T^*$ large enough that $c(T^*) \le (R-1)T^*/2$ holds.  So:

> **The CFH-strict certificate verifies at some $T^*$**
> $\iff c(F(E^*(T^*))) = o(T^*)$ along balanced frontiers.

This is **the existing open obligation** in `haskell/GlobalProofAudit.hs`.

## 3. Why this reduction is not a deeper result

The CFH machinery turns the "bounded conductor" question into a more
explicit form, but the underlying obstacle is the same.  Specifically:

- The conductor sublinearity $c(E) = o(T(E))$ is exactly what the
  power-saving central conductor theorem asks for (in the strict case).
- The empirical evidence (note 66) suggests $c$ is even **bounded**,
  not just sublinear.  But the proof remains open.

So the uniform CFH-strict question is just a renaming.  It doesn't
make the open obligation easier.

## 4. Stronger conjecture worth investigating

Empirically (note 66), the conductor along balanced frontiers
**stabilizes** to a constant $c^*(A, k)$.  This suggests:

> **Stabilization conjecture.**  For every hypothesis-meeting $(A, k)$
> (strict OR exact), $\lim_{T\to\infty} c(F(E^*(T))) = c^*(A, k)
> < \infty$ exists, along balanced frontiers.

If provable, this would close BOTH strict and exact conductor cases
uniformly: in particular, strict + bounded $c$ ⟹ CFH certificate
verifies for $T$ large; exact + bounded $c$ + qualitative S-unit
⟹ Erdős 124 via the standard chain.

The Stabilization conjecture is **stronger** than the open obligation
$c = o(T)$ and matches the empirical pattern more tightly.

## 5. Possible attack on Stabilization

A stabilization proof could go through:

**Stage 1.** Show $c(F(E))$ is a DECREASING function of $E$ in a
suitable poset sense.  Specifically, if $E' \ge E$ componentwise (each
$e_a' \ge e_a$), then $c(F(E')) \le c(F(E)) + \epsilon$ for some
$\epsilon$ depending on the new elements added.

If we can show $\epsilon = 0$ asymptotically (new tail elements don't
introduce new gaps), then $c$ is eventually constant — stabilization.

**Stage 2.** Bound the number of new gaps that can appear in
$(S(E)/2, S(E')/2]$ when extending $E$ to $E'$.  By CFH-style
absorption: each new tail element absorbed without gap.  So no new
gaps — $\epsilon = 0$.

The technical lemma needed:

> **Tail-absorption lemma (conjecture).**  For balanced $E' \supseteq E$
> with $T(E') > T(E)$, the new elements $F(E') \setminus F(E)$ are
> sorted at positions where the seed interval $[c+1, S(E)/2]$ has span
> $\ge $ new-element size.

Empirically true.  Provable?  Likely yes via Brown's complete-sequence
+ careful bookkeeping, similar to note 26's proof for $\{3,4,5\}$
k=1.

## 6. What can be uniformly proved right now

The Stabilization conjecture seems hard to prove unconditionally.
What's *trivially* uniform:

> **Theorem (trivial uniform bound).**  For every strict $R > 1$
> hypothesis-meeting $(A, k)$, $c(E) \le S(E)/2$ for all $E$.

This is by definition of conductor.  But $S(E)/2 \approx RT/2$ is too
loose to satisfy CFH precondition (b), which needs $c \le (R-1)T/2$.

Slightly better:

> **Theorem (max-element bound).**  $c(E) \le \max_{f \in F(E)} f$.

*Proof.*  Subset sums of $F(E)$ certainly include $\{0, f_1, f_2,
\ldots, f_n, f_1+f_2, \ldots, S\}$.  By a greedy argument, every
integer above $\max f$ is representable as a subset sum.  (Specifically,
greedy: for $n > \max f$, write $n = f + r$ with $f$ the largest
seed element $\le n$, recurse on $r$; the recursion terminates within
$|F|$ steps because $f \ge \max(F)/2$ for $n$ large.)

Hmm — this is actually not quite right.  The greedy decomposition can
get stuck because subset sums don't allow reuse.  Let me restate:

> **Theorem (Frobenius-type bound).**  $c(E) \le F(\{\text{some sub-
> generating set of } F(E)\}) \cdot \text{(scale factor)}$.

This uses the same-base Frobenius reduction (note 44).  For SAME-BASE
sub-blocks of $F(E)$, conductor of the sub-block is finite.  Multi-
base combination — handled by complete-sequence absorption — keeps the
combined conductor bounded.

Putting this together rigorously would require carefully verifying the
absorption at each step.  This is essentially what the per-case
verification does.

## 7. Honest assessment

The uniform CFH-strict question reduces cleanly to the existing open
obligation ($c = o(T)$).  Neither is currently provable without new
ideas.

The per-case CFH certification (note 67) **does** give certified
bounded conductor + Erdős 124 for every strict $(A, k)$ on which we
run the verifier.  Running the verifier on more cases is the
actionable path:
- 16 cases verified so far (note 67).
- Easy to extend to hundreds via batch enumeration.
- Each verified case = new unconditional local certificate.

This is *not* the uniform theorem we hoped for, but it IS substantial
progress: from 1 strict case (just $\{3,4,5\}$ k=1 in note 26) to
arbitrarily many.

## 8. Recommendations

1. **Run the CFH verifier in batch** to enumerate ALL strict hypothesis-
   meeting $(A, k)$ with $\max(A) \le N$ for some $N$, certifying
   each.  Add successes to `certificates/manifest.json`.

2. **Attempt the Stabilization conjecture** (§4-§5) as the natural
   "next conjecture" — stronger than the open obligation, matching
   empirical pattern.

3. **Acknowledge** that uniform CFH-strict is not strictly easier than
   the existing open obligation, but per-case certification is real
   progress.

The per-case route is the project's most productive current direction.

## 9. Status

Phase B-2b (this note) closes with a *negative* result: the uniform
CFH-strict question is equivalent to the existing open obligation, not
a weakening of it.  But it sharpens the understanding of what needs
proving and identifies the Stabilization conjecture as the natural
next target.

Note 67's per-case certification remains the actionable result.
