module Main where

import Data.List

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

calculateDistance :: [Int] -> [Int] -> Int
calculateDistance list1 list2 = go list1 list2 0
  where
    go [] [] acc = acc
    go (a : ar) (b : br) acc = go ar br (acc + abs (a - b))
    go _ _ _ = error "Lists must have the same length"

main :: IO ()
main = do
  (l1, l2) <- createLists "./data/lists.txt"

  let sl1 = sort l1
  let sl2 = sort l2

  let distance = calculateDistance sl1 sl2

  print distance
