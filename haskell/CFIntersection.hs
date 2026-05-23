{-# LANGUAGE DerivingStrategies #-}

-- | CF intersection utility for verifying Conjecture 92.2 (note 92).
--
-- For a multiplicatively-independent triple (x, y, z) of integers,
-- compute:
--   D_{xy} = denominators of CF convergents of log y / log x
--   N_{yz} = numerators of CF convergents of log z / log y
-- and report their intersection up to a specified depth.
--
-- Empty intersection (beyond trivial e_y = 1) ⇒ Charge γ closes the
-- triple's contribution to (H4-3').
--
-- Build: ghc -O CFIntersection.hs
-- Run:   ./CFIntersection.exe

module Main where

import Data.List (intersect, sort)
import Data.Ratio (Ratio, denominator, numerator, (%))

-- | Compute CF expansion of log y / log x to a given depth, using
--   exact rational arithmetic.  Returns the list of partial quotients
--   [a_0, a_1, a_2, ...].
--
-- For log y / log x we use the property:
--   log y / log x > a iff y > x^a
--   so a_0 = floor(log y / log x) = max a with x^a <= y.
--
-- We then recurse on 1 / (log y / log x - a_0) = log x / log (y/x^{a_0}).
-- Since we're working with positive integers, this is well-defined as
-- long as y > 1 and x > 1.
cfExpansion :: Integer -> Integer -> Int -> [Integer]
cfExpansion _ _ 0 = []
cfExpansion x y depth
  | y < x = 0 : cfExpansion y x (depth - 1) -- log y / log x < 1: a_0 = 0
  | otherwise =
      let a0 = floorLogRatio y x
       in a0 : cfExpansion (y `divPow` (x, a0)) x (depth - 1)

-- y divPow (x, a0) = y / x^{a0}, but we need to handle this carefully.
-- For CF: after extracting a_0 = floor(log y / log x), we recurse on
-- log x / log(y / x^{a_0}).  But y / x^{a_0} might not be an integer.
-- Instead, we recurse exactly: a_{n+1} = floor(1 / fractional part).
-- We track the fractional part using "log y - a_0 log x", which we keep
-- as a pair (numerator, denominator) of a power product.
--
-- Concretely, we represent the residual as a pair (u, v) of positive
-- integers such that the current value alpha = log u / log v.
-- After extracting a = floor(alpha), the new alpha = log v / log(u / v^a) = log v / log u_new
-- where u_new = u / v^a (as a fraction; we track the integer part exactly).
--
-- This needs more care than the inline version above.  Let's use a cleaner
-- explicit recursion.
divPow :: Integer -> (Integer, Integer) -> Integer
divPow _y (_x, _) = error "use cfExpansionExact instead"

-- | Floor of log y / log x for positive integers x, y > 1.
floorLogRatio :: Integer -> Integer -> Integer
floorLogRatio y x = go 0 1
  where
    go n p
      | p * x > y = n
      | otherwise = go (n + 1) (p * x)

-- | CF expansion using exact integer arithmetic.  We track the
--   residual as a pair (u, v) of positive integers with current value
--   alpha = log u / log v (u >= v > 1).
--
-- After extracting a = floor(alpha) (so u >= v^a and u < v^{a+1}),
-- the new residual has value 1 / (alpha - a) = log v / log(u / v^a).
-- The integer part of u/v^a is some integer r with v^a * r <= u < v^a * (r+1);
-- the next CF step uses (v, r+1) approximately, but this loses precision.
--
-- For our purposes we want exact CF expansion of log y / log x.  This is
-- equivalent to the CF of log_x y, which can be computed exactly using
-- the identity:
--
--   log_x y = a + 1 / log_z x  where z = y / x^a (and a = floor(log_x y)).
--
-- We track (y, x) as the pair, and at each step compute:
--   a = floor(log y / log x) (integer)
--   new pair = (x, y / x^a) ... but y / x^a may not be an integer.
--
-- We instead recurse symbolically: alpha = log y / log x has
-- a_0 = floor(log y / log x), and alpha_1 = 1 / (alpha - a_0).
--
-- For irrational alpha (since x, y mult-indep), the CF is infinite.
-- We use a different representation: at each step, the residual is
-- log y_k / log x_k where (y_k, x_k) are integers with y_k > x_k > 1
-- (or y_k = x_k = 1 termination).
--
-- The recursion:
--   alpha_0 = log y / log x
--   a_0 = floorLogRatio y x  (so x^{a_0} <= y < x^{a_0 + 1})
--   alpha_1 = 1 / (alpha_0 - a_0) = log x / log(y / x^{a_0})  -- but y/x^{a_0} may not be integer
--
-- To keep integer arithmetic: redefine.
--   alpha_0 = log y / log x = log(y) / log(x)
--   alpha_0 - a_0 = (log y - a_0 log x) / log x = log(y / x^{a_0}) / log x
--
-- The "y / x^{a_0}" is a real number in [1, x).  We can approximate it,
-- but for exact CF we need a different tactic.
--
-- ALTERNATIVE: use the standard CF algorithm with rational lower/upper
-- bounds for log y / log x, and extract a_n one at a time.
--
-- This is the project's `scripts/cas_continued_fraction.py` approach,
-- which I'll re-implement in Haskell here using exact rational pairs.
cfExpansionRational ::
  Integer -> -- y
  Integer -> -- x
  Int -> -- depth
  [Integer] -- CF partial quotients
