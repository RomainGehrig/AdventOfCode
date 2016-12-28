import Data.List.Split
import Data.Ord
import Control.Monad
import qualified Data.Set as S
import System.IO.Unsafe
import Data.Function

data Direction = N | E | S | W deriving (Show, Eq, Enum, Bounded, Ord)
data Turn = R | L deriving (Show, Read)
newtype Move = Move { getMove :: (Turn, Int) } deriving (Show)
newtype Position = Position { getPosition :: (Direction, (Int, Int)) } deriving (Show)


advance :: Position -> Move -> [Position]
advance (Position (direction, (north, east))) (Move (turn, nbSteps)) =
  [Position (newDir, (north + n * multiplicator N newDir, east + n * multiplicator E newDir)) | n <- [1..nbSteps]]
  where newDir = newDirection direction turn
        multiplicator d1 d2 =
          if d1 `isParallelWith` d2 then
            (if d1 == d2 then 1 else -1)
          else 0
        d1 `isParallelWith` d2 = (fromEnum d1 + fromEnum d2) `mod` 2 == 0

advanceWithMemo :: (S.Set (Int,Int), Position) -> Move -> (S.Set (Int, Int), Position)
advanceWithMemo startingState@(_, currPos) newMove = foldl stepByStep startingState newPositions
  where newPositions = advance currPos newMove
        stepByStep (visited, pos) newPos  =
          if xy newPos `S.member` visited then
            unsafePerformIO $ do
              putStrLn $ "Returned on point " ++ (show $ xy newPos) ++ " at distance " ++ (show $ l1Norm newPos)
              return (visited, newPos)

          else (xy newPos `S.insert` visited, newPos)

xy :: Position -> (Int, Int)
xy (Position (_, xy)) = xy

newDirection :: Direction -> Turn -> Direction
newDirection d R | d == maxBound = minBound
                 | otherwise = succ d
newDirection d L | d == minBound = maxBound
                 | otherwise = pred d

l1Norm :: Position -> Int
l1Norm (Position (_, (x,y))) = abs x + abs y

readInput :: IO [Move]
readInput = do
  content <- readFile "input.txt"
  let moves = splitOn ", " content
  return $ map toMove moves
  where toMove s = Move (read $ [head s] :: Turn, read $ tail s :: Int)

main :: IO ()
main = do
  moves <- readInput
  print $ l1Norm $ snd $ foldl advanceWithMemo startingState moves
  where startingState = (S.singleton (0,0), Position (N, (0,0)))
