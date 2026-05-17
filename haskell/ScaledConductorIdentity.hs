{-# LANGUAGE DerivingStrategies #-}

module ScaledConductorIdentity
  ( ProgressionWindow (..),
    ConductorWitness (..),
    seedTotal,
    scaledCapacity,
    kappaScaled,
    centralIntervalSpan,
    tailInvariant,
    purePowerKappa,
  )
where

import ScaledPowerBlock
  ( ScaledBlock,
    ScaledProgression,
    base,
    blockProgressions,
    coefficient,
    exponentStart,
  )

-- An exponent window [windowStart, windowEnd) for one scaled progression.
data ProgressionWindow = ProgressionWindow
  { windowStart :: Integer,
    windowEnd :: Integer
  }
  deriving stock (Eq, Show)

data ConductorWitness = ConductorWitness
  { witnessConductor :: Integer,
    witnessSeedTotal :: Integer
  }
  deriving stock (Eq, Show)

geometricSum :: Integer -> Integer -> Integer -> Integer
geometricSum coeff baseValue exponent =
  coeff * (baseValue ^ exponent)

windowSum :: ScaledProgression -> ProgressionWindow -> Either String Integer
windowSum progression window
  | windowStart window < exponentStart progression =
      Left
        ( "window start "
            <> show (windowStart window)
            <> " is below progression start "
            <> show (exponentStart progression)
        )
  | windowEnd window < windowStart window =
      Left
        ( "window end "
            <> show (windowEnd window)
            <> " is below window start "
            <> show (windowStart window)
        )
  | windowEnd window == windowStart window = Right 0
  | otherwise =
      Right
        ( ( geometricSum (coefficient progression) (base progression) (windowEnd window)
              - geometricSum (coefficient progression) (base progression) (windowStart window)
          )
            `div` (base progression - 1)
        )

zipProgressionsAndWindows ::
  ScaledBlock ->
  [ProgressionWindow] ->
  Either String [(ScaledProgression, ProgressionWindow)]
zipProgressionsAndWindows block windows
  | length progressions /= length windows =
      Left
        ( "progression/window length mismatch: "
            <> show (length progressions, length windows)
        )
  | otherwise = Right (zip progressions windows)
  where
    progressions = blockProgressions block

seedTotal :: ScaledBlock -> [ProgressionWindow] -> Either String Integer
seedTotal block windows = do
  pairs <- zipProgressionsAndWindows block windows
  sums <- mapM (uncurry windowSum) pairs
  Right (sum sums)

scaledCapacity :: ScaledBlock -> [ProgressionWindow] -> Either String Integer
scaledCapacity block windows = do
  pairs <- zipProgressionsAndWindows block windows
  let contribution (progression, window) =
        coefficient progression * base progression ^ windowEnd window
          `div` (base progression - 1)
  Right (sum (map contribution pairs))

kappaScaled :: ScaledBlock -> Either String Integer
kappaScaled block =
  Right
    ( sum
        [ coefficient progression * base progression ^ exponentStart progression
            `div` (base progression - 1)
          | progression <- blockProgressions block
        ]
    )

centralIntervalSpan :: ConductorWitness -> Integer
centralIntervalSpan witness =
  witnessSeedTotal witness - 2 * witnessConductor witness - 2

tailInvariant :: ScaledBlock -> ConductorWitness -> Either String Integer
tailInvariant block witness = do
  kappa <- kappaScaled block
  Right (kappa + 2 * witnessConductor witness + 1)

-- Pure-power kappa value for sanity-checking against note 28.
purePowerKappa :: [Integer] -> Integer -> Integer
purePowerKappa bases exponentFloor =
  sum
    [ base ^ exponentFloor `div` (base - 1)
      | base <- bases
    ]
