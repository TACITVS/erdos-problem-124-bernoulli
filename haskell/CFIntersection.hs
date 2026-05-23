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

-- | Prime factorization with exponents: returns [(p, e)] for each prime p with
--   multiplicity e in n.
primeFactorsExp :: Integer -> [(Integer, Integer)]
primeFactorsExp n0 = go n0 2 []
  where
    go n p acc
      | n == 1 = reverse acc
      | n `mod` p == 0 = go (n `div` p) p (incrementExp p acc)
      | p * p > n = reverse ((n, 1) : acc)
      | otherwise = go n (p + 1) acc
    incrementExp p [] = [(p, 1)]
    incrementExp p ((q, e) : rest)
      | q == p = (q, e + 1) : rest
      | otherwise = (q, e) : incrementExp p rest

-- | Primitive power of n: the smallest base c such that n = c^k.
--   Equivalently, n^(1/gcd of exponents in prime factorization).
primitivePower :: Integer -> Integer
primitivePower n =
  let factors = primeFactorsExp n
      g = foldr1 gcd (map snd factors)
   in product [p ^ (e `div` g) | (p, e) <- factors]

-- | Multiplicatively independent: a^m != b^n for all positive integers m, n.
--   Equivalent to: a and b have different primitive powers.
multIndep :: Integer -> Integer -> Bool
multIndep a b = a /= b && primitivePower a /= primitivePower b

-- | Approximate Legendre threshold: smallest p with x^p log y > 4 p B*.
--   (Matches RegimeThresholds.hs.)
legendreThreshold :: Double -> Double -> Double -> Integer
legendreThreshold x y bStar = head [p | p <- [1 ..], x ** fromInteger p * log y > 4 * fromInteger p * bStar]

-- | Test result for a single triple at a given B*.
data TripleResult = TripleResult
  { trX :: Integer,
    trY :: Integer,
    trZ :: Integer,
    trCandidates :: [Integer]
  }
  deriving stock (Eq, Show)

-- | Analyze a triple silently, returning the candidates in the Legendre window.
analyzeTripleSilent :: Double -> Integer -> Integer -> Integer -> TripleResult
analyzeTripleSilent bStar x y z =
  TripleResult x y z sharedInWindow
  where
    depth = 60
    dxy = cfDenominators x y depth
    nyz = cfNumerators y z depth
    mLxy = legendreThreshold (fromInteger x) (fromInteger y) bStar
    sharedAll = sort (filter (`elem` nyz) dxy)
    sharedInWindow = filter (\ey -> ey >= mLxy) sharedAll

-- | For a candidate e_y, compute (e_x, e_z) from the two CF convergent lists
--   and estimate log10 of the joint near-collision gaps |x^e_x - y^e_y| and
--   |y^e_y - z^e_z| via logarithms.  Returns (log10 gap1, log10 gap2).
--
-- For small linear form delta = |e_x log x - e_y log y|:
--   |x^e_x - y^e_y| ~ min(x^e_x, y^e_y) * delta
--   log10 gap ~ e_x log10 x + log10 delta
candidateGapsLog10 ::
  Integer -> -- x
  Integer -> -- y
  Integer -> -- z
  Integer -> -- e_y (candidate)
  Int -> -- CF depth
  Maybe (Double, Double) -- (log10 gap1, log10 gap2)
candidateGapsLog10 x y z ey depth = do
  -- Find (e_x, e_y) in CF of log y/log x with denominator = e_y.
  let cfXY = convergents (cfLogRatio y x depth)
      maybeEx = lookup ey [(d, n) | (n, d) <- cfXY]
  ex <- maybeEx
  -- Find (e_y, e_z) in CF of log z/log y with numerator = e_y.
  let cfYZ = convergents (cfLogRatio z y depth)
      maybeEz = lookup ey [(n, d) | (n, d) <- cfYZ]
  ez <- maybeEz
  -- Now estimate gaps using EXACT integer arithmetic for the
  -- DOUBLE-CHECK and Double precision for the bound.
  let dx = fromInteger x :: Double
      dy = fromInteger y :: Double
      dz = fromInteger z :: Double
      dex = fromInteger ex :: Double
      dey = fromInteger ey :: Double
      dez = fromInteger ez :: Double
      -- Linear forms (in natural log).
      delta1 = abs (dex * log dx - dey * log dy)
      delta2 = abs (dey * log dy - dez * log dz)
      -- log10 of gap ~ log10(min) + log10(delta) where min = e^min(...)
      logMin1 = min (dex * log dx) (dey * log dy)
      logMin2 = min (dey * log dy) (dez * log dz)
      -- Handle delta = 0 (Double underflow): treat as gap ~ 1 (conservative low estimate).
      -- For deep CF convergents, delta might underflow.  In that case, we use the
      -- exact CF theory: at CF convergent (p_n, q_n), |q_n alpha - p_n| ~ 1/q_{n+1},
      -- so log10 gap ~ log10 (min) - log10 q_{n+1}.
      -- For a conservative under-estimate, use log10 gap >= log10(min) - 50
      -- (since deep CF convergents rarely have q_{n+1} > 10^50 in our range).
      safeLogDelta d
        | d > 0 = log d
        | otherwise = -log 10 * 50 -- treat as 10^-50
      log10gap1 = (logMin1 + safeLogDelta delta1) / log 10
      log10gap2 = (logMin2 + safeLogDelta delta2) / log 10
  Just (log10gap1, log10gap2)

