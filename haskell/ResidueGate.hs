{-# LANGUAGE DerivingStrategies #-}

module ResidueGate
  ( Modulus,
    Residue,
    Coverage (..),
    mkModulus,
    modulusValue,
    normalizeResidue,
    residueValue,
    residueMaskFromIntegers,
    subsetSumResidueMask,
    witnessGcd,
    quasiCompleteResidueMask,
    residuesInMask,
    completeResidueSet,
    quasiCompleteResidueWitness,
    missingResiduesInMask,
    coverageName,
  )
where

import Data.Bits ((.|.), shiftL, testBit)
import qualified FiniteSeed as FS

newtype Modulus = Modulus Int
  deriving stock (Eq, Ord, Show)

newtype Residue = Residue Int
  deriving stock (Eq, Ord, Show)

data Coverage
  = CompleteResidues
  | QuasiCompleteWitness
  deriving stock (Eq, Show)

mkModulus :: Int -> Either String Modulus
mkModulus value
  | value > 0 = Right (Modulus value)
  | otherwise = Left ("modulus must be positive, got " <> show value)

modulusValue :: Modulus -> Int
modulusValue (Modulus value) = value

normalizeResidue :: Modulus -> Integer -> Residue
normalizeResidue (Modulus modulus) value =
  Residue (fromInteger (value `mod` toInteger modulus))

residueValue :: Residue -> Int
residueValue (Residue value) = value

residueBit :: Residue -> Integer
residueBit (Residue value) =
  (1 :: Integer) `shiftL` value

residueMaskFromIntegers :: Modulus -> [Integer] -> Integer
residueMaskFromIntegers modulus values =
  foldl (.|.) 0 (map (residueBit . normalizeResidue modulus) values)

subsetSumResidueMask :: Modulus -> [Integer] -> Integer
subsetSumResidueMask modulus =
  FS.finalResidueState (modulusValue modulus)

witnessGcd :: [Integer] -> Maybe Integer
witnessGcd [] = Nothing
witnessGcd values =
  let divisor = foldl gcd 0 (map abs values)
   in if divisor == 0 then Nothing else Just divisor

quasiCompleteResidueMask :: Modulus -> [Integer] -> Maybe Integer
quasiCompleteResidueMask modulus values
  | length values /= modulusValue modulus = Nothing
  | otherwise = do
      divisor <- witnessGcd values
      pure (residueMaskFromIntegers modulus (map (`div` divisor) values))

residuesInMask :: Modulus -> Integer -> [Residue]
residuesInMask (Modulus modulus) mask =
  [Residue value | value <- [0 .. modulus - 1], testBit mask value]

completeResidueSet :: Modulus -> Integer -> Bool
completeResidueSet modulus mask =
  null (FS.missingResidues (modulusValue modulus) mask)

-- Xue-Fang-Ma call a p-element set {c_i} quasi-complete modulo p
-- when division by gcd(c_i) gives a complete residue system modulo p.
quasiCompleteResidueWitness :: Modulus -> [Integer] -> Bool
quasiCompleteResidueWitness modulus values =
  case quasiCompleteResidueMask modulus values of
    Nothing -> False
    Just mask -> completeResidueSet modulus mask

missingResiduesInMask :: Modulus -> Integer -> [Residue]
missingResiduesInMask modulus mask =
  map Residue (FS.missingResidues (modulusValue modulus) mask)

coverageName :: Coverage -> String
coverageName CompleteResidues = "complete residues"
coverageName QuasiCompleteWitness = "gcd-normalized quasi-complete witness"
