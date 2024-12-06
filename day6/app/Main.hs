module Main where

import Data.List
import Data.Maybe

createMap :: FilePath -> IO [[String]]
createMap file = do
  contents <- readFile file
  return (map (map (: [])) (lines contents))

findGuardStartingPosition :: [[String]] -> (Int, Int)
findGuardStartingPosition grid = (guardPosX, guardPosY)
  where
    guardPosY = fromMaybe 0 (find (\y -> elem "^" (grid !! y)) [0 .. length grid - 1])
    guardPosX = fromMaybe 0 (find (\x -> (grid !! guardPosY !! x) == "^") [0 .. length (grid !! guardPosY) - 1])

mapGuardPositions :: (Int, Int) -> [[String]] -> [[String]]
mapGuardPositions (x, y) grid = move (x, y) (0, -1) (markPosition (x, y) grid)
  where
    move :: (Int, Int) -> (Int, Int) -> [[String]] -> [[String]]
    move (x', y') (dx, dy) grid'
      | (y' + dy) > length grid' - 1 || (y' + dy) < 0 = markPosition (x', y') grid'
      | (x' + dx) > length (grid' !! 0) - 1 || (x' + dx) < 0 = markPosition (x', y') grid'
      | otherwise = markAndMove (x', y') (dx, dy) grid'

    markAndMove :: (Int, Int) -> (Int, Int) -> [[String]] -> [[String]]
    markAndMove (x', y') (dx, dy) grid'
      | nextTile == "#" = move (x', y') (turn (dx, dy)) grid'
      | otherwise = move (x' + dx, y' + dy) (dx, dy) (markPosition (x', y') grid')
      where
        nextRow = grid' !! (y' + dy)
        nextTile = nextRow !! (x' + dx)

    turn :: (Int, Int) -> (Int, Int)
    turn (dx, dy)
      | dy == -1 = (1, 0) -- If UP, turn LEFT
      | dy == 1 = (-1, 0) -- If DOWN, turn RIGHT
      | dx == 1 = (0, 1) -- If RIGHT, turn DOWN
      | dx == -1 = (0, -1) -- If LEFT, turn UP
      | otherwise = error "direction is invalid"

    markPosition :: (Int, Int) -> [[String]] -> [[String]]
    markPosition (x', y') grid' = newGrid'
      where
        row = grid' !! y'
        (newColumnStart, newColumnEnd) = splitAt x' row
        newColumn = newColumnStart ++ ["X"] ++ (drop 1 newColumnEnd)
        (newRowStart, newRowEnd) = splitAt y' grid'
        newGrid' = newRowStart ++ [newColumn] ++ (drop 1 newRowEnd)

main :: IO ()
main = do
  grid <- createMap "./data/map.txt"

  let start = findGuardStartingPosition grid
  let visitedTiles = mapGuardPositions start grid
  let visitedTileCount = sum $ map (\y -> length $ filter (\x -> x == "X") y) visitedTiles

  let prettyPrintGrid = unlines $ map concat visitedTiles
  putStrLn prettyPrintGrid
  print visitedTileCount
