{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate)
import ScaledConductorIdentity
  ( ConductorWitness (..),
    ProgressionWindow (..),
    centralIntervalSpan,
    kappaScaled,
    purePowerKappa,
    scaledCapacity,
    seedTotal,
    tailInvariant,
  )
import ScaledPowerBlock
  ( ScaledBlock,
    mkScaledBlock,
    mkScaledProgression,
  )

data ProgressionSpec = ProgressionSpec
  { specCoefficient :: Integer,
    specBase :: Integer,
    specExponentStart :: Integer,
    specWindowEnd :: Integer
  }
  deriving stock (Eq, Show)

data IdentityCase = IdentityCase
  { caseLabel :: String,
    progressions :: [ProgressionSpec],
    expectedSeedTotal :: Integer,
    expectedCapacity :: Integer,
    expectedKappa :: Integer,
    sampleConductor :: Integer,
    expectedInvariant :: Integer
  }
  deriving stock (Eq, Show)

data PurePowerCheck = PurePowerCheck
  { pureLabel :: String,
    pureBases :: [Integer],
    pureExponentFloor :: Integer,
    pureExpectedKappa :: Integer
  }
  deriving stock (Eq, Show)

identityCases :: [IdentityCase]
identityCases =
  -- Single dyadic progression {2^n : 0..3}.  Terms 1,2,4,8.
  [ IdentityCase
      "single dyadic block 2^0..2^3"
      [ProgressionSpec 1 2 0 4]
      -- seedTotal = (2^4 - 2^0)/1 = 15
      15
      -- capacity = 2^4/1 = 16
      16
      -- kappa = 2^0/1 = 1
      1
      -- conductor -1 means the seed is complete on [0, 14]; halfSum = 7.
      -- K = kappa + 2(-1) + 1 = 1 - 2 + 1 = 0.
      (-1)
      0,
    -- Single ternary block 3^0..3^3.  Terms 1,3,9,27.
    IdentityCase
      "single ternary block 3^0..3^3"
      [ProgressionSpec 1 3 0 4]
      -- seedTotal = (3^4 - 3^0)/2 = (81-1)/2 = 40
      40
      -- capacity = 3^4/2 = 40 (integer division)
      40
      -- kappa = 3^0/2 = 0 (integer division)
      0
      -- choose conductor 5; K = 0 + 11 = 11
      5
      11,
    -- Scaled ternary 3*3^n with windows; terms 9, 27, 81.
    IdentityCase
      "scaled ternary 3 * 3^(1..3)"
      [ProgressionSpec 3 3 1 4]
      -- seedTotal = (3*3^4 - 3*3^1) div 2 = (243 - 9) div 2 = 117
      117
      -- capacity = 3 * 3^4 div 2 = 243 div 2 = 121
      121
      -- kappa = 3 * 3^1 div 2 = 9 div 2 = 4
      4
      0
      -- K = 4 + 0 + 1 = 5
      5,
    -- Mixed dyadic + ternary.  Progressions [(1,2,0..3),(1,3,0..2)].
    IdentityCase
      "mixed dyadic 2^0..2^3 and ternary 3^0..3^2"
      [ProgressionSpec 1 2 0 4, ProgressionSpec 1 3 0 3]
      -- 15 + (3^3 - 1)/2 = 15 + 13 = 28
      28
      -- 16 + 27/2 = 16 + 13 = 29
      29
      -- 1 + 3^0/2 = 1 + 0 = 1
      1
      0
      2
  ]

purePowerCases :: [PurePowerCheck]
purePowerCases =
  [ PurePowerCheck
      "pure-power kappa for {3,4,7}, k=1"
      [3, 4, 7]
      1
      -- 3/2 + 4/3 + 7/6 = (9+8+7)/6 = 24/6 = 4 (integer divisions: 1 + 1 + 1 = 3)
      3,
    PurePowerCheck
      "pure-power kappa for {3,4,7}, k=2"
      [3, 4, 7]
      2
      -- 9/2 + 16/3 + 49/6 -- integer: 4 + 5 + 8 = 17
      17
  ]

buildBlock :: [ProgressionSpec] -> Either String ScaledBlock
buildBlock specs = do
  progs <-
    mapM
      ( \spec ->
          mkScaledProgression
            (specCoefficient spec)
            (specBase spec)
            (specExponentStart spec)
      )
      specs
  mkScaledBlock progs

windowsOf :: [ProgressionSpec] -> [ProgressionWindow]
windowsOf =
  map
    ( \spec ->
        ProgressionWindow
          { windowStart = specExponentStart spec,
            windowEnd = specWindowEnd spec
          }
    )

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

runIdentityCase :: IdentityCase -> Either String String
runIdentityCase item = do
  block <- buildBlock (progressions item)
  let windows = windowsOf (progressions item)
  total <- seedTotal block windows
  capacity <- scaledCapacity block windows
  kappa <- kappaScaled block
  let difference = capacity - total
  assertEqual ("seed total for " <> caseLabel item) (expectedSeedTotal item) total
  assertEqual ("capacity for " <> caseLabel item) (expectedCapacity item) capacity
  assertEqual ("kappa for " <> caseLabel item) (expectedKappa item) kappa
  assertEqual
    ("C - S identity for " <> caseLabel item)
    kappa
    difference
  let witness =
        ConductorWitness
          { witnessConductor = sampleConductor item,
            witnessSeedTotal = total
          }
  invariant <- tailInvariant block witness
  assertEqual
    ("tail invariant K for " <> caseLabel item)
    (expectedInvariant item)
    invariant
  let span_ = centralIntervalSpan witness
  pure
    ( intercalate
        "\n"
        [ "case: " <> caseLabel item,
          "seed total S(B,E): " <> show total,
          "capacity C(B,E): " <> show capacity,
          "kappa_scaled(B): " <> show kappa,
          "difference C - S: " <> show difference,
          "sample conductor c: " <> show (sampleConductor item),
          "central interval span H: " <> show span_,
          "tail invariant K: " <> show invariant
        ]
    )

runPurePowerCase :: PurePowerCheck -> Either String String
runPurePowerCase item = do
  let actual = purePowerKappa (pureBases item) (pureExponentFloor item)
  assertEqual
    ("pure-power kappa for " <> pureLabel item)
    (pureExpectedKappa item)
    actual
  pure
    ( "case: "
        <> pureLabel item
        <> "\n  pure-power kappa(A,k): "
        <> show actual
    )

main :: IO ()
main = do
  mapM_ printReport (map runIdentityCase identityCases)
  mapM_ printReport (map runPurePowerCase purePowerCases)
  where
    printReport result =
      case result of
        Left err -> error err
        Right report -> putStrLn (report <> "\n")
