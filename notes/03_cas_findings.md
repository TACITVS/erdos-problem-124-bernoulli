# CAS findings

The script `scripts/cas_checks.py` uses SymPy for exact rational arithmetic and
symbolic simplification.

## Exact critical sets

For bases up to 30 and size up to 5, SymPy finds exact reciprocal-sum critical
sets such as

- \(\{3,4,7\}\)
- \(\{3,4,9,25\}\)
- \(\{3,4,10,19\}\)
- \(\{3,4,11,16\}\)
- \(\{3,5,6,21\}\)
- \(\{3,5,7,13\}\)

These are natural test cases because the reciprocal sum is exactly 1, so the
strict-growth slack in the Brown-style estimate disappears.

## Symbolic frontier deficit

For \(k\ge 1\), if \(q_i=d_i^k\) is the first allowed power and \(T\) is the
next frontier term, SymPy simplifies the lower-bound surplus to

\[
T\left(\sum_i{1\over d_i-1}-1\right)+1-\sum_i{q_i\over d_i-1}.
\]

When the reciprocal sum is greater than 1, this is eventually positive.  When
the reciprocal sum equals 1, it is a negative constant unless some additional
interval or Diophantine-spacing input is used.

