# Strict case certificate: $\{3,4,5\}, k=1$

The reciprocal sum for $\{3,4,5\}$ is $13/12>1$.  The script
`scripts/strict_certificate.py` produces a finite interval certificate.

Command:

```text
python scripts/strict_certificate.py --bases 3,4,5 --k 1 --seed-limit 1000
```

Output:

```text
IntervalCertificate(bases=(3, 4, 5), k=1, seed_limit=1000, interval=Interval(start=80, end=2132), final_span=3076, frontier=(2187, 4096, 3125), extension_steps=1, analytic_frontier=2187, reciprocal_sum=Fraction(13, 12))
proves all n >= 80
```

The bounded exact search in `results/benchmark_2026-05-15.txt` shows 79 is
missing and every integer from 80 to 100000 is represented.  The interval
certificate proves that the interval from 80 onward continues indefinitely.
Therefore the exact largest missing integer for $\{3,4,5\}, k=1$ is 79.

