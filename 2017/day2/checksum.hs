import Data.Char (digitToInt, isDigit, isSpace)
import Data.List

readInput :: IO [[Int]]
readInput = do
  content <- readFile "input.txt"
  return $ map (map read . words) $ lines content

lineChecksum :: [Int] -> Int
lineChecksum xs = (maximum xs) - (minimum xs)

main :: IO ()
main = do
  nums <- readInput
  print $ sum $ map lineChecksum nums
