module Main where

createGrid :: FilePath -> IO [[String]]
createGrid file = do
  contents <- readFile file
  let grid = map (map (: [])) (lines contents)

  return grid

main :: IO ()
main = do
  grid <- createGrid "./data/xmas.txt"

  let ocs =
        sum $
          map
            ( \i ->
                sum $
                  map
                    ( \j ->
                        count i j 0 (-1)
                    )
                    [0 .. length (grid !! i) - 1]
            )
            [0 .. length grid - 1]
        where
          count :: Int -> Int -> Int -> Int -> Int
          count i j pos dir =
            let x = [-1, -1, -1, 0, 0, 1, 1, 1] :: [Int]
                y = [-1, 0, 1, -1, 1, -1, 0, 1] :: [Int]
                word = ["X", "M", "A", "S"]
             in if i < 0 || length grid <= i || j < 0 || length (grid !! 0) <= j
                  then 0
                  else
                    if (grid !! i !! j) == (word !! pos)
                      then
                        if length word == pos + 1
                          then 1
                          else
                            if dir /= -1
                              then count (i + (x !! dir)) (j + (y !! dir)) (pos + 1) (dir)
                              else sum $ map (\d -> count (i + (x !! d)) (j + (y !! d)) (pos + 1) d) [0 .. 7]
                      else 0

  print $ "Occurrences: " ++ show ocs
