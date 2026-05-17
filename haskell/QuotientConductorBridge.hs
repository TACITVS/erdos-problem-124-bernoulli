{-# LANGUAGE DerivingStrategies #-}

module QuotientConductorBridge
  ( QuotientConductorBridge (..),
    completeSelectedQuotient,
  )
where

import CompleteSequence
  ( CentralConductorExtension,
    conductorBound,
    extendCentralConductor,
    newTotal,
  )
import ConductorLift
  ( ConductorBound,
    ScaledCentralBlock,
    conductorBoundFromLift,
    mkScaledCentralBlock,
  )
import qualified ResidueGate as RG
import QuotientBlockSelection
  ( QuotientSelection,
    selectionModulus,
    selectionQuotientBlock,
    selectionUnitFrame,
  )
import ScaledPowerBlock (scaledBlockTermsByCounts)
import UnitResidueFrame (UnitFrame (..))

data QuotientConductorBridge = QuotientConductorBridge
  { bridgeSelection :: QuotientSelection,
    quotientSeedTotal :: Integer,
    quotientSeedConductor :: Integer,
    quotientTermsOrdered :: [Integer],
    quotientExtension :: CentralConductorExtension,
    scaledCentralBlock :: ScaledCentralBlock,
    wholeSeedTotal :: Integer,
    liftedConductorBound :: ConductorBound
  }
  deriving stock (Eq, Show)

completeSelectedQuotient ::
  QuotientSelection ->
  Integer ->
  Integer ->
  [Int] ->
  Either String QuotientConductorBridge
completeSelectedQuotient selection seedTotal seedConductor termCounts = do
  orderedTerms <- scaledBlockTermsByCounts (selectionQuotientBlock selection) termCounts
  extension <- extendCentralConductor seedTotal seedConductor orderedTerms
  block <-
    mkScaledCentralBlock
      (selectionModulus selection)
      (newTotal extension)
      (conductorBound extension)
  let frame = unitFrame (selectionUnitFrame selection)
      modulusInteger = toInteger (RG.modulusValue (selectionModulus selection))
      total = sum (unitTerms (selectionUnitFrame selection)) + modulusInteger * newTotal extension
  bound <- conductorBoundFromLift frame block total
  Right
    QuotientConductorBridge
      { bridgeSelection = selection,
        quotientSeedTotal = seedTotal,
        quotientSeedConductor = seedConductor,
        quotientTermsOrdered = orderedTerms,
        quotientExtension = extension,
        scaledCentralBlock = block,
        wholeSeedTotal = total,
        liftedConductorBound = bound
      }
