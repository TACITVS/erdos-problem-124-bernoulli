# Interval-certificate criterion

This is a finite certificate criterion used by the scripts.

Let $S$ be an infinite sequence of positive integers and let $F\subset S$
be a finite set of already selected seed terms.  Suppose the subset sums of
$F$ contain a full interval

$$[M,M+H].$$

Let $t_1\le t_2\le\cdots$ be the remaining terms of $S\setminus F$.  If,
for each $n\ge 0$,

$$t_{n+1}\le H+1+\sum_{m\le n}t_m,$$

then the subset sums of $S$ contain all integers in the infinite ray
$[M,\infty)$.

Proof: after adding $t_1,\ldots,t_n$, the interval has extended to
$[M,M+H+\sum_{m\le n}t_m]$.  The next translate by $t_{n+1}$ starts at
$M+t_{n+1}$, so the two intervals touch or overlap exactly when the displayed
inequality holds.

## Consequence for strict reciprocal sum

When $S=S(A,k)$ and $R=\sum_{d\in A}1/(d-1)>1$, the frontier prefix sum
grows at least like $RT-C$, where $T$ is the next unused power and $C$ is
a fixed constant depending on $A,k$ and the seed frontier.  Hence any fixed
seed interval is eventually enough.  A finite computation only has to cover the
pre-asymptotic frontiers.

The critical case $R=1$ is different: the same estimate leaves a fixed
deficit, and the actual maximum deficit depends on the distribution of powers
of different bases.  That is where deep Diophantine approximation enters in
the Burr-Erdos-Graham-Li proof for $\{3,4,7\}$.

