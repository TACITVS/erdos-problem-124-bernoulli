# Certificate for $\{3,4,9,25\}, k=2$

This exact-critical set gives a useful test beyond $\{3,4,7\}$, while still
allowing the same $3$-versus-$4$ continued-fraction lemma.

## Finite central interval

The exact C++ scan

```text
cpp\erdos124_fast.exe --mode=central --bases=3,4,9,25 --k=2 --seed-limit=10000000
```

returns

```text
seed_sum = 28320179
conductor_to_half = 452099
central_interval = (452100, 27868079)
```

All omitted powers exceed 452099, so 452099 is genuinely missing, while the seed
represents every integer in the displayed central interval.

## Tail obstruction

The common denominator is $24$, and the denominator-cleared weights are

$$(12,8,3,1)$$

for $(3,4,9,25)$.  The obstruction bound is

$$B=12\cdot3^2+8\cdot4^2+3\cdot9^2+25^2+48\cdot452099+24=21701880.$$

If the exact-critical tail fails, then

$$12(E_3-T)+8(E_4-T)+3(E_9-T)+(E_{25}-T)<B,$$

where $T=\min(E_3,E_4,E_9,E_{25})$.  Hence

$$|E_3-E_4|<B,$$

so a failure forces

$$|3^a-4^b|<21701880.$$

## Continued-fraction tail

The rational continued-fraction certificate

```text
python scripts/cf_near_collision.py --gap 21701880
```

shows that the Legendre reduction starts at $a=19$, the
Mignotte-Waldschmidt threshold is $a=293903$, and all relevant convergents
between these bounds have $|3^a-4^b|>21701880$.

Before $a=19$, the exact frontier starts at

$$(3^{15},4^{12},9^8,25^6).$$

The helper

```text
python scripts/exact_critical_tail.py --bases 3,4,9,25 --k 2 --seed-limit 10000000 --conductor 452099 --target-base 3 --target-exp 19
```

checks those initial frontier states directly, and all margins $G-B$ are
positive.  The helper advances tied minima together; this matters here because
powers of 9 are also powers of 3.

Therefore the tail extends indefinitely.  Combining this with the central
interval proves that every $n\ge452100$ is represented, and 452099 is the
largest missing integer for $\{3,4,9,25\},k=2$.
