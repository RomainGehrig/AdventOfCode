import Data.List

count :: [Int] -> Int -> Int
count cap n = length lst'
  where lst = filter (\s -> sum s == n) $ subsequences cap
        min = minimum $ map length lst
        lst'= filter (\s -> length s == min) lst

main :: IO ()
main = do
  lns <- readFile "input.txt"
  let capacities = map (read :: String -> Int) $ lines lns
  print $ count capacities 150