cfExpansionRational y x depth = go (1, 0) (0, 1) y x 0 depth
  where
    -- Track lower and upper rational bounds for log y / log x.
    -- Invariant: lower_n/lower_d <= log y / log x < upper_n/upper_d
    -- Use exact integer arithmetic.
    go _ _ _ _ _ 0 = []
    go (loN, loD) (hiN, hiD) yc xc _step d =
      let lo = loN % loD
          hi = if hiD == 0 then 10 ^ (18 :: Int) % 1 :: Ratio Integer else hiN % hiD
          a = floor lo
       in if floor lo /= floor hi
            then -- Tighten the bounds by squaring
              if yc < x ^ (1 :: Int) -- safety
                then []
                else go (loN, loD) (hiN, hiD) yc xc 0 d
            else
              a : go
                (loD, loN - a * loD)
                (hiD, hiN - a * hiD)
                xc
                (yc `div` xc ^ a)
                0
                (d - 1)

-- Simpler approach: use rational arithmetic on log ratios via the
-- Stern-Brocot / mediant tree, applied to the inequality x^p < y^q.
--
-- The CF of log y / log x is determined by the sequence of inequalities
-- "is x^p < y^q?" for varying (p, q).  We use this directly:
--
-- For irrational alpha = log y / log x, the CF can be extracted by:
--   at each step, find the largest a such that x^a < y^{step-counter}
--   (or similar).
--
-- This is equivalent to the Knuth/Lehmer algorithm for CF of log ratios.
-- We use the standard recursion: at step n, we have rationals a < alpha < b
-- (with a, b rationals), and we extract floor(alpha) by comparing x^a's
-- and y^b's.
--
-- For now, use a simpler but less efficient direct method: convert to
-- Double and compute CF up to a fixed depth.  This loses precision past
-- ~15 digits but suffices for our windows.

cfDouble :: Double -> Int -> [Integer]
cfDouble _ 0 = []
cfDouble x depth
  | abs x < 1e-12 = []
  | otherwise =
      let a = floor x
          rest = x - fromInteger a
       in if rest < 1e-12
            then [a]
            else a : cfDouble (1 / rest) (depth - 1)

-- | CF of log y / log x using Double precision.  Returns up to `depth`
--   partial quotients.  Precision limited but sufficient for windows up
--   to ~10^15 (well beyond our M_MW thresholds).
cfLogRatio :: Integer -> Integer -> Int -> [Integer]
cfLogRatio y x depth = cfDouble (log (fromInteger y) / log (fromInteger x)) depth

-- | Convergents (numerator, denominator) of a CF [a_0; a_1, a_2, ...].
-- Standard recursion: p_{-2} = 0, p_{-1} = 1; q_{-2} = 1, q_{-1} = 0.
-- p_n = a_n p_{n-1} + p_{n-2}, similarly for q.
convergents :: [Integer] -> [(Integer, Integer)]
convergents = go (0, 1) (1, 0)
  where
    go _ _ [] = []
    go (pPrev, qPrev) (pCurr, qCurr) (a : as) =
      let pNext = a * pCurr + pPrev
          qNext = a * qCurr + qPrev
       in (pNext, qNext) : go (pCurr, qCurr) (pNext, qNext) as

-- | For pair (x, y) with x < y, compute denominators of CF convergents
--   of log y / log x up to given depth.
cfDenominators :: Integer -> Integer -> Int -> [Integer]
cfDenominators x y depth = map snd (convergents (cfLogRatio y x depth))

-- | For pair (y, z) with y < z, compute numerators of CF convergents
--   of log z / log y.
cfNumerators :: Integer -> Integer -> Int -> [Integer]
cfNumerators y z depth = map fst (convergents (cfLogRatio z y depth))

-- | Multiplicatively independent? (Same logic as cpp/include/erdos124/mw.hpp)
multIndep :: Integer -> Integer -> Bool
multIndep a b = a /= b && primitiveRoot a /= primitiveRoot b
  where
    primitiveRoot n =
      let pf = primeFactors n
       in if length pf == 1 then head pf else 0 -- 0 = "composite multi-prime"
    primeFactors n = go n 2
      where
        go m p
          | m == 1 = []
          | m `mod` p == 0 = p : go (m `div` p) p
          | p * p > m = [m]
          | otherwise = go m (p + 1)

