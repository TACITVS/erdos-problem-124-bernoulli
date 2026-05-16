{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate)
import FiniteSeed
  ( completion,
    exactCriticalDenominator,
    finalResidueState,
    firstPowersAbove,
    minimalResidueRepresentatives,
    missingResidues,
    powersUpTo,
    representativeMaximum,
  )

data ResidueProfile = ResidueProfile
  { label :: String,
    bases :: [Integer],
    firstExponent :: Integer,
    seedLimit :: Integer,
    modulus :: Int,
    termCount :: Int,
    seedSum :: Integer,
    firstCompletionIndex :: Int,
    firstCompletionTerm :: Integer,
    maxResidueRepresentative :: Integer,
    frontier :: [Integer],
    reciprocalSumText :: String
  }
  deriving stock (Eq, Show)

profiles :: [ResidueProfile]
profiles =
  [ ResidueProfile "{3,4,7}, k=1" [3, 4, 7] 1 1000 6 13 1831 3 7 14 [2187, 1024, 2401] "1",
    ResidueProfile "{3,4,9,25}, k=1" [3, 4, 9, 25] 1 1000 24 15 2901 6 25 59 [2187, 1024, 6561, 15625] "1",
    ResidueProfile "{3,4,10,19}, k=1" [3, 4, 10, 19] 1 1000 18 15 2922 5 16 42 [2187, 1024, 10000, 6859] "1",
    ResidueProfile "{3,4,11,16}, k=1" [3, 4, 11, 16] 1 1000 30 14 1836 7 27 56 [2187, 1024, 1331, 4096] "1",
    ResidueProfile "{3,5,6,21}, k=1" [3, 5, 6, 21] 1 1000 20 15 2592 6 25 42 [2187, 3125, 1296, 9261] "1",
    ResidueProfile "{3,5,7,13}, k=1" [3, 5, 7, 13] 1 1000 12 15 2453 5 13 23 [2187, 3125, 2401, 2197] "1",
    ResidueProfile "{3,4,13,22,29}, k=1" [3, 4, 13, 22, 29] 1 1000 84 16 2990 9 64 121 [2187, 1024, 2197, 10648, 24389] "1",
    ResidueProfile "{3,5,7,22,29}, k=1" [3, 5, 7, 22, 29] 1 1000 84 17 3647 9 49 110 [2187, 3125, 2401, 10648, 24389] "1",
    ResidueProfile "{3,5,8,15,29}, k=1" [3, 5, 8, 15, 29] 1 1000 28 17 3566 6 25 49 [2187, 3125, 4096, 3375, 24389] "1",
    ResidueProfile "{3,5,9,13,25}, k=1" [3, 5, 9, 13, 25] 1 1000 24 17 3523 7 25 44 [2187, 3125, 6561, 2197, 15625] "1",
    ResidueProfile "{3,5,10,13,19}, k=1" [3, 5, 10, 13, 19] 1 1000 36 17 3544 6 19 56 [2187, 3125, 10000, 2197, 6859] "1",
    ResidueProfile "{3,5,11,13,16}, k=1" [3, 5, 11, 13, 16] 1 1000 60 16 2458 8 27 91 [2187, 3125, 1331, 2197, 4096] "1",
    ResidueProfile "{3,6,7,13,21}, k=1" [3, 6, 7, 13, 21] 1 1000 60 16 2393 7 27 77 [2187, 1296, 2401, 2197, 9261] "1",
    ResidueProfile "{4,5,6,7,21}, k=1" [4, 5, 6, 7, 21] 1 1000 60 16 2239 7 25 84 [1024, 3125, 1296, 2401, 9261] "1",
    ResidueProfile "{3,4,7}, k=2" [3, 4, 7] 2 4000 6 13 7429 4 49 74 [6561, 4096, 16807] "1",
    ResidueProfile "{3,4,9,25}, k=2" [3, 4, 9, 25] 2 4000 24 13 6071 7 243 359 [6561, 4096, 6561, 15625] "1",
    ResidueProfile "{3,4,10,19}, k=2" [3, 4, 10, 19] 2 4000 18 13 6097 8 256 429 [6561, 4096, 10000, 6859] "1",
    ResidueProfile "{3,4,11,16}, k=2" [3, 4, 11, 16] 2 4000 30 13 6344 7 243 345 [6561, 4096, 14641, 4096] "1",
    ResidueProfile "{3,5,6,21}, k=2" [3, 5, 6, 21] 2 4000 20 14 9165 6 125 178 [6561, 15625, 7776, 9261] "1",
    ResidueProfile "{3,5,7,13}, k=2" [3, 5, 7, 13] 2 4000 12 15 12335 5 81 152 [6561, 15625, 16807, 28561] "1",
    ResidueProfile "{3,4,13,22,29}, k=2" [3, 4, 13, 22, 29] 2 4000 84 14 8327 9 484 823 [6561, 4096, 28561, 10648, 24389] "1",
    ResidueProfile "{3,5,7,22,29}, k=2" [3, 5, 7, 22, 29] 2 4000 84 15 11294 9 484 741 [6561, 15625, 16807, 10648, 24389] "1",
    ResidueProfile "{3,5,8,15,29}, k=2" [3, 5, 8, 15, 29] 2 4000 28 15 12193 6 125 331 [6561, 15625, 4096, 50625, 24389] "1",
    ResidueProfile "{3,5,9,13,25}, k=2" [3, 5, 9, 13, 25] 2 4000 24 15 10977 7 169 304 [6561, 15625, 6561, 28561, 15625] "1",
    ResidueProfile "{3,5,10,13,19}, k=2" [3, 5, 10, 13, 19] 2 4000 36 15 11003 10 625 840 [6561, 15625, 10000, 28561, 6859] "1",
    ResidueProfile "{3,5,11,13,16}, k=2" [3, 5, 11, 13, 16] 2 4000 60 15 11250 7 169 405 [6561, 15625, 14641, 28561, 4096] "1",
    ResidueProfile "{3,6,7,13,21}, k=2" [3, 6, 7, 13, 21] 2 4000 60 15 10424 9 343 594 [6561, 7776, 16807, 28561, 9261] "1",
    ResidueProfile "{4,5,6,7,21}, k=2" [4, 5, 6, 7, 21] 2 4000 60 15 10042 9 343 607 [4096, 15625, 7776, 16807, 9261] "1"
  ]

