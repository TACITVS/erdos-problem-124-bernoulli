# Demolition strategy: where to set the charges

A budget-constrained engineering analysis of where to attack in the
network of open problems blocking Erdős 124.  Each "charge" is a
research direction with estimated cost and downstream impact.

## 0. The building (recap from note 90)

The blocking structure, with load-bearing dependencies:

```
                    ╔══════════════════════════╗
                    ║  SCHANUEL'S CONJECTURE   ║  ← roof: too high to reach
                    ╚════════════╤═════════════╝
                                 │ supports
            ╔════════════════════╧══════════════════════╗
            ║      LANG'S CONJECTURE                    ║  ← top floor
            ║   (μ = 2 for all transcendentals)         ║
            ╚════════════════════╤══════════════════════╝
                                 │ specializes
            ╔════════════════════╧══════════════════════╗
            ║   μ(log y/log x) = 2 uniformly            ║  ← our wall
            ║   for mult-indep integer pairs            ║
            ╚════════════════════╤══════════════════════╝
                                 │
       ┌─────────────────────────┼─────────────────────────┐
       │                         │                         │
  ╔════╧════════╗   ╔════════════╧═════════════╗   ╔══════╧═══════════╗
  ║ ABC ↔       ║   ║   EFFECTIVE SUBSPACE     ║   ║  KHINTCHINE BEHAVIOR║
  ║ effective   ║   ║   THEOREM (Bilu-Tichy    ║   ║  of CF(log p/log q) ║
  ║ Pillai      ║   ║   2000 partial)          ║   ║                     ║
  ╚═════════════╝   ╚══════════════════════════╝   ╚═════════════════════╝
       │                         │                         │
       └─────────────────────────┴─────────────────────────┘
                                 │
              ╔══════════════════╧════════════════╗
              ║  (H4') uniformly closed           ║  ← lobby
              ║  for all hypothesis-meeting       ║
              ║  (A, k)                           ║
              ╚══════════════════╤════════════════╝
                                 │
              ╔══════════════════╧════════════════╗
              ║   ERDŐS 124 CLOSED                ║  ← exit
              ║   (via Theorem B'' + chain)       ║
              ╚═══════════════════════════════════╝
```

The dilapidated walls between us and Erdős 124 are the **intermediate
nodes** (μ bound, effective Subspace, ABC, Khintchine).  We can't
demolish the roof (Schanuel, Lang) with conventional tools.  But we
can place charges on the intermediate floors that, **when they
collapse, drop the path open**.

## 1. The charges, ranked by ROI

For each candidate charge, we estimate:
- **Cost** (research effort, in session-units; each session ≈ a focused day).
- **Impact** (what closes if the charge fires).
- **Probability** of successful detonation in 1 / 5 / 50 sessions.
- **ROI** = (probability × impact) / cost.

### Charge α: Sharpen μ(log p/log q) for specific small pairs

