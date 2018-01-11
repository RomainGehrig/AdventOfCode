import Data.List

spiral :: [[Int]]
spiral = [
  [17, 16, 15, 14, 13],
  [18,  5,  4,  3, 12],
  [19,  6,  1,  2, 11],
  [20,  7,  8,  9, 10],
  [21, 22, 23, 24, 25]]

lastNum :: Int -> Int
lastNum i = (i * 2 + 1)^2

layer :: Int -> Int
layer i = ((floor . sqrt . fromIntegral $ i - 1) - 1) `div` 2 + 1

distToCenter :: Int -> Int
distToCenter i = if n == 0 then 0 else abs ((lastNum n - i) `mod` (nums - 1) - n) + n
  where n = layer i
        nums = (n * 2 + 1)

strSpiral :: [[Int]] -> String
strSpiral sp = unlines $ map strRow sp
  where strRow row = unwords $ map strCell row
        strCell i = if i < 10 then " " ++ show i else show i

main :: IO ()
main = do
  -- putStrLn $ strSpiral spiral
  -- let distSpiral = map (map distToCenter) spiral
  -- putStrLn $ strSpiral distSpiral
  print $ distToCenter 277678