verifyProfile :: ResidueProfile -> Either String [(String, String)]
verifyProfile profile = do
  expectedModulus <-
    case exactCriticalDenominator (bases profile) of
      Nothing -> Left "not exact-critical"
      Just denominator -> Right denominator
  if toInteger (modulus profile) /= expectedModulus
    then Left "modulus is not the exact-critical denominator"
    else Right ()

  let seed = powersUpTo (bases profile) (firstExponent profile) (seedLimit profile)
  if length seed /= termCount profile
    then Left "term count mismatch"
    else Right ()
  if sum seed /= seedSum profile
    then Left "seed sum mismatch"
    else Right ()
  if firstPowersAbove (bases profile) (firstExponent profile) (seedLimit profile) /= frontier profile
    then Left "frontier mismatch"
    else Right ()

  let finalResidues = finalResidueState (modulus profile) seed
      missing = missingResidues (modulus profile) finalResidues
  if null missing
    then Right ()
    else Left ("missing residues: " <> show missing)

  representativeMax <-
    case representativeMaximum (minimalResidueRepresentatives (modulus profile) seed) of
      Nothing -> Left "incomplete minimal residue representatives"
      Just value -> Right value
  if representativeMax /= maxResidueRepresentative profile
    then Left ("max residue representative mismatch: " <> show representativeMax)
    else Right ()

  case completion (modulus profile) seed of
    Nothing -> Left "no completion point"
    Just (index, term) ->
      if index == firstCompletionIndex profile && term == firstCompletionTerm profile
        then
          Right
            [ ("case", label profile),
              ("seed limit", show (seedLimit profile)),
              ("modulus", show (modulus profile)),
              ("terms", show (termCount profile)),
              ("completion", show (index, term)),
              ("max residue representative", show representativeMax),
              ("frontier", show (frontier profile)),
              ("reciprocal sum", reciprocalSumText profile)
            ]
        else Left ("completion mismatch: " <> show (index, term))

formatResult :: [(String, String)] -> String
formatResult rows =
  intercalate "\n" [name <> ": " <> value | (name, value) <- rows]

main :: IO ()
main =
  mapM_ run profiles
  where
    run profile =
      case verifyProfile profile of
        Left err -> error (label profile <> ": " <> err)
        Right rows -> putStrLn (formatResult rows <> "\n")