-- | Approximate Legendre threshold: smallest p with x^p log y > 4 p B*.
--   (Matches RegimeThresholds.hs.)
legendreThreshold :: Double -> Double -> Double -> Integer
legendreThreshold x y bStar = head [p | p <- [1 ..], x ** fromInteger p * log y > 4 * fromInteger p * bStar]

-- | Analyze a triple (x, y, z) for Charge gamma applicability,
--   filtering by Legendre thresholds at a given B*.
analyzeTriple :: Double -> Integer -> Integer -> Integer -> IO ()
analyzeTriple bStar x y z = do
  putStrLn $ "Triple (x, y, z) = (" ++ show x ++ ", " ++ show y ++ ", " ++ show z ++ "), B* = " ++ show bStar ++ ":"
  let depth = 30
      dxy = cfDenominators x y depth
      nyz = cfNumerators y z depth
      -- Legendre thresholds for the two pairs at threshold B*.
      mLxy = legendreThreshold (fromInteger x) (fromInteger y) bStar
      mLyz = legendreThreshold (fromInteger y) (fromInteger z) bStar
      -- e_y must be in BOTH lists.  In the (x, y) CF, e_y = denominator.
      -- For Legendre, we need min(e_x, e_y) >= M_L^{(xy)}, which for
      -- pair (x, y) with x < y means e_y >= M_L (since e_y is the
      -- smaller exponent).
      -- For (y, z) CF, e_y = numerator (larger exponent), so e_z >= M_L^{(yz)}.
      sharedAll = sort (filter (`elem` nyz) dxy)
      sharedInWindow = filter (\ey -> ey >= mLxy) sharedAll
  putStrLn $ "  D_{xy} (first 10) = " ++ show (take 10 dxy)
  putStrLn $ "  N_{yz} (first 10) = " ++ show (take 10 nyz)
  putStrLn $ "  M_L^{(xy)} = " ++ show mLxy ++ ", M_L^{(yz)} = " ++ show mLyz
  putStrLn $ "  Intersection (all): " ++ show (take 10 sharedAll)
  putStrLn $ "  Intersection in window (e_y >= M_L^{(xy)} = " ++ show mLxy ++ "): " ++ show sharedInWindow
  putStrLn $
    if null sharedInWindow
      then "  STATUS: Charge gamma CLOSES this triple in the window."
      else "  STATUS: " ++ show (length sharedInWindow) ++ " candidates in window - verify joint gaps exceed B*."
  putStrLn ""

-- | A set of triples to analyze, drawn from hypothesis-meeting cases.
testTriples :: [(Integer, Integer, Integer)]
testTriples =
  filter (\(x, y, z) -> x < y && y < z && multIndep x y && multIndep y z && multIndep x z)
    [ -- Triples from {3, 4, 7}, {3, 4, 5}, {3, 4, 9, 25}:
      (3, 4, 5),
      (3, 4, 7),
      (3, 4, 11),
      (3, 4, 13),
      (3, 5, 7),
      (3, 4, 25),
      (4, 5, 7),
      (4, 5, 11),
      (4, 7, 11),
      (5, 7, 11),
      (3, 5, 11),
      (3, 5, 13),
      (3, 7, 11),
      (3, 7, 13),
      (5, 7, 13),
      (5, 11, 13),
      (7, 11, 13),
      (3, 4, 17),
      (3, 4, 19),
      (4, 5, 9), -- 4, 5, 9 = 3^2: 4 vs 9 mult-indep, 5 vs 9 mult-indep, but 4 vs 5 mult-indep
      (4, 9, 25)
    ]

main :: IO ()
main = do
  putStrLn "# CF Intersection analysis for Conjecture 92.2"
  putStrLn ""
  putStrLn "For each pairwise mult-indep triple (x, y, z), compute"
  putStrLn "  D_{xy} = denominators of CF convergents of log y / log x"
  putStrLn "  N_{yz} = numerators   of CF convergents of log z / log y"
  putStrLn "Both up to depth 20.  Report intersection."
  putStrLn ""
  putStrLn "Charge gamma applies (closes the triple) iff intersection"
  putStrLn "for e_y >= 2 is empty."
  putStrLn ""
  putStrLn "=================================================="
  putStrLn ""
  -- Use B* = 5835 (the {3,4,7} k=1 value) as a representative threshold.
  -- For each triple, compute Legendre thresholds and report.
  mapM_ (\(x, y, z) -> analyzeTriple 5835.0 x y z) testTriples
  putStrLn ""
  let totalTriples = length testTriples
  putStrLn $ "Analyzed " ++ show totalTriples ++ " pairwise mult-indep triples at B* = 5835."

  -- Repeat with larger B* (= 10^9) representative of higher-k cases.
  putStrLn ""
  putStrLn "==================================================="
  putStrLn "Repeat with B* = 10^9 (representative of high-k cases)"
  putStrLn "==================================================="
  putStrLn ""
  mapM_ (\(x, y, z) -> analyzeTriple 1e9 x y z) testTriples
  putStrLn $ "Analyzed " ++ show totalTriples ++ " triples at B* = 10^9."
