{-# LANGUAGE DerivingStrategies #-}

module SingleProgressionAbsorption
  ( AbsorptionCount (..),
    SpanGrowth (..),
    absorbablePrefix,
    spanGrowthFactor,
    progressionTerm,
    absorbSequentially,
  )
where

import GapBridge (SeedInterval, absorbPrefix, intervalEnd, intervalStart, mkSeedInterval)

data AbsorptionCount = AbsorptionCount
  { initialSpan :: Integer,
    progressionCoefficient :: Integer,
    progressionBase :: Integer,
    progressionStart :: Integer,
    maxPrefixLength :: Maybe Int,
    postAbsorptionSpan :: Maybe Integer
  }
  deriving stock (Eq, Show)

data SpanGrowth
  = DyadicFullAbsorption
  | GeometricFactor {factorNumerator :: Integer, factorDenominator :: Integer}
  deriving stock (Eq, Show)

progressionTerm :: Integer -> Integer -> Integer -> Int -> Integer
progressionTerm coeff baseValue startExponent stepIndex =
  coeff * baseValue ^ (startExponent + toInteger stepIndex)

geometricPartialSum ::
  Integer -> Integer -> Integer -> Int -> Integer
geometricPartialSum coeff baseValue startExponent count =
  if count <= 0
    then 0
    else
      coeff * baseValue ^ startExponent * (baseValue ^ count - 1)
        `div` (baseValue - 1)

absorbablePrefix ::
  Integer ->
  Integer ->
  Integer ->
  Integer ->
  Either String AbsorptionCount
absorbablePrefix spanValue coeff baseValue startExponent
  | spanValue < 0 =
      Left ("seed span must be nonnegative, got " <> show spanValue)
  | coeff <= 0 =
      Left ("coefficient must be positive, got " <> show coeff)
  | baseValue < 2 =
      Left ("base must be at least 2, got " <> show baseValue)
  | startExponent < 0 =
      Left ("exponent start must be nonnegative, got " <> show startExponent)
  | otherwise =
      Right
        AbsorptionCount
          { initialSpan = spanValue,
            progressionCoefficient = coeff,
            progressionBase = baseValue,
            progressionStart = startExponent,
            maxPrefixLength = countMaybe,
            postAbsorptionSpan = fmap finalSpan countMaybe
          }
  where
    firstTerm = coeff * baseValue ^ startExponent
    countMaybe = computeCount
    computeCount
      | baseValue == 2 =
          if spanValue + 1 >= firstTerm then Nothing else Just 0
      | otherwise =
          Just (geometricCount 0)
    geometricCount index =
      let term = progressionTerm coeff baseValue startExponent index
          partial = geometricPartialSum coeff baseValue startExponent index
       in if term <= spanValue + partial + 1
            then geometricCount (index + 1)
            else index
    finalSpan count =
      spanValue + geometricPartialSum coeff baseValue startExponent count

-- 2(d-1)/(d-2) for d >= 3; signal dyadic for d=2.
spanGrowthFactor :: Integer -> Either String SpanGrowth
spanGrowthFactor baseValue
  | baseValue < 2 =
      Left ("base must be at least 2, got " <> show baseValue)
  | baseValue == 2 = Right DyadicFullAbsorption
  | otherwise =
      Right
        GeometricFactor
          { factorNumerator = 2 * (baseValue - 1),
            factorDenominator = baseValue - 2
          }

-- Direct sequential absorption through GapBridge for cross-check; returns the
-- prefix length that GapBridge accepted before any term overflowed.
absorbSequentially ::
  SeedInterval ->
  Integer ->
  Integer ->
  Integer ->
  Int ->
  (Int, SeedInterval)
absorbSequentially interval coeff baseValue startExponent maxAttempts =
  go 0 interval
  where
    go index current
      | index >= maxAttempts = (index, current)
      | otherwise =
          let term = progressionTerm coeff baseValue startExponent index
              terms = [term]
           in case absorbPrefix current terms of
                Right next -> go (index + 1) next
                Left _ -> (index, current)

-- Convenience constructor used by certificates.
_buildInterval :: Integer -> Integer -> Either String SeedInterval
_buildInterval = mkSeedInterval

_intervalSpan :: SeedInterval -> Integer
_intervalSpan interval =
  intervalEnd interval - intervalStart interval
