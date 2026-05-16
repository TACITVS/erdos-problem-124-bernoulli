{-# LANGUAGE DerivingStrategies #-}

module ConductorLift
  ( ScaledCentralBlock (..),
    ConductorBound (..),
    mkScaledCentralBlock,
    scaledMultipleInterval,
    conductorBoundFromLift,
  )
where

import GapBridge (SeedInterval, intervalEnd, intervalStart)
import qualified ResidueGate as RG
import ResidueLift
  ( MultipleInterval,
    ResidueFrame,
    frameModulus,
    frameWidth,
    liftMultipleInterval,
    mkMultipleInterval,
  )

data ScaledCentralBlock = ScaledCentralBlock
  { blockModulus :: RG.Modulus,
    quotientTotal :: Integer,
    quotientConductor :: Integer
  }
  deriving stock (Eq, Show)

data ConductorBound = ConductorBound
  { boundToHalf :: Integer,
    wholeHalfSum :: Integer,
    liftedInterval :: SeedInterval
  }
  deriving stock (Eq, Show)

mkScaledCentralBlock :: RG.Modulus -> Integer -> Integer -> Either String ScaledCentralBlock
mkScaledCentralBlock modulus total conductor
  | total < 0 = Left ("quotient total must be nonnegative, got " <> show total)
  | conductor < -1 = Left ("quotient conductor must be at least -1, got " <> show conductor)
  | conductor + 1 > total - conductor - 1 =
      Left
        ( "empty quotient central interval from total/conductor "
            <> show (total, conductor)
        )
  | otherwise =
      Right
        ScaledCentralBlock
          { blockModulus = modulus,
            quotientTotal = total,
            quotientConductor = conductor
          }

scaledMultipleInterval :: ScaledCentralBlock -> Either String MultipleInterval
scaledMultipleInterval block =
  mkMultipleInterval
    (blockModulus block)
    (modulusInteger * (quotientConductor block + 1))
    (modulusInteger * (quotientTotal block - quotientConductor block - 1))
  where
    modulusInteger = toInteger (RG.modulusValue (blockModulus block))

conductorBoundFromLift ::
  ResidueFrame ->
  ScaledCentralBlock ->
  Integer ->
  Either String ConductorBound
conductorBoundFromLift frame block wholeSeedTotal = do
  if wholeSeedTotal < 0
    then Left ("whole seed total must be nonnegative, got " <> show wholeSeedTotal)
    else Right ()
  if frameModulus frame /= blockModulus block
    then
      Left
        ( "modulus mismatch: "
            <> show (RG.modulusValue (frameModulus frame))
            <> " versus "
            <> show (RG.modulusValue (blockModulus block))
        )
    else Right ()

  multipleInterval <- scaledMultipleInterval block
  ordinaryInterval <- liftMultipleInterval frame multipleInterval
  let halfSum = wholeSeedTotal `div` 2
      start = intervalStart ordinaryInterval
      end = intervalEnd ordinaryInterval
  if start > halfSum
    then
      Left
        ( "lifted interval starts after the half-sum: "
            <> show (start, halfSum)
        )
    else Right ()
  if end < halfSum
    then
      Left
        ( "lifted interval does not reach the half-sum: "
            <> show (end, halfSum)
        )
    else Right ()

  Right
    ConductorBound
      { boundToHalf = start - 1,
        wholeHalfSum = halfSum,
        liftedInterval = ordinaryInterval
      }

-- The explicit formula is start - 1 = m(c' + 1) + R - 1.
-- Keeping it implicit through liftMultipleInterval ensures that the residue
-- frame and modulus checks are reused rather than duplicated here.
_formulaBound :: ResidueFrame -> ScaledCentralBlock -> Integer
_formulaBound frame block =
  modulusInteger * (quotientConductor block + 1) + frameWidth frame - 1
  where
    modulusInteger = toInteger (RG.modulusValue (blockModulus block))
