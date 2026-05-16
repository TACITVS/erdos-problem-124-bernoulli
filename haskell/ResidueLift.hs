{-# LANGUAGE DerivingStrategies #-}

module ResidueLift
  ( ResidueFrame (..),
    MultipleRay (..),
    MultipleInterval (..),
    mkResidueFrame,
    mkMultipleRay,
    mkMultipleInterval,
    liftMultipleRay,
    liftMultipleInterval,
  )
where

import GapBridge (Ray (..), SeedInterval, mkSeedInterval)
import qualified ResidueGate as RG

data ResidueFrame = ResidueFrame
  { frameModulus :: RG.Modulus,
    frameRepresentatives :: [Integer],
    frameWidth :: Integer
  }
  deriving stock (Eq, Show)

data MultipleRay = MultipleRay
  { rayModulus :: RG.Modulus,
    rayStart :: Integer
  }
  deriving stock (Eq, Show)

data MultipleInterval = MultipleInterval
  { intervalModulus :: RG.Modulus,
    multipleIntervalStart :: Integer,
    multipleIntervalEnd :: Integer
  }
  deriving stock (Eq, Show)

isMultiple :: RG.Modulus -> Integer -> Bool
isMultiple modulus value =
  value `mod` toInteger (RG.modulusValue modulus) == 0

moduliMatch :: RG.Modulus -> RG.Modulus -> Either String ()
moduliMatch left right
  | left == right = Right ()
  | otherwise =
      Left
        ( "modulus mismatch: "
            <> show (RG.modulusValue left)
            <> " versus "
            <> show (RG.modulusValue right)
        )

mkResidueFrame :: RG.Modulus -> [Integer] -> Either String ResidueFrame
mkResidueFrame modulus representatives
  | length representatives /= RG.modulusValue modulus =
      Left
        ( "expected "
            <> show (RG.modulusValue modulus)
            <> " residue representatives, got "
            <> show (length representatives)
        )
  | any (< 0) representatives =
      Left "residue representatives must be nonnegative subset sums"
  | not (null mismatches) =
      Left ("representative residue mismatches: " <> show mismatches)
  | otherwise =
      Right
        ResidueFrame
          { frameModulus = modulus,
            frameRepresentatives = representatives,
            frameWidth = maximum representatives
          }
  where
    mismatches =
      [ (residue, value)
        | (residue, value) <- zip [0 ..] representatives,
          RG.residueValue (RG.normalizeResidue modulus value) /= residue
      ]

mkMultipleRay :: RG.Modulus -> Integer -> Either String MultipleRay
mkMultipleRay modulus start
  | start < 0 = Left ("multiple ray start must be nonnegative, got " <> show start)
  | not (isMultiple modulus start) =
      Left ("multiple ray start is not divisible by modulus: " <> show start)
  | otherwise = Right (MultipleRay modulus start)

mkMultipleInterval :: RG.Modulus -> Integer -> Integer -> Either String MultipleInterval
mkMultipleInterval modulus start end
  | start < 0 || end < 0 =
      Left ("multiple interval endpoints must be nonnegative: " <> show (start, end))
  | start > end =
      Left ("empty multiple interval: " <> show (start, end))
  | not (isMultiple modulus start) =
      Left ("multiple interval start is not divisible by modulus: " <> show start)
  | not (isMultiple modulus end) =
      Left ("multiple interval end is not divisible by modulus: " <> show end)
  | otherwise = Right (MultipleInterval modulus start end)

liftMultipleRay :: ResidueFrame -> MultipleRay -> Either String Ray
liftMultipleRay frame multipleRay = do
  moduliMatch (frameModulus frame) (rayModulus multipleRay)
  pure (Ray (rayStart multipleRay + frameWidth frame))

liftMultipleInterval :: ResidueFrame -> MultipleInterval -> Either String SeedInterval
liftMultipleInterval frame multipleInterval = do
  moduliMatch (frameModulus frame) (intervalModulus multipleInterval)
  let start = multipleIntervalStart multipleInterval + frameWidth frame
      end = multipleIntervalEnd multipleInterval
  mkSeedInterval start end
