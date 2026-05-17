{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate, isInfixOf)
import SameBaseFrobenius
  ( frobeniusGaps,
    frobeniusNumber,
    gcdOfList,
    numericalSemigroup,
    subsetSums,
  )

data PairCase = PairCase
  { pairLabel :: String,
    pairGenerators :: [Integer],
    expectedFrobenius :: Integer,
    expectedGapsBelow :: Integer,
    expectedGaps :: [Integer]
  }
  deriving stock (Eq, Show)

data MultiCase = MultiCase
  { multiLabel :: String,
    multiGenerators :: [Integer],
    multiExpectedUpperBound :: Integer,
    multiExpectedFiniteGaps :: [Integer]
  }
  deriving stock (Eq, Show)

data InclusionCase = InclusionCase
  { inclusionLabel :: String,
    inclusionGenerators :: [Integer],
    inclusionLimit :: Integer
  }
  deriving stock (Eq, Show)

data FailureCase = FailureCase
  { failureLabel :: String,
    failureGenerators :: [Integer],
    expectedErrorFragment :: String
  }
  deriving stock (Eq, Show)

pairCases :: [PairCase]
pairCases =
  [ PairCase
      "F(3,5) = 7"
      [3, 5]
      7
      8
      -- gaps in [0,8]: 1, 2, 4, 7
      [1, 2, 4, 7],
    PairCase
      "F(2,7) = 5"
      [2, 7]
      5
      6
      -- gaps in [0,6]: 1, 3, 5
      [1, 3, 5],
    PairCase
      "F(5,7) = 23"
      [5, 7]
      23
      24
      -- gaps in [0,24]: 1,2,3,4,6,8,9,11,13,16,18,23
      [1, 2, 3, 4, 6, 8, 9, 11, 13, 16, 18, 23]
  ]

multiCases :: [MultiCase]
multiCases =
  [ MultiCase
      "{3,5,7} numerical semigroup"
      [3, 5, 7]
      -- max q*(q-1) = 7*6 = 42
      42
      -- gaps in [0,42]: 1, 2, 4 (semigroup contains 3,5,6=3+3,7,8=3+5,9,10=3+7,...)
      [1, 2, 4],
    MultiCase
      "{4,6,9} numerical semigroup"
      -- gcd = 1; max q*(q-1) = 9*8 = 72
      [4, 6, 9]
      72
      -- gaps in [0,72]: integers not expressible as 4a+6b+9c, a,b,c >= 0.
      -- representable include 0,4,6,8,9,10,12,13,14,15,16,...
      -- exhaustive enumeration in [0,72] gives: 1,2,3,5,7,11.
      [1, 2, 3, 5, 7, 11]
  ]

inclusionCases :: [InclusionCase]
inclusionCases =
  [ InclusionCase "{3,5} subset-sum vs semigroup up to 20" [3, 5] 20,
    InclusionCase "{3,5,7} subset-sum vs semigroup up to 30" [3, 5, 7] 30
  ]

failureCases :: [FailureCase]
failureCases =
  [ FailureCase
      "non-coprime rejected"
      [4, 6, 10]
      "must be coprime",
    FailureCase
      "below-2 generator rejected"
      [1, 3]
      "at least 2",
    FailureCase
      "single generator rejected"
      [5]
      "infinite Frobenius number"
  ]

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

runPairCase :: PairCase -> Either String String
runPairCase item = do
  frobenius <- frobeniusNumber (pairGenerators item)
  assertEqual ("Frobenius number for " <> pairLabel item) (expectedFrobenius item) frobenius
  gaps <- frobeniusGaps (pairGenerators item) (expectedGapsBelow item)
  assertEqual ("gaps for " <> pairLabel item) (expectedGaps item) gaps
  pure
    ( intercalate
        "\n"
        [ "case: " <> pairLabel item,
          "generators: " <> show (pairGenerators item),
          "Frobenius F(q1,q2): " <> show frobenius,
          "gaps below " <> show (expectedGapsBelow item) <> ": " <> show gaps
        ]
    )

runMultiCase :: MultiCase -> Either String String
runMultiCase item = do
  bound <- frobeniusNumber (multiGenerators item)
  assertEqual ("upper bound for " <> multiLabel item) (multiExpectedUpperBound item) bound
  gaps <- frobeniusGaps (multiGenerators item) bound
  assertEqual ("finite gaps for " <> multiLabel item) (multiExpectedFiniteGaps item) gaps
  pure
    ( intercalate
        "\n"
        [ "case: " <> multiLabel item,
          "generators: " <> show (multiGenerators item),
          "upper bound max q(q-1): " <> show bound,
          "finite gaps in [0,bound]: " <> show gaps
        ]
    )

runInclusionCase :: InclusionCase -> Either String String
runInclusionCase item = do
  let generators = inclusionGenerators item
      limit = inclusionLimit item
      subset = filter (<= limit) (subsetSums generators)
      semigroup_ = numericalSemigroup generators limit
      missing = [s | s <- subset, s `notElem` semigroup_]
  assertEqual
    ("subset-sum subset of semigroup for " <> inclusionLabel item)
    []
    missing
  pure
    ( intercalate
        "\n"
        [ "case: " <> inclusionLabel item,
          "subset sums (truncated): " <> show subset,
          "semigroup elements (truncated): " <> show semigroup_,
          "subset minus semigroup: " <> show missing
        ]
    )

runFailureCase :: FailureCase -> Either String String
runFailureCase item =
  case frobeniusNumber (failureGenerators item) of
    Right value ->
      Left
        ( "expected rejection for "
            <> failureLabel item
            <> ", got "
            <> show value
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

runGcdSanity :: Either String String
runGcdSanity =
  pure
    ( "gcd sanity: gcd[6,10,15] = "
        <> show (gcdOfList [6, 10, 15])
        <> ", gcd[4,6,9] = "
        <> show (gcdOfList [4, 6, 9])
    )

main :: IO ()
main = do
  mapM_ printReport (map runPairCase pairCases)
  mapM_ printReport (map runMultiCase multiCases)
  mapM_ printReport (map runInclusionCase inclusionCases)
  mapM_ printReport (map runFailureCase failureCases)
  printReport runGcdSanity
  where
    printReport result =
      case result of
        Left err -> error err
        Right report -> putStrLn (report <> "\n")
