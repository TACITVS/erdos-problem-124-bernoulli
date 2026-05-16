{-# LANGUAGE DerivingStrategies #-}

module Main where

import CFHTail
  ( TailCertificate (..),
    TailRow (..),
    TailState (..),
    verifyStrictCfhTail,
  )
import Data.List (intercalate)
import Data.Ratio (denominator, numerator)
import GapBridge
  ( Ray (..),
    bridgeAfterPrefix,
    mkSeedInterval,
    mkTailGapBound,
  )

data StrictCase = StrictCase
  { label :: String,
    seedInterval :: (Integer, Integer),
    absorbedPrefix :: [Integer],
    tailState :: TailState,
    maxSteps :: Int,
    expectedReadyStep :: Int,
    expectedRayStart :: Integer
  }
  deriving stock (Eq, Show)

strictCases :: [StrictCase]
strictCases =
  [ StrictCase
      "{3,4,5}, k=1 strict CFH tail"
      (80, 2132)
      [1024]
      TailState
        { tailBases = [3, 4, 5],
          tailFrontier = [2187, 4096, 3125],
          cfhGapBound = 2187
        }
      10
      4
      80
  ]

showRational :: Rational -> String
showRational value
  | denominator value == 1 = show (numerator value)
  | otherwise = show (numerator value) <> "/" <> show (denominator value)

formatRow :: TailRow -> String
formatRow row =
  intercalate
    ", "
    [ "step=" <> show (rowStep row),
      "next=" <> show (rowNextTerm row),
      "margin=" <> showRational (rowMargin row),
      "ready=" <> show (rowStrictReady row)
    ]

readyStep :: TailCertificate -> Maybe Int
readyStep certificate =
  case certificateRows certificate of
    [] -> Nothing
    rows -> Just (rowStep (last rows))

verifyCase :: StrictCase -> Either String String
verifyCase item = do
  interval <- uncurry mkSeedInterval (seedInterval item)
  gapBound <- mkTailGapBound (cfhGapBound (tailState item))
  Ray rayStart <- bridgeAfterPrefix interval (absorbedPrefix item) gapBound
  if rayStart /= expectedRayStart item
    then Left ("ray start mismatch: " <> show rayStart)
    else Right ()

  certificate <- verifyStrictCfhTail (maxSteps item) (tailState item)
  case readyStep certificate of
    Nothing -> Left "empty CFH certificate"
    Just step ->
      if step /= expectedReadyStep item
        then Left ("ready step mismatch: " <> show step)
        else Right ()

  pure
    ( intercalate
        "\n"
        [ "case: " <> label item,
          "seed interval: " <> show (seedInterval item),
          "absorbed prefix: " <> show (absorbedPrefix item),
          "tail bases: " <> show (tailBases (tailState item)),
          "tail frontier: " <> show (tailFrontier (tailState item)),
          "CFH gap bound: " <> show (cfhGapBound (tailState item)),
          "CFH invariant: " <> showRational (certificateInvariant certificate),
          "strict takeover step: " <> show (expectedReadyStep item),
          "certified ray start: " <> show rayStart,
          "rows:\n  " <> intercalate "\n  " (map formatRow (certificateRows certificate))
        ]
    )

main :: IO ()
main =
  mapM_ printCase strictCases
  where
    printCase item =
      case verifyCase item of
        Left err -> error (label item <> ": " <> err)
        Right report -> putStrLn (report <> "\n")
