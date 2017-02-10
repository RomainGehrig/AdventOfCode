import qualified Data.Hash.MD5 as M
import qualified Data.Map as Mp
import Data.Maybe (mapMaybe)
import Data.Char (isDigit, digitToInt)
import Debug.Trace

getPassword :: String -> [(Int,Char)]
getPassword seed = mapMaybe (getDigit . toPassword seed) [0..]

toPassword :: String -> Int -> String
toPassword s i = s ++ show i

getDigit :: String -> Maybe (Int, Char)
getDigit s = if (take 5 hash == "00000") then
               validPos >>= (\p -> trace ("Found a hash: " ++ hash ++ " (position: " ++ show p ++ ")") $ Just (p,digit))
             else
               Nothing
  where hash = M.md5s (M.Str s)
        position = head $ drop 5 hash
        validPos = if isDigit position then Just (digitToInt position) else Nothing
        digit = head $ drop 6 hash

main :: IO ()
main = do
  print $ map (`Mp.lookup` mp) [0..7]
  where mp = Mp.fromList $ getPassword "reyedfim"
