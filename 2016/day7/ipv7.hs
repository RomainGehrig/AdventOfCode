import Data.List
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

supportsTLS :: IPv7 -> Bool
supportsTLS (IPv7 normals hypernets) = (any hasABBA normals) && (not $ any hasABBA hypernets)

hasABBA :: String -> Bool
hasABBA = isJust . getABBA

getABBA :: String -> Maybe String
getABBA (a:b:b':a':xs) = if (a == a' && b == b' && a /= b) then Just [a,b,b,a] else getABBA (b:b':a':xs)
getABBA _ = Nothing

main :: IO ()
main = do
  ips <- readInput
  print $ length $ filter supportsTLS ips
