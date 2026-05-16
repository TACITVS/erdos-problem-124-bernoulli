# Bibliographical map for Erdős 124

This note records the first serious literature pass for the current Erdős 124
program.  It is not a claim that all papers below have been fully digested.
It is a working map: what to read, why it matters, and which open obligation it
may attack.

The important conclusion is that a deeper bibliography is profitable now.  The
current proof architecture has three open obligations:

1. global residue saturation;
2. post-saturation central interval formation;
3. global explicit analytic bounds for arbitrary independent base pairs/classes.

The literature below contains tools that plausibly address all three.

## Primary problem sources

### Burr, Erdős, Graham, Li, 1996

S. A. Burr, P. Erdős, R. L. Graham, W. Wen-Ching Li,
"Complete sequences of sets of integer powers", Acta Arithmetica 77 (1996),
133-138.  DOI: `10.4064/aa-77-2-133-138`.

Links:

- IMPAN page:
  <https://www.impan.pl/en/publishing-house/journals-and-series/acta-arithmetica/all/77/2/109048/complete-sequences-of-sets-of-integer-powers>
- PDF mirror:
  <https://matwbn.icm.edu.pl/ksiazki/aa/aa77/aa7722.pdf>

Status for this project: core primary source.

Relevance:

- states the pure-power conjecture used here;
- proves the \(\{3,4,7\}\) case;
- imports Mignotte-Waldschmidt for the \(3^p\) versus \(4^q\) tail;
- explicitly distinguishes the pure-power problem from Birch-type mixed-product
  sequences.

Proof hooks:

- exact-critical tail obstruction;
- local certificate targets;
- necessity of reciprocal-sum and gcd hypotheses;
- benchmark for our \(\{3,4,7\}\) conductor.

Action:

- read the PDF line-by-line and align each proof step against the current
  Haskell certificates;
- extract the Mignotte-Waldschmidt corollary exactly, including constants and
  hypotheses.

### Erdős Problems #124

Link:

- <https://www.erdosproblems.com/124>
- LaTeX source:
  <https://www.erdosproblems.com/latex/124>

Status for this project: live problem index and caution label.

Relevance:

- records that the second question was conjectured by BEGL96 and proved there
  for \(\{3,4,7\}\);
- points out the site owner's warning that relevant literature may be missing;
- references Erdős 1997 problem statements and Melfi 2004;
- notes Pomerance's necessity observation and Tao's comment sketch.

Proof hooks:

- confirms we should not rely on finite computation;
- validates the current conservative audit posture.

Action:

- inspect comments and source history for Tao/Pomerance necessity details;
- track whether new comments mention a partial solution or related literature.

### Erdős Problems #125

Link:

- <https://www.erdosproblems.com/latex/125>

Status for this project: adjacent problem, especially for \(\{3,4\}\).

Relevance:

- documents the related \(\{3,4\}\) density problem;
- cites Melfi 2001 and Hasler-Melfi 2024;
- states that recent arguments show the lower density of the \(\{3,4\}\) sumset
  is zero.

Proof hook:

- warns that positive density or local density estimates for \(\{3,4\}\) do not
  automatically imply cofiniteness after adding a third base.

Action:

- treat \(\{3,4\}\) as a density/barrier test case for residue and gap
  heuristics.

### Melfi, 2001 and 2004

G. Melfi, "An additive problem about powers of fixed integers", Rendiconti del
Circolo Matematico di Palermo 50 (2001), 239-246.

G. Melfi, "On certain positive integer sequences", Riv. Mat. Univ. Parma (7) 3
(2004), 253-260; arXiv:math/0404555.

Links:

- arXiv 2004 survey: <https://arxiv.org/abs/math/0404555>
- Melfi publication list:
  <https://www.hep-bejune.ch/fr/Personnel-academique/Giuseppe-Melfi/Publications/Publications.html>

Status for this project: adjacent density and construction literature.

Relevance:

- Melfi 2001 gives the older lower-bound estimate for sums of powers of \(3\)
  and \(4\);
