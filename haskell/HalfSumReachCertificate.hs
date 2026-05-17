{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate, isInfixOf)
import HalfSumReach
  ( HalfSumReachWitness (..),
    frameTotal,
    halfSumReachEndpoint,
    halfSumReachHalfSum,
    halfSumReachMargin,
    halfSumReachThreshold,
    halfSumReachWholeTotal,
    provesHalfSumReach,
  )
import qualified ResidueGate as RG
import UnitResidueFrame (UnitFrame, mkUnitFrame, unitModulus)

data FrameSpec = FrameSpec
  { frameLabel :: String,
    frameModulusValue :: Int,
    frameBaseValue :: Integer,
    frameExponentStart :: Integer
  }
  deriving stock (Eq, Show)

data SuccessCase = SuccessCase
  { successLabel :: String,
    successFrame :: FrameSpec,
    successQuotientConductor :: Integer,
    successQuotientTotal :: Integer,
    successExpectedThreshold :: Integer,
    successExpectedMargin :: Integer
  }
  deriving stock (Eq, Show)

data FailureCase = FailureCase
  { failureLabel :: String,
    failureFrame :: FrameSpec,
    failureQuotientConductor :: Integer,
    failureQuotientTotal :: Integer
  }
  deriving stock (Eq, Show)

frameSeven6 :: FrameSpec
frameSeven6 =
  FrameSpec
    { frameLabel = "base 7 modulo 6, exponent start 1",
      frameModulusValue = 6,
      frameBaseValue = 7,
      frameExponentStart = 1
    }

frameThree5 :: FrameSpec
frameThree5 =
  FrameSpec
    { frameLabel = "base 3 modulo 5, exponent start 1",
      frameModulusValue = 5,
      frameBaseValue = 3,
      frameExponentStart = 1
    }

