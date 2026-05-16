{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate)
import GapBridge
  ( Ray (..),
    SeedInterval,
    TailGapBound (..),
    bridgeToRay,
    intervalSpan,
    mkSeedInterval,
    mkTailGapBound,
    requiredGapBound,
  )

data BridgeCase = BridgeCase
  { label :: String,
    seedStart :: Integer,
    seedEnd :: Integer,
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
      1
      "Known tail fact: P({1,2,4,...}) has consecutive gaps 1.",
    BridgeCase
      "{3,4,5}, k=1 strict seed interval"
      80
      2132
      2053
      "Capacity row only: this is the gap bound needed from a tail theorem.",
    BridgeCase
      "{3,4,7}, k=1 exact-critical seed interval"
      582
      1249
      668
      "Capacity row only: this is the gap bound needed from a tail theorem.",
    BridgeCase
      "{3,4,7}, k=2 small seed interval"
      1415
      1426
      12
      "Capacity row only: this is the gap bound needed from a tail theorem."
  ]

formatCase :: BridgeCase -> SeedInterval -> TailGapBound -> Ray -> String
formatCase bridge interval gapBound ray =
  let TailGapBound required = requiredGapBound interval
      TailGapBound checked = gapBound
      Ray rayStart = ray
   in
  intercalate
    "\n"
    [ "case: " <> label bridge,
      "seed interval: " <> show (seedStart bridge, seedEnd bridge),
      "span: " <> show (intervalSpan interval),
      "required tail gap bound: " <> show required,
      "checked tail gap bound: " <> show checked,
      "conditional ray start: " <> show rayStart,
      "source: " <> source bridge
    ]

runCase :: BridgeCase -> Either String String
runCase bridge = do
  interval <- mkSeedInterval (seedStart bridge) (seedEnd bridge)
  gapBound <- mkTailGapBound (checkedGapBound bridge)
  ray <- bridgeToRay interval gapBound
  pure (formatCase bridge interval gapBound ray)

main :: IO ()
main =
  mapM_ printCase bridgeCases
  where
    printCase bridge =
      case runCase bridge of
        Left err -> error (label bridge <> ": " <> err)
        Right report -> putStrLn (report <> "\n")
