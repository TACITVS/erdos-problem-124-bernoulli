# S-unit route for exact-critical tails

This note records a new algebraic idea for the exact-critical tail obstruction.
It is qualitative, not computational: it replaces explicit Baker-style
thresholds by the finiteness theorem for \(S\)-unit equations.

## External theorem

We use the standard \(S\)-unit finiteness theorem:

> If \(\Gamma\) is a finitely generated multiplicative subgroup of a number
> field and \(a_1,\ldots,a_n\ne0\), then the linear equation
> \[
> a_1x_1+\cdots+a_nx_n=1,\qquad x_i\in\Gamma,
> \]
> has only finitely many nondegenerate solutions.

For this project only the two-variable case is needed.  Equivalently, for a
finite set of rational primes \(S\), each equation

\[
u-v=c,\qquad c\ne0,
\]

has only finitely many solutions with \(u,v\) rational \(S\)-units.

References:

- Jan-Hendrik Evertse, Hans Peter Schlickewei, Wolfgang M. Schmidt,
  "Linear equations in variables which lie in a multiplicative group",
  Annals of Mathematics 155 (2002), 807-836.
- Frits Beukers and Hans Peter Schlickewei, "The equation \(x+y=1\) in
  finitely generated groups", Acta Arithmetica 78 (1996), 189-199.

## Lemma: bounded independent power collisions are finite

Let \(x,y>1\) be multiplicatively independent integers.  For every fixed
\(B\ge0\), the set

\[
\{(m,n)\in\mathbb N^2: |x^m-y^n|\le B\}
\]

is finite.

Proof.  Let \(S\) be the finite set of primes dividing \(xy\).  Each \(x^m\)
and \(y^n\) is an \(S\)-unit.  For every nonzero integer \(c\) with
\(|c|\le B\), the equation

\[
x^m-y^n=c
\]

is an \(S\)-unit equation and has only finitely many solutions.  The case
\(c=0\) has no solutions because \(x\) and \(y\) are multiplicatively
independent.  A finite union over the possible integers \(c\) is finite.

This is the exact qualitative substitute for a Baker-type lower bound.

## Consequence for exact-critical frontier failures

Assume the exact-critical condition

\[
\sum_{d\in A}{1\over d-1}=1.
\]

For a frontier \(E_i=d_i^{e_i}\), the existing near-collision reduction says
that if interval extension fails, then after clearing denominators there is a
constant \(B\), depending on the current seed interval, such that for every
pair \(i,j\),

\[
|E_i-E_j|<B\left({1\over w_i}+{1\over w_j}\right),
\qquad
w_i={D\over d_i-1}.
\]

If \(\gcd(A)=1\), the bases cannot all lie in one multiplicative class; the
existing multiplicative-class reduction gives a multiplicatively independent
pair \(x,y\in A\).  Infinite exact-critical frontier failures would then give
infinitely many pairs \((m,n)\) with

\[
|x^m-y^n|\le C
\]

for one fixed constant \(C\).  The bounded independent collision lemma forbids
this.  Therefore:

> For any fixed exact-critical base set \(A\), and any fixed finite seed
> interval, there are only finitely many tail frontiers at which interval
> extension can fail.

This statement is ineffective: it proves finiteness but does not give the last
bad frontier.

## What this solves and what it does not solve

This algebraic idea removes the need for an explicit Mignotte-Waldschmidt style
bound if the goal is a nonconstructive proof of cofiniteness.  It does not
remove the need for a seed-interval theorem.

The remaining exact-critical proof route would be:

1. prove a global central-interval theorem that can produce a finite seed
   interval with frontier past any prescribed finite obstruction set;
2. use \(S\)-unit finiteness to know that the obstruction set is finite;
3. start beyond it and apply interval extension forever.

Thus the exact-critical analytic obstruction is no longer the conceptual
bottleneck for a qualitative proof.  The bottleneck moves to the global
central-interval theorem.

## Practical impact on the project

The previous code-oriented plan wanted explicit pairwise Baker thresholds for
every independent base pair.  That is still valuable for effective certificates
and explicit largest-missing claims.  For a clean existence proof, however, the
right theorem to import is \(S\)-unit finiteness.

So the proof search should now prioritize:

- central intervals from finite seeds, uniformly and nonconstructively;
- residue/interval formation theorems from complete-sequence literature;
- only after that, effective Baker constants if explicit conductors are wanted.
