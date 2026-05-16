{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate)
import GapBridge
  ( Ray (..),
    SeedInterval,
    TailGapBound (..),
    absorbPrefix,
    bridgeAfterPrefix,
    bridgeToRay,
    intervalEnd,
    intervalSpan,
    intervalStart,
    mkSeedInterval,
    mkTailGapBound,
    requiredGapBound,
  )

data BridgeCase = BridgeCase
  { label :: String,
    seedStart :: Integer,
    seedEnd :: Integer,
    absorbedPrefix :: [Integer],
    checkedGapBound :: Integer,
    source :: String
  }
  deriving stock (Eq, Show)

bridgeCases :: [BridgeCase]
bridgeCases =
  [ BridgeCase
      "binary powers"
      0
      0
      []
      1
      "Known tail fact: P({1,2,4,...}) has consecutive gaps 1.",
    BridgeCase
      "{3,4,5}, k=1 after absorbing first tail term"
      80
      2132
      [1024]
      2187
      "Conditional row: needs tail subset-sum gaps <= 2187 after the prefix.",
    BridgeCase
      "{3,4,7}, k=2 large seed after two prefix terms"
      3982889
      130036004
      [67108864, 129140163]
      268435456
      "Conditional row: needs tail subset-sum gaps <= 268435456 after the prefix.",
    BridgeCase
      "{3,4,9,25}, k=2 large seed without prefix"
      452100
      27868079
      []
      14348907
      "Conditional row: needs tail subset-sum gaps <= 14348907."
  ]

formatCase :: BridgeCase -> SeedInterval -> SeedInterval -> TailGapBound -> Ray -> String
formatCase bridge interval extended gapBound ray =
  let TailGapBound required = requiredGapBound interval
      TailGapBound extendedRequired = requiredGapBound extended
      TailGapBound checked = gapBound
      Ray rayStart = ray
   in
  intercalate
    "\n"
    [ "case: " <> label bridge,
      "seed interval: " <> show (seedStart bridge, seedEnd bridge),
      "span: " <> show (intervalSpan interval),
      "absorbed prefix: " <> show (absorbedPrefix bridge),
      "initial interval capacity: " <> show required,
      "extended interval: " <> show (intervalStart extended, intervalEnd extended),
      "extended interval capacity: " <> show extendedRequired,
      "checked tail gap bound: " <> show checked,
      "conditional ray start: " <> show rayStart,
      "source: " <> source bridge
    ]

runCase :: BridgeCase -> Either String String
runCase bridge = do
  interval <- mkSeedInterval (seedStart bridge) (seedEnd bridge)
  gapBound <- mkTailGapBound (checkedGapBound bridge)
  extended <- absorbPrefix interval (absorbedPrefix bridge)
  ray <-
    if null (absorbedPrefix bridge)
      then bridgeToRay interval gapBound
      else bridgeAfterPrefix interval (absorbedPrefix bridge) gapBound
  pure (formatCase bridge interval extended gapBound ray)

main :: IO ()
main =
  mapM_ printCase bridgeCases
  where
    printCase bridge =
      case runCase bridge of
        Left err -> error (label bridge <> ": " <> err)
        Right report -> putStrLn (report <> "\n")
