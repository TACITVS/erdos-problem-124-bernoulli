{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Main where

import Data.List (intercalate)

newtype Base = Base Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord)

newtype Exponent = Exponent Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

newtype Power = Power Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

newtype Denominator = Denominator Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

newtype Weight = Weight Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

newtype Conductor = Conductor Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

newtype ClearedBound = ClearedBound Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

newtype Margin = Margin Integer
  deriving stock (Eq, Show)
  deriving newtype (Ord, Num)

data ExactCritical = ExactCritical
  { bases :: [Base],
    denominator :: Denominator,
    weights :: [Weight]
  }
  deriving stock (Eq, Show)

data TailCase = TailCase
  { label :: String,
    baseSet :: [Base],
    firstPower :: Exponent,
    seedLimit :: Integer,
    conductor :: Conductor,
    expectedBound :: ClearedBound,
    startExponents :: [Exponent],
    checkedUntilBase :: Base,
    checkedUntilExponent :: Exponent
  }
  deriving stock (Eq, Show)

baseValue :: Base -> Integer
baseValue (Base x) = x

exponentValue :: Exponent -> Integer
exponentValue (Exponent x) = x

powerValue :: Power -> Integer
powerValue (Power x) = x

weightValue :: Weight -> Integer
weightValue (Weight x) = x

boundValue :: ClearedBound -> Integer
boundValue (ClearedBound x) = x

marginValue :: Margin -> Integer
marginValue (Margin x) = x

pow :: Base -> Exponent -> Power
pow b e = Power (baseValue b ^ exponentValue e)

exactCritical :: [Base] -> Either String ExactCritical
exactCritical bs =
  let den = foldl lcm 1 [baseValue b - 1 | b <- bs]
      ws = [den `div` (baseValue b - 1) | b <- bs]
   in if sum ws == den
        then Right (ExactCritical bs (Denominator den) (map Weight ws))
        else Left "base set is not exact-critical"

firstExponentsAbove :: [Base] -> Exponent -> Integer -> [Exponent]
firstExponentsAbove bs k limit = map firstAbove bs
  where
    firstAbove b = go k
      where
        go e
          | powerValue (pow b e) > limit = e
          | otherwise = go (e + 1)

obstructionBound :: ExactCritical -> Exponent -> Conductor -> ClearedBound
obstructionBound ec k (Conductor c) =
  let Denominator den = denominator ec
      initial =
        sum
          [ weightValue w * powerValue (pow b k)
            | (w, b) <- zip (weights ec) (bases ec)
          ]
   in ClearedBound (initial + 2 * den * c + den)

frontierStatesUntil :: [Base] -> [Exponent] -> Base -> Exponent -> [[Exponent]]
frontierStatesUntil bs start targetBase targetExp = go start
  where
    targetIndex =
      case [i | (i, b) <- zip [0 :: Int ..] bs, b == targetBase] of
        i : _ -> i
        [] -> error "target base not in base set"
    go exps
      | exps !! targetIndex >= targetExp = []
      | otherwise = exps : go (advance exps)
    advance exps =
      let values = [pow b e | (b, e) <- zip bs exps]
          next = minimum values
       in [ if v == next then e + 1 else e
            | (e, v) <- zip exps values
          ]

marginForState :: ExactCritical -> [Exponent] -> ClearedBound -> Margin
marginForState ec exps bound =
  let values = [pow b e | (b, e) <- zip (bases ec) exps]
      next = minimum values
      excess =
        sum
          [ weightValue w * (powerValue value - powerValue next)
            | (w, value) <- zip (weights ec) values
          ]
   in Margin (excess - boundValue bound)

verifyCase :: TailCase -> Either String [(String, String)]
verifyCase tc = do
  ec <- exactCritical (baseSet tc)
  let actualStart = firstExponentsAbove (baseSet tc) (firstPower tc) (seedLimit tc)
      actualBound = obstructionBound ec (firstPower tc) (conductor tc)
      states =
        frontierStatesUntil
          (baseSet tc)
          (startExponents tc)
          (checkedUntilBase tc)
          (checkedUntilExponent tc)
      margins = [marginForState ec state actualBound | state <- states]
  if actualStart /= startExponents tc
    then Left ("start exponents mismatch: " <> show actualStart)
    else
      if actualBound /= expectedBound tc
        then Left ("bound mismatch: " <> show actualBound)
        else
          if any ((<= 0) . marginValue) margins
            then Left ("non-positive margin: " <> show margins)
            else
              Right
                [ ("case", label tc),
                  ("denominator", show (denominator ec)),
                  ("weights", show (weights ec)),
                  ("bound", show actualBound),
                  ("start", show actualStart),
                  ("states checked", show (length states)),
                  ("minimum margin", show (minimum margins))
                ]

formatResult :: [(String, String)] -> String
formatResult rows =
  intercalate
    "\n"
    [name <> ": " <> value | (name, value) <- rows]

case34925k2 :: TailCase
case34925k2 =
  TailCase
    { label = "{3,4,9,25}, k=2",
      baseSet = map Base [3, 4, 9, 25],
      firstPower = Exponent 2,
      seedLimit = 10000000,
      conductor = Conductor 452099,
      expectedBound = ClearedBound 21701880,
      startExponents = map Exponent [15, 12, 8, 6],
      checkedUntilBase = Base 3,
      checkedUntilExponent = Exponent 19
    }

case347k3 :: TailCase
case347k3 =
  TailCase
    { label = "{3,4,7}, k=3",
      baseSet = map Base [3, 4, 7],
      firstPower = Exponent 3,
      seedLimit = 5000000000,
      conductor = Conductor 166025260,
      expectedBound = ClearedBound 1992303678,
      startExponents = map Exponent [21, 17, 12],
      checkedUntilBase = Base 3,
      checkedUntilExponent = Exponent 23
    }

main :: IO ()
main = do
  let cases = [case34925k2, case347k3]
  mapM_ run cases
  where
    run tc =
      case verifyCase tc of
        Left err -> error (label tc <> ": " <> err)
        Right rows -> putStrLn (formatResult rows <> "\n")
