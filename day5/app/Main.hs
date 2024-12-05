module Main where

import qualified Data.HashMap.Strict as HashMap
import Data.Maybe
import qualified Data.Text as T

createRulesAndPages :: FilePath -> IO ([(Int, Int)], [[Int]])
createRulesAndPages file = do
  contents <- readFile file
  let (p1, p2) = case T.splitOn (T.pack "\n\n") (T.pack contents) of
        [p1', p2'] -> (T.unpack p1', T.unpack p2')
        _ -> error ""
  let rules =
        map
          ( \v -> case T.splitOn (T.pack "|") (T.pack v) of
              [p1', p2'] -> ((read (T.unpack p1') :: Int), (read (T.unpack p2') :: Int))
              _ -> error "Failed to parse rule"
          )
          (lines p1)
  let pages = map (\v -> map (\d -> read (T.unpack d) :: Int) (T.splitOn (T.pack ",") (T.pack v))) (lines p2)
  return (rules, pages)

main :: IO ()
main = do
  (rules, pages) <- createRulesAndPages "./data/pages.txt"

  let rmap = foldr (\(b, a) acc -> HashMap.insertWith (++) a [b] acc) HashMap.empty rules
  let vpages =
        filter
          ( \p ->
              all
                ( \d -> do
                    let page = p !! d
                    let rules' = fromMaybe [] (HashMap.lookup page rmap)
                        after = drop (d + 1) p
                     in (any (\e -> elem e rules') after) == False
                )
                [0 .. length p - 1]
          )
          pages

  let msum = sum $ map (\p -> p !! ((length p) `div` 2)) vpages

  print $ "Sum: " ++ show msum
