readInput :: IO [String]
readInput = do
  content <- readFile "input.txt"
  return $ lines $ content

distance :: String -> String -> Int
distance xs ys = length $ filter (\(x,y) -> x /= y) $ zip xs ys

findUniqueDist1 :: [String] -> String
findUniqueDist1 ids = map fst $ filter (\(x,y) -> x == y) $ uncurry zip $ head $ [ (x,y) | x <- ids, y <- ids, distance x y == 1 ]

main :: IO ()
main = do
  ids <- readInput
  print $ findUniqueDist1 ids
