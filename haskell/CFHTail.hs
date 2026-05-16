{-# LANGUAGE DerivingStrategies #-}

module CFHTail
  ( TailState (..),
    TailRow (..),
    TailCertificate (..),
    reciprocalSum,
    tailCapital,
    cfhInvariant,
    nextTerm,
    cfhMargin,
    cfhConditionHolds,
    strictTakeoverReady,
    advanceFrontier,
    verifyStrictCfhTail,
  )
where

import Data.List (minimumBy)
import Data.Ord (comparing)

data TailState = TailState
  { tailBases :: [Integer],
    tailFrontier :: [Integer],
    cfhGapBound :: Integer
  }
  deriving stock (Eq, Show)

data TailRow = TailRow
  { rowStep :: Int,
    rowFrontier :: [Integer],
    rowNextTerm :: Integer,
    rowMargin :: Rational,
    rowStrictReady :: Bool
  }
  deriving stock (Eq, Show)

data TailCertificate = TailCertificate
  { certificateInvariant :: Rational,
    certificateRows :: [TailRow]
  }
  deriving stock (Eq, Show)

reciprocalSum :: [Integer] -> Rational
reciprocalSum bases =
  sum [1 / fromInteger (base - 1) | base <- bases]

tailCapital :: TailState -> Rational
tailCapital state =
  sum
    [ fromInteger term / fromInteger (base - 1)
      | (base, term) <- zip (tailBases state) (tailFrontier state)
    ]

cfhInvariant :: TailState -> Rational
cfhInvariant state =
  tailCapital state - fromInteger (cfhGapBound state)

nextTerm :: TailState -> Integer
nextTerm =
  minimum . tailFrontier

cfhMargin :: Rational -> TailState -> Rational
cfhMargin invariant state =
  tailCapital state - fromInteger (nextTerm state) - invariant

cfhConditionHolds :: Rational -> TailState -> Bool
cfhConditionHolds invariant state =
  cfhMargin invariant state >= 0

strictTakeoverReady :: Rational -> TailState -> Bool
strictTakeoverReady invariant state =
  let slack = reciprocalSum (tailBases state) - 1
   in slack > 0 && slack * fromInteger (nextTerm state) >= invariant

advanceFrontier :: TailState -> TailState
advanceFrontier state =
  let indexed = zip3 ([0 ..] :: [Int]) (tailBases state) (tailFrontier state)
      (advanceIndex, _, _) = minimumBy (comparing (\(_, _, term) -> term)) indexed
      update index base term
        | index == advanceIndex = term * base
        | otherwise = term
   in state {tailFrontier = zipWith3 update ([0 ..] :: [Int]) (tailBases state) (tailFrontier state)}

verifyStrictCfhTail :: Int -> TailState -> Either String TailCertificate
verifyStrictCfhTail maxSteps initial
  | length (tailBases initial) /= length (tailFrontier initial) =
      Left "base/frontier length mismatch"
  | any (<= 1) (tailBases initial) =
      Left "all bases must be greater than 1"
  | cfhGapBound initial <= 0 =
      Left "gap bound must be positive"
  | reciprocalSum (tailBases initial) <= 1 =
      Left "strict CFH tail certificate requires reciprocal sum greater than 1"
  | maxSteps < 0 =
      Left "maxSteps must be nonnegative"
  | otherwise =
      go (cfhInvariant initial) 0 initial []
  where
    go invariant step state rows
      | not (cfhConditionHolds invariant state) =
          Left ("CFH condition failed at step " <> show step)
      | strictTakeoverReady invariant state =
          Right (TailCertificate invariant (reverse (currentRow : rows)))
      | step >= maxSteps =
          Left ("strict takeover not reached within " <> show maxSteps <> " steps")
      | otherwise =
          go invariant (step + 1) (advanceFrontier state) (currentRow : rows)
      where
        currentRow =
          TailRow
            { rowStep = step,
              rowFrontier = tailFrontier state,
              rowNextTerm = nextTerm state,
              rowMargin = cfhMargin invariant state,
              rowStrictReady = strictTakeoverReady invariant state
            }
