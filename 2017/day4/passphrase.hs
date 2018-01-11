import qualified Data.Set as S

readInput :: IO [String]
readInput = do
  content <- readFile "input.txt"
  return $ lines content

correctPassphrase :: String -> Bool
correctPassphrase p = length words' == (S.size . S.fromList $ words')
  where words' = words p

main :: IO ()
main = do
  phrases <- readInput
  print $ length $ filter correctPassphrase phrases
