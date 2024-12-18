module Main where

import qualified Data.HashMap.Strict as HashMap
import Data.List
import Data.Maybe (fromMaybe)

createLists :: FilePath -> IO ([Int], [Int])
createLists file = do
  contents <- readFile file
  let line = lines contents
      parsed =
        map
          ( \v -> case words v of
              [a, b] -> (read a, read b)
              _ -> error $ "Invalid line: " ++ v
          )
          line
      (list1, list2) = unzip parsed
  return (list1, list2)

main :: IO ()
main = do
  (l1, l2) <- createLists "./data/lists.txt"

  -- Part 1:
  let sl1 = sort l1
  let sl2 = sort l2
  let distance = sum $ zipWith (\a b -> abs (a - b)) sl1 sl2

  print $ "Distance: " ++ show distance

  -- Part 2:
  let occurrences = foldr (\v acc -> HashMap.insertWith (+) v 1 acc) HashMap.empty l2
  let similarity = foldr (\v acc -> acc + (v * (fromMaybe 0 (HashMap.lookup v occurrences)))) 0 l1

  print $ "Similarity: " ++ show similarity
