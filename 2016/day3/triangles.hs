import Data.List.Split (splitOn)

readInput :: IO [[Int]]
readInput = do
  content <- readFile "input.txt"
  let triangles = splitOn "\n" content
  return $ filter (\t -> length t == 3) $ map (map read . filter (\s -> length s /= 0) . splitOn " ") triangles

isTriangle :: [Int] -> Bool
isTriangle xs = sum xs - biggestSide > biggestSide
  where biggestSide = maximum xs

countTriangles :: [[Int]] -> Int
countTriangles = length . filter isTriangle

main :: IO ()
main = do
  triangles <- readInput
  print $ countTriangles triangles
