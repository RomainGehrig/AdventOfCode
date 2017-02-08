{-# LANGUAGE MultiWayIf #-}
import Data.List.Split

data Direction = L | R | U | D deriving (Show, Read, Eq, Enum, Bounded)
newtype Digit = Digit { getDigit :: Int } deriving (Show, Eq)

readInput :: IO [[Direction]]
readInput = do
  content <- readFile "input.txt"
  let directionss = splitOn "\n" content
  return $ map (map toDirection) directionss
  where toDirection c = read [c]

directionToInt :: Direction -> Int
directionToInt L = -1
directionToInt R =  1
directionToInt U = -3
directionToInt D =  3

applyDirection :: Digit -> Direction -> Digit
applyDirection dig@(Digit d) dir =
  if | (dir == L || dir == R) && staysInKeypad && staysOnRow -> Digit digit'
     | (dir == U || dir == D) && staysInKeypad && staysOnColumn -> Digit digit'
     | otherwise -> dig
  where d' = d - 1
        dirVal = directionToInt dir
        digit' = d + dirVal
        staysOnRow = (d' + dirVal) `div` 3 == d' `div` 3
        staysOnColumn = (d' + dirVal) `mod` 3 == d' `mod` 3
        staysInKeypad = digit' > 0 && digit' <= 9

findRowDigit :: Digit -> [Direction] -> Digit
findRowDigit = foldl (applyDirection)

main :: IO ()
main = do
  directionss <- readInput
  print $ toCode $ tail $ scanl findRowDigit (Digit 5) directionss
  where toCode = foldl (\i (Digit d) -> i * 10 + d) 0
