{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate, isInfixOf)
import GapBridge (intervalEnd, intervalStart, mkSeedInterval)
import SingleProgressionAbsorption
  ( AbsorptionCount (..),
    SpanGrowth (..),
    absorbSequentially,
    absorbablePrefix,
    spanGrowthFactor,
  )

data DyadicCase = DyadicCase
  { dyadicLabel :: String,
    dyadicSpan :: Integer,
    dyadicCoefficient :: Integer,
    dyadicStart :: Integer,
    expectedDyadicCount :: Maybe Int
  }
  deriving stock (Eq, Show)

data GeometricCase = GeometricCase
  { geometricLabel :: String,
    geometricSpan :: Integer,
    geometricCoefficient :: Integer,
    geometricBase :: Integer,
    geometricStart :: Integer,
    expectedCount :: Int,
    expectedFinalSpan :: Integer
  }
  deriving stock (Eq, Show)

data FailureCase = FailureCase
  { failureLabel :: String,
    failureSpan :: Integer,
    failureCoefficient :: Integer,
    failureBase :: Integer,
    failureStart :: Integer,
    expectedErrorFragment :: String
  }
  deriving stock (Eq, Show)

dyadicCases :: [DyadicCase]
dyadicCases =
  [ DyadicCase
      "dyadic full absorption with H0=7, q=1, n0=0"
      7
      1
      0
      Nothing,
    DyadicCase
      "dyadic no absorption when H0 below first term"
      6
      1
      3
      (Just 0),
    DyadicCase
      "dyadic ignition exactly at threshold q=3, n0=2"
      11
      3
      2
      Nothing
  ]

geometricCases :: [GeometricCase]
geometricCases =
  [ GeometricCase
      "ternary q=1 n0=0 with span 1"
      1
      1
      3
      0
      -- terms 1, 3, 9, ... ; H0=1 so first term 1 absorbs (1 <= 2) leaving
      -- span 2; second term 3 absorbs (3 <= 3) leaving span 5; third term
      -- 9 fails (9 > 6).
      2
      5,
    GeometricCase
      "ternary q=1 n0=0 with large span"
      100
      1
      3
      0
      -- terms 1, 3, 9, 27, 81, 243; cumulative sums 0,1,4,13,40,121,...
      -- check 243 <= 100 + 121 + 1 = 222? No. So absorb 5 terms 1..81.
      5
      221,
    GeometricCase
      "ternary q=2 n0=1 with span 12"
      12
      2
      3
      1
      -- first term 6 needs span >= 5; ok (12 + 0 + 1 = 13 >= 6).  Sum 6;
      -- new span 18.  Next 18 needs 18 <= 12 + 6 + 1 = 19; ok.  Sum 24;
      -- new span 36.  Next 54 needs 54 <= 12 + 24 + 1 = 37; fails.
      2
      36,
    GeometricCase
      "quaternary q=1 n0=0 with span 4"
      4
      1
      4
      0
      -- terms 1, 4, 16, 64; cumulative 0,1,5,21
      -- 1 <= 5? yes. 4 <= 6? yes. 16 <= 10? no. So 2 terms.
      2
      9,
    GeometricCase
      "quinary q=1 n0=0 with span 100"
      100
      1
      5
      0
      -- terms 1, 5, 25, 125, 625; cumulative 0,1,6,31,156
      -- 1<=101 yes; 5<=106 yes; 25<=126 yes; 125<=131 yes; 625<=257 no.
      -- So 4 terms.
      4
      256
  ]

