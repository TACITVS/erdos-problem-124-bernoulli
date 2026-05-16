{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate)
import qualified FiniteSeed as FS
import GapBridge (Ray (..), intervalEnd, intervalStart)
import qualified ResidueGate as RG
import ResidueLift
  ( MultipleInterval,
    MultipleRay,
    ResidueFrame,
    frameRepresentatives,
    frameWidth,
    liftMultipleInterval,
    liftMultipleRay,
    mkMultipleInterval,
    mkMultipleRay,
    mkResidueFrame,
  )

data LiftCase = LiftCase
  { label :: String,
    modulusValue :: Int,
    seedTerms :: [Integer],
    multipleStart :: Integer,
    multipleIntervalStartValue :: Integer,
    multipleIntervalEndValue :: Integer
  }
  deriving stock (Eq, Show)

liftCases :: [LiftCase]
liftCases =
  [ LiftCase
      "{3,4,7}, k=1 denominator residue frame"
      6
      (FS.powersUpTo [3, 4, 7] 1 1000)
      6000
      6000
      6060,
    LiftCase
      "{3,4,9,25}, k=2 denominator residue frame"
      24
      (FS.powersUpTo [3, 4, 9, 25] 2 4000)
      24000
      24000
      24720
  ]

completeRepresentatives :: Int -> [Integer] -> Either String [Integer]
completeRepresentatives modulus terms =
  case sequence (FS.minimalResidueRepresentatives modulus terms) of
    Nothing -> Left ("seed is not residue-complete modulo " <> show modulus)
    Just representatives -> Right representatives

buildCase ::
  LiftCase ->
  Either String (ResidueFrame, MultipleRay, MultipleInterval, Ray)
buildCase item = do
  modulus <- RG.mkModulus (modulusValue item)
  representatives <- completeRepresentatives (modulusValue item) (seedTerms item)
  frame <- mkResidueFrame modulus representatives
  multipleRay <- mkMultipleRay modulus (multipleStart item)
  multipleInterval <-
    mkMultipleInterval
      modulus
      (multipleIntervalStartValue item)
      (multipleIntervalEndValue item)
  liftedRay <- liftMultipleRay frame multipleRay
  pure (frame, multipleRay, multipleInterval, liftedRay)

formatCase :: LiftCase -> ResidueFrame -> MultipleInterval -> Ray -> Either String String
formatCase item frame multipleInterval liftedRay = do
  liftedInterval <- liftMultipleInterval frame multipleInterval
  let Ray rayStartValue = liftedRay
  pure
    ( intercalate
        "\n"
        [ "case: " <> label item,
          "modulus: " <> show (modulusValue item),
          "representatives: " <> show (frameRepresentatives frame),
          "representative bound R: " <> show (frameWidth frame),
          "multiple ray start: " <> show (multipleStart item),
          "lifted integer ray start: " <> show rayStartValue,
          "multiple interval: " <> show (multipleIntervalStartValue item, multipleIntervalEndValue item),
          "lifted integer interval: " <> show (intervalStart liftedInterval, intervalEnd liftedInterval)
        ]
    )

runCase :: LiftCase -> Either String String
runCase item = do
  (frame, _, multipleInterval, liftedRay) <- buildCase item
  formatCase item frame multipleInterval liftedRay

main :: IO ()
main =
  mapM_ printCase liftCases
  where
    printCase item =
      case runCase item of
        Left err -> error (label item <> ": " <> err)
        Right report -> putStrLn (report <> "\n")
