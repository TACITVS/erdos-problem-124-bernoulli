# Continued-fraction tail lemma for \(\{3,4,7\}, k=2\)

This note replaces the large exact frontier scan in
`notes/07_347_k2_certificate.md` by a smaller Diophantine argument.

Let

\[
B=6K=47794770.
\]

The exact-critical tail fails only if

\[
G=3(E_3-T)+2(E_4-T)+(E_7-T)<B,
\qquad T=\min(E_3,E_4,E_7).
\]

In that case, necessarily

\[
|E_3-E_4|<B.
\]

So for \(E_3=3^a\), \(E_4=4^b\), a tail failure forces

\[
|3^a-4^b|<B.
\]

## Large \(a\) forces a continued-fraction convergent

Let

\[
\alpha={\log 3\over \log 4}.
\]

If \(a\ge20\) and \(|3^a-4^b|<B\), then

\[
\left|\alpha-{b\over a}\right|
= {|a\log3-b\log4|\over a\log4}
< {B\over a\log4(3^a-B)}
< {1\over 2a^2}.
\]

The last inequality follows from \(\log4>1\) and

\[
2aB<3^a-B\qquad(a\ge20),
\]

which holds at \(a=20\) and then follows by induction.  By Legendre's theorem,
\(b/a\) must be a convergent of the continued fraction of \(\alpha\).

## Certified continued fraction

The script `scripts/cf_near_collision.py` computes rational intervals for
\(\log3\) and \(\log4\) from

\[
\log x=2\sum_{j\ge0}{y^{2j+1}\over 2j+1},
\qquad y={x-1\over x+1},
\]

using an exact rational geometric tail bound.  It then extracts the continued
fraction of \(\alpha\) from the resulting rational interval.

Up to the Mignotte-Waldschmidt threshold \(a=293904\), the only convergents
with \(20\le a<293904\) are

\[
{19\over24},\ {23\over29},\ {42\over53},\ {485\over612},\
{527\over665},\ {24727\over31202},\ {25254\over31867},\
{150997\over190537}.
\]

Exact integer comparison gives

\[
|3^a-4^b|>B
\]

for all eight pairs.

For \(a\ge293904\), the Mignotte-Waldschmidt bound cited by Burr, Erdos,
Graham, and Li gives \(|3^a-4^b|>B\).

## Small frontier states

The tail after the finite seed starts at

\[
(E_3,E_4,E_7)=(3^{17},4^{13},7^{10}).
\]

Before the exponent of \(3\) reaches \(20\), there are only seven frontier
states:

\[
(17,13,10),(17,14,10),(18,14,10),(18,15,10),
(18,15,11),(19,15,11),(19,16,11).
\]

For these states, exact arithmetic gives \(G-B>0\).  Therefore the tail cannot
fail before \(a=20\), and the continued-fraction plus Mignotte-Waldschmidt
argument handles all later states.

This is still not a proof of the full Erdos-124 problem, but it is a much
cleaner mathematical certificate for the infinite tail of the
\(\{3,4,7\}, k=2\) case.

