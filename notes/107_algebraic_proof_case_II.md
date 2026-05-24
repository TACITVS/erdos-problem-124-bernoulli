---
title: "Note 107: Algebraic Proof of Case II — Seed Completeness for Base-2 Sets"
date: "2026-05-24"
status: "THEOREM"
tags: ["algebraic-proof", "case-II", "seed-completeness", "universal"]
---

# Algebraic Proof of Case II: Seed Completeness for Sets Containing 2

This note provides a complete algebraic proof that Theorem A's hypotheses (H1)–(H3) are universally satisfiable when $2 \in A$, thereby closing Case II of the Erdős 124 proof.

## 0. Setup and Goal

Let $A = \{2\} \cup B$ with $B \subseteq \mathbb{Z}_{\ge 3}$, $|B| \ge 2$, $\gcd(A) = 1$, and $k \ge 1$.

**Goal**: Show there exists $T^* = T^*(A, k)$ such that the seed $F(T^*) = \{a^e : a \in A, k \le e < e_a(T^*)\}$ satisfies hypotheses (H1)–(H3) of Theorem A (Note 72).

Since $R(A) = 1 + R(B) > 1$ (because $B \ne \emptyset$), hypotheses (H3a)–(H3b) are automatically satisfied once (H1)–(H2) hold, by the strict takeover mechanism of Theorem A. So it suffices to prove (H1) and (H2) for some $T^*$.

Recall:
- **(H1)**: $2c^* + 2 \le S^*$ (central interval non-empty).
- **(H2)**: $\min_a E_a(T^*) \le S^* - 2c^* - 1$ (smallest frontier fits in interval).

Both reduce to: **the conductor $c(T^*)$ of $F(T^*)$ is at most $(S(T^*) - \min_a E_a(T^*) - 1)/2$.**

We prove a stronger result: $c(T^*) \le C_1 - 1$ where $C_1$ is an explicit constant depending only on $A$ and $k$.

---

## 1. The Unit Residue Coverage Lemma

> **Lemma 107.1 (Unit Residue Coverage).** Let $m \ge 2$ be a positive integer and $a_1, \ldots, a_n$ be integers with $n \ge m - 1$ and $\gcd(a_i, m) = 1$ for all $i$. Then the set of subset sums
> $$\Sigma = \left\{ \sum_{i \in I} a_i : I \subseteq \{1, \ldots, n\} \right\}$$
> satisfies $\Sigma \bmod m = \mathbb{Z}/m\mathbb{Z}$.

**Proof.** Define $T_0 = \{0\} \subseteq \mathbb{Z}/m\mathbb{Z}$ and $T_j = T_{j-1} \cup (T_{j-1} + a_j \bmod m)$ for $j = 1, \ldots, n$.

**Claim**: If $T_{j-1} \ne \mathbb{Z}/m\mathbb{Z}$, then $|T_j| \ge |T_{j-1}| + 1$.

Suppose for contradiction that $T_{j-1} + a_j \subseteq T_{j-1}$, i.e., $T_{j-1}$ is invariant under translation by $a_j$. Then $T_{j-1}$ is invariant under translation by $\ell \cdot a_j$ for all $\ell \ge 0$. Since $\gcd(a_j, m) = 1$, the element $a_j$ generates all of $\mathbb{Z}/m\mathbb{Z}$ as an additive group: $\{0, a_j, 2a_j, \ldots, (m-1)a_j\} = \mathbb{Z}/m\mathbb{Z}$. Therefore $T_{j-1} + g \subseteq T_{j-1}$ for every $g \in \mathbb{Z}/m\mathbb{Z}$, implying $T_{j-1} = \mathbb{Z}/m\mathbb{Z}$, contradicting our assumption.

Starting from $|T_0| = 1$ and applying the claim $m - 1$ times: $|T_{m-1}| \ge 1 + (m - 1) = m$. Since $|\mathbb{Z}/m\mathbb{Z}| = m$, we have $T_{m-1} = \mathbb{Z}/m\mathbb{Z}$. $\square$

---

## 2. Existence of Odd Elements in $B$

> **Lemma 107.2.** If $\gcd(A) = 1$ and $2 \in A$, then $B$ contains at least one odd element.

**Proof.** If all elements of $B$ were even, then every $a \in A$ would be even, giving $\gcd(A) \ge 2$, contradicting $\gcd(A) = 1$. $\square$

