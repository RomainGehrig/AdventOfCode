import Text.Regex.Posix
import Data.List.Split (splitOn)
import Data.Char
import qualified Data.List as L

data Room = Room { name :: String
                 , sectorID :: Int
                 , checksum :: String } deriving (Show, Eq)

instance Read Room where
  readsPrec _ str = [(Room { name = name
                           , sectorID = read sect
                           , checksum = checksum}, "")]
    where (_,_,_, [name, sect, checksum]) =
            str =~ "([a-z-]+)([0-9]+)\\[([a-z]+)\\]" :: (String, String, String, [String])

isRealRoom :: Room -> Bool
isRealRoom (Room name _ checksum) = computeChecksum name == checksum
  where computeChecksum = map snd . take 5 . L.sort . map (\xs@(x:_) -> (negate $ length xs, x)) . L.group . L.sort . filter (/= '-')

caesar :: Int -> Char -> Char
caesar _ '-' = ' '
caesar shift c = chr $ (ord c - a + shift) `mod` 26 + a
  where a = ord 'a'

decipher :: Room -> String
decipher (Room name sector _) = map (caesar sector) name

readInput :: IO [Room]
readInput = do
  content <- readFile "input.txt"
  let rooms = filter (not . null) $ splitOn "\n" content
  return $ map read rooms

main :: IO ()
main = do
  rooms <- readInput
  print $ filter ((=~ "north") . snd) $ map (\r -> (sectorID r, decipher r)) $ filter isRealRoom rooms