- Melfi 2004 gives constructions showing reciprocal-sum intuition can fail for
  infinite base sets.

Proof hooks:

- density does not equal cofiniteness;
- infinite-base constructions are not directly the finite-base theorem, but they
  clarify why hypotheses matter.

Action:

- read Melfi 2001 together with Hasler-Melfi 2024 to understand large gaps in
  \(\Sigma(\operatorname{Pow}(\{3,4\}))\).

### Hasler and Melfi, 2024

M. F. Hasler and G. Melfi, "On sums of distinct powers of 3 and 4",
Combinatorics and Number Theory 13 (2024), 141-148.  DOI:
`10.2140/cnt.2024.13.141`.

Links:

- University of Neuchâtel record:
  <https://libra.unine.ch/entities/publication/895211f4-d9da-4472-a058-c0bfd2b29e7c>
- PDF:
  <https://libra.unine.ch/server/api/core/bitstreams/66082c0f-9f01-4e86-a176-1bebb27e3a83/content>

Status for this project: important adjacent density/gap source.

Relevance:

- improves Melfi's lower estimate for the \(\{3,4\}\) counting function;
- studies structural properties of sums of distinct powers of \(3\) and \(4\);
- explicitly connects the \(k=0\) and \(k=1\) counting functions up to a constant
  factor.

Proof hooks:

- helps calibrate why adding \(7\) in \(\{3,4,7\}\) is essential;
- may contain gap data useful for modular-gate classifiers.

Action:

- mine its structural functions and gap observations for candidate invariants in
  the post-saturation central interval theorem.

## Classical complete-sequence literature

### Brown, 1961

J. L. Brown, "Note on complete sequences of integers", American Mathematical
Monthly 68 (1961), 557-560.

Status for this project: baseline criterion.

Relevance:

- supplies the complete-sequence criterion used for the easy \(k=0\) style
  argument;
- current interval-extension lemma is a finite-seed analogue.

Proof hooks:

- post-saturation central interval theorem;
- bridge from residue-complete finite blocks to Brown-style greedy extension.

Action:

- write a precise comparison between Brown's one-dimensional condition and our
  multibase frontier invariant.

### Cassels, 1960

J. W. S. Cassels, "On the representation of integers as the sums of distinct
summands taken from a fixed set", Acta Sci. Math. (Szeged) 21 (1960), 111-124.

Status for this project: important general completeness theorem.

Relevance:

- cited in the exponential-type sequence literature as more general than
  Birch's theorem;
- Chen-Fang-Hegyvári quote a Cassels theorem with growth and equidistribution
  hypotheses.

Proof hooks:

- possible route to post-saturation central interval formation;
- possible replacement for ad hoc seed bridge if our pure powers satisfy an
  appropriate equidistribution/subset-sum criterion.

Action:

- obtain and read the full paper; isolate whether its hypotheses can be checked
  for unions of pure powers.

### Birch, 1959, and Zannier, 1989

B. J. Birch, "Note on a problem of Erdős", Proc. Cambridge Philos. Soc. 55
(1959), 370-373.

U. Zannier, "On a theorem of Birch concerning sums of distinct integers taken
from certain sequences", Math. Proc. Cambridge Philos. Soc. 106 (1989),
199-206.  DOI: `10.1017/S0305004100078014`.

Link:

- Zannier Cambridge Core PDF:
  <https://www.cambridge.org/core/services/aop-cambridge-core/content/view/4C00C806E9153B784CB06EA4488D2F39/S0305004100078014a.pdf/on_a_theorem_of_birch_concerning_sums_of_distinct_integers_taken_from_certain_sequences.pdf>

Status for this project: product-sequence analogue.

Relevance:

- Birch proves completeness for mixed products \(p^a q^b\), \(p,q\) coprime;
- Zannier revisits Birch and records the bounded-exponent strengthening;
- this is not the pure-power problem, but BEGL96 explicitly frames its problem
  as an analogue of this mixed-product theorem.

