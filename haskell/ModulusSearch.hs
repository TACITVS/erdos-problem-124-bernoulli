{-# LANGUAGE DerivingStrategies #-}

module ModulusSearch
  ( ModulusVerdict (..),
    primesOfBases,
    squarefreeDivisors,
    radicalDivisors,
    searchAllRegimes,
    bestSlackModulus,
  )
where

import Data.List (sort)
import Data.Ratio (Ratio)
import QuotientReciprocalSum
  ( BridgeRegime (..),
    bridgeRegime,
    primeSupport,
    selectionSlack,
  )

data ModulusVerdict = ModulusVerdict
  { verdictModulus :: Integer,
    verdictRegime :: BridgeRegime,
    verdictSlack :: Ratio Integer
  }
  deriving stock (Eq, Show)

primesOfBases :: [Integer] -> [Integer]
primesOfBases =
  sort
    . foldr insertUnique []
    . concatMap primeSupport
  where
    insertUnique value acc
      | value `elem` acc = acc
      | otherwise = value : acc

squarefreeDivisors :: [Integer] -> [Integer]
squarefreeDivisors primes =
  sort (map product (subsequencesOf primes))
  where
    subsequencesOf [] = [[]]
    subsequencesOf (x : xs) =
      let rest = subsequencesOf xs
       in rest <> map (x :) rest

radicalDivisors :: [Integer] -> [Integer]
radicalDivisors =
  squarefreeDivisors . primesOfBases

searchAllRegimes ::
  [Integer] ->
  Either String [ModulusVerdict]
searchAllRegimes bases
  | null bases = Left "modulus search needs at least one base"
  | any (< 2) bases =
      Left ("bases must be at least 2, got " <> show bases)
  | otherwise =
      mapM verdictAt nontrivialRadicals
  where
    nontrivialRadicals = filter (> 1) (radicalDivisors bases)
    verdictAt modulus = do
      regime <- bridgeRegime modulus bases
      pure
        ModulusVerdict
          { verdictModulus = modulus,
            verdictRegime = regime,
            verdictSlack = selectionSlack modulus bases
          }

-- Selection rule: prefer the largest slack overall; ties broken by smaller
-- radical.  Returns Nothing when the only valid moduli are degenerate.
bestSlackModulus :: [Integer] -> Either String (Maybe ModulusVerdict)
bestSlackModulus bases = do
  verdicts <- searchAllRegimes bases
  pure (foldr accumulate Nothing verdicts)
  where
    accumulate verdict Nothing = Just verdict
    accumulate verdict (Just current)
      | verdictSlack verdict > verdictSlack current = Just verdict
      | verdictSlack verdict == verdictSlack current
          && verdictModulus verdict < verdictModulus current =
          Just verdict
      | otherwise = Just current
