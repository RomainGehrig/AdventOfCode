position :: (Integer, Integer) -> Integer
position (row,col) = triangle + toNum + 1
  where line = row + col - 1
        triangle = line * (line - 1) `div` 2 -- Big triangle
        toNum    = line - row -- from the bottom to the number

fastExpUnderMod :: Integer -- modulo
                -> Integer -- base
                -> Integer -- exponent
                -> Integer -- Result
fastExpUnderMod m 1 _ = 1
fastExpUnderMod m b 1 = b `mod` m
fastExpUnderMod m b e | even e    = fastExpUnderMod m (b * b) (e `div` 2)
                      | otherwise = ((b `mod` m) * fastExpUnderMod m b (e - 1)) `mod` m

getPassForPos :: (Integer, Integer) -> Integer
getPassForPos input = baseNum * (fastExpUnderMod modulo multiply exponent) `mod` modulo
  where exponent = position input - 1

baseNum = 20151125
modulo =  33554393
multiply =  252533

main :: IO ()
main = do
  let input = (3010, 3019) -- Row, column
  print $ getPassForPos input
