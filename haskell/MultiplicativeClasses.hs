{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate, nub, sort)

newtype Base = Base Integer
  deriving stock (Eq, Ord, Show)

newtype Prime = Prime Integer
  deriving stock (Eq, Ord, Show)

newtype Exponent = Exponent Integer
  deriving stock (Eq, Ord, Show)

newtype ClassKey = ClassKey [(Prime, Exponent)]
  deriving stock (Eq, Ord, Show)

baseValue :: Base -> Integer
baseValue (Base x) = x

exponentValue :: Exponent -> Integer
exponentValue (Exponent x) = x

gcdAll :: [Base] -> Integer
gcdAll = foldl gcd 0 . map baseValue

factorize :: Base -> [(Prime, Exponent)]
factorize (Base n)
  | n < 2 = error "bases must be at least 2"
  | otherwise = go n 2 []
  where
    go rest divisor acc
      | divisor * divisor > rest =
          reverse
            ( if rest == 1
                then acc
                else (Prime rest, Exponent 1) : acc
            )
      | rest `mod` divisor == 0 =
          let (remaining, count) = divideOut rest divisor 0
           in go remaining (nextDivisor divisor) ((Prime divisor, Exponent count) : acc)
      | otherwise = go rest (nextDivisor divisor) acc
    divideOut value divisor count
      | value `mod` divisor == 0 = divideOut (value `div` divisor) divisor (count + 1)
      | otherwise = (value, count)
    nextDivisor 2 = 3
    nextDivisor d = d + 2

classKey :: Base -> ClassKey
classKey b =
  let factors = factorize b
      exponentGcd = foldl gcd 0 [e | (_, Exponent e) <- factors]
      normalize (prime, power) = (prime, Exponent (exponentValue power `div` exponentGcd))
   in ClassKey (map normalize factors)

classKeys :: [Base] -> [ClassKey]
classKeys = sort . nub . map classKey

classCount :: [Base] -> Int
classCount = length . classKeys

multiplicativelyDependent :: Base -> Base -> Bool
multiplicativelyDependent x y = classKey x == classKey y

hasIndependentPair :: [Base] -> Bool
hasIndependentPair bases = classCount bases >= 2

data ClassCase = ClassCase
  { label :: String,
    bases :: [Base],
    expectedGcd :: Integer,
    expectedClassCount :: Int
  }
  deriving stock (Eq, Show)

knownExactCriticalCases :: [ClassCase]
knownExactCriticalCases =
  [ make "(3,4,7)" [3, 4, 7] 3,
    make "(3,4,9,25)" [3, 4, 9, 25] 3,
    make "(3,4,10,19)" [3, 4, 10, 19] 4,
    make "(3,4,11,16)" [3, 4, 11, 16] 3,
    make "(3,5,6,21)" [3, 5, 6, 21] 4,
    make "(3,5,7,13)" [3, 5, 7, 13] 4,
    make "(3,4,13,22,29)" [3, 4, 13, 22, 29] 5,
    make "(3,5,7,22,29)" [3, 5, 7, 22, 29] 5,
    make "(3,5,8,15,29)" [3, 5, 8, 15, 29] 5,
    make "(3,5,9,13,25)" [3, 5, 9, 13, 25] 3,
    make "(3,5,10,13,19)" [3, 5, 10, 13, 19] 5,
    make "(3,5,11,13,16)" [3, 5, 11, 13, 16] 5,
    make "(3,6,7,13,21)" [3, 6, 7, 13, 21] 5,
    make "(4,5,6,7,21)" [4, 5, 6, 7, 21] 5
  ]
  where
    make name values classes =
      ClassCase
        { label = name,
          bases = map Base values,
          expectedGcd = 1,
          expectedClassCount = classes
        }

dependentSanityCases :: [ClassCase]
dependentSanityCases =
  [ ClassCase "{4,8,16}" (map Base [4, 8, 16]) 4 1,
    ClassCase "{9,27,81}" (map Base [9, 27, 81]) 9 1,
    ClassCase "{8,27}" (map Base [8, 27]) 1 2,
    ClassCase "{12,72}" (map Base [12, 72]) 12 2
  ]

verifyCase :: ClassCase -> Either String [(String, String)]
verifyCase item = do
  let actualGcd = gcdAll (bases item)
      actualClassCount = classCount (bases item)
      independent = hasIndependentPair (bases item)
  if actualGcd /= expectedGcd item
    then Left ("gcd mismatch: " <> show actualGcd)
    else pure ()
  if actualClassCount /= expectedClassCount item
    then Left ("class count mismatch: " <> show actualClassCount)
    else pure ()
  if actualGcd == 1 && not independent
    then Left "gcd-one set had no independent pair"
    else
      Right
        [ ("case", label item),
          ("gcd", show actualGcd),
          ("classes", show actualClassCount),
          ("class keys", show (classKeys (bases item)))
        ]

formatResult :: [(String, String)] -> String
formatResult rows =
  intercalate "\n" [name <> ": " <> value | (name, value) <- rows]

main :: IO ()
main =
  mapM_ run (knownExactCriticalCases <> dependentSanityCases)
  where
    run item =
      case verifyCase item of
        Left err -> error (label item <> ": " <> err)
        Right rows -> putStrLn (formatResult rows <> "\n")