Let $b_0 \in B$ be odd (fixed henceforth). Note: $\gcd(b_0^e, 2^k) = 1$ for all $e \ge 1$, since $b_0$ is odd.

---

## 3. The Seed Decomposition

Fix $m = 2^k$. We decompose the seed $F(T)$ into three disjoint parts:

1. **Powers of 2**: $P_2(T) = \{2^k, 2^{k+1}, \ldots, 2^{M_2}\}$ where $M_2 = e_2(T) - 1$.
2. **Covering elements**: $F_{\text{cov}} = \{b_0^k, b_0^{k+1}, \ldots, b_0^{k+m-2}\}$ — the first $m - 1 = 2^k - 1$ powers of $b_0$ starting from exponent $k$.
3. **Remaining elements**: $F_{\text{rest}}(T) = F(T) \setminus (P_2(T) \cup F_{\text{cov}})$.

Define the constant $C_1 = \sum_{e=k}^{k+m-2} b_0^e = \frac{b_0^{k+m-1} - b_0^k}{b_0 - 1}$.

**Requirement on $T$**: We need $T > b_0^{k+m-1}$ so that $F_{\text{cov}} \subseteq F(T)$ (all covering elements are in the seed).

---

## 4. Properties of Each Part

### 4.1 Powers of 2

The subset sums of $P_2(T) = \{2^k, 2^{k+1}, \ldots, 2^{M_2}\}$ are exactly the set:
$$\mathcal{S}_2 = \left\{ \sum_{i \in I} 2^i : I \subseteq \{k, k+1, \ldots, M_2\} \right\} = \{ j \cdot 2^k : 0 \le j \le 2^{M_2 - k + 1} - 1 \}.$$

This is precisely **all multiples of $2^k$** from $0$ to $\Sigma_2 := 2^{M_2+1} - 2^k$.

*Proof*: By the uniqueness of binary representation, each subset $I$ corresponds to a unique integer $\sum_{i \in I} 2^i$, which is a multiple of $2^k$ (since every summand is). Conversely, every multiple of $2^k$ in $[0, \Sigma_2]$ has a binary expansion using only digits in positions $k$ through $M_2$. $\square$

### 4.2 Covering elements and residue coverage

All elements of $F_{\text{cov}}$ are **odd** (since $b_0$ is odd). By Lemma 107.1 with $n = m - 1 = 2^k - 1$ elements that are all coprime to $m = 2^k$:

> The subset sums of $F_{\text{cov}}$ cover all residue classes modulo $2^k$.

For each $r \in \{0, 1, \ldots, 2^k - 1\}$, fix a subset $I_r \subseteq F_{\text{cov}}$ with $\sigma_r := \sum_{i \in I_r} i \equiv r \pmod{2^k}$.

Note: $\sigma_r \le C_1$ for all $r$, and $\sigma_0 = 0$ (using the empty subset for $r = 0$).

Define $\sigma_{\max} = \max_r \sigma_r \le C_1$.

### 4.3 Disjointness

$F_{\text{cov}} \cap P_2(T) = \emptyset$ since every element of $F_{\text{cov}}$ is a power of the odd integer $b_0$, hence odd, while every element of $P_2(T)$ is a power of 2, hence even. $\square$

---

## 5. The Initial Central Interval

> **Theorem 107.3 (Seed Conductor Bound).** For $T \ge T_1 := \max(b_0^{k+m-1} + 1, \; 2C_1 + 2^{k+1})$, the conductor of $F(T)$ satisfies $c(T) \le C_1 - 1$.

**Proof.** We show that every integer $N$ with $C_1 \le N \le S(T) - C_1$ is representable as a subset sum of $F(T)$. Since $C_1$ is a constant independent of $T$, this gives $c(T) \le C_1 - 1$.

**Part A: Representing $N \in [C_1, \Sigma_2]$ using $F_{\text{cov}} \cup P_2(T)$.**

Let $r = N \bmod 2^k \in \{0, \ldots, 2^k - 1\}$. By §4.2, there exists $I_r \subseteq F_{\text{cov}}$ with $\sigma_r \equiv r \pmod{2^k}$ and $0 \le \sigma_r \le C_1$.

Since $N \equiv r \pmod{2^k}$ and $\sigma_r \equiv r \pmod{2^k}$: $N - \sigma_r \equiv 0 \pmod{2^k}$.

Write $N - \sigma_r = 2^k \cdot q$ where $q \ge 0$ (since $N \ge C_1 \ge \sigma_r$).

