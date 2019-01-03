import Data.List


readInput :: IO [String]
readInput = do
  content <- readFile "input.txt"
  return $ lines $ content

count :: [String] -> (Int, Int)
count xs = (length . filter twoLetters $ xs, length . filter threeLetters $ xs)
  where twoLetters = counter 2
        threeLetters = counter 3
        counter n xs = any ((== n) . length . (`elemIndices` xs)) xs

distance :: String -> String -> Int
distance xs ys = length $ filter (\(x,y) -> x /= y) $ zip xs ys

findUniqueDist1 :: [String] -> String
findUniqueDist1 ids = map fst $ filter (\(x,y) -> x == y) $ uncurry zip $ head $ [ (x,y) | x <- ids, y <- ids, distance x y == 1 ]

main :: IO ()
main = do
  ids <- readInput
  print $ (\(x,y) -> x*y) $ count ids
  print $ findUniqueDist1 ids
