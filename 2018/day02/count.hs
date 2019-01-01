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

main :: IO ()
main = do
  ids <- readInput
  print $ (\(x,y) -> x*y) $ count $ ids
