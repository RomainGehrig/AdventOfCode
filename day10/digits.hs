import qualified Data.List as L

countInput :: String -> String
countInput s = concatMap (\l -> show (length l) ++ [head l]) $ L.group s

input = "1321131112"

frepeat :: (a -> a) -> Int -> a -> a
frepeat _ 0 x = x
frepeat f n x = frepeat f (n-1) (f x)

main :: IO ()
main = print $ length $ frepeat countInput 50 input
