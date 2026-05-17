{-# LANGUAGE DerivingStrategies #-}

module QuotientReciprocalSum
  ( BridgeRegime (..),
    primeSupport,
    radicalOf,
    coversSupport,
    divisibleSubset,
    reciprocalSum,
    quotientReciprocalSum,
    selectionSlack,
    bridgeRegime,
    regimeName,
  )
where

import Data.Ratio (Ratio, (%))

data BridgeRegime
  = RecursiveStrict
  | RecursiveCritical
  | DeficitOneShot
  deriving stock (Eq, Show)

primeSupport :: Integer -> [Integer]
primeSupport value
  | value <= 1 = []
  | otherwise = go value 2 []
  where
    go remaining divisor acc
      | divisor * divisor > remaining =
          reverse
            ( if remaining > 1
                then remaining : acc
                else acc
            )
      | remaining `mod` divisor == 0 =
          let stripped = stripPrime remaining divisor
           in go stripped (nextDivisor divisor) (divisor : acc)
      | otherwise = go remaining (nextDivisor divisor) acc

    stripPrime remaining divisor
      | remaining `mod` divisor == 0 = stripPrime (remaining `div` divisor) divisor
      | otherwise = remaining

    nextDivisor 2 = 3
    nextDivisor divisor = divisor + 2

radicalOf :: Integer -> Integer
radicalOf = product . primeSupport

coversSupport :: Integer -> Integer -> Bool
coversSupport modulus candidate =
  all (\p -> candidate `mod` p == 0) (primeSupport modulus)

divisibleSubset :: Integer -> [Integer] -> [Integer]
divisibleSubset modulus =
  filter (coversSupport modulus)

reciprocalSum :: [Integer] -> Ratio Integer
reciprocalSum = sum . map term
  where
    term base = 1 % (base - 1)

quotientReciprocalSum :: Integer -> [Integer] -> Ratio Integer
quotientReciprocalSum modulus bases =
  reciprocalSum (divisibleSubset modulus bases)

selectionSlack :: Integer -> [Integer] -> Ratio Integer
selectionSlack modulus bases =
  quotientReciprocalSum modulus bases - 1

bridgeRegime :: Integer -> [Integer] -> Either String BridgeRegime
bridgeRegime modulus bases
  | modulus <= 0 =
      Left ("modulus must be positive, got " <> show modulus)
  | any (< 2) bases =
      Left ("bases must be at least 2, got " <> show bases)
  | slack > 0 = Right RecursiveStrict
  | slack == 0 = Right RecursiveCritical
  | otherwise = Right DeficitOneShot
  where
    slack = selectionSlack modulus bases

regimeName :: BridgeRegime -> String
regimeName RecursiveStrict = "recursive strict"
regimeName RecursiveCritical = "recursive critical"
regimeName DeficitOneShot = "deficit one-shot"
