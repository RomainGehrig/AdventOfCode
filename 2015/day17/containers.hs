import Data.List


count :: [Int] -> Int -> Int
count cap n = length $ filter (\s -> sum s == n) $ subsequences cap

main :: IO ()
main = do
  lns <- readFile "input.txt"
  let capacities = map (read :: String -> Int) $ lines lns
  print $ count capacities 150
