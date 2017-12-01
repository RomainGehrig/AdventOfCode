import Data.Char (digitToInt, isDigit)

readInput :: IO [Int]
readInput = do
  content <- readFile "input.txt"
  return $ map digitToInt . filter isDigit $ content

consecutiveDigits :: Int -> [Int] -> [Int]
consecutiveDigits rotation xs = map fst . filter (\(x, y) -> x == y) $ zip xs rotated
  where rotated = drop rotation xs ++ take rotation xs

main :: IO ()
main = do
  digits <- readInput
  print $ sum $ consecutiveDigits (length digits `div` 2) digits
