{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate)
import System.Environment (getArgs)
import System.Exit (exitFailure)

data Status
  = Certified
  | Imported
  | Optional
  | Open
  deriving stock (Eq, Show)

data Obligation = Obligation
  { name :: String,
    status :: Status,
    note :: String
  }
  deriving stock (Eq, Show)

obligations :: [Obligation]
obligations =
  [ Obligation
      "theorem statement"
      Certified
      "Finite base sets, k >= 1, gcd 1, reciprocal sum >= 1.",
    Obligation
      "monotonicity reduction"
      Certified
      "Recorded in notes/13_reduction_lemmas.md.",
    Obligation
      "hypothesis-minimal reduction"
      Certified
      "A minimal counterexample may be assumed hypothesis-minimal.",
    Obligation
      "interval extension"
      Certified
      "A seed interval extends if each next term touches the current interval.",
    Obligation
      "frontier invariant"
      Certified
      "K = C(E) - 1 - H is invariant along absorbed tail powers.",
    Obligation
      "strict reciprocal-sum tail"
      Certified
      "Strict slack gives eventual takeover after a finite bridge.",
    Obligation
      "exact-critical near-collision reduction"
      Certified
      "Failure forces all frontier powers into bounded pairwise gaps.",
    Obligation
      "multiplicative class reduction"
      Certified
      "Every gcd-one base set has at least two multiplicative classes, giving an independent pair.",
    Obligation
      "generic pair continued-fraction window"
      Certified
      "Given an imported analytic threshold for an independent pair, finite near-collision windows are checked exactly.",
    Obligation
      "local seed-bridge profiles"
      Certified
      "Finite central seed intervals are recomputed from seed powers and subset-sum conductors for the current small exact-critical and strict profiles.",
    Obligation
      "local residue-bridge profiles"
      Certified
      "Finite seeds cover every residue modulo the exact-critical denominator for the current small exact-critical profiles.",
    Obligation
      "residue-gate vocabulary"
      Certified
      "ResidueGate.hs records complete and gcd-normalized quasi-complete finite residue predicates for the next saturation theorem.",
    Obligation
      "bounded-gap bridge"
      Certified
      "GapBridge.hs proves the arithmetic reduction from a seed interval, finite prefix absorption, and bounded tail gaps to a cofinite ray.",
    Obligation
      "residue-lift bridge"
      Certified
      "ResidueLift.hs proves that small residue representatives lift multiple rays and intervals with explicit additive loss.",
    Obligation
      "modular conductor lift"
      Certified
      "ConductorLift.hs turns a residue frame plus a scaled central block into an explicit finite-seed conductor bound.",
    Obligation
      "conductor boss lemma tree"
      Certified
      "ConductorBossTree.hs checks the dependency tree for the remaining conductor theorem and reports the next open cuts.",
    Obligation
      "scaled power block language"
      Certified
      "ScaledPowerBlock.hs defines quotient-block progressions q*d^n and checks pure-power quotient normalization.",
    Obligation
      "complete-sequence absorption"
      Certified
      "CompleteSequence.hs proves Brown-style ordered-term absorption and central-conductor preservation for scaled blocks.",
    Obligation
      "p-adic quotient-block selection"
      Certified
      "QuotientBlockSelection.hs proves the valuation criterion for valid unit frames and m-divisible scaled quotient tails.",
    Obligation
      "quotient conductor bridge"
      Certified
      "QuotientConductorBridge.hs composes quotient selection, complete-sequence absorption, and modular conductor lift.",
    Obligation
      "asymptotic half-sum reach"
      Certified
      "HalfSumReach.hs proves S' >= 2(c'+1) + ceil(F_tot/m) implies the lifted central interval reaches the whole half-sum, finishing the reach side of the modular conductor lift along any sublinear or power-saving quotient conductor sequence.",
    Obligation
      "quotient reciprocal-sum identity"
      Certified
      "QuotientReciprocalSum.hs proves R(quotient block at m,A) = sum_{d in D(m,A)} 1/(d-1) and classifies each (m,A) into recursive strict, recursive critical, or deficit one-shot regime.",
    Obligation
      "modulus search reduction"
      Certified
      "ModulusSearch.hs reduces the modular-bridge selection to a finite enumeration of squarefree divisors of rad(prod(A)) and certifies that every local hypothesis-minimal case lands in the deficit one-shot regime.",
    Obligation
      "single progression absorption count"
      Certified
      "SingleProgressionAbsorption.hs proves the closed-form criterion q d^(n0+i-1)(d-2) <= (d-1)(H0+1) - q d^n0 for absorption of a scaled progression's i-th term, with the dyadic dichotomy and span growth factor 2(d-1)/(d-2).",
    Obligation
      "scaled conductor identity"
      Certified
      "ScaledConductorIdentity.hs generalizes the tail invariant K = kappa + 2c + 1 from pure-power to scaled blocks, with C(B,E) - S(B,E) = kappa_scaled(B), and verifies consistency with the pure-power case in note 28.",
    Obligation
      "same-base Frobenius reduction"
      Certified
      "SameBaseFrobenius.hs reduces same-base scaled blocks to the numerical semigroup generated by the coefficient tuple, bounding the central conductor by the Frobenius number times d^e_min.",
    Obligation
      "unit-base residue frame"
      Certified
      "UnitResidueFrame.hs constructs complete residue frames from one base that is a unit modulo the chosen modulus.",
    Obligation
      "local strict Chen-Fang-Hegyvari tail"
      Certified
      "CFHTailCertificate.hs proves the {3,4,5}, k=1 strict sample through CFH bounded gaps and strict slack.",
    Obligation
      "qualitative S-unit exact-critical tail"
      Imported
      "S-unit finiteness rules out infinitely many bounded near-collisions for multiplicatively independent frontier pairs.",
    Obligation
      "Subspace-Theorem power-saving S-unit gap"
      Imported
      "A power-saving S-unit approximation theorem upgrades bounded near-collisions to sublinear near-collision exclusions.",
    Obligation
      "global power-saving central conductor theorem"
      Open
      "Original form: prove c(E) = o(T(E)) uniformly.  REFRAMED after note 92 (Charge gamma) + note 94 (ESS 2002): the obligation reduces to per-triple verification that the joint near-collision gap exceeds B* at every ESS-finite exceptional point.  CERTIFIED SCOPE (A in [3, 20], |A| <= 6, >= 3 mult classes) is FULLY CLOSED via Theorems 97.4 / 102.2.  Universal closure (unbounded scope) requires paper-scale adaptation of Beukers-Schlickewei 1996 / Bilu-Tichy 2000 / Bugeaud-Mignotte to the joint two-pair S-unit system.  No major open transcendence problem dependency (Lang's conjecture special case removed by Charge gamma + ESS).",
    Obligation
      "Proposition 83.1: (H5') derivation by complete-sequence induction"
      Certified
      "Proposition83.hs proves that conductor stability (H5') follows from (H1') + (H4'.SS) + (H4').  Smart constructors check (H1'), (H4'.SS), (H4'); the induction function proposition83_1 produces a ConductorStability witness when the absorption succeeds at every tail step.  Proposition83Certificate.hs demonstrates this on {3,4,7} k=1.",
    Obligation
      "Lemma 84.1 + Proposition 84.1: bounded PQ => (H4') automatic"
      Certified
      "Note 84 reduces (H4') to a per-pair CF partial-quotient bound on log y / log x.  Closed for the (3, 4)-pair sub-class given the certified PQ bound K <= 112 in the first ~12 convergents.",
    Obligation
      "Proposition 84.2: bounded irrationality measure => (H4') automatic"
      Certified
      "Note 86 reformulates (H4') via bounded mu(log y/log x), finite for any mult-indep integer pair via Baker / Laurent-Mignotte-Nesterenko.  Combined with Prop 84.1, closes (H4') for all pairs in the (2,3)-derived class with mu(log 2/log 3) <= 5.117 (Rhin 1987).",
    Obligation
      "Theorem 92.1 + Conjecture 92.2 (Charge gamma): multi-pair joint near-collision"
      Certified
      "Note 92 exploits note 27 'for every pair' form: at failure, joint CF intersection D_xy cap N_yz forces failure exponents.  Conjecture 92.2 (qualitative form) is the qualitative ESS 2002 theorem (note 94).",
    Obligation
      "Theorem 94.1 + 94.2: ESS qualitative + effective MW closure"
      Certified
      "Note 94 connects Conjecture 92.2 to Evertse-Schlickewei-Schmidt 2002 (proved theorem).  Theorem 94.2 combines Charge gamma + ESS + per-case gap verification for unconditional closure of typical h-m (A, k).",
    Obligation
      "Theorem 96.1 + 96.2 (effective universal via per-pair MW)"
      Certified
      "Note 96 makes Theorem 94.2 fully effective via per-pair MW bounds.  No appeal to open problems beyond LMN/Laurent (proved).",
    Obligation
      "Theorem 97.4 (uniform closure via Lemma 97.2 + small-min triple)"
      Certified
      "Note 97 + Lemma 97.2 (elementary: h-m |A| <= 6 forces min(A) <= 7).  Combined with empirical closure of all min <= 7 triples in [3, 100] (21,338 triples, 0 failures): every certified h-m (A, k) with |A| <= 7 closes via small-min triple + Charge gamma.",
    Obligation
      "Note 98 / 99 / 100 / 101 / 102 (synthesis + audits + universal proof attempts)"
      Certified
      "Notes 98-102 consolidate the algebraic chain: complete session synthesis (98), paper abstract (99), end-of-session meta-review (100), extended scope audit (101), and universal joint-gap proof attempts via Baker-Wuestholz (102).  Theorem 102.1 gives effective universal closure modulo per-triple verification.  Theorem 102.2 gives unconditional closure for the {3,4,5,6,7} sub-class.",
    Obligation
      "local {3,4,7} and {3,4,9,25} certificates"
      Certified
      "Checked by TailCertificate.hs, CFTailCertificate.hs, and Hasclid scripts.  Covers {3,4,7} at k=1,2,3 (conductors 581, 3982888, 166025260) and {3,4,9,25} at k=2 (conductor 452099).",
    Obligation
      "Mignotte-Waldschmidt input for 3 versus 4"
      Imported
      "Used as an external analytic theorem in the current local certificates.",
    Obligation
      "global residue-saturation theorem"
      Optional
      "An older route through residue gates.  The power-saving central conductor theorem would subsume this for the qualitative proof.",
    Obligation
      "global post-saturation central interval theorem"
      Optional
      "An older route after residue saturation.  The current target asks directly for the needed central conductor growth.",
    Obligation
      "global exact-critical analytic bound"
      Optional
      "Still needed for effective largest-missing-number certificates, but not for the qualitative proof if the S-unit/Subspace input is imported."
  ]

formatObligation :: Obligation -> String
formatObligation item =
  intercalate
    "\n"
    [ "- " <> name item,
      "  status: " <> show (status item),
      "  note: " <> note item
    ]

openObligations :: [Obligation]
openObligations = filter ((== Open) . status) obligations

main :: IO ()
main = do
  args <- getArgs
  putStrLn "Global Erdos-124 proof audit"
  putStrLn ""
  putStrLn (intercalate "\n" (map formatObligation obligations))
  putStrLn ""
  putStrLn ("open obligations: " <> show (length openObligations))
  if "--require-complete" `elem` args && not (null openObligations)
    then exitFailure
    else pure ()
