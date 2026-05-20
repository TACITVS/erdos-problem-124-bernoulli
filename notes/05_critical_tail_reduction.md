# Critical-tail reduction

For exact-critical sets, $\sum_i 1/(d_i-1)=1$, the strict reciprocal-sum
tail argument is unavailable.  There is still a useful invariant.

Assume a finite seed prefix has total sum $U$, first unused powers
$E_i$, and subset sums containing a central interval

$$[c+1, U-c-1].$$

Let

$$H=U-2c-2,\qquad C(E)=\sum_i {E_i\over d_i-1},\qquad K=C(E)-1-H.$$

When the next power $T=E_j$ is appended, the interval span increases by
$T$, and $E_j$ changes to $d_jT$.  Therefore $C(E)$ also increases by

$${d_jT-T\over d_j-1}=T.$$

So $K=C(E)-1-H$ is invariant along the tail.  The interval extends forever
if every future frontier satisfies

$$\min_i E_i \le H+1,$$

equivalently

$$C(E)-\min_i E_i \ge K.$$

This converts the critical tail into a concrete spacing problem for powers of
the bases.

## Example: $\{3,4,7\}, k=2$

Using seed powers up to 50000000, exact subset-sum search up to half the finite
seed sum gives last missing value 3982888.  Thus the finite seed contains the
central interval

$$[3982889, 130036004].$$

The invariant is $K=7965795$.  The script
`scripts/critical_tail_sim.py` checks the next 1000 frontier steps and finds
the minimum extension margin at step 2:

```text
margin = 53866687
frontier = (387420489, 268435456, 282475249)
```

This is strong computational evidence, but it is not a proof of the infinite
tail.  A proof needs a Diophantine spacing bound showing
$C(E)-\min_iE_i\ge 7965795$ for all future frontiers.

