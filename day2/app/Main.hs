module Main where

createReports :: FilePath -> IO [[Int]]
createReports file = do
  contents <- readFile file
  return (map (map read . words) (lines contents))

main :: IO ()
main = do
  reports <- createReports "./data/reports.txt"

  -- Part 1:
  let vr = sum $ map (\v -> if isValid v then 1 :: Int else 0 :: Int) reports
        where
          isValid :: [Int] -> Bool
          isValid v =
            let diffs = zipWith (-) (drop 1 v) v
             in all (\d -> abs d >= 1 && abs d <= 3) diffs && (all (> 0) diffs || all (< 0) diffs)

  print $ "Valid reports: " ++ show vr

  -- Part 2:
  let vrd = sum $ map (\v -> if isValidDampened v then 1 :: Int else 0 :: Int) reports
        where
          removeAt :: Int -> [a] -> [a]
          removeAt _ [] = []
          removeAt 0 (_ : xs) = xs
          removeAt n (x : xs) = x : removeAt (n - 1) xs

          isValid :: [Int] -> Bool
          isValid v =
            let diffs = zipWith (-) (drop 1 v) v
             in all (\d -> abs d >= 1 && abs d <= 3) diffs && (all (> 0) diffs || all (< 0) diffs)

          isValidDampened :: [Int] -> Bool
          isValidDampened v =
            any (\i -> isValid (removeAt i v)) [0 .. length v - 1]

  print $ "Valid reports, dampened: " ++ show vrd
