{-# LANGUAGE DerivingStrategies #-}

module GapBridge
  ( SeedInterval (..),
    TailGapBound (..),
    Ray (..),
    mkSeedInterval,
    mkTailGapBound,
    intervalSpan,
    requiredGapBound,
    absorbTerm,
    absorbPrefix,
    bridgeToRay,
    bridgeAfterPrefix,
  )
where

newtype TailGapBound = TailGapBound Integer
  deriving stock (Eq, Ord, Show)

data SeedInterval = SeedInterval
  { intervalStart :: Integer,
    intervalEnd :: Integer
  }
  deriving stock (Eq, Show)

newtype Ray = Ray Integer
  deriving stock (Eq, Show)

mkSeedInterval :: Integer -> Integer -> Either String SeedInterval
mkSeedInterval start end
  | start <= end = Right (SeedInterval start end)
  | otherwise = Left ("empty seed interval: " <> show (start, end))

mkTailGapBound :: Integer -> Either String TailGapBound
mkTailGapBound value
  | value >= 1 = Right (TailGapBound value)
  | otherwise = Left ("tail gap bound must be positive, got " <> show value)

intervalSpan :: SeedInterval -> Integer
intervalSpan interval =
  intervalEnd interval - intervalStart interval

requiredGapBound :: SeedInterval -> TailGapBound
requiredGapBound interval =
  TailGapBound (intervalSpan interval + 1)

absorbTerm :: SeedInterval -> Integer -> Either String SeedInterval
absorbTerm interval term
  | term <= 0 = Left ("tail term must be positive, got " <> show term)
  | term <= intervalSpan interval + 1 =
      Right (interval {intervalEnd = intervalEnd interval + term})
  | otherwise =
      Left
        ( "tail term "
            <> show term
            <> " exceeds interval capacity "
            <> show (intervalSpan interval + 1)
        )

absorbPrefix :: SeedInterval -> [Integer] -> Either String SeedInterval
absorbPrefix =
  foldl step . Right
  where
    step (Left err) _ = Left err
    step (Right interval) term = absorbTerm interval term

bridgeToRay :: SeedInterval -> TailGapBound -> Either String Ray
bridgeToRay interval (TailGapBound gap)
  | gap <= intervalSpan interval + 1 = Right (Ray (intervalStart interval))
  | otherwise =
      Left
        ( "tail gap bound "
            <> show gap
            <> " exceeds interval capacity "
            <> show (intervalSpan interval + 1)
        )

bridgeAfterPrefix :: SeedInterval -> [Integer] -> TailGapBound -> Either String Ray
bridgeAfterPrefix interval prefix gapBound = do
  extended <- absorbPrefix interval prefix
  bridgeToRay extended gapBound
