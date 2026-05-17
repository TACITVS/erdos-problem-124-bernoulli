{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Main where

import Data.List (intercalate)
import Data.Ratio ((%))

newtype Gap = Gap Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

newtype Exponent = Exponent Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

newtype CfTerm = CfTerm Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

data Convergent = Convergent
  { exp4 :: Exponent,
    exp3 :: Exponent
  }
  deriving stock (Eq, Show)

data TailGate = TailGate
  { label :: String,
    gap :: Gap,
    legendreStart :: Exponent,
    mwStart :: Exponent
  }
  deriving stock (Eq, Show)

gapValue :: Gap -> Integer
gapValue (Gap x) = x

exponentValue :: Exponent -> Integer
exponentValue (Exponent x) = x

cfTermValue :: CfTerm -> Integer
cfTermValue (CfTerm x) = x

logInterval :: Integer -> Int -> (Rational, Rational)
logInterval x terms =
  let y = (x - 1) % (x + 1)
      y2 = y * y
      (partial, nextPower) = foldl step (0, y) [0 .. terms - 1]
      step (acc, power) n =
        (acc + power / fromIntegral (2 * n + 1), power * y2)
      lower = 2 * partial
      tailBound =
        2
          * nextPower
          / fromIntegral (2 * terms + 1)
          / (1 - y2)
   in (lower, lower + tailBound)

intervalCf :: Rational -> Rational -> Int -> [CfTerm]
intervalCf lower upper maxTerms = go lower upper maxTerms []
  where
    go _ _ 0 out = reverse out
    go lo hi remaining out =
      let loFloor = floor lo
          hiFloor = floor hi
       in if loFloor /= hiFloor
            then reverse out
            else
              let loRemainder = lo - fromInteger loFloor
                  hiRemainder = hi - fromInteger hiFloor
               in if loRemainder <= 0
                    then reverse (CfTerm loFloor : out)
                    else go (1 / hiRemainder) (1 / loRemainder) (remaining - 1) (CfTerm loFloor : out)

convergents :: [CfTerm] -> [Convergent]
convergents terms = go terms 0 1 1 0 []
  where
    go [] _ _ _ _ out = reverse out
    go (term : rest) p0 p1 q0 q1 out =
      let a = cfTermValue term
          p = a * p1 + p0
          q = a * q1 + q0
       in go rest p1 p q1 q (Convergent (Exponent p) (Exponent q) : out)

alphaCfPrefix :: [CfTerm]
alphaCfPrefix =
  let (log3Lower, log3Upper) = logInterval 3 80
      (log4Lower, log4Upper) = logInterval 4 80
   in intervalCf (log3Lower / log4Upper) (log3Upper / log4Lower) 13

expectedCfPrefix :: [CfTerm]
expectedCfPrefix = map CfTerm [0, 1, 3, 1, 4, 1, 1, 11, 1, 46, 1, 5, 112]

expectedRelevant :: [Convergent]
expectedRelevant =
  [ Convergent (Exponent 19) (Exponent 24),
    Convergent (Exponent 23) (Exponent 29),
    Convergent (Exponent 42) (Exponent 53),
    Convergent (Exponent 485) (Exponent 612),
    Convergent (Exponent 527) (Exponent 665),
    Convergent (Exponent 24727) (Exponent 31202),
    Convergent (Exponent 25254) (Exponent 31867),
    Convergent (Exponent 150997) (Exponent 190537)
  ]

expectedNextAfterMw :: Convergent
expectedNextAfterMw = Convergent (Exponent 16936918) (Exponent 21372011)

legendreThresholdHolds :: TailGate -> Bool
legendreThresholdHolds gate =
  let a = exponentValue (legendreStart gate)
      bound = gapValue (gap gate)
   in 2 * a * bound < 3 ^ a - bound

nearCollisionGap :: Convergent -> Integer
nearCollisionGap conv =
  abs (3 ^ exponentValue (exp3 conv) - 4 ^ exponentValue (exp4 conv))

relevantConvergents :: TailGate -> [Convergent] -> [Convergent]
relevantConvergents gate =
  filter
    ( \conv ->
        exp3 conv >= legendreStart gate
          && exp3 conv < mwStart gate
    )

firstAfterMw :: TailGate -> [Convergent] -> Maybe Convergent
firstAfterMw gate =
  firstWhere (\conv -> exp3 conv >= mwStart gate)
  where
    firstWhere _ [] = Nothing
    firstWhere predicate (x : xs)
      | predicate x = Just x
      | otherwise = firstWhere predicate xs

verifyGate :: [Convergent] -> TailGate -> Either String [(String, String)]
verifyGate convs gate = do
  if not (legendreThresholdHolds gate)
    then Left "Legendre threshold inequality failed"
    else Right ()
  let relevant = relevantConvergents gate convs
      nextAfter = firstAfterMw gate convs
      gaps = [(conv, nearCollisionGap conv) | conv <- relevant]
      allGapsClear = all ((> gapValue (gap gate)) . snd) gaps
  if relevant /= expectedRelevant
    then Left ("relevant convergents mismatch: " <> show relevant)
    else Right ()
  if nextAfter /= Just expectedNextAfterMw
    then Left ("next convergent mismatch: " <> show nextAfter)
    else Right ()
  if not allGapsClear
    then Left ("near-collision gap did not clear: " <> show gaps)
    else
      Right
        [ ("case", label gate),
          ("gap", show (gap gate)),
          ("legendre start", show (legendreStart gate)),
          ("mw start", show (mwStart gate)),
          ("relevant convergents", show (length relevant)),
          ("minimum exact gap", show (minimum (map snd gaps))),
          ("next denominator", show (exp3 expectedNextAfterMw))
        ]

formatResult :: [(String, String)] -> String
formatResult rows =
  intercalate "\n" [name <> ": " <> value | (name, value) <- rows]

case347k2 :: TailGate
case347k2 =
  TailGate
    { label = "{3,4,7}, k=2",
      gap = Gap 47794770,
      legendreStart = Exponent 20,
      mwStart = Exponent 293904
    }

case347k3 :: TailGate
case347k3 =
  TailGate
    { label = "{3,4,7}, k=3",
      gap = Gap 1992303678,
      legendreStart = Exponent 23,
      mwStart = Exponent 293907
    }

case34925k2 :: TailGate
case34925k2 =
  TailGate
    { label = "{3,4,9,25}, k=2",
      gap = Gap 21701880,
      legendreStart = Exponent 19,
      mwStart = Exponent 293903
    }

case347k1 :: TailGate
case347k1 =
  TailGate
    { label = "{3,4,7}, k=1",
      gap = Gap 7002,
      legendreStart = Exponent 11,
      mwStart = Exponent 293895
    }

main :: IO ()
main = do
  let cfPrefix = alphaCfPrefix
      convs = convergents cfPrefix
      cases = [case347k1, case347k2, case347k3, case34925k2]
  if cfPrefix /= expectedCfPrefix
    then error ("continued-fraction prefix mismatch: " <> show cfPrefix)
    else putStrLn ("cf prefix: " <> show cfPrefix <> "\n")
  mapM_ (run convs) cases
  where
    run convs gate =
      case verifyGate convs gate of
        Left err -> error (label gate <> ": " <> err)
        Right rows -> putStrLn (formatResult rows <> "\n")
