import Data.List

spiral :: [[Int]]
spiral = [
  [17, 16, 15, 14, 13],
  [18,  5,  4,  3, 12],
  [19,  6,  1,  2, 11],
  [20,  7,  8,  9, 10],
  [21, 22, 23, 24, 25]]

strSpiral :: [[Int]] -> String
strSpiral sp = unlines $ map strRow sp
  where strRow row = unwords $ map strCell row
        strCell i = if i < 10 then " " ++ show i else show i

newtype Vec2 = Vec2 { getPos :: (Int, Int) } deriving (Show, Eq)

addVec2 :: Vec2 -> Vec2 -> Vec2
addVec2 (Vec2 (x1,y1)) (Vec2 (x2,y2)) = Vec2 (x1+x2, y1+y2)

moves :: [Vec2]
moves = zipWith (\v x -> v x) (cycle constructors) ms
  where ms = [1..] >>= \x -> [x,x]
        constructors = [\x -> Vec2 (x,0), \y -> Vec2 (0,-y), \x -> Vec2 (-x, 0), \y -> Vec2 (0, y)]

decomposeMove :: Vec2 -> [Vec2]
decomposeMove (Vec2 (x, y)) =
  if x == 0 then
    newVec2s y (\y -> Vec2 (0,y))
  else
    newVec2s x (\x -> Vec2 (x,0))
  where newVec2s dir constructor = replicate (abs dir) (constructor (signum dir))

positions :: [Vec2]
positions = (startPos:) $ scanl addVec2 startPos (moves >>= decomposeMove)
  where startPos = Vec2 (0,0)

vec2Num :: Vec2 -> Int
vec2Num (Vec2 (x, y)) = (2*layer - 1) ^ 2 + if x > y then (-x) - y + 2 * layer else x + y + 6 * layer
  where layer = max x' y'
        x' = abs x
        y' = abs y

valueFromNeighbors :: Vec2 -> Int
valueFromNeighbors pos = sum $ map (\n -> spiralValues !! (vec2Num n - 1)) $ validNeighbors pos
  where validNeighbors vec = filter (\neighbor -> vec2Num neighbor < vec2Num vec ) $ neighbors vec

neighbors :: Vec2 -> [Vec2]
neighbors (Vec2 (x,y)) = [ Vec2 (x+dx, y+dy) | dx <- [-1,0,1], dy <- [-1,0,1], dx /= 0 || dy /= 0]

spiralValues :: [Int]
spiralValues = 1 : map valueFromNeighbors (drop 2 positions)

main :: IO ()
main = do
  -- putStrLn $ strSpiral spiral
  -- let distSpiral = map (map (\i -> valueFromNeighbors $ positions !! i)) spiral
  -- putStrLn $ strSpiral distSpiral
  print $ head $ dropWhile (<277678) spiralValues
