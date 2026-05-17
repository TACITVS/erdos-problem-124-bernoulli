{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate, isInfixOf)
import qualified ResidueGate as RG
import ResidueLift (frameWidth)
import QuotientBlockSelection
  ( DivisibleProgression (..),
    QuotientSelection (..),
    firstDivisibleExponent,
    mkQuotientSelection,
  )
import ScaledPowerBlock
  ( ScaledProgression (..),
    scaledBlockTermsByCounts,
  )
import UnitResidueFrame (UnitFrame (..))

data SelectionCase = SelectionCase
  { label :: String,
    modulusValue :: Int,
    frameBaseValue :: Integer,
    exponentFloor :: Integer,
    divisibleBases :: [Integer],
    termCounts :: [Int],
    expectedStarts :: [Integer],
    expectedProgressions :: [(Integer, Integer, Integer)],
    expectedTerms :: [Integer]
  }
  deriving stock (Eq, Show)

data FailureCase = FailureCase
  { failureLabel :: String,
    failureModulusValue :: Int,
    failureFrameBase :: Integer,
    failureExponentFloor :: Integer,
    failureDivisibleBases :: [Integer],
    expectedErrorFragment :: String
  }
  deriving stock (Eq, Show)

successCases :: [SelectionCase]
successCases =
  [ SelectionCase
      "prime modulus cut: {3,4,7}, k=1, m=2"
      2
      3
      1
      [4]
      [4]
      [1]
      [(2, 4, 0)]
      [2, 8, 32, 128],
    SelectionCase
      "two quotient bases: {3,4,9,25}, k=1, m=3"
      3
      4
      1
      [3, 9]
      [4, 3]
      [1, 1]
      [(1, 3, 0), (3, 9, 0)]
      [1, 3, 3, 9, 27, 27, 243],
    SelectionCase
      "composite modulus cut: bases 6 and 12 modulo 6"
      6
      5
      2
      [6, 12]
      [3, 2]
      [2, 2]
      [(6, 6, 0), (24, 12, 0)]
      [6, 24, 36, 216, 288],
    SelectionCase
      "valuation lift: base 12 needs exponent 2 modulo 8"
      8
      5
      1
      [12]
      [3]
      [2]
      [(18, 12, 0)]
      [18, 216, 2592]
  ]

failureCases :: [FailureCase]
failureCases =
  [ FailureCase
      "frame base must be a unit"
      2
      4
      1
      [4]
      "is not a unit",
    FailureCase
      "divisible base must contain every modulus prime"
      2
      3
      1
      [3]
      "missing modulus prime 2"
  ]

progressionShape :: ScaledProgression -> (Integer, Integer, Integer)
progressionShape progression =
  (coefficient progression, base progression, exponentStart progression)

assertEqual :: (Eq value, Show value) => String -> value -> value -> Either String ()
assertEqual name expected actual
  | expected == actual = Right ()
  | otherwise =
      Left
        ( name
            <> " mismatch: expected "
            <> show expected
            <> ", got "
            <> show actual
        )

runSuccessCase :: SelectionCase -> Either String String
runSuccessCase item = do
  modulus <- RG.mkModulus (modulusValue item)
  selection <-
    mkQuotientSelection
      modulus
      (frameBaseValue item)
      (exponentFloor item)
      (divisibleBases item)
  let progressions = selectionDivisibleProgressions selection
      starts = map startExponent progressions
      shapes = map (progressionShape . scaledProgression) progressions
  assertEqual "start exponents" (expectedStarts item) starts
  assertEqual "progression shapes" (expectedProgressions item) shapes
  quotientTerms <- scaledBlockTermsByCounts (selectionQuotientBlock selection) (termCounts item)
  assertEqual "quotient terms" (expectedTerms item) quotientTerms
  mapM_
    ( \(baseValue, expectedStart) -> do
        actualStart <-
          firstDivisibleExponent
            (toInteger (modulusValue item))
            (exponentFloor item)
            baseValue
        assertEqual ("first divisible exponent for base " <> show baseValue) expectedStart actualStart
    )
    (zip (divisibleBases item) (expectedStarts item))
  pure
    ( intercalate
        "\n"
        [ "case: " <> label item,
          "modulus: " <> show (modulusValue item),
          "frame base: " <> show (selectionFrameBase selection),
          "frame term count: " <> show (length (unitTerms (selectionUnitFrame selection))),
          "frame width R: " <> show (frameWidth (unitFrame (selectionUnitFrame selection))),
          "divisible bases: " <> show (map originalBase progressions),
          "start exponents: " <> show starts,
          "quotient progressions: " <> show shapes,
          "sample quotient terms: " <> show quotientTerms
        ]
    )

runFailureCase :: FailureCase -> Either String String
runFailureCase item = do
  modulus <- RG.mkModulus (failureModulusValue item)
  case
    mkQuotientSelection
      modulus
      (failureFrameBase item)
      (failureExponentFloor item)
      (failureDivisibleBases item) of
    Right selection ->
      Left
        ( "expected selection failure, got "
            <> show (selectionDivisibleProgressions selection)
        )
    Left err
      | expectedErrorFragment item `isInfixOf` err ->
          Right
            ( intercalate
                "\n"
                [ "case: " <> failureLabel item,
                  "rejected: " <> err
                ]
            )
      | otherwise -> Left ("unexpected failure reason: " <> err)

main :: IO ()
main = do
  mapM_ printReport (map runSuccessCase successCases)
  mapM_ printReport (map runFailureCase failureCases)
  where
    printReport result =
      case result of
        Left err -> error err
        Right report -> putStrLn (report <> "\n")
