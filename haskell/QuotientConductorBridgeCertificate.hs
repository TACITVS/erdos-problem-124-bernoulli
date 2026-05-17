{-# LANGUAGE DerivingStrategies #-}

module Main where

import ConductorLift
  ( ConductorBound (..),
    ScaledCentralBlock (..),
  )
import Data.List (intercalate, isInfixOf)
import GapBridge (intervalEnd, intervalStart)
import QuotientBlockSelection
  ( QuotientSelection (..),
    mkQuotientSelection,
  )
import QuotientConductorBridge
  ( QuotientConductorBridge (..),
    completeSelectedQuotient,
  )
import qualified ResidueGate as RG

data BridgeCase = BridgeCase
  { label :: String,
    modulusValue :: Int,
    frameBaseValue :: Integer,
    exponentFloor :: Integer,
    divisibleBases :: [Integer],
    quotientInitialTotal :: Integer,
    quotientInitialConductor :: Integer,
    termCounts :: [Int],
    expectedQuotientTerms :: [Integer],
    expectedQuotientTotal :: Integer,
    expectedWholeTotal :: Integer,
    expectedLiftedInterval :: (Integer, Integer),
    expectedBoundToHalf :: Integer
  }
  deriving stock (Eq, Show)

data FailureCase = FailureCase
  { failureLabel :: String,
    failureCase :: BridgeCase,
    expectedErrorFragment :: String
  }
  deriving stock (Eq, Show)

successCases :: [BridgeCase]
successCases =
  [ BridgeCase
      "dyadic quotient bridge with perfect quotient seed"
      2
      3
      1
      [4]
      3
      (-1)
      [1]
      [2]
      5
      13
      (3, 10)
      2,
    BridgeCase
      "dyadic quotient bridge with nonzero conductor"
      2
      3
      1
      [4]
      20
      3
      [2]
      [2, 8]
      30
      63
      (11, 52)
      10,
    BridgeCase
      "ternary two-base quotient bridge"
      3
      4
      1
      [3, 9]
      8
      (-1)
      [2, 1]
      [1, 3, 3]
      15
      65
      (20, 45)
      19
  ]

failureCases :: [FailureCase]
failureCases =
  [ FailureCase
      "complete-sequence failure is exposed"
      ( BridgeCase
          "sparse dyadic quotient term from zero"
          2
          3
          1
          [4]
          0
          (-1)
          [1]
          [2]
          2
          7
          (0, 0)
          0
      )
      "exceeds interval capacity",
    FailureCase
      "half-sum reach failure is exposed"
      ( BridgeCase
          "too-small quotient block behind a wide frame"
          3
          4
          1
          [3, 9]
          0
          (-1)
          [1, 0]
          [1]
          1
          23
          (0, 0)
          0
      )
      "empty seed interval"
  ]

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

buildSelection :: BridgeCase -> Either String QuotientSelection
buildSelection item = do
  modulus <- RG.mkModulus (modulusValue item)
  mkQuotientSelection
    modulus
    (frameBaseValue item)
    (exponentFloor item)
    (divisibleBases item)

liftedIntervalShape :: QuotientConductorBridge -> (Integer, Integer)
liftedIntervalShape bridge =
  ( intervalStart (liftedInterval (liftedConductorBound bridge)),
    intervalEnd (liftedInterval (liftedConductorBound bridge))
  )

runSuccessCase :: BridgeCase -> Either String String
runSuccessCase item = do
  selection <- buildSelection item
  bridge <-
    completeSelectedQuotient
      selection
      (quotientInitialTotal item)
      (quotientInitialConductor item)
      (termCounts item)
  assertEqual "quotient terms" (expectedQuotientTerms item) (quotientTermsOrdered bridge)
  assertEqual "quotient total" (expectedQuotientTotal item) (quotientTotal (scaledCentralBlock bridge))
  assertEqual "quotient conductor" (quotientInitialConductor item) (quotientConductor (scaledCentralBlock bridge))
  assertEqual "whole total" (expectedWholeTotal item) (wholeSeedTotal bridge)
  assertEqual "lifted interval" (expectedLiftedInterval item) (liftedIntervalShape bridge)
  assertEqual "bound to half" (expectedBoundToHalf item) (boundToHalf (liftedConductorBound bridge))
  pure
    ( intercalate
        "\n"
        [ "case: " <> label item,
          "modulus: " <> show (modulusValue item),
          "frame base: " <> show (selectionFrameBase selection),
          "divisible bases: " <> show (divisibleBases item),
          "ordered quotient terms: " <> show (quotientTermsOrdered bridge),
          "quotient total: " <> show (quotientTotal (scaledCentralBlock bridge)),
          "quotient conductor: " <> show (quotientConductor (scaledCentralBlock bridge)),
          "whole seed total: " <> show (wholeSeedTotal bridge),
          "lifted interval: " <> show (liftedIntervalShape bridge),
          "certified bound to half: " <> show (boundToHalf (liftedConductorBound bridge))
        ]
    )

runFailureCase :: FailureCase -> Either String String
runFailureCase item = do
  selection <- buildSelection (failureCase item)
  case
    completeSelectedQuotient
      selection
      (quotientInitialTotal (failureCase item))
      (quotientInitialConductor (failureCase item))
      (termCounts (failureCase item)) of
    Right bridge ->
      Left
        ( "expected bridge failure, got lifted interval "
            <> show (liftedIntervalShape bridge)
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
