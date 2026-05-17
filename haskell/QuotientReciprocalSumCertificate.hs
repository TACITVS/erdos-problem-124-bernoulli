{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate, isInfixOf)
import Data.Ratio (Ratio, denominator, numerator, (%))
import QuotientReciprocalSum
  ( BridgeRegime (..),
    bridgeRegime,
    divisibleSubset,
    quotientReciprocalSum,
    radicalOf,
    reciprocalSum,
    regimeName,
    selectionSlack,
  )

data ModulusRow = ModulusRow
  { modulusValue :: Integer,
    expectedDivisibleSubset :: [Integer],
    expectedQuotientRecip :: Ratio Integer,
    expectedSlack :: Ratio Integer,
    expectedRegime :: BridgeRegime
  }
  deriving stock (Eq, Show)

data SetCase = SetCase
  { setLabel :: String,
    setBases :: [Integer],
    expectedRecipSum :: Ratio Integer,
    modulusRows :: [ModulusRow]
  }
  deriving stock (Eq, Show)

data FailureCase = FailureCase
  { failureLabel :: String,
    failureModulus :: Integer,
    failureBases :: [Integer],
    expectedErrorFragment :: String
  }
  deriving stock (Eq, Show)

setCases :: [SetCase]
setCases =
  [ SetCase
      "exact-critical {3,4,7}, k=1"
      [3, 4, 7]
      (1 % 1)
      [ ModulusRow 2 [4] (1 % 3) ((-2) % 3) DeficitOneShot,
        ModulusRow 3 [3] (1 % 2) ((-1) % 2) DeficitOneShot,
        ModulusRow 6 [] (0 % 1) ((-1) % 1) DeficitOneShot,
        ModulusRow 7 [7] (1 % 6) ((-5) % 6) DeficitOneShot
      ],
    SetCase
      "exact-critical {3,4,9,25}, k=2"
      [3, 4, 9, 25]
      (1 % 1)
      [ ModulusRow 2 [4] (1 % 3) ((-2) % 3) DeficitOneShot,
        ModulusRow 3 [3, 9] (5 % 8) ((-3) % 8) DeficitOneShot,
        ModulusRow 5 [25] (1 % 24) ((-23) % 24) DeficitOneShot
      ],
    SetCase
      "strict {3,4,5}, k=1"
      [3, 4, 5]
      (13 % 12)
      [ ModulusRow 2 [4] (1 % 3) ((-2) % 3) DeficitOneShot,
        ModulusRow 3 [3] (1 % 2) ((-1) % 2) DeficitOneShot,
        ModulusRow 5 [5] (1 % 4) ((-3) % 4) DeficitOneShot
      ],
    SetCase
      "exact-critical modular-gate {3,6,9,12,21,45,89}, k=2"
      [3, 6, 9, 12, 21, 45, 89]
      (1 % 1)
      [ ModulusRow 3 [3, 6, 9, 12, 21, 45] (87 % 88) ((-1) % 88) DeficitOneShot,
        ModulusRow 9 [3, 6, 9, 12, 21, 45] (87 % 88) ((-1) % 88) DeficitOneShot,
        ModulusRow 89 [89] (1 % 88) ((-87) % 88) DeficitOneShot
      ],
    SetCase
      "synthetic recursive {3,5,6,9,12,15,18,21}, k=1"
      [3, 5, 6, 9, 12, 15, 18, 21]
      -- R = 1/2 + 1/4 + 1/5 + 1/8 + 1/11 + 1/14 + 1/17 + 1/20.
      ( 1 % 2 + 1 % 4 + 1 % 5 + 1 % 8 + 1 % 11 + 1 % 14 + 1 % 17 + 1 % 20
      )
      [ ModulusRow
          3
          [3, 6, 9, 12, 15, 18, 21]
          -- 1/2 + 1/5 + 1/8 + 1/11 + 1/14 + 1/17 + 1/20.
          (1 % 2 + 1 % 5 + 1 % 8 + 1 % 11 + 1 % 14 + 1 % 17 + 1 % 20)
          (1 % 2 + 1 % 5 + 1 % 8 + 1 % 11 + 1 % 14 + 1 % 17 + 1 % 20 - 1)
          RecursiveStrict,
        ModulusRow
          5
          [5, 15]
          (1 % 4 + 1 % 14)
          (1 % 4 + 1 % 14 - 1)
          DeficitOneShot,
        ModulusRow
          15
          [15]
          (1 % 14)
          (1 % 14 - 1)
          DeficitOneShot
      ]
  ]

failureCases :: [FailureCase]
failureCases =
  [ FailureCase
      "negative modulus rejected"
      (-3)
      [3, 4, 7]
      "modulus must be positive",
    FailureCase
      "base below 2 rejected"
      3
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

runModulusRow :: [Integer] -> ModulusRow -> Either String String
runModulusRow bases row = do
  let modulus = modulusValue row
      subset = divisibleSubset modulus bases
      quotientRecip = quotientReciprocalSum modulus bases
      slack = selectionSlack modulus bases
  assertEqual ("divisible subset at m=" <> show modulus) (expectedDivisibleSubset row) subset
  assertEqual ("quotient R at m=" <> show modulus) (expectedQuotientRecip row) quotientRecip
  assertEqual ("slack at m=" <> show modulus) (expectedSlack row) slack
  regime <- bridgeRegime modulus bases
  assertEqual ("regime at m=" <> show modulus) (expectedRegime row) regime
  assertEqual
    ("radical-invariance at m=" <> show modulus)
    subset
    (divisibleSubset (radicalOf modulus) bases)
  pure
    ( "  m="
        <> show modulus
        <> "  D="
        <> show subset
        <> "  R(D)="
        <> formatRatio quotientRecip
        <> "  sigma="
        <> formatRatio slack
        <> "  regime="
        <> regimeName regime
    )

runSetCase :: SetCase -> Either String String
runSetCase item = do
  let bases = setBases item
      recip = reciprocalSum bases
  assertEqual ("reciprocal sum for " <> setLabel item) (expectedRecipSum item) recip
  rowReports <- mapM (runModulusRow bases) (modulusRows item)
  pure
    ( intercalate
        "\n"
        ( [ "case: " <> setLabel item,
            "bases: " <> show bases,
            "R(A): " <> formatRatio recip
          ]
            <> rowReports
        )
    )

runFailureCase :: FailureCase -> Either String String
runFailureCase item =
  case bridgeRegime (failureModulus item) (failureBases item) of
    Right regime ->
      Left
        ( "expected rejection, got regime "
            <> regimeName regime
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
  mapM_ printReport (map runSetCase setCases)
  mapM_ printReport (map runFailureCase failureCases)
  where
    printReport result =
      case result of
        Left err -> error err
        Right report -> putStrLn (report <> "\n")