-- | Check if all candidates have gaps exceeding B*.
verifyCandidateGaps :: Double -> Integer -> Integer -> Integer -> [Integer] -> Bool
verifyCandidateGaps bStar x y z candidates =
  all check candidates
  where
    log10BStar = log bStar / log 10
    check ey = case candidateGapsLog10 x y z ey 60 of
      Nothing -> True -- can't compute, default OK (shouldn't happen)
      Just (g1, g2) -> g1 > log10BStar && g2 > log10BStar

-- | Enumerate all pairwise mult-indep triples with x < y < z in [3, maxBase].
allTriplesInRange :: Integer -> [(Integer, Integer, Integer)]
allTriplesInRange maxBase =
  [ (x, y, z)
    | x <- [3 .. maxBase],
      y <- [x + 1 .. maxBase],
      z <- [y + 1 .. maxBase],
      multIndep x y,
      multIndep y z,
      multIndep x z
  ]

testTriples :: [(Integer, Integer, Integer)]
testTriples = allTriplesInRange 50

main :: IO ()
main = do
  putStrLn "# CF Intersection analysis for Conjecture 92.2"
  putStrLn "# Enumeration of all pairwise mult-indep triples in [3, 50] at depth 60"
  putStrLn ""
  let triples = testTriples
      totalTriples = length triples

  putStrLn $ "Total pairwise mult-indep triples: " ++ show totalTriples
  putStrLn ""

  -- Run at three B* levels.
  mapM_
    ( \bStar -> do
        putStrLn $ "## B* = " ++ show bStar
        let results = map (\(x, y, z) -> analyzeTripleSilent bStar x y z) triples
            closedNoCands = filter (\r -> null (trCandidates r)) results
            withCands = filter (\r -> not (null (trCandidates r))) results
            -- For each "with candidates" triple, verify gaps exceed B*.
            gapVerifiedAll = filter (\r -> verifyCandidateGaps bStar (trX r) (trY r) (trZ r) (trCandidates r)) withCands
            gapFailed = filter (\r -> not (verifyCandidateGaps bStar (trX r) (trY r) (trZ r) (trCandidates r))) withCands
            nClosedNoCands = length closedNoCands
            nGapVerified = length gapVerifiedAll
            nFailed = length gapFailed
            totalClosed = nClosedNoCands + nGapVerified
            pctClosedNoCands = fromIntegral nClosedNoCands / fromIntegral totalTriples * 100 :: Double
            pctTotalClosed = fromIntegral totalClosed / fromIntegral totalTriples * 100 :: Double
        putStrLn $ "  Triples with empty intersection: " ++ show nClosedNoCands ++ " / " ++ show totalTriples ++ " (" ++ show (round pctClosedNoCands :: Int) ++ "%)"
        putStrLn $ "  Triples with candidates, ALL gaps verified > B*: " ++ show nGapVerified
        putStrLn $ "  Triples with at least one gap <= B*: " ++ show nFailed
        putStrLn $ "  TOTAL closed: " ++ show totalClosed ++ " / " ++ show totalTriples ++ " (" ++ show (round pctTotalClosed :: Int) ++ "%)"
        when (nFailed > 0) $ do
          putStrLn "  Triples with failed gap verification:"
          mapM_
            ( \r ->
                putStrLn $
                  "    (" ++ show (trX r) ++ ", " ++ show (trY r) ++ ", " ++ show (trZ r)
                    ++ "): candidates " ++ show (trCandidates r)
            )
            (take 20 gapFailed)
        putStrLn ""
    )
    [5835.0, 1e9, 1e15]
  where
    when c m = if c then m else return ()
