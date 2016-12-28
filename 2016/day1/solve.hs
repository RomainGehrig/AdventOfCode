import Data.List.Split

data Direction = N | E | S | W deriving (Show, Eq, Enum, Bounded)
data Turn = R | L deriving (Show, Read)
newtype Move = Move { getMove :: (Turn, Int) } deriving (Show)
newtype Position = Position { getPosition :: (Direction, Int, Int) } deriving (Show)

readInput :: IO [Move]
readInput = do
  content <- readFile "input.txt"
  let moves = splitOn ", " content
  return $ map toMove moves
  where toMove s = Move (read $ [head s] :: Turn, read $ tail s :: Int)

advance :: Position -> Move -> Position
advance (Position (direction, north, east)) (Move (turn, n)) =
  Position (newDir, north + n * multiplicator N newDir, east + n * multiplicator E newDir)
  where newDir = newDirection direction turn
        d1 `isParallelWith` d2 = (fromEnum d1 + fromEnum d2) `mod` 2 == 0
        multiplicator d1 d2 =
          if d1 `isParallelWith` d2 then
            (if d1 == d2 then 1 else -1)
          else 0

newDirection :: Direction -> Turn -> Direction
newDirection d R | d == maxBound = minBound
                 | otherwise = succ d
newDirection d L | d == minBound = maxBound
                 | otherwise = pred d

l1Norm :: Position -> Int
l1Norm (Position (_, x, y)) = abs x + abs y

main :: IO ()
main = do
  moves <- readInput
  print $ l1Norm $ foldl advance (Position (N, 0, 0)) moves
