# Reduction lemmas toward Erdos 124

This note collects general lemmas that are independent of the individual
certificates.  These are the pieces that should eventually become the backbone
of a full proof or a clean counterexample.

## Lemma 1: Monotonicity

Let $A\subseteq A'$ be finite sets of bases, and fix $k\ge1$.  If
$\Sigma(S(A,k))$ is cofinite, then $\Sigma(S(A',k))$ is cofinite.

Proof.  Every representation using powers from $A$ is also a representation
using powers from $A'$.  Adding available summands cannot destroy existing
representations.

## Lemma 2: Reduction to hypothesis-minimal counterexamples

Assume Erdos 124 is false.  Then there is a counterexample $A$ such that every
proper subset $B\subsetneq A$ fails at least one of the two hypotheses:

$$\gcd(B)=1,\qquad \sum_{d\in B}{1\over d-1}\ge1.$$

Proof.  Among all counterexamples, choose $A$ with minimum cardinality.  If a
proper subset $B\subsetneq A$ satisfied both hypotheses, then either $B$
would be a smaller counterexample, contradicting minimality, or $B$ would be
cofinite.  In the latter case, Lemma 1 would imply $A$ is cofinite, again a
contradiction.  Hence every proper subset fails at least one hypothesis.

Thus it is enough to prove the theorem for hypothesis-minimal sets.  Equivalently,
for every $d\in A$,

$$\gcd(A\setminus\{d\})>1
\quad\text{or}\quad
\sum_{a\in A\setminus\{d\}}{1\over a-1}<1.$$

Since deleting more bases only lowers the reciprocal sum and cannot lower a gcd
from $>1$ to $1$ in a way that matters once a one-element deletion already
fails, checking one-element deletions is enough.

## Lemma 3: Interval extension

Let the subset sums of a finite seed contain an interval $[M,M+H]$.  Let
$t_1\le t_2\le\cdots$ be the remaining terms.  If

$$t_{n+1}\le H+1+\sum_{j\le n}t_j$$

for every $n\ge0$, then every integer $N\ge M$ is represented.

Proof.  After adding $t_1,\ldots,t_n$, the represented interval has extended
to

$$[M,M+H+\sum_{j\le n}t_j].$$

The next translate by $t_{n+1}$ begins at $M+t_{n+1}$.  The displayed
inequality says the old interval and the new translate touch or overlap.
Induction gives intervals with endpoints tending to infinity.

## Lemma 4: Frontier invariant

Fix bases $A=\{d_1,\ldots,d_r\}$, exponent $k$, and a frontier

$$E_i=d_i^{e_i},\qquad e_i\ge k.$$

Suppose all powers $d_i^j$, $k\le j<e_i$, have been absorbed into the seed,
and the seed subset sums contain an interval of span $H$.  Define

$$C(E)=\sum_i {E_i\over d_i-1},\qquad K=C(E)-1-H.$$

When the next frontier term $T=E_j$ is added, $H$ increases by $T$, and
$E_j$ changes to $d_jE_j$.  Therefore $C(E)$ also increases by

$${d_jE_j-E_j\over d_j-1}=E_j=T.$$

Hence $K=C(E)-1-H$ is invariant along the tail.

The interval-extension condition at a frontier is equivalent to

$$C(E)-T\ge K,\qquad T=\min_iE_i.$$

## Corollary 5: Strict-tail takeover

Let

$$R=\sum_i {1\over d_i-1}.$$

If $R>1$, then

$$C(E)-T
=\sum_i {E_i\over d_i-1}-T
\ge T(R-1).$$

Therefore, once the tail reaches a frontier with

$$T(R-1)\ge K,$$

all future interval-extension inequalities hold automatically.

This does not by itself prove the full strict case; one still has to produce a
seed interval and bridge the finite pre-takeover frontiers.  It does prove that
the strict case has only a finite tail obstruction after any seed interval.

## Corollary 6: Exact-critical near-collision obstruction

Assume the exact-critical condition $R=1$.  Clear denominators by setting

$$D=\operatorname{lcm}_i(d_i-1),\qquad w_i={D\over d_i-1}.$$

Let

$$B=DK.$$

If interval extension fails at a frontier, then

$$\sum_i w_i(E_i-T)<B,\qquad T=\min_iE_i.$$

Consequently, for every pair $i,j$,

$$|E_i-E_j|
\le (E_i-T)+(E_j-T)
< B\left({1\over w_i}+{1\over w_j}\right).$$

Thus exact-critical failure forces simultaneous near-collisions among powers of
the bases.  This is the main bridge from the additive problem to Diophantine
approximation.

## Corollary 7: Why the $\{3,4,\cdots\}$ cases are tractable

If an exact-critical set contains bases $3$ and $4$, and the obstruction
bound $B$ satisfies

$$B\left({1\over w_3}+{1\over w_4}\right)\le B',$$

then a tail failure implies

$$|3^a-4^b|<B'.$$

Continued fractions for $\log3/\log4$, plus an explicit lower bound such as
Mignotte-Waldschmidt, can then turn the infinite tail into a finite list of
near-collision candidates.