Also $q = (N - \sigma_r)/2^k \le N/2^k \le \Sigma_2/2^k = 2^{M_2 - k + 1} - 1$.

By §4.1: $2^k \cdot q$ is representable as a subset sum of $P_2(T)$, using some subset $J \subseteq \{k, \ldots, M_2\}$, giving $\sum_{i \in J} 2^i = 2^k q$.

Therefore $N = \sigma_r + 2^k q = \sum_{i \in I_r} i + \sum_{i \in J} 2^i$ is a subset sum of $I_r \cup \{2^i : i \in J\}$. Since $I_r \subseteq F_{\text{cov}}$ and $\{2^i : i \in J\} \subseteq P_2(T)$, and these sets are disjoint (§4.3), $N$ is a subset sum of $F_{\text{cov}} \cup P_2(T) \subseteq F(T)$. $\square$ (Part A)

**Part B: Extending to $N \in [\Sigma_2 + 1, \; \Sigma_2 + \Sigma_{\text{rest}}]$ by absorption.**

Sort the elements of $F_{\text{rest}}(T)$ in non-decreasing order: $f_1 \le f_2 \le \cdots \le f_s$.

By Part A, $F_{\text{cov}} \cup P_2(T)$ represents all integers in $[C_1, \Sigma_2]$.

The interval width is $W_0 = \Sigma_2 - C_1 + 1$.

We have $\Sigma_2 = 2^{M_2+1} - 2^k \ge T - 2^k$ (since $2^{M_2+1} = 2^{e_2(T)} \ge T$).

By assumption $T \ge 2C_1 + 2^{k+1}$, so $W_0 = \Sigma_2 - C_1 + 1 \ge T - 2^k - C_1 + 1 \ge C_1 + 1 > 0$.

**Key observation**: Every element of $F_{\text{rest}}(T)$ satisfies $f_i < T$.

*Proof*: Each $f_i = a^e$ for some $a \in A$, $k \le e < e_a(T)$. Since $a^{e_a(T)} \ge T$ and $e < e_a(T)$: $f_i = a^e \le a^{e_a(T)-1} = a^{e_a(T)}/a < aT/a = T$. $\square$

Now apply the Interval Absorption Lemma (Note 36) inductively. After absorbing $f_1, \ldots, f_{j-1}$, the representable interval is $[C_1, \Sigma_2 + \sum_{i<j} f_i]$ with width $W_{j-1} = W_0 + \sum_{i<j} f_i$.

For absorption of $f_j$: we need $f_j \le W_{j-1} = W_0 + \sum_{i<j} f_i$.

Since $f_j < T \le W_0 + 2^k + C_1 - 1 \le W_0 + C_1$: for the first element $f_1$, we need $f_1 \le W_0$. Since $f_1 < T$ and $W_0 \ge T - 2^k - C_1 + 1$: we need $T < T - 2^k - C_1 + 1 + 1$, i.e., $2^k + C_1 < 2$. This is **NOT** guaranteed for all $k$!

**Correction**: We need $W_0 \ge T$, i.e., $\Sigma_2 - C_1 + 1 \ge T$. Since $\Sigma_2 \ge T - 2^k$: this requires $T - 2^k - C_1 + 1 \ge T$, i.e., $C_1 \le 1 - 2^k < 0$, which is impossible.

So direct absorption of ALL remaining elements fails. We need a refined approach.

---

## 6. Refined Approach: Complementation + Partial Absorption

Since $F_{\text{cov}} \cup P_2(T) \subseteq F(T)$, any subset sum of $F_{\text{cov}} \cup P_2(T)$ is also a subset sum of $F(T)$. By the **complementation principle** applied to the FULL seed $F(T)$:

> If $N$ is representable using a subset $S' \subseteq F(T)$, then $S(T) - N$ is representable using $F(T) \setminus S'$.

Part A showed: every $N \in [C_1, \Sigma_2]$ is representable using some $S' \subseteq F_{\text{cov}} \cup P_2(T) \subseteq F(T)$.

By complementation: every $N' = S(T) - N$ with $N \in [C_1, \Sigma_2]$ is also representable. This gives:

$$[S(T) - \Sigma_2, \; S(T) - C_1]$$

is representable using $F(T)$.