**Where placed.**  The "wall" between $\mathcal P_{23}$ pair class
(uniformly closed asymptotically via Rhin's 5.117) and broader pair
classes.

**Method.**  Apply known transcendence techniques (Padé approximants,
Apéry-style sequences, hypergeometric methods) to improve μ bounds
for specific pairs.  E.g., sharpen $\mu(\log 5/\log 3)$ if best known
is loose.

**Cost.**  Medium — 2–5 sessions per pair.  Requires literature
synthesis + adaptation.

**Impact.**  Per pair: extends the (2,3)-derived class to a (2,3,5)
class, then (2,3,5,7), etc.  Each pair closes its derived sub-class
in the asymptotic regime.

**Probability.**  Medium-high (5–20% per session).  This is *active
research*; incremental progress is plausible.

**ROI.**  **★★★★** — high leverage on the (H4') uniformly node;
modest cost; achievable via known techniques.

**Why this works.**  The walls between pair classes are not
load-bearing for each other.  Closing μ for one pair only affects
that pair's class — but enough pairs closed shrinks the residual
class.

### Charge β: Effective Subspace Theorem for our specific setting

**Where placed.**  The "wall" of Prop D (note 73): bounded-or-linear
dichotomy modulo Subspace.

**Method.**  Adapt Bilu–Tichy 2000 (effective Subspace for special
families) to the multi-base subset-sum setting.  The multi-base
structure gives MORE invariants than generic Subspace.

**Cost.**  High — 5–15 sessions.  Requires deep work on Subspace
techniques + adaptation.

**Impact.**  **Very high**.  Effective Subspace at our level ⟹ Prop D
becomes effective ⟹ linear conductor growth ruled out per case ⟹
**closes Erdős 124 for many more cases**.

**Probability.**  Low–medium (1–5% per session).  Effective Subspace
is a known hard problem.

**ROI.**  ★★★ — high if it works, but probability is low.

**Why this might work where general Subspace doesn't.**  Our linear
forms have very specific structure ($\log p, \log q$ for integers).
Specific structure has historically yielded effective bounds when
general ones don't (cf. Roth → Mahler → Schmidt sequence).

### Charge γ: Multi-pair JOINT Diophantine analysis

**Where placed.**  A new "wall" not on the standard dependency tree.

**Method.**  Use note 27's "for every pair" form of the near-collision
reduction.  At a frontier failure, ALL pairs $(d_i, d_j)$ have
near-collisions simultaneously.  The joint constraint is much stronger
than any single-pair constraint.

For $|A| = 3$: three near-collisions $|d_1^{e_1} - d_2^{e_2}|$,
$|d_1^{e_1} - d_3^{e_3}|$, $|d_2^{e_2} - d_3^{e_3}|$ all small means
all three powers are within $B^*$ of each other.

If the *joint* solution set is empty (or finite), failure is ruled
out without needing $\mu(\alpha) = 2$.

**Cost.**  Medium — 3–8 sessions.  Novel direction, requires invention.

**Impact.**  **Very high** if it works.  Closes (H4') uniformly via a
*purely combinatorial* argument bypassing Lang.

**Probability.**  Unknown — this is a new direction.  Estimate
2–8% per session.

**ROI.**  ★★★★ — novel, high-leverage, accessible.

**Why this is a "new demolition method".**  Standard Diophantine
analysis is single-pair.  The multi-pair joint constraint is a
*structural* observation about our setting that the literature
doesn't typically exploit.

### Charge δ: Direct multi-base subset-sum density

**Where placed.**  Bypasses the entire Diophantine wall.

**Method.**  Show directly that subset sums of $F(T) = \{a^j\}_{a \in A, j}$
saturate $[0, S(T)/2]$ for large $T$, using a counting / pigeonhole
argument.  The key insight: $|F| \approx |A| \log T$, so
$2^{|F|} \approx T^{|A| \log 2}$ — exponentially many subset sums in
an interval of length $T$.

**Method variants:**
- Plünnecke–Ruzsa inverse: structured missing set ⟹ structural
  constraint on $F$, which our specific $F$ violates.
- Probabilistic / second-moment method on $\Sigma(F)$.
- Modular density bridges (notes 33, 41).

**Cost.**  Medium — 5–15 sessions.  Requires new combinatorial
insight.

**Impact.**  **Very very high**.  Direct closure of Erdős 124 bypassing
Diophantine input entirely.

**Probability.**  Unknown — this is genuine new mathematics.
Estimate 1–4% per session.

**ROI.**  ★★★★ — if successful, the biggest collapse possible.

**Why this is plausible.**  Empirically, missing sets ARE finite
($\mathcal M_\infty < \infty$ for all 12,226+ cases tested).  The
"why" is the question — and combinatorial structure of $F$ is the
natural place to look.

### Charge ε: Khintchine behavior for log p/log q

**Where placed.**  The "wall" between $\mu < \infty$ (known) and
$\mu = 2$ (Lang).

**Method.**  Prove that CF partial quotients $a_n$ of $\log p/\log q$
satisfy a Khintchine-type bound (e.g., $a_n = O(n^\epsilon)$).  This
is *weaker* than $\mu = 2$ but stronger than $\mu < \infty$.

**Cost.**  Very high — 10–30 sessions.  This is essentially proving
generic CF behavior for log ratios, requiring deep transcendence
input.

**Impact.**  High — would give a much sharper $\mu$ bound than known
Baker / LMN constants, closing most cases.

**Probability.**  Very low — Lang's conjecture in disguise.

**ROI.**  ★★ — high impact but very low probability per session.

### Charge ζ: Audit + Lean formalization

**Where placed.**  Not on the demolition tree at all — these are
*reinforcement* charges, ensuring the existing structure holds.

**Method.**  Full audit pass of all algebraic theorems (A, C, D,
83.1, 84.1, 84.2, 87.1).  Lean formalization of the load-bearing
ones.

**Cost.**  Low–medium — 3–8 sessions total.

**Impact.**  Low for Erdős 124 (no demolition); high for project
durability (catches more hidden assumptions, makes results
publishable).

**Probability.**  Very high (>90%) — these are mechanical tasks.

**ROI.**  ★★★ — high probability, low cost, but no demolition value.

### Charge η: Paper draft + community outreach

**Where placed.**  External — passes the demolition charge to a
broader community.

**Method.**  Write up the project's reformulation of Erdős 124 as
Lang's conjecture special case.  Submit to arXiv, distribute to
Solomyak, Shmerkin, Bugeaud, Wu.

**Cost.**  Medium — 5–10 sessions for the writeup.

**Impact.**  Hard to estimate.  Could attract major collaborators or
inspire new attacks on adjacent walls.

**Probability.**  Medium — depends on response.

**ROI.**  **★★★★★ for the broader research ecosystem** (not for
*us* directly demolishing the building, but for getting OTHER teams
to bring more explosives).

## 2. The combined attack plan

Given budget constraints, the optimal "multi-charge" placement:

### Phase 1 (next 5 sessions): the high-ROI charges

1. **Charge γ (multi-pair joint analysis)** — 2–3 sessions.
   Investigate whether the joint constraint at failure rules out
   linear conductor growth for $|A| \ge 3$.  This is the novel
   direction with the highest expected per-session ROI.

2. **Charge α (sharpen μ for more pairs)** — 1–2 sessions.
   Look up best known μ bounds for $(2, 5), (3, 5), (2, 7), (3, 7),
   (5, 7), \ldots$ from the literature.  Apply Prop 84.2 to each.
   Quick wins for the asymptotic regime.

3. **Charge ζ (audit pass)** — 1 session.
   Reinforcement charge: ensure Theorems A, C, D, 83.1, 84.1, 84.2,
   87.1 don't have other (H5')-style hidden assumptions.

### Phase 2 (sessions 6–15): the medium-ROI charges

4. **Charge δ (direct combinatorial)** — 5–8 sessions.
   Pursue the multi-base subset-sum density argument.  This is
   speculative but potentially the biggest collapse.

5. **Charge β (effective Subspace adaptation)** — 5–10 sessions
   parallel.  Long-term, but if it works, major collapse.

### Phase 3 (sessions 15+): community engagement

6. **Charge η (paper + outreach)** — 5–10 sessions.
   By this point, the algebraic framework + multi-charge analysis
   is a substantial paper-worthy contribution.  Engage the
   transcendence community.

## 3. The single highest-ROI charge for the *next session*

Looking at Phase 1, the single best next move:

> **Charge γ — multi-pair joint Diophantine analysis.**
>
> Cost: ~2 sessions for a meaningful sketch + verification.
> Impact: closes (H4') uniformly via a *purely combinatorial*
> route, bypassing Lang.
> Probability: low but unknown (this direction hasn't been
> explored).

**Why this is the right next charge:**

1. It's a **new demolition method** (per the user's framing) — not
   a sharpening of existing tools, but a novel bridge using the
   project's existing structural observation (note 27's "for every
   pair" form).

2. **Low marginal cost.**  We can SKETCH the joint argument in
   a single session and see if it has legs.  If it doesn't, we've
   spent 1 session learning where the wall is.

3. **High potential reward.**  If the joint constraint forces
   the failure set to be bounded (which is what we'd need to close
   the conductor obligation), it bypasses the entire Lang's
   conjecture dependency.

4. **It exploits structure we have.**  Multi-base $A$ with $|A| \ge 3$
   gives ${|A| \choose 2} \ge 3$ pairs of constraints simultaneously.
   This is structure unavailable in generic Diophantine analysis.

5. **It's an HONEST gamble.**  We know it might not work.  But the
   cost of trying is low, and even a partial result (e.g., for
   $|A| \ge 4$ specifically) would be valuable.

### Concrete first step

Set up the joint constraint for $A = \{3, 4, 7\}$:
- At failure, $|3^{e_3} - 4^{e_4}| \le B^*_{34}$,
  $|3^{e_3} - 7^{e_7}| \le B^*_{37}$, $|4^{e_4} - 7^{e_7}| \le B^*_{47}$.
- All three simultaneously: the triple $(e_3, e_4, e_7)$ lies in the
  intersection of three near-collision varieties.
- Question: is the intersection empty, finite, or infinite?

If empty for all (most) $|A| \ge 3$: closure follows by combinatorial
exhaustion.  No Diophantine input needed beyond the existing.

If finite: similar to single-pair case but with sharper bounds.

If infinite: the joint constraint doesn't help; back to single-pair.

This is a concrete, single-session investigation with clear
deliverables.

## 4. The dialogue: budget vs. ambition

Honest meta-assessment:

The project so far has succeeded at **algebraic reformulation**
(reducing Erdős 124 to a precise Diophantine question).  The next
phase needs either:

- **Patience** for the transcendence community to close Lang's
  special case (decades-scale), OR
- **A genuinely new bridge** (multi-pair, direct density, or other
  invention).

Our budget constraint says: don't spend 10 sessions on Lang directly
(out of reach), but DO spend 2 sessions on Charge γ (multi-pair) and
2 sessions on Charge α (more pairs via known μ).

If γ pays off — major collapse.  If it doesn't — we've learned the
shape of the wall and can place subsequent charges with better
information.

## 5. The metaphor's conclusion

Old building (open problems):
- Roof (Schanuel, Lang): too high — can't reach with current tools.
- Top floor (μ for log ratios): being chipped at globally, slow.
- Mid-floor (effective Subspace, ABC): active research, gradual.
- Lobby (our (H4') uniformly): one wall away from collapse if μ
  uniform.
- **HIDDEN WEAK POINT**: the multi-pair joint constraint — a wall
  whose load-bearing role hasn't been examined.

New building (Erdős 124 closure):
- Foundation: 12,226+ certified cases.
- Structure: Theorems A, B'', C, Prop D, 83.1, 84.1, 84.2, 87.1.
- Missing: the door (closure of (H4') uniformly).

**Next charge: Charge γ on the multi-pair joint constraint.**
A small explosion in a load-bearing intersection might bring down a
disproportionate amount of the wall.  Worth a session to find out.

## 6. Status

This note (Phase B-23) consolidates the demolition strategy:

- Seven candidate charges identified, with cost/impact/probability
  estimates.
- Combined attack plan in three phases.
- Single highest-ROI next charge: **Charge γ (multi-pair joint
  Diophantine analysis)**.

The next session, if directed at the open problem, should
investigate the multi-pair joint constraint for $|A| \ge 3$ as the
first concrete instance of a new demolition method.
