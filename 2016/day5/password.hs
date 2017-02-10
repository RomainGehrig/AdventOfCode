import Data.Hash.MD5 as M
import Data.Maybe (mapMaybe)

getPassword :: String -> [Char]
getPassword seed = mapMaybe (getDigit . toPassword seed) [0..]

toPassword :: String -> Int -> String
toPassword s i = s ++ show i

getDigit :: String -> Maybe Char
getDigit s = if (take 5 hash == "00000") then
               Just (head $ drop 5 hash)
             else
               Nothing
  where hash = M.md5s (M.Str s)

main :: IO ()
main = do
  print $ take 8 $ getPassword "reyedfim"
