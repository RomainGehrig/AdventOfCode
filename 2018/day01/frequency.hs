import qualified Data.Set as S

readInput :: IO [Int]
readInput = do
  content <- readFile "input.txt"
  return $ map (read . filter (/= '+')) $ lines $ content

repeated :: Ord a => [a] -> [a]
repeated xss = go S.empty xss
  where
    go _ [] = []
    go prev (x:xs) =
      let xs' = go (x `S.insert` prev) xs in
        if x `S.member` prev then
          x : xs'
        else
          xs'

main :: IO ()
main = do
  digits <- readInput
  print $ sum $ digits
  print $ head $ repeated $ scanl (+) 0 $ cycle digits
