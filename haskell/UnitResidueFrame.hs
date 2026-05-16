{-# LANGUAGE DerivingStrategies #-}

module UnitResidueFrame
  ( UnitFrame (..),
    multiplicativeOrder,
    unitFrameTerms,
    unitResidueRepresentatives,
    mkUnitFrame,
  )
where

import Data.List (find)
import qualified ResidueGate as RG
import ResidueLift (ResidueFrame, mkResidueFrame)

data UnitFrame = UnitFrame
  { unitModulus :: RG.Modulus,
    unitBase :: Integer,
    unitExponentStart :: Integer,
    unitOrder :: Int,
    unitTerms :: [Integer],
    unitFrame :: ResidueFrame
  }
  deriving stock (Eq, Show)

powMod :: Integer -> Integer -> Integer -> Integer
powMod _ _ 1 = 0
powMod base power modulus = go power 1 (base `mod` modulus)
  where
    go 0 acc _ = acc
    go n acc current
      | even n = go (n `div` 2) acc ((current * current) `mod` modulus)
      | otherwise = go (n - 1) ((acc * current) `mod` modulus) current

multiplicativeOrder :: RG.Modulus -> Integer -> Either String Int
multiplicativeOrder modulus base
  | base <= 0 = Left ("base must be positive, got " <> show base)
  | gcd base modulusInteger /= 1 =
      Left
        ( "base "
            <> show base
            <> " is not a unit modulo "
            <> show modulusInteger
        )
  | modulusInteger == 1 = Right 1
  | otherwise =
      case find (\candidate -> powMod base (toInteger candidate) modulusInteger == 1) [1 .. RG.modulusValue modulus] of
        Nothing -> Left ("could not find multiplicative order modulo " <> show modulusInteger)
        Just order -> Right order
  where
    modulusInteger = toInteger (RG.modulusValue modulus)

unitFrameTerms :: RG.Modulus -> Integer -> Integer -> Either String [Integer]
unitFrameTerms modulus base exponentStart
  | exponentStart < 0 = Left ("exponent start must be nonnegative, got " <> show exponentStart)
  | otherwise = do
      order <- multiplicativeOrder modulus base
      let termCount = RG.modulusValue modulus - 1
      pure [base ^ (exponentStart + toInteger step * toInteger order) | step <- [0 .. termCount - 1]]

residueCoefficient :: RG.Modulus -> Integer -> Int -> Either String Int
residueCoefficient modulus unit residue =
  case find (\coefficient -> (toInteger coefficient * unit) `mod` modulusInteger == toInteger residue) [0 .. RG.modulusValue modulus - 1] of
    Nothing -> Left ("could not solve unit residue for " <> show residue)
    Just coefficient -> Right coefficient
  where
    modulusInteger = toInteger (RG.modulusValue modulus)

unitResidueRepresentatives :: RG.Modulus -> Integer -> Integer -> Either String [Integer]
unitResidueRepresentatives modulus base exponentStart = do
  terms <- unitFrameTerms modulus base exponentStart
  let modulusInteger = toInteger (RG.modulusValue modulus)
      unit = powMod base exponentStart modulusInteger
      prefixSums = scanl (+) 0 terms
  mapM
    ( \residue -> do
        coefficient <- residueCoefficient modulus unit residue
        pure (prefixSums !! coefficient)
    )
    [0 .. RG.modulusValue modulus - 1]

mkUnitFrame :: RG.Modulus -> Integer -> Integer -> Either String UnitFrame
mkUnitFrame modulus base exponentStart = do
  order <- multiplicativeOrder modulus base
  terms <- unitFrameTerms modulus base exponentStart
  representatives <- unitResidueRepresentatives modulus base exponentStart
  frame <- mkResidueFrame modulus representatives
  pure
    UnitFrame
      { unitModulus = modulus,
        unitBase = base,
        unitExponentStart = exponentStart,
        unitOrder = order,
        unitTerms = terms,
        unitFrame = frame
      }
