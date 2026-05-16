# Power-saving central-interval target

This note sharpens the remaining proof bottleneck after the \(S\)-unit pivot in
`notes/27_s_unit_exact_critical_tail.md`.

The important point is that a qualitative proof does not need exact finite
conductors or a bounded central conductor.  A power-saving conductor bound is
enough, provided one imports the Subspace-Theorem strengthening of the
\(S\)-unit argument.

## Finite initial segments by frontier

Fix bases \(A=\{d_1,\ldots,d_r\}\) and exponent floor \(k\).  Let

\[
E_i=d_i^{e_i}
\]

be a frontier, and let \(F(E)\) contain all powers \(d_i^j\) with
\(k\le j<e_i\).  Write

\[
S(E)=\sum_{t\in F(E)} t.
\]

If the subset sums of \(F(E)\) have last missing value \(c(E)\) up to
\(\lfloor S(E)/2\rfloor\), then symmetry gives the central interval

\[
[c(E)+1,\ S(E)-c(E)-1].
\]

Its span is

\[
H(E)=S(E)-2c(E)-2.
\]

## Tail invariant in conductor form

Set

\[
C(E)=\sum_i {E_i\over d_i-1}.
\]

Since

\[
S(E)=\sum_i {E_i-d_i^k\over d_i-1},
\]

we have

\[
C(E)-S(E)=\kappa(A,k):=\sum_i {d_i^k\over d_i-1}.
\]

For the central interval above,

\[
K(E)=C(E)-1-H(E)=\kappa(A,k)+2c(E)+1.
\]

Thus the additive tail obstruction is controlled exactly by the finite seed
conductor \(c(E)\), up to a fixed constant.

## Strict case

If

\[
R=\sum_i {1\over d_i-1}>1,
\]

then interval extension eventually holds whenever

\[
T(E)(R-1)\ge K(E),\qquad T(E)=\min_i E_i.
\]

So for strict reciprocal sum, the central conductor condition needed by this
route is only

\[
c(E)=o(T(E))
\]

along some sequence of frontiers with \(T(E)\to\infty\).

This is much weaker than bounded conductor.

## Exact-critical case

Assume now \(R=1\).  The existing near-collision reduction gives, after clearing
denominators, a constant \(C_A\) depending only on \(A,k\) such that any
frontier failure forces a multiplicatively independent pair \(x,y\in A\) to
satisfy

\[
|x^m-y^n|\le C_A(c(E)+1).
\]

The plain \(S\)-unit finiteness theorem handles the case where \(c(E)\) is
bounded.  A stronger Subspace-Theorem consequence handles a power-saving
version: for every \(\epsilon>0\), only finitely many independent \(S\)-unit
pairs can satisfy

\[
|u-v|<\max(|u|,|v|)^{1-\epsilon}
\]

outside the degenerate multiplicative-dependence cases.

Therefore an exact-critical qualitative proof would follow from a central
conductor bound of the form

\[
c(E)=O(T(E)^{1-\epsilon})
\]

for some \(\epsilon>0\), along frontiers \(E\) with \(T(E)\to\infty\).

## New reduced theorem target

The global proof can now be refocused around this single structural target:

> **Power-saving central conductor theorem.**
> For every finite \(A\), \(k\ge1\), with \(\gcd(A)=1\) and
> \(\sum_{d\in A}1/(d-1)\ge1\), there are frontiers \(E\) with
> \(T(E)\to\infty\) such that the finite seed conductor \(c(E)\) satisfies:
> - \(c(E)=o(T(E))\) in the strict case;
> - \(c(E)=O(T(E)^{1-\epsilon})\) for some \(\epsilon>0\) in the exact-critical
>   case.

This target is still hard, but it is now a clean additive-combinatorial theorem
about finite subset sums of initial power segments.  It does not mention Baker
constants, continued fractions, or any bounded computation.

It also subsumes the older two-step residue-gate route for the qualitative
proof.  A residue-saturation theorem plus a post-saturation central-interval
theorem would still be a possible way to prove this conductor theorem, but the
global proof only needs the conductor-growth conclusion itself.

## Consequence

If the power-saving central conductor theorem is proved, then the rest of the
current proof architecture gives a qualitative proof of Erdős 124:

1. the central conductor bound gives a large seed interval with controlled
   invariant \(K(E)\);
2. strict slack handles \(R>1\);
3. the Subspace/S-unit theorem handles exact-critical \(R=1\);
4. interval extension gives the cofinite ray.

Conversely, without a theorem of this kind, the current architecture has no
noncomputational way to produce the seed interval needed before the tail
arguments can start.
