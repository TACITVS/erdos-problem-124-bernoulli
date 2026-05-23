{-# LANGUAGE DerivingStrategies #-}

-- | Utility for computing Proposition 84.1 / 84.2 thresholds.
--
-- Given a multiplicatively-independent pair (x, y), an irrationality
-- measure bound mu_0 on log y / log x, and a B* value, this module
-- computes:
--
-- - M_L  (Legendre threshold from note 82 §2.1): smallest p with
--         4 p B* < x^p log y.
-- - M_L' (Proposition 84.1 threshold under bounded PQ K): smallest p
--         with x^p log x > 4 (K+1) p B*.
-- - M_L'' (Proposition 84.2 threshold under bounded mu_0): smallest p
--         with x^p log x > 4 p^{mu_0 - 1} B*.
--
-- A case (A, k) with pair (x, y) and threshold B* is closed
-- unconditionally by Proposition 84.2 iff M_L''(mu_0, B*, x) <= M_L
-- (i.e., the Prop 84.2 closure window starts before or at the
-- Legendre threshold).
--
-- Build: ghc -O RegimeThresholds.hs
-- Run:   ./RegimeThresholds.exe

module Main where

-- | Smallest positive integer p with x^p log y > 4 p B*.
--   (Legendre threshold from note 82 §2.1.)
legendreThreshold :: Double -> Double -> Double -> Integer
legendreThreshold x y bStar = head [p | p <- [1 ..], satisfies p]
  where
    satisfies p =
      x ** fromInteger p * log y > 4 * fromInteger p * bStar

-- | Smallest p with x^p log x > 4 (K+1) p B*.
--   (Proposition 84.1's M_L' threshold under bounded PQ K.)
prop841Threshold :: Double -> Double -> Double -> Integer -> Integer
prop841Threshold x _y bStar k = head [p | p <- [1 ..], satisfies p]
  where
    satisfies p =
      x ** fromInteger p * log x > 4 * fromInteger (k + 1) * fromInteger p * bStar

-- | Smallest p with x^p log x > 4 p^{mu_0 - 1} B*.
--   (Proposition 84.2's M_L'' threshold under bounded mu_0.)
prop842Threshold :: Double -> Double -> Double -> Double -> Integer
prop842Threshold x _y bStar mu0 = head [p | p <- [1 ..], satisfies p]
  where
    satisfies p =
      x ** fromInteger p * log x > 4 * fromInteger p ** (mu0 - 1) * bStar

-- | A case description.
data Case = Case
  { caseName :: String,
    pairX :: Double,
    pairY :: Double,
    pairMu :: Double,
    pairPQBound :: Integer,
    bStarValue :: Double
  }
  deriving stock (Eq, Show)

-- | Print analysis of a case.
analyzeCase :: Case -> IO ()
analyzeCase c = do
  let mL = legendreThreshold (pairX c) (pairY c) (bStarValue c)
      mL' = prop841Threshold (pairX c) (pairY c) (bStarValue c) (pairPQBound c)
      mL'' = prop842Threshold (pairX c) (pairY c) (bStarValue c) (pairMu c)
      shiftPQ = mL' - mL
      shiftMu = mL'' - mL
      closedBy
        | mL' <= mL = "Prop 84.1 (PQ window empty above M_L)"
        | mL'' <= mL = "Prop 84.2 (large B* regime)"
        | otherwise = "needs intermediate CF check on [" ++ show mL ++ ", " ++ show (min mL' mL'') ++ "]"
  putStrLn $ "Case: " ++ caseName c
  putStrLn $ "  pair (x, y) = (" ++ show (pairX c :: Double) ++ ", " ++ show (pairY c) ++ ")"
  putStrLn $ "  B* = " ++ show (bStarValue c)
  putStrLn $ "  mu_0 = " ++ show (pairMu c) ++ ", K bound = " ++ show (pairPQBound c)
  putStrLn $ "  M_L = " ++ show mL
  putStrLn $ "  M_L' (Prop 84.1) = " ++ show mL' ++ "  (shift +" ++ show shiftPQ ++ ")"
  putStrLn $ "  M_L'' (Prop 84.2) = " ++ show mL'' ++ "  (shift +" ++ show shiftMu ++ ")"
  putStrLn $ "  Status: " ++ closedBy
  putStrLn ""

main :: IO ()
main = do
  putStrLn "# Regime thresholds for Propositions 84.1 / 84.2"
  putStrLn ""
  putStrLn "Comparing the (3, 4)-pair across the four certified cases of"
  putStrLn "notes 46, 07, 09, 10, 11, using:"
  putStrLn "  K = 112 (max partial quotient through first 12 convergents of log 4/log 3)"
  putStrLn "  mu_0 = 5.117 (Rhin 1987: mu(log 2/log 3) <= 5.117)"
  putStrLn ""

  mapM_ analyzeCase
    [ Case "{3,4,7} k=1" 3.0 4.0 5.117 112 5835.0,
      Case "{3,4,7} k=2" 3.0 4.0 5.117 112 39828975.0,
      Case "{3,4,7} k=3" 3.0 4.0 5.117 112 1660253065.0,
      Case "{3,4,9,25} k=2" 3.0 4.0 5.117 112 4521225.0,
      -- Hypothetical new cases from larger A:
      Case "{3,4,7,11} k=1 (B* est)" 3.0 4.0 5.117 112 50000.0,
      Case "{3,4,7,11,13} k=2 (B* est)" 3.0 4.0 5.117 112 100000000.0
    ]

  putStrLn ""
  putStrLn "## (2, 9) pair: x = 2, y = 9, mu(log 9/log 2) = mu(log 3/log 2) <= 5.117"
  putStrLn ""
  mapM_ analyzeCase
    [ Case "Synthetic small B*" 2.0 9.0 5.117 112 10000.0,
      Case "Synthetic large B*" 2.0 9.0 5.117 112 1000000000.0
    ]

  putStrLn ""
  putStrLn "## (4, 9) pair: x = 4, y = 9, mu(log 9/log 4) = mu(log 3/log 2) <= 5.117"
  putStrLn ""
  mapM_ analyzeCase
    [ Case "Synthetic small B*" 4.0 9.0 5.117 112 10000.0,
      Case "Synthetic large B*" 4.0 9.0 5.117 112 1000000000.0
    ]
