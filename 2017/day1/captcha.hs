import Data.Char (digitToInt, isDigit)

readInput :: IO [Int]
readInput = do
  content <- readFile "input.txt"
  return $ map digitToInt . filter isDigit $ content

consecutiveDigits :: [Int] -> [Int]
consecutiveDigits xs = map fst $ filter (\(x, y) -> x == y) $ zip xs (last xs : init xs)

main :: IO ()
main = do
  digits <- readInput
  print $ sum $ consecutiveDigits digits
