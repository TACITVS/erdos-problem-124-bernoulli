{-# LANGUAGE DerivingStrategies #-}

module CompleteSequence
  ( CompleteSequenceCertificate (..),
    CentralConductorExtension (..),
    orderedPositiveTerms,
    completeSequenceFromInterval,
    completeSequenceFromZero,
    extendCentralConductor,
  )
where

import Data.List (sort)
import GapBridge
  ( SeedInterval,
    absorbPrefix,
    intervalEnd,
    intervalStart,
    mkSeedInterval,
  )

data CompleteSequenceCertificate = CompleteSequenceCertificate
  { sourceTerms :: [Integer],
    orderedTerms :: [Integer],
    initialInterval :: SeedInterval,
    finalInterval :: SeedInterval,
    absorbedTotal :: Integer
  }
  deriving stock (Eq, Show)

data CentralConductorExtension = CentralConductorExtension
  { seedTotal :: Integer,
    conductorBound :: Integer,
    extraTermsOrdered :: [Integer],
    newTotal :: Integer,
    extendedCentralInterval :: SeedInterval
  }
  deriving stock (Eq, Show)

orderedPositiveTerms :: [Integer] -> Either String [Integer]
orderedPositiveTerms terms
  | null nonpositive = Right (sort terms)
  | otherwise = Left ("terms must be positive, got " <> show nonpositive)
  where
    nonpositive = filter (<= 0) terms

completeSequenceFromInterval ::
  SeedInterval ->
  [Integer] ->
  Either String CompleteSequenceCertificate
completeSequenceFromInterval interval terms = do
  ordered <- orderedPositiveTerms terms
  final <- absorbPrefix interval ordered
  let absorbed = sum ordered
      expectedEnd = intervalEnd interval + absorbed
  if intervalStart final /= intervalStart interval
    then Left "internal error: interval absorption changed the left endpoint"
    else Right ()
  if intervalEnd final /= expectedEnd
    then
      Left
        ( "internal error: final endpoint "
            <> show (intervalEnd final)
            <> " differs from expected "
            <> show expectedEnd
        )
    else Right ()
  Right
    CompleteSequenceCertificate
      { sourceTerms = terms,
        orderedTerms = ordered,
        initialInterval = interval,
        finalInterval = final,
        absorbedTotal = absorbed
      }

completeSequenceFromZero :: [Integer] -> Either String CompleteSequenceCertificate
completeSequenceFromZero terms = do
  interval <- mkSeedInterval 0 0
  completeSequenceFromInterval interval terms

extendCentralConductor ::
  Integer ->
  Integer ->
  [Integer] ->
  Either String CentralConductorExtension
extendCentralConductor originalTotal conductor terms = do
  if originalTotal < 0
    then Left ("seed total must be nonnegative, got " <> show originalTotal)
    else Right ()
  if conductor < -1
    then Left ("conductor must be at least -1, got " <> show conductor)
    else Right ()

  interval <- mkSeedInterval (conductor + 1) (originalTotal - conductor - 1)
  certificate <- completeSequenceFromInterval interval terms
  let combinedTotal = originalTotal + absorbedTotal certificate
      expectedRightEndpoint = combinedTotal - conductor - 1
      actualRightEndpoint = intervalEnd (finalInterval certificate)
  if actualRightEndpoint /= expectedRightEndpoint
    then
      Left
        ( "central endpoint mismatch: "
            <> show (actualRightEndpoint, expectedRightEndpoint)
        )
    else Right ()
  Right
    CentralConductorExtension
      { seedTotal = originalTotal,
        conductorBound = conductor,
        extraTermsOrdered = orderedTerms certificate,
        newTotal = combinedTotal,
        extendedCentralInterval = finalInterval certificate
      }
