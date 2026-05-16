# Certificate for \(\{3,4,7\}, k=3\)

This note records a second nontrivial instance of the same proof architecture.

## Finite central interval

The exact C++ bitset scan

```text
cpp\erdos124_fast.exe --mode=central --bases=3,4,7 --k=3 --seed-limit=5000000000
```

returns

```text
seed_sum = 13263680771
conductor_to_half = 166025260
central_interval = (166025261, 13097655510)
```

All omitted powers exceed 166025260, so 166025260 is genuinely missing, while
the seed represents every integer in the displayed central interval.

The first unused powers are

\[
(E_3,E_4,E_7)=(3^{21},4^{17},7^{12}).
\]

The denominator-cleared obstruction threshold is

\[
B=3\cdot3^3+2\cdot4^3+7^3+12\cdot166025260+6=1992303678.
\]

As in the \(k=2\) case, tail failure implies

\[
|3^a-4^b|<B.
\]

## Small initial states

The Legendre continued-fraction reduction applies once \(a\ge23\), since

\[
2aB<3^a-B
\]

at \(a=23\), and then the inequality propagates by induction.

Before \(a=23\), the possible frontier states are

\[
(21,17,12),(22,17,12),(22,17,13),(22,18,13).
\]

Direct arithmetic gives \(G-B>0\) in all four cases:

```text
(21,17,12): 14827662282
(22,17,12): 57304177512
(22,17,13): 120320408820
(22,18,13): 138192481374
```

## Continued fractions and MW tail

The rational continued-fraction certificate

```text
python scripts/cf_near_collision.py --gap 1992303678
```

finds the same eight relevant convergents below the Mignotte-Waldschmidt
threshold:

\[
{19\over24},{23\over29},{42\over53},{485\over612},
{527\over665},{24727\over31202},{25254\over31867},
{150997\over190537}.
\]

Exact integer comparison gives \(|3^a-4^b|>1992303678\) for all eight.  The
Mignotte-Waldschmidt threshold is \(a=293907\), so the cited lower bound rules
out all later near-collisions.

Therefore the tail extends indefinitely.  Combining this with the finite
central interval proves that every \(n\ge166025261\) is represented, and
166025260 is the largest missing integer for \(\{3,4,7\},k=3\).