successCases :: [SuccessCase]
successCases =
  -- Sums for base 7 mod 6 starting at 1: terms [7,49,343,2401,16807].
  -- Frame total F_tot = 19607, modulus m = 6, ceil(F_tot/m) = 3268.
  [ SuccessCase
      "large quotient total well above threshold"
      frameSeven6
      (-1)
      100000
      -- threshold = 2(c'+1) + ceil(F_tot/m) = 0 + 3268 = 3268
      3268
      -- end = 6 * (100000 - 0) = 600000
      -- whole = 19607 + 600000 = 619607
      -- halfSum = floor(619607/2) = 309803
      -- margin = 600000 - 309803 = 290197
      290197,
    SuccessCase
      "quotient total exactly at threshold"
      frameSeven6
      0
      -- threshold = 2(1) + 3268 = 3270
      3270
      3270
      -- end = 6 * (3270 - 1) = 19614
      -- whole = 19607 + 6 * 3270 = 19607 + 19620 = 39227
      -- halfSum = floor(39227/2) = 19613
      -- margin = 19614 - 19613 = 1
      1,
    SuccessCase
      "positive quotient conductor with base 3 mod 5"
      frameThree5
      10
      -- base 3 mod 5 exponent start 1 has order 4, so termCount = 4,
      -- terms are [3, 3^5, 3^9, 3^13] = [3, 243, 19683, 1594323]
      -- F_tot = 3 + 243 + 19683 + 1594323 = 1614252
      -- m = 5, ceil(F_tot/m) = ceil(1614252 / 5) = 322851
      -- threshold = 2(11) + 322851 = 322873
      400000
      322873
      -- end = 5 * (400000 - 11) = 1999945
      -- whole = 1614252 + 2000000 = 3614252
      -- halfSum = floor(3614252/2) = 1807126
      -- margin = 1999945 - 1807126 = 192819
      192819
  ]

failureCases :: [FailureCase]
failureCases =
  -- Pick a quotient total well below threshold so the parity slack cannot save it.
  [ FailureCase
      "tiny quotient total below threshold rejects"
      frameSeven6
      (-1)
      100
  ]

buildFrame :: FrameSpec -> Either String UnitFrame
buildFrame spec = do
  modulus <- RG.mkModulus (frameModulusValue spec)
  mkUnitFrame modulus (frameBaseValue spec) (frameExponentStart spec)

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

runSuccessCase :: SuccessCase -> Either String String
runSuccessCase item = do
  frame <- buildFrame (successFrame item)
  let modulusValue = toInteger (RG.modulusValue (unitModulus frame))
      total = frameTotal frame
      conductor = successQuotientConductor item
      quotientTotalValue = successQuotientTotal item
      thresholdValue = halfSumReachThreshold frame conductor
      marginValue = halfSumReachMargin frame conductor quotientTotalValue
      endpoint = halfSumReachEndpoint frame conductor quotientTotalValue
      halfSum = halfSumReachHalfSum frame quotientTotalValue
      wholeSum = halfSumReachWholeTotal frame quotientTotalValue
  assertEqual "expected threshold" (successExpectedThreshold item) thresholdValue
  assertEqual "expected margin" (successExpectedMargin item) marginValue
  witness <- provesHalfSumReach frame conductor quotientTotalValue
  assertEqual "witness threshold" thresholdValue (reachThreshold witness)
  assertEqual "witness margin" marginValue (reachMargin witness)
  assertEqual "witness endpoint" endpoint (reachLiftedEnd witness)
  assertEqual "witness half-sum" halfSum (reachHalfSum witness)
  assertEqual "witness whole total" wholeSum (reachWholeSeedTotal witness)
  assertEqual "witness frame total" total (reachFrameTotal witness)
  assertEqual "witness modulus" modulusValue (reachModulus witness)
  pure
    ( intercalate
        "\n"
        [ "case: " <> successLabel item,
          "frame: " <> frameLabel (successFrame item),
          "modulus m: " <> show modulusValue,
          "frame total F_tot: " <> show total,
          "quotient conductor c': " <> show conductor,
          "quotient total S': " <> show quotientTotalValue,
          "threshold S'*: " <> show thresholdValue,
          "lifted endpoint m(S' - c' - 1): " <> show endpoint,
          "whole seed F_tot + mS': " <> show wholeSum,
          "half-sum floor((F_tot + mS')/2): " <> show halfSum,
          "reach margin end - half-sum: " <> show marginValue
        ]
    )

runFailureCase :: FailureCase -> Either String String
runFailureCase item = do
  frame <- buildFrame (failureFrame item)
  let conductor = failureQuotientConductor item
      quotientTotalValue = failureQuotientTotal item
      thresholdValue = halfSumReachThreshold frame conductor
      marginValue = halfSumReachMargin frame conductor quotientTotalValue
  case provesHalfSumReach frame conductor quotientTotalValue of
    Right witness ->
      Left
        ( "expected half-sum reach failure, but obtained margin "
            <> show (reachMargin witness)
        )
    Left err
      | "half-sum reach fails" `isInfixOf` err ->
          pure
            ( intercalate
                "\n"
                [ "case: " <> failureLabel item,
                  "frame: " <> frameLabel (failureFrame item),
                  "quotient conductor c': " <> show conductor,
                  "quotient total S': " <> show quotientTotalValue,
                  "threshold S'*: " <> show thresholdValue,
                  "reach margin: " <> show marginValue,
                  "rejected: " <> err
                ]
            )
      | otherwise -> Left ("unexpected failure reason: " <> err)

-- Sanity check: the threshold inequality matches the explicit half-sum
-- inequality at the boundary.  At S'=threshold the margin should be >= 0; at
-- S'=threshold - 1 it should typically be < 0 (apart from a parity slack of
-- at most one).
runBoundaryCase :: FrameSpec -> Integer -> Either String String
runBoundaryCase spec conductor = do
  frame <- buildFrame spec
  let thresholdValue = halfSumReachThreshold frame conductor
      atThreshold = halfSumReachMargin frame conductor thresholdValue
      justBelow = halfSumReachMargin frame conductor (thresholdValue - 1)
      m = toInteger (RG.modulusValue (unitModulus frame))
  if atThreshold < 0
    then
      Left
        ( "boundary failed: margin at threshold "
            <> show thresholdValue
            <> " was negative ("
            <> show atThreshold
            <> ")"
        )
    else Right ()
  -- The drop from threshold to threshold - 1 reduces 2*margin by m, so the
  -- margin itself drops by m / 2 or (m - 1) / 2 depending on parity.  Either
  -- way it does drop, so justBelow < atThreshold.
  if justBelow >= atThreshold
    then
      Left
        ( "boundary failed: margin did not decrease from "
            <> show atThreshold
            <> " to "
            <> show justBelow
            <> " when dropping below threshold"
        )
    else Right ()
  pure
    ( intercalate
        "\n"
        [ "case: boundary check for " <> frameLabel spec,
          "quotient conductor: " <> show conductor,
          "modulus m: " <> show m,
          "threshold S'*: " <> show thresholdValue,
          "margin at S'*: " <> show atThreshold,
          "margin at S'* - 1: " <> show justBelow
        ]
    )

main :: IO ()
main = do
  mapM_ printReport (map runSuccessCase successCases)
  mapM_ printReport (map runFailureCase failureCases)
  printReport (runBoundaryCase frameSeven6 0)
  printReport (runBoundaryCase frameThree5 5)
  where
    printReport result =
      case result of
        Left err -> error err
        Right report -> putStrLn (report <> "\n")
