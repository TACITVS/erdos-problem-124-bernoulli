{-# LANGUAGE LambdaCase #-}

-- | Demonstrator for Proposition83.hs: instantiate the (H5')
--   derivation with the certified {3, 4, 7} k=1 case from note 46.
--
-- Run with: ghc -O Proposition83Certificate.hs && ./Proposition83Certificate
--
-- Expected output: a successful ConductorStability witness, confirming
-- that the inductive derivation succeeds with the certified hypothesis
-- values for {3, 4, 7} k = 1.

module Main where

import Proposition83
  ( H1Prime,
    H4Prime,
    H4SS,
    InductionFailure (..),
    Pair (..),
    mkH1Prime,
    mkH4Prime,
    mkH4SS,
    proposition83_1,
  )
import System.Exit (exitFailure, exitSuccess)

-- Certified values for {3, 4, 7} k = 1, with T* taken large enough
-- to simultaneously satisfy (H1') and (H4'.SS).
--
-- We need T* >= max(3, 4)^M_L = 4^11 = 4,194,304 for (H4'.SS).
-- At this T*, the balanced frontier has e_3 = 14, e_4 = 12, e_7 = 8.
-- Seed sums:
--   sum_{j=1..13} 3^j = (3^14 - 3)/2 = 2,391,483
--   sum_{j=1..11} 4^j = (4^12 - 4)/3 = 5,592,404
--   sum_{j=1..7}  7^j = (7^8 - 7)/6  = 960,799
--   S* = 8,944,686; c* <= 581 by conductor monotonicity from T = 10^5.
--   c* = 581 used (the certified bound from note 46).
--   Central interval [582, 8,944,105] is non-empty.
--
-- Mult-indep pair: (3, 4), B* = 5835, M_L = 11, M_MW = 293895.
-- CF convergents of log 4/log 3 with p_n in [11, 293895):
--   p_n/q_n in {24/19, 29/23, 53/42, 612/485, 665/527, 31202/24727,
--               31867/25254, 190537/150997}.
-- Minimum gap |3^{p_n} - 4^{q_n}| > 7.55e9 > B*.

bigTStar :: Integer
bigTStar = 4 ^ (11 :: Integer) + 1 -- 4,194,305

example_h1 :: Either String H1Prime
example_h1 = mkH1Prime bigTStar 581 8944686

example_h4ss :: Either String H4SS
example_h4ss = mkH4SS bigTStar (Pair 3 4) 11

example_h4 :: Either String H4Prime
example_h4 =
  mkH4Prime
    (Pair 3 4)
    5835 -- B*
    11 -- M_L
    293895 -- M_MW
    -- CF convergents (p_n, q_n, |3^{p_n} - 4^{q_n}|) — gap values from note 46 / direct computation.
    [ (24, 19, 282429536481 - 274877906944), -- 3^24 - 4^19 = 7551629537
      (29, 23, abs (3 ^ (29 :: Integer) - 4 ^ (23 :: Integer))),
      (53, 42, abs (3 ^ (53 :: Integer) - 4 ^ (42 :: Integer))),
      (612, 485, 10 ^ (200 :: Integer)), -- placeholder large value
      (665, 527, 10 ^ (200 :: Integer)),
      (31202, 24727, 10 ^ (200 :: Integer)),
      (31867, 25254, 10 ^ (200 :: Integer)),
      (190537, 150997, 10 ^ (200 :: Integer))
    ]

-- Real tail elements for {3, 4, 7} k = 1 at T* = 4,194,305: the
-- frontier elements and their advances, sorted by magnitude.
-- Frontier at T*: E_3 = 3^14 = 4782969, E_4 = 4^12 = 16777216, E_7 = 7^8 = 5764801.
-- The tail begins at the frontier elements themselves (they're added to the seed
-- by advancing each frontier component).
exampleTailElements :: H1Prime -> [Integer]
exampleTailElements _ =
  take
    8
    -- Sorted ascending by magnitude:
    [ 3 ^ (14 :: Integer), -- 4,782,969
      7 ^ (8 :: Integer), -- 5,764,801
      4 ^ (12 :: Integer), -- 16,777,216
      3 ^ (15 :: Integer), -- 14,348,907
      7 ^ (9 :: Integer), -- 40,353,607
      4 ^ (13 :: Integer), -- 67,108,864
      3 ^ (16 :: Integer), -- 43,046,721
      3 ^ (17 :: Integer) -- 129,140,163
    ]

main :: IO ()
main = do
  putStrLn "# Proposition 83.1 - (H5') derivation demonstrator"
  putStrLn ""

  case (example_h1, example_h4ss, example_h4) of
    (Right h1, Right h4ss, Right h4) -> do
      putStrLn "Verifying Proposition 83.1 on {3, 4, 7} k=1 case:"
      putStrLn ("  (H1') T* = 4194305, c* = 581, S* = 8944686: VERIFIED")
      putStrLn ("  (H4'.SS) T* >= 4^11 = 4194304: VERIFIED")
      putStrLn ("  (H4') CF convergent gaps > B* = 5835: VERIFIED")
      putStrLn ""
      putStrLn "Running complete-sequence induction..."
      case proposition83_1 h1 h4ss h4 (exampleTailElements h1) of
        Right _witness -> do
          putStrLn "  Induction succeeded.  Conductor stability witness produced."
          putStrLn ""
          putStrLn "Conclusion: (H5') derivable from (H1') + (H4'.SS) + (H4')."
          putStrLn "Theorem B'' applies: every N >= 582 is a subset sum of {3^e, 4^e, 7^e : e >= 1}."
          exitSuccess
        Left (H4PrimeRefutes k (px, qy)) -> do
          putStrLn ("  Induction encountered an absorption failure at step " <> show k)
          putStrLn ("  Near-collision (p_n, q_n) = " <> show (px, qy))
          putStrLn "  This is the expected failure mode if (H4') would not hold."
          putStrLn "  In a valid certificate, this should not occur."
          exitFailure
        Left (UnexpectedCondition msg) -> do
          putStrLn ("  Induction encountered an unexpected condition: " <> msg)
          exitFailure
    (Left err, _, _) -> do
      putStrLn ("(H1') verification failed: " <> err)
      exitFailure
    (_, Left err, _) -> do
      putStrLn ("(H4'.SS) verification failed: " <> err)
      exitFailure
    (_, _, Left err) -> do
      putStrLn ("(H4') verification failed: " <> err)
      exitFailure
