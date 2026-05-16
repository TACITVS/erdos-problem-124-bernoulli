{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate)
import ScaledPowerBlock
  ( ScaledProgression,
    base,
    coefficient,
    exponentStart,
    mkScaledProgression,
    progressionFrontierAfterCount,
    progressionTotal,
    quotientPurePowerProgression,
    quotientPurePowerTerms,
    scaledTermsByCount,
    scaledTermsUpTo,
  )

data ScaledCase = ScaledCase
  { label :: String,
    coeffValue :: Integer,
    baseValue :: Integer,
    startValue :: Integer,
    countValue :: Int,
    expectedTerms :: [Integer]
  }
  deriving stock (Eq, Show)

data QuotientCase = QuotientCase
  { quotientLabel :: String,
    modulusValue :: Integer,
    pureBaseValue :: Integer,
    pureStartValue :: Integer,
    quotientCount :: Int,
    expectedQuotientTerms :: [Integer]
  }
  deriving stock (Eq, Show)

scaledCases :: [ScaledCase]
scaledCases =
  [ ScaledCase
      "scaled progression 2*3^n, n>=1"
      2
      3
      1
      5
      [6, 18, 54, 162, 486],
    ScaledCase
      "shifted progression 5*7^n, n>=2"
      5
      7
      2
      4
      [245, 1715, 12005, 84035]
  ]

quotientCases :: [QuotientCase]
quotientCases =
  [ QuotientCase
      "quotient 6^n by 6 from n>=2"
      6
      6
      2
      4
      [6, 36, 216, 1296],
    QuotientCase
      "quotient 12^n by 4 from n>=2"
      4
      12
      2
      3
      [36, 432, 5184]
  ]

formatProgression :: ScaledProgression -> String
formatProgression progression =
  show (coefficient progression)
    <> "*"
    <> show (base progression)
    <> "^n, n>="
    <> show (exponentStart progression)

runScaledCase :: ScaledCase -> Either String String
runScaledCase item = do
  progression <- mkScaledProgression (coeffValue item) (baseValue item) (startValue item)
  terms <- scaledTermsByCount progression (countValue item)
  if terms /= expectedTerms item
    then Left ("terms mismatch: " <> show terms)
    else Right ()
  total <- progressionTotal progression (countValue item)
  frontier <- progressionFrontierAfterCount progression (countValue item)
  let upToFrontierMinusOne = scaledTermsUpTo progression (frontier - 1)
  if upToFrontierMinusOne /= terms
    then Left "termsUpTo/frontier relation failed"
    else Right ()
  pure
    ( intercalate
        "\n"
        [ "case: " <> label item,
          "progression: " <> formatProgression progression,
          "terms: " <> show terms,
          "total: " <> show total,
          "frontier after count: " <> show frontier
        ]
    )

runQuotientCase :: QuotientCase -> Either String String
runQuotientCase item = do
  progression <-
    quotientPurePowerProgression
      (modulusValue item)
      (pureBaseValue item)
      (pureStartValue item)
  terms <-
    quotientPurePowerTerms
      (modulusValue item)
      (pureBaseValue item)
      (pureStartValue item)
      (quotientCount item)
  if terms /= expectedQuotientTerms item
    then Left ("quotient terms mismatch: " <> show terms)
    else Right ()
  let originalTerms =
        [ pureBaseValue item ^ powerIndex
          | powerIndex <- [pureStartValue item .. pureStartValue item + toInteger (quotientCount item) - 1]
        ]
      dividedOriginalTerms = map (`div` modulusValue item) originalTerms
  if terms /= dividedOriginalTerms
    then Left "quotient terms do not match divided pure powers"
    else Right ()
  pure
    ( intercalate
        "\n"
        [ "case: " <> quotientLabel item,
          "modulus: " <> show (modulusValue item),
          "quotient progression: " <> formatProgression progression,
          "quotient terms: " <> show terms
        ]
    )

main :: IO ()
main = do
  mapM_ printReport (map runScaledCase scaledCases)
  mapM_ printReport (map runQuotientCase quotientCases)
  where
    printReport result =
      case result of
        Left err -> error err
        Right report -> putStrLn (report <> "\n")