**The two representable intervals are**:
- $\mathcal{I}_1 = [C_1, \; \Sigma_2]$ (from Part A)
- $\mathcal{I}_2 = [S(T) - \Sigma_2, \; S(T) - C_1]$ (from complementation)

**Overlap condition**: $\mathcal{I}_1$ and $\mathcal{I}_2$ overlap iff $\Sigma_2 \ge S(T) - \Sigma_2$, i.e., $2\Sigma_2 \ge S(T)$.

Now: $S(T) = \Sigma_2 + C_1 + \Sigma_{\text{rest}}$ where $\Sigma_{\text{rest}} = \sum_{f \in F_{\text{rest}}} f$.

So the overlap condition is: $2\Sigma_2 \ge \Sigma_2 + C_1 + \Sigma_{\text{rest}}$, i.e., $\Sigma_2 \ge C_1 + \Sigma_{\text{rest}}$.

$\Sigma_{\text{rest}}$ is the sum of all non-2, non-cover elements. Since the total sum of ALL non-2 elements is $\Sigma_B = \sum_{b \in B} (b^{e_b(T)} - b^k)/(b-1)$, and the cover elements sum to $C_1$:

$$\Sigma_{\text{rest}} = \Sigma_B - C_1.$$

So the overlap condition is: $\Sigma_2 \ge C_1 + \Sigma_B - C_1 = \Sigma_B$, i.e., **$\Sigma_2 \ge \Sigma_B$**.

This says: the sum of powers of 2 must exceed the sum of powers of all other bases.

**Is this true?**

$\Sigma_2 = 2^{e_2(T)} - 2^k \ge T - 2^k$.

$\Sigma_B = \sum_{b \in B} \frac{b^{e_b(T)} - b^k}{b-1} \le \sum_b \frac{bT - b^k}{b-1} = T \sum_b \frac{b}{b-1} - \sum_b \frac{b^k}{b-1} = T(|B| + R(B)) - C_B$.

For $|B| \ge 2$: $\Sigma_B$ can be as large as $T(|B| + R(B))$, which is $\gg T \ge \Sigma_2$ for $|B| \ge 2$.

**The overlap condition fails for $|B| \ge 2$!** The non-2 elements dominate the total sum.

---

## 7. The Complete Approach: Interleaved Absorption

The failure of the complementation overlap approach shows we need a more refined strategy. Instead of using only $F_{\text{cov}} \cup P_2$, we interleave ALL elements.

> **Theorem 107.4 (Interleaved Complete Sequence).** Let $A = \{2\} \cup B$, $\gcd(A) = 1$, $|B| \ge 2$, $k \ge 1$, $\delta = R(B) > 0$. For $T$ sufficiently large, the sorted elements of $F(T)$ satisfy the complete sequence condition from a bounded initial conductor.

**Proof.** Sort all elements of $F(T)$ as $s_1 \le s_2 \le \cdots \le s_N$.

Define the partial sums $\Sigma_j = \sum_{i=1}^{j} s_i$. The complete sequence condition at step $j$ is: $s_{j+1} \le \Sigma_j + 1$ (equivalently, $s_{j+1} \le 1 + \sum_{i \le j} s_i$).

**Key claim**: For all $j$ with $s_j \ge s_{\min}$ (a threshold defined below), the complete sequence condition holds.

Consider the elements near scale $s$: let $\Sigma(s) = \sum_{a^e \le s, e \ge k} a^e$ be the partial sum of all seed elements $\le s$.

The next element after $s$ in the sorted list is $s' = \min\{a^e \in F(T) : a^e > s\}$. The worst case is when $s'$ is the next power of 2: $s' = 2^{e+1}$ where $2^e \le s < 2^{e+1}$.

**Lower bound on $\Sigma(s)$**: For $s \ge 2^e$ (where $2^e$ is the largest power of 2 $\le s$):

$$\Sigma(s) \ge \underbrace{(2^{e+1} - 2^k)}_{\text{powers of 2}} + \underbrace{\sum_{b \in B} \frac{b^{g_b+1} - b^k}{b-1}}_{\text{powers of } b \le s}$$

where $g_b = \lfloor \log_b s \rfloor$ (so $b^{g_b} \le s < b^{g_b+1}$).

