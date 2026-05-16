{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate)
import FiniteSeed (powersUpTo)
import ResidueGate
  ( Coverage (..),
    Modulus,
    completeResidueSet,
    coverageName,
    missingResiduesInMask,
    mkModulus,
    modulusValue,
    quasiCompleteResidueMask,
    quasiCompleteResidueWitness,
    residueMaskFromIntegers,
    residueValue,
    residuesInMask,
    subsetSumResidueMask,
    witnessGcd,
  )

data GateSource
  = ExplicitWitness [Integer]
  | SubsetSumTerms [Integer]
  deriving stock (Eq, Show)

data GateCase = GateCase
  { gateLabel :: String,
    gateModulusValue :: Int,
    gateCoverage :: Coverage,
    gateSource :: GateSource
  }
  deriving stock (Eq, Show)

gateCases :: [GateCase]
gateCases =
  [ GateCase
      "Xue-Fang-Ma style witness: {2,4,6} modulo 3"
      3
      QuasiCompleteWitness
      (ExplicitWitness [2, 4, 6]),
    GateCase
      "binary digit seed: P({1}) modulo 2"
      2
      CompleteResidues
      (SubsetSumTerms [1]),
    GateCase
      "{3,4,7}, k=1 seed powers <= 1000 modulo 6"
      6
      CompleteResidues
      (SubsetSumTerms (powersUpTo [3, 4, 7] 1 1000)),
    GateCase
      "{3,4,9,25}, k=2 seed powers <= 4000 modulo 24"
      24
      CompleteResidues
      (SubsetSumTerms (powersUpTo [3, 4, 9, 25] 2 4000))
  ]

sourceMask :: Modulus -> GateSource -> Integer
sourceMask modulus source =
  case source of
    ExplicitWitness values -> residueMaskFromIntegers modulus values
    SubsetSumTerms terms -> subsetSumResidueMask modulus terms

coverageMask :: Coverage -> Modulus -> GateSource -> Either String Integer
coverageMask coverage modulus source =
  case (coverage, source) of
    (CompleteResidues, _) -> Right (sourceMask modulus source)
    (QuasiCompleteWitness, ExplicitWitness values) ->
      case quasiCompleteResidueMask modulus values of
        Nothing -> Left "wrong-size, empty, or zero quasi-complete witness"
        Just mask -> Right mask
    (QuasiCompleteWitness, SubsetSumTerms _) ->
      Left "quasi-complete witness target needs explicit witness integers"

sourceTermCount :: GateSource -> Int
sourceTermCount source =
  case source of
    ExplicitWitness values -> length values
    SubsetSumTerms terms -> length terms

sourceGcdText :: GateSource -> String
sourceGcdText source =
  case source of
    ExplicitWitness values -> maybe "none" show (witnessGcd values)
    SubsetSumTerms _ -> "not applicable"

formatResidues :: [Int] -> String
formatResidues residues =
  "[" <> intercalate ", " (map show residues) <> "]"

runGateCase :: GateCase -> Either String String
runGateCase gate = do
  modulus <- mkModulus (gateModulusValue gate)
  mask <- coverageMask (gateCoverage gate) modulus (gateSource gate)
  let rawMask = sourceMask modulus (gateSource gate)
      covered = map residueValue (residuesInMask modulus mask)
      missing = map residueValue (missingResiduesInMask modulus mask)
      witnessOk =
        case (gateCoverage gate, gateSource gate) of
          (QuasiCompleteWitness, ExplicitWitness values) -> quasiCompleteResidueWitness modulus values
          _ -> completeResidueSet modulus rawMask
  if witnessOk
    then
      Right
        ( intercalate
            "\n"
            [ "case: " <> gateLabel gate,
              "modulus: " <> show (modulusValue modulus),
              "coverage target: " <> coverageName (gateCoverage gate),
              "source terms/residues: " <> show (sourceTermCount (gateSource gate)),
              "source gcd: " <> sourceGcdText (gateSource gate),
              "covered residues: " <> formatResidues covered,
              "missing for target: " <> formatResidues missing
            ]
        )
    else
      Left
        ( gateLabel gate
            <> ": missing residues for "
            <> coverageName (gateCoverage gate)
            <> " "
            <> formatResidues missing
        )

main :: IO ()
main =
  mapM_ printGate gateCases
  where
    printGate gate =
      case runGateCase gate of
        Left err -> error err
        Right report -> putStrLn (report <> "\n")
