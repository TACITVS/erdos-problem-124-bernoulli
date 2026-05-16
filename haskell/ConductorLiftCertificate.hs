{-# LANGUAGE DerivingStrategies #-}

module Main where

import ConductorLift
  ( ConductorBound (..),
    ScaledCentralBlock,
    conductorBoundFromLift,
    mkScaledCentralBlock,
  )
import Data.List (intercalate)
import GapBridge (intervalEnd, intervalStart)
import qualified ResidueGate as RG
import ResidueLift
  ( ResidueFrame,
    frameWidth,
    mkResidueFrame,
  )

data LiftCase = LiftCase
  { label :: String,
    modulusValue :: Int,
    representatives :: [Integer],
    quotientSeedTotal :: Integer,
    quotientSeedConductor :: Integer,
    frameTermTotal :: Integer,
    expectedBound :: Integer
  }
  deriving stock (Eq, Show)

liftCases :: [LiftCase]
liftCases =
  [ LiftCase
      "binary quotient block with {3,4,7} residue frame"
      6
      [0, 7, 14, 3, 4, 11]
      2047
      (-1)
      14
      13,
    LiftCase
      "positive quotient conductor with {3,4,7} residue frame"
      6
      [0, 7, 14, 3, 4, 11]
      1000
      10
      14
      79
  ]

wholeSeedTotal :: LiftCase -> Integer
wholeSeedTotal item =
  frameTermTotal item
    + toInteger (modulusValue item) * quotientSeedTotal item

buildCase :: LiftCase -> Either String (ResidueFrame, ScaledCentralBlock, ConductorBound)
buildCase item = do
  modulus <- RG.mkModulus (modulusValue item)
  frame <- mkResidueFrame modulus (representatives item)
  block <- mkScaledCentralBlock modulus (quotientSeedTotal item) (quotientSeedConductor item)
  bound <- conductorBoundFromLift frame block (wholeSeedTotal item)
  if boundToHalf bound /= expectedBound item
    then
      Left
        ( "conductor bound mismatch: expected "
            <> show (expectedBound item)
            <> ", got "
            <> show (boundToHalf bound)
        )
    else Right (frame, block, bound)

formatCase :: LiftCase -> ResidueFrame -> ConductorBound -> String
formatCase item frame bound =
  intercalate
    "\n"
    [ "case: " <> label item,
      "modulus: " <> show (modulusValue item),
      "frame width R: " <> show (frameWidth frame),
      "quotient total: " <> show (quotientSeedTotal item),
      "quotient conductor: " <> show (quotientSeedConductor item),
      "whole seed total: " <> show (wholeSeedTotal item),
      "whole half-sum: " <> show (wholeHalfSum bound),
      "lifted interval: " <> show (intervalStart interval, intervalEnd interval),
      "certified conductor bound to half: " <> show (boundToHalf bound)
    ]
  where
    interval = liftedInterval bound

runCase :: LiftCase -> Either String String
runCase item = do
  (frame, _, bound) <- buildCase item
  pure (formatCase item frame bound)

main :: IO ()
main =
  mapM_ printCase liftCases
  where
    printCase item =
      case runCase item of
        Left err -> error (label item <> ": " <> err)
        Right report -> putStrLn (report <> "\n")
