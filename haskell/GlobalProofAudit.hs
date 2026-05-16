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
      "The remaining qualitative bottleneck: prove c(E) = o(T(E)) in the strict case and c(E) = O(T(E)^(1-epsilon)) in the exact-critical case.",
    Obligation
      "local {3,4,7} and {3,4,9,25} certificates"
      Certified
      "Checked by TailCertificate.hs, CFTailCertificate.hs, and Hasclid scripts.",
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
