module FiniteSeed
  ( powersFor,
    powersUpTo,
    firstPowerAbove,
    firstPowersAbove,
    subsetSumBitsUpTo,
    lastMissingUpTo,
    exactCriticalDenominator,
    finalResidueState,
    residueStates,
    completion,
    missingResidues,
    minimalResidueRepresentatives,
    representativeMaximum,
  )
where

import Data.Bits ((.&.), (.|.), popCount, shiftL, shiftR, testBit)
import Data.List (find, sort)

powersFor :: Integer -> Integer -> Integer -> [Integer]
powersFor base exponentStart limit =
  takeWhile (<= limit) (iterate (* base) (base ^ exponentStart))

powersUpTo :: [Integer] -> Integer -> Integer -> [Integer]
powersUpTo bases exponentStart limit =
  sort (concatMap (\base -> powersFor base exponentStart limit) bases)

firstPowerAbove :: Integer -> Integer -> Integer -> Integer
firstPowerAbove base exponentStart limit =
  go (base ^ exponentStart)
  where
    go value
      | value <= limit = go (value * base)
      | otherwise = value

firstPowersAbove :: [Integer] -> Integer -> Integer -> [Integer]
firstPowersAbove bases exponentStart limit =
  map (\base -> firstPowerAbove base exponentStart limit) bases

bitMaskThrough :: Integer -> Integer
bitMaskThrough limit =
  (1 `shiftL` fromInteger (limit + 1)) - 1

subsetSumBitsUpTo :: Integer -> [Integer] -> Integer
subsetSumBitsUpTo limit =
  foldl step 1 . sort
  where
    mask = bitMaskThrough limit
    step bits term
      | term <= limit = (bits .|. (bits `shiftL` fromInteger term)) .&. mask
      | otherwise = bits

lastMissingUpTo :: Integer -> Integer -> Maybe Integer
lastMissingUpTo limit bits =
  foldl recordMissing Nothing [0 .. limit]
  where
    recordMissing latest value
      | testBit bits (fromInteger value) = latest
      | otherwise = Just value

exactCriticalDenominator :: [Integer] -> Maybe Integer
exactCriticalDenominator bases =
  let denominator = foldr lcm 1 (map (\base -> base - 1) bases)
      weightSum = sum [denominator `div` (base - 1) | base <- bases]
   in if weightSum == denominator then Just denominator else Nothing

maskFor :: Int -> Integer
maskFor residueMod =
  (1 `shiftL` residueMod) - 1

rotateResidueBits :: Int -> Integer -> Int -> Integer
rotateResidueBits residueMod bits shift =
  if shift == 0
    then bits .&. maskFor residueMod
    else ((bits `shiftL` shift) .|. (bits `shiftR` (residueMod - shift))) .&. maskFor residueMod

residueStep :: Int -> Integer -> Integer -> Integer
residueStep residueMod residues term =
  let shift = fromInteger (term `mod` toInteger residueMod)
   in residues .|. rotateResidueBits residueMod residues shift

finalResidueState :: Int -> [Integer] -> Integer
finalResidueState residueMod =
  foldl (residueStep residueMod) 1

residueStates :: Int -> [Integer] -> [Integer]
residueStates residueMod =
  scanl (residueStep residueMod) 1

completion :: Int -> [Integer] -> Maybe (Int, Integer)
completion residueMod terms =
  let afterTerms = zip3 [1 ..] terms (drop 1 (residueStates residueMod terms))
   in fmap (\(index, term, _) -> (index, term)) $
        find (\(_, _, residues) -> popCount residues == residueMod) afterTerms

missingResidues :: Int -> Integer -> [Int]
missingResidues residueMod residues =
  [residue | residue <- [0 .. residueMod - 1], not (testBit residues residue)]

updateMinAt :: Int -> Integer -> [Maybe Integer] -> [Maybe Integer]
updateMinAt 0 candidate (value : rest) =
  case value of
    Nothing -> Just candidate : rest
    Just known -> Just (min known candidate) : rest
updateMinAt index candidate (value : rest) =
  value : updateMinAt (index - 1) candidate rest
updateMinAt _ _ [] = []

addRepresentativeTerm :: Int -> [Maybe Integer] -> Integer -> [Maybe Integer]
addRepresentativeTerm residueMod representatives term =
  foldl addCandidate representatives (zip [0 ..] representatives)
  where
    shift = fromInteger (term `mod` toInteger residueMod)
    addCandidate current (residue, Just value) =
      let nextResidue = (residue + shift) `mod` residueMod
       in updateMinAt nextResidue (value + term) current
    addCandidate current (_, Nothing) = current

minimalResidueRepresentatives :: Int -> [Integer] -> [Maybe Integer]
minimalResidueRepresentatives residueMod =
  foldl (addRepresentativeTerm residueMod) (Just 0 : replicate (residueMod - 1) Nothing)

representativeMaximum :: [Maybe Integer] -> Maybe Integer
representativeMaximum representatives =
  case sequence representatives of
    Nothing -> Nothing
    Just [] -> Nothing
    Just (value : rest) -> Just (foldl max value rest)
