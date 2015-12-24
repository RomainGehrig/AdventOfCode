import Data.List
import Data.Ord

possibilities :: [Int] -> [([Int],[Int],[Int],[Int])]
possibilities packets = do
  group1 <- possibilitiesWith inverse
  let remaining = inverse \\ group1
  let group2 = head $ possibilitiesWith remaining
  let remaining2 = remaining \\ group2
  let group3 = head $ possibilitiesWith remaining2
  let remaining3 = remaining2 \\ group3
  let group4 = head $ possibilitiesWith remaining3
  return (group1,group2,group3,group4)
  where perSide = sum packets `div` 4
        inverse = reverse packets
        possibilitiesWith remainingPackets = filter ((== perSide) . sum) $ subsequences' remainingPackets

-- Shamelessly taken from http://stackoverflow.com/questions/21265454/subsequences-of-length-n-from-list-performance
subsequencesOfSize :: Int -> [a] -> [[a]]
subsequencesOfSize n xs = let l = length xs
                          in if n>l then [] else subsequencesBySize xs !! (l-n)
 where
   subsequencesBySize [] = [[[]]]
   subsequencesBySize (x:xs) = let next = subsequencesBySize xs
                             in zipWith (++) ([]:next) (map (map (x:)) next ++ [[]])

-- This subsequencee' yields possibilities in ascending length
subsequences' :: [a] -> [[a]]
subsequences' xs = concatMap (\n -> subsequencesOfSize n xs) [0..length xs]

fst4 :: (a,b,c,d) -> a
fst4 (a,_,_,_) = a

prunePossibilities :: [([Int], [Int], [Int], [Int])] -> [([Int], [Int], [Int], [Int])]
prunePossibilities xs = takeWhile ((== minPackets) . group1Size) xs
  where minPackets = group1Size $ head xs
        group1Size = length . fst4

bestPossibility :: [([Int], [Int], [Int], [Int])] -> ([Int], [Int], [Int], [Int])
bestPossibility = minimumBy (comparing qe)
  where qe = product . fst4

readInput :: IO [Int]
readInput = do
  str <- readFile "input.txt"
  return $ map (read :: String -> Int) $ lines str

main :: IO ()
main = do
  packets <- readInput
  let p = bestPossibility $ prunePossibilities $ possibilities packets
  print $ product . fst4 $ p