Proof hooks:

- global post-saturation central interval theorem;
- bounded "escape exponent" ideas may inform modular-gate saturation.

Action:

- read Birch and Zannier before attempting a global seed-bridge proof;
- compare their induction blocks with our residue-gate and frontier machinery.

### Hegyvári, 2000; Fang, 2011; Chen-Fang-Hegyvári, 2016

N. Hegyvári, "On the completeness of an exponential type sequence", Acta
Mathematica Hungarica 86 (2000), 127-135.

J. Fang, "A note on the completeness of an exponential type sequence", Chinese
Annals of Mathematics B 32 (2011), 527-532. DOI:
`10.1007/s11401-011-0660-5`.

Y.-G. Chen, J.-H. Fang, N. Hegyvári, "On the subset sums of exponential type
sequences", Acta Arithmetica 173 (2016), 141-150. DOI:
`10.4064/aa8133-3-2016`.

Links:

- Hegyvári 2000 metadata:
  <https://www.ovid.com/journals/acmah/abstract/00133301-200008610-00009~on-the-completeness-of-an-exponential-type-sequence>
- Fang 2011 metadata:
  <https://www.researchgate.net/publication/251400435_A_note_on_the_completeness_of_an_exponential_type_sequence>
- Chen-Fang-Hegyvári EUDML:
  <https://eudml.org/doc/279487>
- Chen-Fang-Hegyvári PDF:
  <https://www.impan.pl/shop/en/publication/transaction/download/product/91561>

Status for this project: high-priority family.

Relevance:

- Hegyvári gives an effective bound for the bounded-exponent Birch/Davenport
  problem;
- Fang improves the bound;
- Chen-Fang-Hegyvári study subset sums of exponential-type sequences and cite
  Cassels/Birch/Hegyvári.

Proof hooks:

- residue saturation;
- central interval formation;
- possible effective constants for bounded finite seeds.

Action:

- read Chen-Fang-Hegyvári first, then trace its references backward;
- identify their residue/interval lemmas and test whether they can be adapted
  from \(S_pA\)-type sequences to unions of pure powers.

### Bergelson and Simmons, 2017

V. Bergelson and D. Simmons, "New examples of complete sets, with connections
to a Diophantine theorem of Furstenberg", Acta Arithmetica 178 (2017),
253-264; arXiv:1507.02208.

Links:

- arXiv: <https://arxiv.org/abs/1507.02208>
- PDF mirror:
  <https://people.math.osu.edu/bergelson.1/BS_CompleteSets.pdf>

Status for this project: very high priority.

Relevance:

- the abstract says the method improves results of Cassels, Zannier, BEGL96,
  and Hegyvári;
- Yu-Chen-Chen 2025 records a bound \(K_0(s_1,s_2)\le 4s_1-5\) attributed to
  Bergelson-Simmons for the bounded-exponent mixed-product problem.

Proof hooks:

- residue-saturation and central-interval methods may already be packaged here
  in a form more flexible than BEGL96;
- possible conceptual replacement for some current brute-force seed bridge
  reasoning.

Action:

- read before writing more bespoke seed-bridge code;
- extract any theorem that can be specialized to pure-power unions or to a
  finite family of shifted geometric progressions.

## Modern exponential-type sequence literature

### Xue, Fang, Ma, 2023

F.-G. Xue, J.-H. Fang, J. Ma, "On exponential type sequences", Discrete Applied
Mathematics 338 (2023), 187-189. DOI: `10.1016/j.dam.2023.05.023`.

Link:

- <https://www.sciencedirect.com/science/article/abs/pii/S0166218X23002019>

Status for this project: directly relevant to residue-saturation language.

Relevance:

- introduces a "quasi complete set of residues modulo \(p\)" criterion;
- proves implications between residue completeness and lower density or
  completeness properties for sequences of the form \(S_pA\);
- gives an explicit theorem that if a finite seed block has the right interval
  subset-sum property, then \(P(S_pA)\) is all nonnegative integers.

