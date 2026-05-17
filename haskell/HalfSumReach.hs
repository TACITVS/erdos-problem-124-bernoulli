{-# LANGUAGE DerivingStrategies #-}

module HalfSumReach
  ( HalfSumReachWitness (..),
    frameTotal,
    halfSumReachThreshold,
    halfSumReachMargin,
    halfSumReachEndpoint,
    halfSumReachHalfSum,
    halfSumReachWholeTotal,
    provesHalfSumReach,
  )
where

import qualified ResidueGate as RG
import UnitResidueFrame (UnitFrame, unitModulus, unitTerms)

data HalfSumReachWitness = HalfSumReachWitness
  { reachModulus :: Integer,
    reachFrameTotal :: Integer,
    reachQuotientConductor :: Integer,
    reachQuotientTotal :: Integer,
    reachThreshold :: Integer,
    reachWholeSeedTotal :: Integer,
    reachHalfSum :: Integer,
    reachLiftedEnd :: Integer,
    reachMargin :: Integer
  }
  deriving stock (Eq, Show)

modulusInteger :: UnitFrame -> Integer
modulusInteger frame =
  toInteger (RG.modulusValue (unitModulus frame))

-- Frame total: sum of the actual unit-power seed terms used by the frame.
-- This is the contribution the residue frame makes to the whole seed total
-- when combined with a rescaled quotient block.
frameTotal :: UnitFrame -> Integer
frameTotal frame = sum (unitTerms frame)

ceilingDivide :: Integer -> Integer -> Integer
ceilingDivide numerator denominator =
  (numerator + denominator - 1) `div` denominator

-- Sufficient algebraic threshold S'_* on the quotient total above which
-- half-sum reach is guaranteed.  See notes/39_asymptotic_half_sum_reach.md.
-- The threshold is sufficient but not always necessary; some sub-threshold
-- S' still pass via the parity slack on floor((F_tot + mS')/2).
halfSumReachThreshold :: UnitFrame -> Integer -> Integer
halfSumReachThreshold frame quotientConductor =
  2 * (quotientConductor + 1) + ceilingDivide (frameTotal frame) (modulusInteger frame)

-- Right endpoint of the lifted interval m(S'-c'-1).
halfSumReachEndpoint :: UnitFrame -> Integer -> Integer -> Integer
halfSumReachEndpoint frame quotientConductor quotientTotal =
  modulusInteger frame * (quotientTotal - quotientConductor - 1)

-- Whole finite seed total F_tot + m S'.
halfSumReachWholeTotal :: UnitFrame -> Integer -> Integer
halfSumReachWholeTotal frame quotientTotal =
  frameTotal frame + modulusInteger frame * quotientTotal

-- Half of the whole finite seed floor((F_tot + mS') / 2).
halfSumReachHalfSum :: UnitFrame -> Integer -> Integer
halfSumReachHalfSum frame quotientTotal =
  halfSumReachWholeTotal frame quotientTotal `div` 2

-- Explicit reach margin mu = end - half-sum.  Half-sum reach is exactly the
-- statement mu >= 0.
halfSumReachMargin :: UnitFrame -> Integer -> Integer -> Integer
halfSumReachMargin frame quotientConductor quotientTotal =
  halfSumReachEndpoint frame quotientConductor quotientTotal
    - halfSumReachHalfSum frame quotientTotal

-- Direct half-sum reach proof.  Always reports threshold and margin so the
-- caller can distinguish "passed by threshold" from "passed by parity slack".
provesHalfSumReach ::
  UnitFrame ->
  Integer ->
  Integer ->
  Either String HalfSumReachWitness
provesHalfSumReach frame quotientConductor quotientTotal
  | quotientConductor < -1 =
      Left
        ( "quotient conductor must be at least -1, got "
            <> show quotientConductor
        )
  | quotientTotal < 0 =
      Left
        ( "quotient total must be nonnegative, got "
            <> show quotientTotal
        )
  | margin < 0 =
      Left
        ( "half-sum reach fails: lifted endpoint "
            <> show endpoint
            <> " is below half-sum "
            <> show halfSum
            <> " (margin "
            <> show margin
            <> "); sufficient threshold S'* is "
            <> show threshold
        )
  | otherwise =
      Right
        HalfSumReachWitness
          { reachModulus = modulusValue,
            reachFrameTotal = total,
            reachQuotientConductor = quotientConductor,
            reachQuotientTotal = quotientTotal,
            reachThreshold = threshold,
            reachWholeSeedTotal = halfSumReachWholeTotal frame quotientTotal,
            reachHalfSum = halfSum,
            reachLiftedEnd = endpoint,
            reachMargin = margin
          }
  where
    modulusValue = modulusInteger frame
    total = frameTotal frame
    threshold = halfSumReachThreshold frame quotientConductor
    halfSum = halfSumReachHalfSum frame quotientTotal
    endpoint = halfSumReachEndpoint frame quotientConductor quotientTotal
    margin = halfSumReachMargin frame quotientConductor quotientTotal
