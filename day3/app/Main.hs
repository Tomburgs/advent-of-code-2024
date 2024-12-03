module Main where

import Text.Regex.Posix

mul :: [String] -> Int
mul v = do
  case v of
    [_, a, b] -> (read a :: Int) * (read b :: Int)
    _ -> error "Bad match"

main :: IO ()
main = do
  contents <- readFile "./data/corrupted-memory.txt"

  -- Part 1:
  let regex = "mul\\(([0-9]{1,3}),([0-9]{1,3})\\)"
  let matches = contents =~ regex :: [[String]]
  let mulr = sum $ map mul matches

  print $ "Multiplication: " ++ show mulr

  -- Part 2:
  let regexIns = "don't\\(\\)|do\\(\\)|mul\\(([0-9]{1,3}),([0-9]{1,3})\\)"
  let matchesIns = contents =~ regexIns :: [[String]]

  let mulIns =
        sum $
          ( fst $
              foldl
                ( \(acc, ignr) v ->
                    if v !! 0 == "don't()"
                      then (acc, True)
                      else
                        if v !! 0 == "do()"
                          then (acc, False)
                          else
                            if ignr
                              then (acc, ignr)
                              else (acc ++ [mul v], ignr)
                )
                ([], False)
                matchesIns
          )

  print $ "Multiplication instructions: " ++ show mulIns
