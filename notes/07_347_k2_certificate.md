# Computer-assisted certificate for $\{3,4,7\}, k=2$

This note records a computer-assisted certificate that the largest missing
integer in $\Sigma(S(\{3,4,7\},2))$ is 3982888.  It is mathematically useful,
but it is not the same thing as a clean algebraic proof of Erdos-124.  The
finite verification should be treated as an exact finite lemma.

## Finite central interval

The C++ bitset scan

```text
cpp\erdos124_fast.exe --mode=central --bases=3,4,7 --k=2 --seed-limit=50000000
```

returns

```text
seed_sum = 134018893
conductor_to_half = 3982888
central_interval = (3982889, 130036004)
```

Since all omitted powers are larger than 3982888, the integer 3982888 is truly
missing.  The finite seed powers represent every integer in the central interval
$[3982889,130036004]$.

For the first unused powers

$$E=(3^{17},4^{13},7^{10}),$$

the denominator-cleared invariant is

$$6K=47794770.$$

## Exact frontier scan

The exact big-integer frontier scan

```text
cpp\frontier_tail.exe --bases=3,4,7 --k=2 --seed-limit=50000000 --conductor=3982888 --steps=1000000 --target-base=3 --target-exp=293904 --top=10
```

checks every frontier state until the exponent of 3 passes 293904.  It reports

```text
actual_steps = 692710
failed = False
final_state = [3^293905, 4^232914, 7^165931]
min_margin = 53866687 at [3^18, 4^14, 7^10]
```

Thus the interval extension condition holds for every frontier state with
3-exponent at most 293904.

## Infinite tail

Let $T=\min(E_3,E_4,E_7)$, and write the denominator-cleared excess as

$$G=3(E_3-T)+2(E_4-T)+(E_7-T).$$

The tail can fail only if $G<47794770$.  In that case

$$|E_3-E_4|
\le (E_3-T)+(E_4-T)
< {47794770\over 3}+{47794770\over 2}
<47794770.$$

So a failure beyond the finite scan would imply

$$|3^a-4^b|<47794770$$

with $a\ge 293904$.

Burr, Erdos, Graham, and Li cite the Mignotte-Waldschmidt lower bound

$$|3^p-4^q|
>
\exp\{\log 3\,(p-500\log 4(8+\log p)^2)\}.$$

The script `scripts/mw_threshold.py` computes that the right-hand side first
exceeds 47794770 at $p=293904$, and the inner expression is increasing there.
Therefore no failure is possible after the finite scan.

Combining the finite central interval, the exact frontier scan, and the
Mignotte-Waldschmidt tail exclusion certifies that every integer
$n\ge3982889$ is represented.  Since 3982888 is missing, it is the largest
missing integer.

The large frontier scan is replaced by a smaller continued-fraction argument in
`notes/09_cf_tail_347_k2.md`.  The remaining computational input is then the
finite central interval and a small rational-arithmetic continued-fraction
certificate.
