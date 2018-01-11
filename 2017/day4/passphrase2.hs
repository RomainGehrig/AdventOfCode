import qualified Data.Set as S
import Data.List (sort)

readInput :: IO [String]
readInput = do
  content <- readFile "input.txt"
  return $ lines content

correctPassphrase :: String -> Bool
correctPassphrase p = length words' == (S.size . S.fromList $ words')
  where words' = map sort $ words p

main :: IO ()
main = do
  phrases <- readInput
  print $ length $ filter correctPassphrase phrases