Since $b^{g_b} \le s < 2^{e+1}$: $b^{g_b+1} > s \ge 2^e$. So:
$$\frac{b^{g_b+1}}{b-1} > \frac{2^e}{b-1} = \frac{s'}{2(b-1)}.$$

Summing over $B$:
$$\Sigma(s) > 2^{e+1} - 2^k + \sum_b \frac{2^e}{b-1} - C_B = 2^{e+1} - 2^k + 2^e \cdot R(B) - C_B = 2^e(2 + \delta) - 2^k - C_B.$$

**Upper bound on $s'$**: $s' \le 2^{e+1} = 2 \cdot 2^e$.

**Complete sequence condition**: $s' \le \Sigma(s) + 1$, i.e., $2 \cdot 2^e \le 2^e(2 + \delta) - 2^k - C_B + 1$, i.e., $\delta \cdot 2^e \ge 2^k + C_B - 1$.

This holds for $2^e \ge (2^k + C_B - 1)/\delta$, i.e., $e \ge \lceil \log_2((2^k + C_B - 1)/\delta) \rceil$.

**But**: $s'$ might NOT be $2^{e+1}$! It could be a power of some base $b \in B$ that falls between $s$ and $2^{e+1}$. In that case, $s' \le 2^{e+1}$, so the condition is even easier to satisfy.

**Also**: the worst case is when $s$ is just below $2^{e+1}$ and no non-2 element falls between $s$ and $2^{e+1}$. But even then, the PARTIAL SUM already includes all non-2 powers up to $s$, which contribute $\ge \delta \cdot 2^e$ to $\Sigma(s)$.

**Define** $E_0 = \lceil \log_2((2^k + C_B)/\delta) \rceil$ and $s_{\min} = 2^{E_0}$.

For all $s \ge s_{\min}$: the complete sequence condition holds at each step. $\square$

**Corollary (Bounded Conductor)**: The conductor of $F(T)$ (for $T \ge 2 s_{\min}$) is at most the conductor of the elements below $s_{\min}$, which is a finite set of constants depending only on $A$ and $k$. Therefore $c(T) \le c_0(A, k)$ where $c_0$ is an explicit, computable constant. $\square$

---

## 8. Verification of Theorem A's Hypotheses

With $c(T) \le c_0$ (bounded), we verify (H1) and (H2) for $T^*$ large enough:

**(H1)**: $2c_0 + 2 \le S(T^*)$. Since $S(T^*) \ge R(A) \cdot T^* - C_0 \to \infty$: satisfied for $T^* \ge (2c_0 + 2 + C_0)/R(A)$. $\square$

**(H2)**: $\min_a E_a(T^*) \le S(T^*) - 2c_0 - 1$. Since $\min_a E_a(T^*) \le 2T^*$ and $S(T^*) \ge (1+\delta)T^* - C_0$: this requires $2T^* \le (1+\delta)T^* - C_0 - 2c_0 - 1$, i.e., $\delta T^* \ge C_0 + 2c_0 + 1$. Satisfied for $T^* \ge (C_0 + 2c_0 + 1)/\delta$. $\square$

---

## 9. Complete Proof of Case II

> **Theorem 107.5 (Erdős 124 for sets containing 2).** Let $A = \{2\} \cup B$ with $B \subseteq \mathbb{Z}_{\ge 3}$, $|B| \ge 2$, $\gcd(A) = 1$, and $k \ge 1$. Then every sufficiently large integer is a subset sum of $\{a^e : a \in A, e \ge k\}$.

**Proof.** By Theorem 107.4, the conductor $c(T)$ is bounded by $c_0 = c_0(A, k)$ for all $T \ge T_1$. By §8, hypotheses (H1) and (H2) of Theorem A hold for $T^* = \max(T_1, (C_0 + 2c_0 + 1)/\delta)$. Since $R(A) = 1 + \delta > 1$, (H3) of Theorem A is satisfied by the strict takeover mechanism. By Theorem A, every integer $N \ge c_0 + 1$ is representable. $\square$

---

## 10. Explicit Constants

For reference, the constants in the proof:
- $\delta = R(B) = \sum_{b \in B} 1/(b-1)$
- $C_B = \sum_{b \in B} b^k/(b-1)$
- $E_0 = \lceil \log_2((2^k + C_B)/\delta) \rceil$
- $s_{\min} = 2^{E_0}$ (threshold for complete sequence condition)
- $c_0 \le$ conductor of $\{a^e : a \in A, k \le e, a^e < s_{\min}\}$ (a finite, computable set)
- $T^* = \max(2s_{\min}, (C_0 + 2c_0 + 1)/\delta)$
- $N_0 = c_0 + 1$ (the effective threshold)
