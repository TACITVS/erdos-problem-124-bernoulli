{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Main where

import Data.List (intercalate)
import Data.Ratio ((%))

newtype Base = Base Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

newtype Gap = Gap Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

newtype Exponent = Exponent Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

newtype CfTerm = CfTerm Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

data BasePair = BasePair
  { xBase :: Base,
    yBase :: Base
  }
  deriving stock (Eq, Show)

data Convergent = Convergent
  { yExponent :: Exponent,
    xExponent :: Exponent
  }
  deriving stock (Eq, Show)

data PairGate = PairGate
  { label :: String,
    pair :: BasePair,
    gap :: Gap,
    legendreStart :: Exponent,
    analyticStart :: Exponent,
    logTerms :: Int,
    cfTerms :: Int,
    expectedPrefix :: [CfTerm],
    expectedRelevant :: [Convergent],
    expectedNextAfterAnalytic :: Convergent
  }
  deriving stock (Eq, Show)

baseValue :: Base -> Integer
baseValue (Base x) = x

gapValue :: Gap -> Integer
gapValue (Gap x) = x

exponentValue :: Exponent -> Integer
exponentValue (Exponent x) = x

cfTermValue :: CfTerm -> Integer
cfTermValue (CfTerm x) = x

logInterval :: Base -> Int -> (Rational, Rational)
logInterval base terms =
  let x = baseValue base
      y = (x - 1) % (x + 1)
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

pairCfPrefix :: PairGate -> [CfTerm]
pairCfPrefix gate =
  let (logXLower, logXUpper) = logInterval (xBase (pair gate)) (logTerms gate)
      (logYLower, logYUpper) = logInterval (yBase (pair gate)) (logTerms gate)
   in intervalCf (logXLower / logYUpper) (logXUpper / logYLower) (cfTerms gate)

convergents :: [CfTerm] -> [Convergent]
convergents terms = go terms 0 1 1 0 []
  where
    go [] _ _ _ _ out = reverse out
    go (term : rest) p0 p1 q0 q1 out =
      let a = cfTermValue term
          p = a * p1 + p0
          q = a * q1 + q0
       in go rest p1 p q1 q (Convergent (Exponent p) (Exponent q) : out)

legendreThresholdHolds :: PairGate -> Bool
legendreThresholdHolds gate =
  let xStart = exponentValue (legendreStart gate)
      bound = gapValue (gap gate)
      x = baseValue (xBase (pair gate))
   in 2 * xStart * bound < x ^ xStart - bound

nearCollisionGap :: PairGate -> Convergent -> Integer
nearCollisionGap gate conv =
  let x = baseValue (xBase (pair gate))
      y = baseValue (yBase (pair gate))
   in abs (x ^ exponentValue (xExponent conv) - y ^ exponentValue (yExponent conv))

relevantConvergents :: PairGate -> [Convergent] -> [Convergent]
relevantConvergents gate =
  filter
    ( \conv ->
        xExponent conv >= legendreStart gate
          && xExponent conv < analyticStart gate
    )

firstAfterAnalytic :: PairGate -> [Convergent] -> Maybe Convergent
firstAfterAnalytic gate =
  firstWhere (\conv -> xExponent conv >= analyticStart gate)
  where
    firstWhere _ [] = Nothing
    firstWhere predicate (x : xs)
      | predicate x = Just x
      | otherwise = firstWhere predicate xs

verifyGate :: PairGate -> Either String [(String, String)]
verifyGate gate = do
  let prefix = pairCfPrefix gate
      convs = convergents prefix
      relevant = relevantConvergents gate convs
      nextAfter = firstAfterAnalytic gate convs
      gaps = [(conv, nearCollisionGap gate conv) | conv <- relevant]
      allGapsClear = all ((> gapValue (gap gate)) . snd) gaps
  if prefix /= expectedPrefix gate
    then Left ("continued-fraction prefix mismatch: " <> show prefix)
    else Right ()
  if not (legendreThresholdHolds gate)
    then Left "Legendre threshold inequality failed"
    else Right ()
  if relevant /= expectedRelevant gate
    then Left ("relevant convergents mismatch: " <> show relevant)
    else Right ()
  if nextAfter /= Just (expectedNextAfterAnalytic gate)
    then Left ("next convergent mismatch: " <> show nextAfter)
    else Right ()
  if null gaps
    then Left "no relevant convergents checked"
    else
      if not allGapsClear
        then Left ("near-collision gap did not clear: " <> show gaps)
        else
          Right
            [ ("case", label gate),
              ("pair", show (pair gate)),
              ("gap", show (gap gate)),
              ("legendre start", show (legendreStart gate)),
              ("analytic start", show (analyticStart gate)),
              ("relevant convergents", show (length relevant)),
              ("minimum exact gap", show (minimum (map snd gaps))),
              ("next x-exponent", show (xExponent (expectedNextAfterAnalytic gate)))
            ]

formatResult :: [(String, String)] -> String
formatResult rows =
  intercalate "\n" [name <> ": " <> value | (name, value) <- rows]

cf34 :: [CfTerm]
cf34 = map CfTerm [0, 1, 3, 1, 4, 1, 1, 11, 1, 46, 1, 5, 112]

relevant34 :: [Convergent]
relevant34 =
  [ Convergent (Exponent 19) (Exponent 24),
    Convergent (Exponent 23) (Exponent 29),
    Convergent (Exponent 42) (Exponent 53),
    Convergent (Exponent 485) (Exponent 612),
    Convergent (Exponent 527) (Exponent 665),
    Convergent (Exponent 24727) (Exponent 31202),
    Convergent (Exponent 25254) (Exponent 31867),
    Convergent (Exponent 150997) (Exponent 190537)
  ]

next34 :: Convergent
next34 = Convergent (Exponent 16936918) (Exponent 21372011)

case347k2 :: PairGate
case347k2 =
  PairGate
    { label = "{3,4,7}, k=2 imported 3/4 window",
      pair = BasePair (Base 3) (Base 4),
      gap = Gap 47794770,
      legendreStart = Exponent 20,
      analyticStart = Exponent 293904,
      logTerms = 80,
      cfTerms = 13,
      expectedPrefix = cf34,
      expectedRelevant = relevant34,
      expectedNextAfterAnalytic = next34
    }

case347k3 :: PairGate
case347k3 =
  case347k2
    { label = "{3,4,7}, k=3 imported 3/4 window",
      gap = Gap 1992303678,
      legendreStart = Exponent 23,
      analyticStart = Exponent 293907
    }

case34925k2 :: PairGate
case34925k2 =
  case347k2
    { label = "{3,4,9,25}, k=2 imported 3/4 window",
      gap = Gap 21701880,
      legendreStart = Exponent 19,
      analyticStart = Exponent 293903
    }

case513Sanity :: PairGate
case513Sanity =
  PairGate
    { label = "sanity finite window for 5/13",
      pair = BasePair (Base 5) (Base 13),
      gap = Gap 1000000,
      legendreStart = Exponent 11,
      analyticStart = Exponent 1000,
      logTerms = 100,
      cfTerms = 15,
      expectedPrefix = map CfTerm [0, 1, 1, 1, 2, 5, 1, 16, 5, 1, 1, 111, 1, 3, 3],
      expectedRelevant =
        [ Convergent (Exponent 27) (Exponent 43),
          Convergent (Exponent 32) (Exponent 51),
          Convergent (Exponent 539) (Exponent 859)
        ],
      expectedNextAfterAnalytic = Convergent (Exponent 2727) (Exponent 4346)
    }

main :: IO ()
main =
  mapM_ run [case347k2, case347k3, case34925k2, case513Sanity]
  where
    run gate =
      case verifyGate gate of
        Left err -> error (label gate <> ": " <> err)
        Right rows -> putStrLn (formatResult rows <> "\n")
