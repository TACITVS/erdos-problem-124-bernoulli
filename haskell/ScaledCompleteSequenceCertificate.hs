{-# LANGUAGE DerivingStrategies #-}

module Main where

import CompleteSequence
  ( CentralConductorExtension (..),
    CompleteSequenceCertificate (..),
    completeSequenceFromZero,
    extendCentralConductor,
  )
import Data.List (intercalate, isInfixOf)
import GapBridge (intervalEnd, intervalStart)
import ScaledPowerBlock
  ( ScaledBlock,
    mkScaledBlock,
    mkScaledProgression,
    scaledBlockTermsByCounts,
  )

data ProgressionSpec = ProgressionSpec
  { coeffValue :: Integer,
    baseValue :: Integer,
    exponentStartValue :: Integer
  }
  deriving stock (Eq, Show)

data BlockCase = BlockCase
  { label :: String,
    originalTotal :: Integer,
    originalConductor :: Integer,
    specs :: [ProgressionSpec],
    counts :: [Int],
    expectedTerms :: [Integer],
    expectedNewTotal :: Integer,
    expectedInterval :: (Integer, Integer)
  }
  deriving stock (Eq, Show)

successCases :: [BlockCase]
successCases =
  [ BlockCase
      "binary complete sequence from zero"
      0
      (-1)
      [ProgressionSpec 1 2 0]
      [8]
      [1, 2, 4, 8, 16, 32, 64, 128]
      255
      (0, 255),
    BlockCase
      "two-scale dyadic block from zero"
      0
      (-1)
      [ProgressionSpec 1 2 0, ProgressionSpec 3 2 0]
      [5, 4]
      [1, 2, 3, 4, 6, 8, 12, 16, 24]
      76
      (0, 76),
    BlockCase
      "shifted dyadic block preserves a perfect seed interval"
      3
      (-1)
      [ProgressionSpec 1 2 2]
      [5]
      [4, 8, 16, 32, 64]
      127
      (0, 127),
    BlockCase
      "nonzero conductor preserved by touching scaled terms"
      20
      3
      [ProgressionSpec 13 2 0]
      [2]
      [13, 26]
      59
      (4, 55)
  ]

failureCase :: BlockCase
failureCase =
  BlockCase
    "gap detected for sparse ternary scaled block"
    0
    (-1)
    [ProgressionSpec 3 3 0]
    [2]
    [3, 9]
    12
    (0, 12)

buildBlock :: [ProgressionSpec] -> Either String ScaledBlock
buildBlock items = do
  progressions <-
    mapM
      ( \item ->
          mkScaledProgression
            (coeffValue item)
            (baseValue item)
            (exponentStartValue item)
      )
      items
  mkScaledBlock progressions

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

extensionInterval :: CentralConductorExtension -> (Integer, Integer)
extensionInterval extension =
  ( intervalStart (extendedCentralInterval extension),
    intervalEnd (extendedCentralInterval extension)
  )

runSuccessCase :: BlockCase -> Either String String
runSuccessCase item = do
  block <- buildBlock (specs item)
  terms <- scaledBlockTermsByCounts block (counts item)
  assertEqual "ordered scaled terms" (expectedTerms item) terms
  extension <- extendCentralConductor (originalTotal item) (originalConductor item) terms
  assertEqual "new total" (expectedNewTotal item) (newTotal extension)
  assertEqual "central interval" (expectedInterval item) (extensionInterval extension)
  assertEqual "ordered extension terms" (expectedTerms item) (extraTermsOrdered extension)
  pure
    ( intercalate
        "\n"
        [ "case: " <> label item,
          "seed total: " <> show (seedTotal extension),
          "conductor bound: " <> show (conductorBound extension),
          "absorbed terms: " <> show terms,
          "new total: " <> show (newTotal extension),
          "extended central interval: " <> show (extensionInterval extension)
        ]
    )

runFailureCase :: BlockCase -> Either String String
runFailureCase item = do
  block <- buildBlock (specs item)
  terms <- scaledBlockTermsByCounts block (counts item)
  assertEqual "failure terms" (expectedTerms item) terms
  case extendCentralConductor (originalTotal item) (originalConductor item) terms of
    Right extension ->
      Left
        ( "expected a gap failure, but obtained "
            <> show (extensionInterval extension)
        )
    Left err
      | "exceeds interval capacity" `isInfixOf` err ->
          Right
            ( intercalate
                "\n"
                [ "case: " <> label item,
                  "absorbed terms: " <> show terms,
                  "rejected: " <> err
                ]
            )
      | otherwise -> Left ("unexpected failure reason: " <> err)

runDirectBrownCase :: Either String String
runDirectBrownCase = do
  certificate <- completeSequenceFromZero [8, 1, 4, 2]
  assertEqual "ordered direct terms" [1, 2, 4, 8] (orderedTerms certificate)
  assertEqual
    "direct interval"
    (0, 15)
    ( intervalStart (finalInterval certificate),
      intervalEnd (finalInterval certificate)
    )
  pure
    ( intercalate
        "\n"
        [ "case: direct Brown ordering sanity check",
          "source terms: " <> show (sourceTerms certificate),
          "ordered terms: " <> show (orderedTerms certificate),
          "absorbed total: " <> show (absorbedTotal certificate),
          "final interval: "
            <> show
              ( intervalStart (finalInterval certificate),
                intervalEnd (finalInterval certificate)
              )
        ]
    )

main :: IO ()
main = do
  mapM_ printReport (map runSuccessCase successCases)
  printReport (runFailureCase failureCase)
  printReport runDirectBrownCase
  where
    printReport result =
      case result of
        Left err -> error err
        Right report -> putStrLn (report <> "\n")
