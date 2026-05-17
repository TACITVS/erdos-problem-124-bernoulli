{-# LANGUAGE DerivingStrategies #-}

module Main where

import Data.List (intercalate, nub, sort)
import System.Exit (exitFailure)

data Status
  = Done
  | Imported
  | Open
  deriving stock (Eq, Ord, Show)

data Node = Node
  { nodeId :: String,
    title :: String,
    status :: Status,
    dependencies :: [String],
    note :: String
  }
  deriving stock (Eq, Show)

nodes :: [Node]
nodes =
  [ Node
      "conductor-identity"
      "Tail invariant in conductor form"
      Done
      []
      "K(E) = kappa(A,k) + 2c(E) + 1.",
    Node
      "residue-lift"
      "Residue frame lifts multiple intervals"
      Done
      []
      "A residue frame of width R lifts [M0,M1] multiples to [M0+R,M1].",
    Node
      "unit-frame"
      "Unit-base residue frame"
      Done
      []
      "If gcd(a,m)=1, powers of a give a complete residue frame modulo m.",
    Node
      "modular-conductor-lift"
      "Residue lift gives conductor bound"
      Done
      ["residue-lift"]
      "c(F union mG') <= m(c' + 1) + R - 1 under the half-sum reach condition.",
    Node
      "fixed-frame-asymptotic-transfer"
      "Fixed residue frames preserve asymptotic conductor quality"
      Done
      ["modular-conductor-lift"]
      "Sublinear and power-saving quotient conductor bounds transfer across fixed m,R.",
    Node
      "scaled-power-language"
      "Scaled power block language"
      Done
      ["fixed-frame-asymptotic-transfer"]
      "Quotient blocks should be treated as finite unions of q*d^n progressions.",
    Node
      "complete-sequence-absorption"
      "Complete-sequence absorption criterion"
      Done
      ["scaled-power-language"]
      "Brown-style ordered-term absorption preserves an existing central conductor bound.",
    Node
      "p-adic-quotient-selection"
      "P-adic quotient-block selection"
      Done
      ["unit-frame", "scaled-power-language"]
      "Valuation criteria choose valid unit residue frames and m-divisible quotient progressions.",
    Node
      "quotient-conductor-bridge"
      "Selected quotient block gives lift input"
      Done
      ["p-adic-quotient-selection", "complete-sequence-absorption", "modular-conductor-lift"]
      "A selected complete quotient block becomes a scaled central block and either lifts or exposes the exact failed inequality.",
    Node
      "scaled-power-middle-interval"
      "Middle interval theorem for scaled power blocks"
      Open
      ["scaled-power-language", "complete-sequence-absorption"]
      "Prove central intervals with sublinear or power-saving conductor for q*d^n blocks.",
    Node
      "quotient-block-selection"
      "Choose useful modular quotient blocks"
      Open
      ["unit-frame", "scaled-power-language", "p-adic-quotient-selection"]
      "Find moduli and finite frames leaving quotient blocks with enough admissible structure.",
    Node
      "asymptotic-half-sum-reach"
      "Algebraic half-sum reach threshold"
      Done
      ["modular-conductor-lift"]
      "S' >= 2(c'+1) + ceil(F_tot/m) is a sufficient algebraic threshold for the lifted central interval to reach floor((F_tot + mS')/2).",
    Node
      "half-sum-reach"
      "Lifted interval reaches the whole half-sum"
      Done
      ["asymptotic-half-sum-reach", "modular-conductor-lift", "quotient-conductor-bridge"]
      "Closed by asymptotic-half-sum-reach: any sublinear or power-saving quotient conductor sequence eventually crosses the threshold, so the reach side is no longer the bottleneck.",
    Node
      "strict-conductor"
      "Strict central conductor theorem"
      Open
      ["scaled-power-middle-interval", "quotient-block-selection", "half-sum-reach"]
      "Prove c(E)=o(T(E)) when reciprocal sum is strict.",
    Node
      "exact-conductor"
      "Exact-critical central conductor theorem"
      Open
      ["scaled-power-middle-interval", "quotient-block-selection", "half-sum-reach"]
      "Prove c(E)=O(T(E)^(1-epsilon)) in exact-critical cases.",
    Node
      "strict-tail"
      "Strict tail closure"
      Done
      ["conductor-identity"]
      "Conditional tail lemma: strict slack beats sublinear conductor growth once the conductor input is available.",
    Node
      "sunit-tail"
      "Exact-critical S-unit tail closure"
      Imported
      ["conductor-identity"]
      "Conditional imported tail lemma: Subspace/S-unit theorem kills power-saving near-collision failures once the conductor input is available.",
    Node
      "erdos-124"
      "Full Erdos 124 theorem"
      Open
      ["strict-conductor", "exact-conductor", "strict-tail", "sunit-tail"]
      "Combine conductor production with the certified tail engines."
  ]

nodeIds :: [String]
nodeIds = map nodeId nodes

duplicateIds :: [String]
duplicateIds =
  [value | value <- nub nodeIds, length (filter (== value) nodeIds) > 1]

missingDependencies :: [(String, String)]
missingDependencies =
  [ (nodeId node, dependency)
    | node <- nodes,
      dependency <- dependencies node,
      dependency `notElem` nodeIds
  ]

nodeById :: String -> Maybe Node
nodeById target =
  case filter ((== target) . nodeId) nodes of
    [node] -> Just node
    _ -> Nothing

hasCycleFrom :: [String] -> String -> Bool
hasCycleFrom path current =
  current `elem` path
    || case nodeById current of
      Nothing -> False
      Just node -> any (hasCycleFrom (current : path)) (dependencies node)

cycleNodes :: [String]
cycleNodes =
  [nodeId node | node <- nodes, any (hasCycleFrom [nodeId node]) (dependencies node)]

isClosed :: String -> Bool
isClosed target =
  case nodeById target of
    Nothing -> False
    Just node -> status node /= Open

nextCuts :: [Node]
nextCuts =
  [ node
    | node <- nodes,
      status node == Open,
      all isClosed (dependencies node)
  ]

formatNode :: Node -> String
formatNode node =
  intercalate
    "\n"
    [ "- " <> nodeId node <> " [" <> show (status node) <> "]",
      "  title: " <> title node,
      "  depends: " <> show (dependencies node),
      "  note: " <> note node
    ]

main :: IO ()
main = do
  putStrLn "Conductor boss lemma tree"
  putStrLn ""
  putStrLn (intercalate "\n" (map formatNode nodes))
  putStrLn ""
  putStrLn ("node count: " <> show (length nodes))
  putStrLn ("open count: " <> show (length (filter ((== Open) . status) nodes)))
  putStrLn ("next cuts: " <> intercalate ", " (map nodeId nextCuts))
  let errors =
        concat
          [ ["duplicate ids: " <> show duplicateIds | not (null duplicateIds)],
            ["missing dependencies: " <> show missingDependencies | not (null missingDependencies)],
            ["cycle nodes: " <> show (sort cycleNodes) | not (null cycleNodes)]
          ]
  if null errors
    then putStrLn "tree check: PASS"
    else do
      putStrLn "tree check: FAIL"
      mapM_ putStrLn errors
      exitFailure