failureCases :: [FailureCase]
failureCases =
  [ FailureCase
      "base 1 rejected"
      10
      1
      1
      0
      "base must be at least 2",
    FailureCase
      "negative span rejected"
      (-1)
      1
      3
      0
      "seed span must be nonnegative",
    FailureCase
      "zero coefficient rejected"
      10
      0
      3
      0
      "coefficient must be positive"
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

runDyadicCase :: DyadicCase -> Either String String
runDyadicCase item = do
  count <- absorbablePrefix (dyadicSpan item) (dyadicCoefficient item) 2 (dyadicStart item)
  assertEqual
    ("dyadic count for " <> dyadicLabel item)
    (expectedDyadicCount item)
    (maxPrefixLength count)
  pure
    ( intercalate
        "\n"
        [ "case: " <> dyadicLabel item,
          "initial span: " <> show (initialSpan count),
          "first term q * 2^n0: "
            <> show (dyadicCoefficient item * 2 ^ dyadicStart item),
          "absorbable prefix length: "
            <> show
              (maybe "infinite" show (maxPrefixLength count))
        ]
    )

-- Crosscheck closed-form count against direct GapBridge.absorbTerm iteration.
crosscheckGeometric :: GeometricCase -> Either String ()
crosscheckGeometric item = do
  interval <- mkSeedInterval 0 (geometricSpan item)
  let (sequentialCount, _) =
        absorbSequentially
          interval
          (geometricCoefficient item)
          (geometricBase item)
          (geometricStart item)
          (expectedCount item + 5)
  assertEqual
    ("sequential vs closed-form count for " <> geometricLabel item)
    (expectedCount item)
    sequentialCount

runGeometricCase :: GeometricCase -> Either String String
runGeometricCase item = do
  count <-
    absorbablePrefix
      (geometricSpan item)
      (geometricCoefficient item)
      (geometricBase item)
      (geometricStart item)
  assertEqual
    ("closed-form count for " <> geometricLabel item)
    (Just (expectedCount item))
    (maxPrefixLength count)
  assertEqual
    ("post-absorption span for " <> geometricLabel item)
    (Just (expectedFinalSpan item))
    (postAbsorptionSpan count)
  crosscheckGeometric item
  growth <- spanGrowthFactor (geometricBase item)
  let (num, den) = case growth of
        GeometricFactor n d -> (n, d)
        DyadicFullAbsorption ->
          error ("internal: unexpected dyadic growth for base " <> show (geometricBase item))
  pure
    ( intercalate
        "\n"
        [ "case: " <> geometricLabel item,
          "initial span: " <> show (initialSpan count),
          "scaled progression: q="
            <> show (progressionCoefficient count)
            <> ", d="
            <> show (progressionBase count)
            <> ", n0="
            <> show (progressionStart count),
          "absorbable prefix length: " <> show (maxPrefixLength count),
          "post-absorption span: " <> show (postAbsorptionSpan count),
          "structural growth factor 2(d-1)/(d-2): "
            <> show num
            <> "/"
            <> show den
        ]
    )

runFailureCase :: FailureCase -> Either String String
runFailureCase item =
  case absorbablePrefix
    (failureSpan item)
    (failureCoefficient item)
    (failureBase item)
    (failureStart item) of
    Right _ -> Left ("expected rejection for " <> failureLabel item)
    Left err
      | expectedErrorFragment item `isInfixOf` err ->
          Right ("case: " <> failureLabel item <> "\n  rejected: " <> err)
      | otherwise -> Left ("unexpected failure reason: " <> err)

runDyadicGrowthCase :: Either String String
runDyadicGrowthCase = do
  growth <- spanGrowthFactor 2
  case growth of
    DyadicFullAbsorption ->
      pure "growth check: base 2 reports DyadicFullAbsorption"
    GeometricFactor n d ->
      Left
        ( "expected DyadicFullAbsorption for base 2, got "
            <> show n
            <> "/"
            <> show d
        )

main :: IO ()
main = do
  mapM_ printReport (map runDyadicCase dyadicCases)
  mapM_ printReport (map runGeometricCase geometricCases)
  mapM_ printReport (map runFailureCase failureCases)
  printReport runDyadicGrowthCase
  where
    printReport result =
      case result of
        Left err -> error err
        Right report -> putStrLn (report <> "\n")
