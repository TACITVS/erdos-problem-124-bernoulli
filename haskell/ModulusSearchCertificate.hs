{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate, isInfixOf)
import Data.Ratio (Ratio, denominator, numerator, (%))
import ModulusSearch
  ( ModulusVerdict (..),
    bestSlackModulus,
    primesOfBases,
    radicalDivisors,
    searchAllRegimes,
  )
import QuotientReciprocalSum (BridgeRegime (..), regimeName)

data SearchCase = SearchCase
  { searchLabel :: String,
    searchBases :: [Integer],
    expectedPrimes :: [Integer],
    expectedRadicalCount :: Int,
    expectedBestModulus :: Integer,
    expectedBestRegime :: BridgeRegime,
    expectedBestSlack :: Ratio Integer
  }
  deriving stock (Eq, Show)

data FailureCase = FailureCase
  { failureLabel :: String,
    failureBases :: [Integer],
    expectedErrorFragment :: String
  }
  deriving stock (Eq, Show)

successCases :: [SearchCase]
successCases =
  [ SearchCase
      "{3,4,7}"
      [3, 4, 7]
      [2, 3, 7]
      8
      3
      DeficitOneShot
      ((-1) % 2),
    SearchCase
      "{3,4,9,25}"
      [3, 4, 9, 25]
      [2, 3, 5]
      8
      3
      DeficitOneShot
      ((-3) % 8),
    SearchCase
      "{3,4,5}"
      [3, 4, 5]
      [2, 3, 5]
      8
      3
      DeficitOneShot
      ((-1) % 2),
    SearchCase
      "{3,5,7,13}"
      [3, 5, 7, 13]
      [3, 5, 7, 13]
      16
      3
      DeficitOneShot
      ((-1) % 2),
    SearchCase
      "modular-gate {3,6,9,12,21,45,89}"
      [3, 6, 9, 12, 21, 45, 89]
      [2, 3, 5, 7, 89]
      32
      3
      DeficitOneShot
      ((-1) % 88),
    SearchCase
      "synthetic recursive {3,5,6,9,12,15,18,21}"
      [3, 5, 6, 9, 12, 15, 18, 21]
      [2, 3, 5, 7]
      16
      3
      RecursiveStrict
      -- 1/2 + 1/5 + 1/8 + 1/11 + 1/14 + 1/17 + 1/20 - 1.
      (1 % 2 + 1 % 5 + 1 % 8 + 1 % 11 + 1 % 14 + 1 % 17 + 1 % 20 - 1)
  ]

failureCases :: [FailureCase]
failureCases =
  [ FailureCase
      "empty base set rejected"
      []
      "at least one base",
    FailureCase
      "base below 2 rejected"
      [1, 3, 4]
      "bases must be at least 2"
  ]

formatRatio :: Ratio Integer -> String
formatRatio value =
  show (numerator value) <> "/" <> show (denominator value)

assertEqual :: (Eq value, Show value) => String -> value -> value -> Either String ()
assertEqual name expected actual
  | expected == actual = Right ()
  | otherwise =
      Left
        ( name
            <> " mismatch: expected "
            <> show expected
            <> ", got "
            <> show actual
        )

formatVerdict :: ModulusVerdict -> String
formatVerdict verdict =
  "  m="
    <> show (verdictModulus verdict)
    <> "  regime="
    <> regimeName (verdictRegime verdict)
    <> "  slack="
    <> formatRatio (verdictSlack verdict)

runSuccessCase :: SearchCase -> Either String String
runSuccessCase item = do
  let bases = searchBases item
      primes = primesOfBases bases
      divisors = radicalDivisors bases
  assertEqual ("primes for " <> searchLabel item) (expectedPrimes item) primes
  assertEqual
    ("radical divisor count for " <> searchLabel item)
    (expectedRadicalCount item)
    (length divisors)
  verdicts <- searchAllRegimes bases
  best <- bestSlackModulus bases
  case best of
    Nothing -> Left ("no verdict produced for " <> searchLabel item)
    Just verdict -> do
      assertEqual
        ("best modulus for " <> searchLabel item)
        (expectedBestModulus item)
        (verdictModulus verdict)
      assertEqual
        ("best regime for " <> searchLabel item)
        (expectedBestRegime item)
        (verdictRegime verdict)
      assertEqual
        ("best slack for " <> searchLabel item)
        (expectedBestSlack item)
        (verdictSlack verdict)
      pure
        ( intercalate
            "\n"
            ( [ "case: " <> searchLabel item,
                "primes: " <> show primes,
                "radical divisors: " <> show divisors,
                "best: " <> formatVerdict verdict,
                "all verdicts:"
              ]
                <> map formatVerdict verdicts
            )
        )

runFailureCase :: FailureCase -> Either String String
runFailureCase item =
  case bestSlackModulus (failureBases item) of
    Right _ ->
      Left
        ( "expected rejection for "
            <> failureLabel item
        )
    Left err
      | expectedErrorFragment item `isInfixOf` err ->
          Right
            ( "case: "
                <> failureLabel item
                <> "\n  rejected: "
                <> err
            )
      | otherwise -> Left ("unexpected failure reason: " <> err)

main :: IO ()
main = do
  mapM_ printReport (map runSuccessCase successCases)
  mapM_ printReport (map runFailureCase failureCases)
  where
    printReport result =
      case result of
        Left err -> error err
        Right report -> putStrLn (report <> "\n")
