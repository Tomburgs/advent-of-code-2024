module Main where

createGrid :: FilePath -> IO [[String]]
createGrid file = do
  contents <- readFile file
  let grid = map (map (: [])) (lines contents)

  return grid

main :: IO ()
main = do
  grid <- createGrid "./data/xmas.txt"

  -- Part 1:
  let ocs =
        sum [sum [count i j 0 (-1) | j <- [0 .. length (grid !! i) - 1]] | i <- [0 .. length grid - 1]]
        where
          count :: Int -> Int -> Int -> Int -> Int
          count i j pos dir
            | i < 0 || length grid <= i || j < 0 || length (grid !! 0) <= j = 0
            | grid !! i !! j /= word !! pos = 0
            | pos == length word - 1 = 1
            | dir /= -1 = count (i + dx) (j + dy) (pos + 1) dir
            | otherwise = sum [count (i + dx') (j + dy') (pos + 1) dir' | dir' <- [0 .. 7], let (dx', dy') = directions !! dir']
            where
              word = ["X", "M", "A", "S"]
              (dx, dy) = directions !! dir
              directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]

  print $ "Occurrences: " ++ show ocs

  -- Part 2:
  let xocs =
        sum [length (filter (isValid i) [0 .. length (grid !! i) - 1]) | i <- [0 .. length grid - 1]]
        where
          charAt :: Int -> Int -> String
          charAt i j =
            if i < 0 || length grid <= i || j < 0 || length (grid !! 0) <= j
              then ""
              else grid !! i !! j

          isValid :: Int -> Int -> Bool
          isValid i j
            | char /= "A" = False
            | otherwise = (length $ filter (\((ni1, nj1), (ni2, nj2)) -> (charAt (i + ni1) (j + nj1) == "M" && charAt (i + ni2) (j + nj2) == "S")) directions) == 2
            where
              directions = [((-1, -1), (1, 1)), ((1, 1), (-1, -1)), ((-1, 1), (1, -1)), ((1, -1), (-1, 1))] :: [((Int, Int), (Int, Int))]
              char = grid !! i !! j

  print $ "Cross occurrences: " ++ show xocs
