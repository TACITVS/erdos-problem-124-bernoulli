{-# LANGUAGE DerivingStrategies #-}

module ScaledPowerBlock
  ( ScaledProgression (..),
    ScaledBlock (..),
    mkScaledProgression,
    mkScaledBlock,
    scaledTermAt,
    scaledTermsByCount,
    scaledTermsUpTo,
    scaledBlockTermsByCounts,
    scaledBlockTermsUpTo,
    scaledBlockTotal,
    quotientPurePowerProgression,
    quotientPurePowerTerms,
    progressionTotal,
    progressionFrontierAfterCount,
  )
where

import Control.Monad (zipWithM)
import Data.List (sort)

data ScaledProgression = ScaledProgression
  { coefficient :: Integer,
    base :: Integer,
    exponentStart :: Integer
  }
  deriving stock (Eq, Show)

newtype ScaledBlock = ScaledBlock
  { blockProgressions :: [ScaledProgression]
  }
  deriving stock (Eq, Show)

mkScaledProgression :: Integer -> Integer -> Integer -> Either String ScaledProgression
mkScaledProgression coeff baseValue start
  | coeff <= 0 = Left ("coefficient must be positive, got " <> show coeff)
  | baseValue <= 1 = Left ("base must be at least 2, got " <> show baseValue)
  | start < 0 = Left ("exponent start must be nonnegative, got " <> show start)
  | otherwise =
      Right
        ScaledProgression
          { coefficient = coeff,
            base = baseValue,
            exponentStart = start
          }

mkScaledBlock :: [ScaledProgression] -> Either String ScaledBlock
mkScaledBlock progressions
  | null progressions = Left "scaled block must contain at least one progression"
  | otherwise = Right (ScaledBlock progressions)

scaledTermAt :: ScaledProgression -> Integer -> Either String Integer
scaledTermAt progression offset
  | offset < 0 = Left ("offset must be nonnegative, got " <> show offset)
  | otherwise =
      Right
        ( coefficient progression
            * base progression ^ (exponentStart progression + offset)
        )

scaledTermsByCount :: ScaledProgression -> Int -> Either String [Integer]
scaledTermsByCount progression count
  | count < 0 = Left ("term count must be nonnegative, got " <> show count)
  | otherwise = mapM (scaledTermAt progression . toInteger) [0 .. count - 1]

scaledTermsUpTo :: ScaledProgression -> Integer -> [Integer]
scaledTermsUpTo progression limit =
  takeWhile
    (<= limit)
    [ coefficient progression * base progression ^ powerIndex
      | powerIndex <- [exponentStart progression ..]
    ]

scaledBlockTermsByCounts :: ScaledBlock -> [Int] -> Either String [Integer]
scaledBlockTermsByCounts block counts
  | length progressions /= length counts =
      Left
        ( "progression/count length mismatch: "
            <> show (length progressions, length counts)
        )
  | otherwise = do
      termsByProgression <- zipWithM scaledTermsByCount progressions counts
      Right (sort (concat termsByProgression))
  where
    progressions = blockProgressions block

scaledBlockTermsUpTo :: ScaledBlock -> Integer -> [Integer]
scaledBlockTermsUpTo block limit =
  sort (concatMap (`scaledTermsUpTo` limit) (blockProgressions block))

scaledBlockTotal :: ScaledBlock -> [Int] -> Either String Integer
scaledBlockTotal block counts =
  sum <$> scaledBlockTermsByCounts block counts

quotientPurePowerProgression ::
  Integer ->
  Integer ->
  Integer ->
  Either String ScaledProgression
quotientPurePowerProgression modulus baseValue pureExponentStart
  | modulus <= 0 = Left ("modulus must be positive, got " <> show modulus)
  | baseValue <= 1 = Left ("base must be at least 2, got " <> show baseValue)
  | pureExponentStart < 0 =
      Left ("pure exponent start must be nonnegative, got " <> show pureExponentStart)
  | firstTerm `mod` modulus /= 0 =
      Left
        ( "first pure power "
            <> show firstTerm
            <> " is not divisible by modulus "
            <> show modulus
        )
  | otherwise =
      mkScaledProgression (firstTerm `div` modulus) baseValue 0
  where
    firstTerm = baseValue ^ pureExponentStart

quotientPurePowerTerms ::
  Integer ->
  Integer ->
  Integer ->
  Int ->
  Either String [Integer]
quotientPurePowerTerms modulus baseValue pureExponentStart count = do
  progression <- quotientPurePowerProgression modulus baseValue pureExponentStart
  scaledTermsByCount progression count

progressionTotal :: ScaledProgression -> Int -> Either String Integer
progressionTotal progression count =
  sum <$> scaledTermsByCount progression count

progressionFrontierAfterCount :: ScaledProgression -> Int -> Either String Integer
progressionFrontierAfterCount progression count =
  scaledTermAt progression (toInteger count)
