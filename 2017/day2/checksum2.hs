import Data.Char (digitToInt, isDigit, isSpace)
import Data.List

readInput :: IO [[Int]]
readInput = do
  content <- readFile "input.txt"
  return $ map (map read . words) $ lines content

lineChecksum :: [Int] -> Int
lineChecksum xs = sum [ x `div` y | x <- xs, y <- xs, x /= y, y /= 0, x `mod` y == 0]

main :: IO ()
main = do
  nums <- readInput
  print $ sum $ map lineChecksum nums