Proof hooks:

- global residue saturation;
- post-saturation central interval theorem;
- our bounded residue-bridge lemma is close in spirit to their residue
  criterion.

Action:

- translate their definitions into our notation;
- test whether our modular-gate certificates can be recast as positive/negative
  instances of their "quasi complete residue" framework.

### Yu, Chen, Chen, 2025

W.-X. Yu, Y.-G. Chen, S.-Q. Chen, "A generalization of the Erdős-Birch theorem",
European Journal of Combinatorics 128 (2025), article 104187. DOI:
`10.1016/j.ejc.2025.104187`.

Links:

- ScienceDirect:
  <https://www.sciencedirect.com/science/article/abs/pii/S0195669825000721>
- DBLP:
  <https://dblp.uni-trier.de/rec/journals/ejc/YuCC25.html>

Status for this project: high-priority but not directly the same theorem.

Relevance:

- proves that the mixed-product set
  \(\{s_1^{x_1}\cdots s_k^{x_k}: x_i\ge0\}\) is complete exactly when
  \(\gcd(s_1,\ldots,s_k)\le2\);
- this is much stronger than Birch for product monoids, but the terms are
  products, not pure powers.

Proof hooks:

- may contain a modern proof architecture for residue saturation plus interval
  formation;
- duplicate-term handling in product monoids may be relevant to our warning not
  to collapse equal pure powers.

Action:

- read after Bergelson-Simmons and Chen-Fang-Hegyvári;
- search for a lemma that applies to finite unions of geometric progressions,
  not only product monoids.

### Liu, 2026 and Ding-Liu-Wang, 2025/2026

H. Liu, "The Birch-Erdős theorem on exponential type sequences", Periodica
Mathematica Hungarica (2026). DOI: `10.1007/s10998-026-00707-y`.

Y. Ding, H. Liu, Z. Wang, "Note on a theorem of Birch-Erdős and m-ary
partitions", Journal of Number Theory 279 (2026), 910-928.

Status for this project: follow-up reading.

Relevance:

- Liu sharpens representation size/large-term features for product-monoid
  exponential sequences;
- useful if we need representations where every selected term lies beyond a
  threshold, which resembles our \(k\ge1\) cutoff.

Proof hooks:

- tail entry;
- avoiding low powers;
- possible comparison theorem for large-term representations.

Action:

- useful after the core older papers; not the first stop.

## Analytic Diophantine approximation

### Mignotte and Waldschmidt, 1978/1989

M. Mignotte and M. Waldschmidt, "Linear forms in two logarithms and Schneider's
method", Math. Ann. 231 (1978), 241-267.

M. Mignotte and M. Waldschmidt, "Linear forms in two logarithms and Schneider's
method. II", Acta Arithmetica 53 (1989), 251-287.

M. Mignotte and M. Waldschmidt, "Linear forms in two logarithms and Schneider's
method (III)", Ann. Fac. Sci. Toulouse, Série 5, S10 (1989), 43-75.

Links:

- EUDML MW II:
  <https://eudml.org/doc/206222>
- IMPAN MW II:
  <https://www.impan.pl/get/doi/10.4064/aa-53-3-251-287>
- NUMDAM MW III:
  <https://www.numdam.org/item/AFST_1989_5_S10__43_0/>

Status for this project: required for local certificates and global analytic
replacement.

Relevance:

- BEGL96 cites a specific Mignotte-Waldschmidt inequality for \(3^p-4^q\);
- our local certificates currently import this as an external theorem.

Proof hooks:

- global exact-critical analytic bound;
- arbitrary independent base pair tail exclusion.

Action:

- extract the exact corollary used by BEGL96 into a formal statement in notes;
- compare with Laurent 1994 and later sharper two-logarithm bounds for a
  generic pair certificate.

### Laurent and later two-logarithm bounds

M. Laurent, "Linear forms in two logarithms and interpolation determinants",
Acta Arithmetica 66 (1994), 181-199.

Link:

