import Data.List.Split (splitOn, chunksOf)
import Data.List (transpose)

readInput :: IO [[Int]]
readInput = do
  content <- readFile "input.txt"
  let triangles = splitOn "\n" content
  return $ filter (\t -> length t == 3) $ map (map read . filter (\s -> length s /= 0) . splitOn " ") triangles

transformInput :: [[a]] -> [[a]]
transformInput xss = chunksOf 3 xss >>= transpose

isTriangle :: [Int] -> Bool
isTriangle xs = sum xs - biggestSide > biggestSide
  where biggestSide = maximum xs

countTriangles :: [[Int]] -> Int
countTriangles = length . filter isTriangle

main :: IO ()
main = do
  triangles <- readInput
  print $ countTriangles $ transformInput triangles
