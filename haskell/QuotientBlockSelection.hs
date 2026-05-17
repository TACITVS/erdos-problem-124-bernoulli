{-# LANGUAGE DerivingStrategies #-}

module QuotientBlockSelection
  ( PrimePower (..),
    DivisibleProgression (..),
    QuotientSelection (..),
    factorInteger,
    valuationAt,
    firstDivisibleExponent,
    quotientProgressionForBase,
    mkQuotientSelection,
  )
where

import qualified ResidueGate as RG
import ScaledPowerBlock
  ( ScaledBlock,
    ScaledProgression,
    mkScaledBlock,
    quotientPurePowerProgression,
  )
import UnitResidueFrame (UnitFrame, mkUnitFrame)

data PrimePower = PrimePower
  { primeValue :: Integer,
    primeExponent :: Integer
  }
  deriving stock (Eq, Show)

data DivisibleProgression = DivisibleProgression
  { originalBase :: Integer,
    startExponent :: Integer,
    scaledProgression :: ScaledProgression
  }
  deriving stock (Eq, Show)

data QuotientSelection = QuotientSelection
  { selectionModulus :: RG.Modulus,
    selectionExponentFloor :: Integer,
    selectionFrameBase :: Integer,
    selectionUnitFrame :: UnitFrame,
    selectionDivisibleProgressions :: [DivisibleProgression],
    selectionQuotientBlock :: ScaledBlock
  }
  deriving stock (Eq, Show)

factorInteger :: Integer -> Either String [PrimePower]
factorInteger value
  | value <= 0 = Left ("factorization requires a positive integer, got " <> show value)
  | value == 1 = Right []
  | otherwise = Right (go value 2 [])
  where
    go remaining divisor acc
      | divisor * divisor > remaining =
          reverse
            ( if remaining == 1
                then acc
                else PrimePower remaining 1 : acc
            )
      | remaining `mod` divisor == 0 =
          let (nextRemaining, divisorPower) = divideOut remaining divisor 0
           in go nextRemaining (nextDivisor divisor) (PrimePower divisor divisorPower : acc)
      | otherwise = go remaining (nextDivisor divisor) acc

    divideOut remaining divisor divisorPower
      | remaining `mod` divisor == 0 = divideOut (remaining `div` divisor) divisor (divisorPower + 1)
      | otherwise = (remaining, divisorPower)

    nextDivisor 2 = 3
    nextDivisor divisor = divisor + 2

valuationAt :: Integer -> Integer -> Either String Integer
valuationAt prime value
  | prime <= 1 = Left ("valuation prime must be at least 2, got " <> show prime)
  | value <= 0 = Left ("valuation value must be positive, got " <> show value)
  | otherwise = Right (go value 0)
  where
    go remaining powerCount
      | remaining `mod` prime == 0 = go (remaining `div` prime) (powerCount + 1)
      | otherwise = powerCount

ceilingDivide :: Integer -> Integer -> Integer
ceilingDivide numerator denominator =
  (numerator + denominator - 1) `div` denominator

firstDivisibleExponent ::
  Integer ->
  Integer ->
  Integer ->
  Either String Integer
firstDivisibleExponent modulus exponentFloor baseValue
  | modulus <= 0 = Left ("modulus must be positive, got " <> show modulus)
  | exponentFloor < 0 = Left ("exponent floor must be nonnegative, got " <> show exponentFloor)
  | baseValue <= 1 = Left ("base must be at least 2, got " <> show baseValue)
  | otherwise = do
      factors <- factorInteger modulus
      thresholds <- mapM threshold factors
      Right (maximum (exponentFloor : thresholds))
  where
    threshold factor = do
      baseValuation <- valuationAt (primeValue factor) baseValue
      if baseValuation == 0
        then
          Left
            ( "base "
                <> show baseValue
                <> " is missing modulus prime "
                <> show (primeValue factor)
            )
        else Right (ceilingDivide (primeExponent factor) baseValuation)

quotientProgressionForBase ::
  Integer ->
  Integer ->
  Integer ->
  Either String DivisibleProgression
quotientProgressionForBase modulus exponentFloor baseValue = do
  start <- firstDivisibleExponent modulus exponentFloor baseValue
  progression <- quotientPurePowerProgression modulus baseValue start
  Right
    DivisibleProgression
      { originalBase = baseValue,
        startExponent = start,
        scaledProgression = progression
      }

mkQuotientSelection ::
  RG.Modulus ->
  Integer ->
  Integer ->
  [Integer] ->
  Either String QuotientSelection
mkQuotientSelection modulus frameBase exponentFloor divisibleBases
  | null divisibleBases = Left "quotient selection needs at least one divisible base"
  | otherwise = do
      unitFrame <- mkUnitFrame modulus frameBase exponentFloor
      divisibleProgressions <-
        mapM
          (quotientProgressionForBase (toInteger (RG.modulusValue modulus)) exponentFloor)
          divisibleBases
      quotientBlock <- mkScaledBlock (map scaledProgression divisibleProgressions)
      Right
        QuotientSelection
          { selectionModulus = modulus,
            selectionExponentFloor = exponentFloor,
            selectionFrameBase = frameBase,
            selectionUnitFrame = unitFrame,
            selectionDivisibleProgressions = divisibleProgressions,
            selectionQuotientBlock = quotientBlock
          }
