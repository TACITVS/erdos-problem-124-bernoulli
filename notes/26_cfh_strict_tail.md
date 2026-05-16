# Chen-Fang-Hegyvari strict tail certificate

This note turns one prefix-gap capacity row into an actual proof.

## CFH tail condition

Let \(B=\{b_1\le b_2\le\cdots\}\) be the remaining ordered tail after a finite
seed and finite prefix have been removed.  Chen-Fang-Hegyvari Lemma 2.1 with
\(n_0=1\) says that if

\[
b_n\le b_1+\cdots+b_{n-1}+b_1\quad(n\ge1),
\]

then \(P(B)\) has consecutive gaps bounded by \(b_1\).

For a pure-power frontier \(E_i=d_i^{e_i}\), define

\[
C(E)=\sum_i {E_i\over d_i-1}.
\]

As the sorted tail is consumed, \(C(E)\) increases by exactly the consumed term.
If \(C_0\) is the initial value and \(G=b_1\), the CFH condition at a frontier
is equivalent to

\[
C(E)-T\ge C_0-G,\qquad T=\min_i E_i.
\]

The right side is invariant along the tail.

## Strict takeover

If

\[
R=\sum_i {1\over d_i-1}>1,
\]

then \(E_i\ge T\) gives

\[
C(E)-T\ge (R-1)T.
\]

Therefore once

\[
(R-1)T\ge C_0-G,
\]

the CFH condition holds forever, because future minimum frontier terms are
nondecreasing.

## Certified local row

For \(\{3,4,5\}, k=1\), the finite seed interval is \([80,2132]\).  Absorbing
the first tail term \(1024\) extends it to \([80,3156]\).  The remaining tail
frontier is

\[
(3^7,4^6,5^5)=(2187,4096,3125),
\]

so \(G=2187\).  The prefix-gap bridge can absorb this gap because

\[
2187\le 3156-80+1.
\]

The Haskell checker verifies the CFH condition directly for the four
pre-takeover frontiers and then verifies the strict takeover inequality at the
fifth row.  Combining this with the prefix-gap bridge proves again that every
integer \(n\ge80\) is represented by distinct powers from \(\{3,4,5\}\) with
exponent at least \(1\).

This is not a new global theorem, but it is a clean literature-aligned proof of
the strict local sample.  It also isolates exactly what is missing in the
exact-critical cases: a no-failure theorem replacing strict slack.
