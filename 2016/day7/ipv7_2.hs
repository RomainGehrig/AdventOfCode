import Data.List
import Data.Tuple
import Data.List.Split (splitOn)
import Text.Regex.Posix
import Data.Maybe (isJust)
import Debug.Trace

data IPv7 = IPv7 { normals :: [String]
                 , hypernets :: [String] } deriving (Show, Eq)

instance Read IPv7 where
  readsPrec _ str = [(IPv7 normals hypernets', "")]
    where matches = getAllTextMatches $ str =~ "\\[[a-z]+\\]|[a-z]+" :: [String]
          (normals, hypernets) = partition ((/= '[') . head) matches
          hypernets' = map (init . tail) $ hypernets

readInput :: IO [IPv7]
readInput = do
  content <- readFile "input.txt"
  let ips = map read $ filter (not . null) $ splitOn "\n" content
  return ips

supportsSSL :: IPv7 -> Bool
supportsSSL (IPv7 normals hypernets) = not . null $ normalsABA `intersect` hypernetsABA
  where normalsABA = normals >>= collectABA
        hypernetsABA = map swap $ hypernets >>= collectABA

collectABA :: String -> [(Char,Char)]
collectABA s = collectABA' [] s
  where collectABA' acc (a:b:a':xs) = let acc' = if (a == a' && a /= b) then (a,b):acc
                                                 else acc
                                      in collectABA' acc' (b:a':xs)
        collectABA' acc _ = acc

main :: IO ()
main = do
  ips <- readInput
  print $ length $ filter supportsSSL ips
