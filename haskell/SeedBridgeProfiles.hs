{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate)

data SeedProfile = SeedProfile
  { label :: String,
    bases :: [Integer],
    firstExponent :: Integer,
    seedLimit :: Integer,
    termCount :: Integer,
    seedSum :: Integer,
    halfSum :: Integer,
    conductorToHalf :: Integer,
    centralStart :: Integer,
    centralEnd :: Integer,
    centralSpan :: Integer,
    frontier :: [Integer],
    reciprocalSumText :: String
  }
  deriving stock (Eq, Show)

profiles :: [SeedProfile]
profiles =
  [ SeedProfile "{3,4,7}, k=1" [3, 4, 7] 1 1000 13 1831 915 581 582 1249 667 [2187, 1024, 2401] "1",
    SeedProfile "{3,4,5}, k=1" [3, 4, 5] 1 1000 14 2212 1106 79 80 2132 2052 [2187, 1024, 3125] "13/12",
    SeedProfile "{3,4,9,25}, k=1" [3, 4, 9, 25] 1 1000 15 2901 1450 658 659 2242 1583 [2187, 1024, 6561, 15625] "1",
    SeedProfile "{3,4,10,19}, k=1" [3, 4, 10, 19] 1 1000 15 2922 1461 251 252 2670 2418 [2187, 1024, 10000, 6859] "1",
    SeedProfile "{3,4,11,16}, k=1" [3, 4, 11, 16] 1 1000 14 1836 918 69 70 1766 1696 [2187, 1024, 1331, 4096] "1",
    SeedProfile "{3,5,6,21}, k=1" [3, 5, 6, 21] 1 1000 15 2592 1296 22 23 2569 2546 [2187, 3125, 1296, 9261] "1",
    SeedProfile "{3,5,7,13}, k=1" [3, 5, 7, 13] 1 1000 15 2453 1226 112 113 2340 2227 [2187, 3125, 2401, 2197] "1",
    SeedProfile "{3,4,13,22,29}, k=1" [3, 4, 13, 22, 29] 1 1000 16 2990 1495 37 38 2952 2914 [2187, 1024, 2197, 10648, 24389] "1",
    SeedProfile "{3,5,7,22,29}, k=1" [3, 5, 7, 22, 29] 1 1000 17 3647 1823 26 27 3620 3593 [2187, 3125, 2401, 10648, 24389] "1",
    SeedProfile "{3,5,8,15,29}, k=1" [3, 5, 8, 15, 29] 1 1000 17 3566 1783 21 22 3544 3522 [2187, 3125, 4096, 3375, 24389] "1",
    SeedProfile "{3,5,9,13,25}, k=1" [3, 5, 9, 13, 25] 1 1000 17 3523 1761 110 111 3412 3301 [2187, 3125, 6561, 2197, 15625] "1",
    SeedProfile "{3,5,10,13,19}, k=1" [3, 5, 10, 13, 19] 1 1000 17 3544 1772 20 21 3523 3502 [2187, 3125, 10000, 2197, 6859] "1",
    SeedProfile "{3,5,11,13,16}, k=1" [3, 5, 11, 13, 16] 1 1000 16 2458 1229 112 113 2345 2232 [2187, 3125, 1331, 2197, 4096] "1",
    SeedProfile "{3,6,7,13,21}, k=1" [3, 6, 7, 13, 21] 1 1000 16 2393 1196 17 18 2375 2357 [2187, 1296, 2401, 2197, 9261] "1",
    SeedProfile "{4,5,6,7,21}, k=1" [4, 5, 6, 7, 21] 1 1000 16 2239 1119 24 25 2214 2189 [1024, 3125, 1296, 2401, 9261] "1"
  ]

verifyProfile :: SeedProfile -> Either String [(String, String)]
verifyProfile profile = do
  if halfSum profile /= seedSum profile `div` 2
    then Left "half sum mismatch"
    else Right ()
  if centralStart profile /= conductorToHalf profile + 1
    then Left "central start mismatch"
    else Right ()
  if centralEnd profile /= seedSum profile - conductorToHalf profile - 1
    then Left "central end mismatch"
    else Right ()
  if centralSpan profile /= centralEnd profile - centralStart profile
    then Left "central span mismatch"
    else Right ()
  if termCount profile <= 0
    then Left "empty seed profile"
    else Right ()
  if length (frontier profile) /= length (bases profile)
    then Left "frontier length mismatch"
    else
      Right
        [ ("case", label profile),
          ("seed limit", show (seedLimit profile)),
          ("terms", show (termCount profile)),
          ("central interval", show (centralStart profile, centralEnd profile)),
          ("span", show (centralSpan profile)),
          ("frontier", show (frontier profile)),
          ("reciprocal sum", reciprocalSumText profile)
        ]

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
