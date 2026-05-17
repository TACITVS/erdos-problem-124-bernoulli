{-# LANGUAGE DerivingStrategies #-}

module SameBaseFrobenius
  ( gcdOfList,
    frobeniusNumber,
    numericalSemigroup,
    frobeniusGaps,
    subsetSums,
  )
where

import Data.List (foldl', nub, sort)

gcdOfList :: [Integer] -> Integer
gcdOfList = foldl' gcd 0

-- Frobenius number for two coprime generators (Sylvester):
-- F(q1,q2) = q1*q2 - q1 - q2.  For more than two generators we return an
-- explicit upper bound max q_i * (q_i - 1) that suffices for the same-base
-- conductor bound in the note; the certificate distinguishes the exact
-- two-generator case from the upper-bound case.
frobeniusNumber :: [Integer] -> Either String Integer
frobeniusNumber [] = Left "Frobenius needs at least one generator"
frobeniusNumber generators
  | any (< 2) generators =
      Left ("generators must be at least 2, got " <> show generators)
  | length unique == 1 =
      Left ("single generator " <> show unique <> " has infinite Frobenius number")
  | gcdOfList generators /= 1 =
      Left ("generators must be coprime, got gcd " <> show (gcdOfList generators))
  | length unique == 2 =
      let [q1, q2] = unique
       in Right (q1 * q2 - q1 - q2)
  | otherwise =
      Right (maximum [q * (q - 1) | q <- unique])
  where
    unique = nub (sort generators)

numericalSemigroup :: [Integer] -> Integer -> [Integer]
numericalSemigroup generators upperLimit
  | upperLimit < 0 = []
  | otherwise = sort (build [0])
  where
    build acc
      | all (`elem` acc) candidates = acc
      | otherwise = build (nub (acc <> candidates))
      where
        candidates =
          [ x + g
            | x <- acc,
              g <- generators,
              x + g <= upperLimit,
              (x + g) `notElem` acc
          ]

frobeniusGaps :: [Integer] -> Integer -> Either String [Integer]
frobeniusGaps generators upperLimit
  | upperLimit < 0 = Left ("upper limit must be nonnegative, got " <> show upperLimit)
  | otherwise = do
      let representable = numericalSemigroup generators upperLimit
      Right [n | n <- [0 .. upperLimit], n `notElem` representable]

subsetSums :: [Integer] -> [Integer]
subsetSums =
  sort . nub . foldr step [0]
  where
    step value acc = nub (acc <> map (+ value) acc)
