{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate)
import System.Environment (getArgs)
import System.Exit (exitFailure)

data Status
  = Certified
  | Imported
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
      "Finite central seed intervals are reproducible for the current small exact-critical and strict profiles.",
    Obligation
      "local residue-bridge profiles"
      Certified
      "Finite seeds cover every residue modulo the exact-critical denominator for the current small exact-critical profiles.",
    Obligation
      "local {3,4,7} and {3,4,9,25} certificates"
      Certified
      "Checked by TailCertificate.hs, CFTailCertificate.hs, and Hasclid scripts.",
    Obligation
      "Mignotte-Waldschmidt input for 3 versus 4"
      Imported
      "Used as an external analytic theorem in the current local certificates.",
    Obligation
      "global seed-bridge theorem"
      Open
      "Need a proof that every admissible finite A,k admits a seed interval large enough to enter the tail argument.",
    Obligation
      "global exact-critical analytic bound"
      Open
      "Need explicit thresholds for arbitrary certified independent base pairs/classes."
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
