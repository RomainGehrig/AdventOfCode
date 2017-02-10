import Data.List
import Data.List.Split (splitOn)
import Data.Ord (comparing)

readInput :: IO [String]
readInput = do
  content <- readFile "input.txt"
  let passwords = splitOn "\n" content
  return $ passwords

findPassword :: [String] -> String
findPassword pwds = map bestCandidate possibleLetters
  where possibleLetters = transpose pwds
        bestCandidate = head . maximumBy (comparing length) . group . sort

main :: IO ()
main = do
  passwords <- readInput
  print $ findPassword passwords
