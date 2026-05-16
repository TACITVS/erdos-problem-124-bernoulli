{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate)
import qualified ResidueGate as RG
import ResidueLift (frameRepresentatives, frameWidth)
import UnitResidueFrame
  ( UnitFrame (..),
    mkUnitFrame,
  )

data UnitCase = UnitCase
  { label :: String,
    modulusValue :: Int,
    baseValue :: Integer,
    exponentStart :: Integer
  }
  deriving stock (Eq, Show)

unitCases :: [UnitCase]
unitCases =
  [ UnitCase
      "{3,4,7} denominator: base 7 is a unit modulo 6"
      6
      7
      1,
    UnitCase
      "{3,4,9,25} denominator: base 25 is a unit modulo 24"
      24
      25
      2,
    UnitCase
      "nontrivial order sample: base 3 modulo 5"
      5
      3
      1
  ]

runCase :: UnitCase -> Either String String
runCase item = do
  modulus <- RG.mkModulus (modulusValue item)
  unit <- mkUnitFrame modulus (baseValue item) (exponentStart item)
  pure
    ( intercalate
        "\n"
        [ "case: " <> label item,
          "modulus: " <> show (modulusValue item),
          "base: " <> show (baseValue item),
          "exponent start: " <> show (exponentStart item),
          "multiplicative order: " <> show (unitOrder unit),
          "frame term count: " <> show (length (unitTerms unit)),
          "representative count: " <> show (length (frameRepresentatives (unitFrame unit))),
          "representative bound R: " <> show (frameWidth (unitFrame unit))
        ]
    )

main :: IO ()
main =
  mapM_ printCase unitCases
  where
    printCase item =
      case runCase item of
        Left err -> error (label item <> ": " <> err)
        Right report -> putStrLn (report <> "\n")
