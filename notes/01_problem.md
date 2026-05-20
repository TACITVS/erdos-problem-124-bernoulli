# Problem 124 notes

## Definitions

For a finite set $A=\{d_1,\ldots,d_r\}$ and an integer $k\ge 0$, define

$$S(A,k)=\{d_i^j: 1\le i\le r,\ j\ge k\},$$

counting equal values from different bases as separate available summands.
The subset-sum set $\Sigma(S(A,k))$ consists of all finite sums of distinct
terms from this multiset.

The hard Erdos-124 form is:

> If $d_i\ge 3$, $\gcd(d_1,\ldots,d_r)=1$, and
> $\sum_i 1/(d_i-1)\ge 1$, is $\Sigma(S(A,k))$ cofinite for every
> $k\ge 1$?

The page at erdosproblems.com currently has a likely typo in the first displayed
condition: it writes a repeated $d_r$ where the intended condition is the sum
over $d_i$.  A comment on the page points this out.

## Easy version, $k=0$

Let $b_1\le b_2\le\cdots$ be the nondecreasing list of all powers $d_i^j$,
$j\ge 0$.  Brown's criterion says that all nonnegative integers are
representable if $b_1=1$ and

$$b_{n+1}\le 1+\sum_{m\le n} b_m$$

for every $n$.

At a frontier where the first unused power of base $d_i$ is $d_i^{e_i}$,
the next term is $T=\min_i d_i^{e_i}$.  The prefix sum is

$$\sum_i {d_i^{e_i}-1\over d_i-1}.$$

Since $d_i^{e_i}\ge T$,

$$\sum_i {d_i^{e_i}-1\over d_i-1}
\ge (T-1)\sum_i {1\over d_i-1}
\ge T-1.$$

Thus Brown's inequality holds.  The hard $k\ge 1$ case loses the low powers
and introduces a constant deficit:

$$\sum_i {d_i^{e_i}-d_i^k\over d_i-1}.$$

When $\sum_i1/(d_i-1)=1$, that deficit is not swallowed by exponential
growth, which is why the critical cases such as $\{3,4,7\}$ remain hard.

