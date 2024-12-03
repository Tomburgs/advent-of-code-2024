module Main where

createReports :: FilePath -> IO [[Int]]
createReports file = do
  contents <- readFile file
  return (map (map read . words) (lines contents))

main :: IO ()
main = do
  reports <- createReports "./data/reports.txt"

  let vr = sum $ map (\v -> if isValid v then 1 :: Int else 0 :: Int) reports
        where
          isValid :: [Int] -> Bool
          isValid v =
            let diffs = zipWith (-) (drop 1 v) v
             in all (\d -> abs d >= 1 && abs d <= 3) diffs && (all (> 0) diffs || all (< 0) diffs)

  print $ "Valid reports: " ++ show vr
