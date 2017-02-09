{-# LANGUAGE MultiWayIf #-}
import Data.List.Split (splitOn)
import qualified Data.Map as M
import Control.Monad

data Direction = L | R | U | D deriving (Show, Read, Eq, Enum, Bounded, Ord)
newtype Digit = Digit { getDigit :: Char } deriving (Show, Eq, Ord)
type Keypad = Digit -> Direction -> Maybe Digit -- M.Map Digit (M.Map Direction Digit)

withCoordinates :: [[a]] -> [((Int,Int), a)]
withCoordinates xss = join $ zipWith subCoord [0..] xss
  where subCoord ycoord xs = zipWith (\xcoord x -> ((xcoord, ycoord), x)) [0..] xs

readKeypad :: String -> Keypad
readKeypad s = \digit dir ->
  do
    position <- digit `M.lookup` digits
    (position `addDirection` dir) `M.lookup` positions
  where s' = splitOn "\n" s
        coordinates = map (fmap Digit) $ filter (\(_, c) -> c /= ' ') $ withCoordinates s'
        positions = M.fromList $ coordinates -- from coordinates to digits
        digits = M.fromList $ map (\(x,y) -> (y,x)) coordinates -- from digits to coordinates

addDirection :: (Int, Int) -> Direction -> (Int, Int)
addDirection (x,y) d = (x+dx, y+dy)
  where (dx, dy) = dirToTuple d

dirToTuple :: Direction -> (Int,Int)
dirToTuple L = (-1, 0)
dirToTuple R = ( 1, 0)
dirToTuple U = ( 0,-1)
dirToTuple D = ( 0, 1)

keypadStr =
  "  1  \n\
  \ 234 \n\
  \56789\n\
  \ ABC \n\
  \  D  "

keypad :: Keypad
keypad = readKeypad keypadStr

readInput :: IO [[Direction]]
readInput = do
  content <- readFile "input.txt"
  let directionss = splitOn "\n" content
  return $ map (map toDirection) directionss
  where toDirection c = read [c]


applyDirection :: Digit -> Direction -> Digit
applyDirection digit dir = maybe digit id (keypad digit dir)

findRowDigit :: Digit -> [Direction] -> Digit
findRowDigit = foldl (applyDirection)

main :: IO ()
main = do
  directionss <- readInput
  print $ toCode $ tail $ scanl findRowDigit (Digit '5') directionss
  where toCode xs = map getDigit xs
