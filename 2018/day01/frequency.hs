import Data.Char (digitToInt, isDigit)

readInput :: IO [Int]
readInput = do
  content <- readFile "input.txt"
  return $ map (read . filter (/= '+')) $ lines $ content

main :: IO ()
main = do
  digits <- readInput
  print $ sum $ digits
