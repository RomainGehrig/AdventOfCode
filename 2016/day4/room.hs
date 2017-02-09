import Text.Regex.Posix
import Data.List.Split (splitOn)
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

readInput :: IO [Room]
readInput = do
  content <- readFile "input.txt"
  let rooms = filter (not . null) $ splitOn "\n" content
  return $ map read rooms

main :: IO ()
main = do
  rooms <- readInput
  print $ sum $ map sectorID $ filter isRealRoom rooms