- <https://www.impan.pl/en/publishing-house/journals-and-series/acta-arithmetica/all/66/2/108147/linear-forms-in-two-logarithms-and-interpolation-determinants>

Status for this project: likely upgrade path.

Relevance:

- improves constants for real logarithms compared with earlier
  Mignotte-Waldschmidt methods;
- likely better suited for arbitrary-pair thresholds.

Proof hook:

- global exact-critical analytic bound.

Action:

- compare Laurent's explicit corollaries against the current
  `PairCFTailCertificate.hs` API.

## Finite abelian group subset-sum literature

### Olson/Davenport and subset-sum covering

Selected entry points:

- "Covering a finite abelian group by subset sums", Combinatorica:
  <https://link.springer.com/article/10.1007/s00493-003-0036-x>
- "Subset sums in abelian groups", arXiv:1112.1929:
  <https://arxiv.org/abs/1112.1929>
- Geroldinger, "Zero-sum problems in finite abelian groups: a survey":
  <https://www.sciencedirect.com/science/article/pii/S0723086906000351>

Status for this project: likely relevant to modular gates.

Relevance:

- our residue-saturation problem is subset-sum coverage in finite cyclic groups;
- modular-gate examples are finite abelian group subset-sum obstructions in
  disguise.

Proof hooks:

- global residue saturation;
- one-escape-base saturation lemma;
- arbitrary-modulus `ResidueGateCertificate.hs`.

Action:

- survey Olson constants and subset-sum covering theorems before attempting a
  custom residue-saturation proof;
- specialize first to cyclic groups \(\mathbb Z/q\mathbb Z\).

## Local modern discussions and data

### MathOverflow: sums of powers of 3, 4, and 7

Link:

- <https://mathoverflow.net/questions/501259/sums-of-distinct-powers-of-3-4-and-7>

Status for this project: useful informal discussion, not a primary theorem.

Relevance:

- asks for a rigorous proof of the BEGL96 \(\{3,4,7\}\) largest-missing claim;
- quotes the exact Mignotte-Waldschmidt inequality used in BEGL96.

Proof hooks:

- local \(\{3,4,7\}\) certificate explanation;
- communication-quality proof writeup.

Action:

- use as a checklist for making our local certificate explanatory enough for a
  human reader.

### OEIS A327621 and related computational data

Link:

- <https://oeis.org/A327621/internal>

Status for this project: empirical data source only.

Relevance:

- records sums of distinct powers of \(3\) and \(4\) greater than \(1\);
- links BEGL96, Melfi 2001, Hasler-Melfi 2024;
- includes record-gap comments.

Proof hooks:

- gap heuristics;
- modular-gate candidate generation.

Action:

- do not cite as proof; use only for sanity checks and counterexample hunting.

## Priority reading order

1. BEGL96, line-by-line.
2. Bergelson-Simmons 2017.
3. Chen-Fang-Hegyvári 2016.
4. Xue-Fang-Ma 2023.
5. Yu-Chen-Chen 2025.
6. Birch 1959 and Zannier 1989.
7. Cassels 1960.
8. Mignotte-Waldschmidt II and Laurent 1994.
9. finite abelian group subset-sum covering literature.
10. Hasler-Melfi 2024 and Melfi 2001 for \(\{3,4\}\) gap/density context.

## Immediate impact on the project plan

The bibliography changes the next tasks.

The old next step was:

- build `ResidueGateCertificate.hs` immediately.

The better next step is:

1. read Xue-Fang-Ma 2023 and Chen-Fang-Hegyvári 2016 carefully enough to
   extract their residue and interval lemmas;
2. build `ResidueGateCertificate.hs` with terminology compatible with those
   papers, especially quasi-complete residue sets;
3. read Bergelson-Simmons before trying to prove a bespoke central interval
   theorem;
4. only then attempt a new global seed-bridge lemma.

In short: yes, this bibliography sprint is worthwhile.  It identifies a modern
complete-sequence line that is close to our residue-saturation/central-interval
split and should inform the next certificate design.
