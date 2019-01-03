import Data.List
import qualified Data.Ord as O
import Data.Either
import Control.Monad
import Text.ParserCombinators.Parsec
import Data.Array.IO
import qualified Data.Map as M

data Time = Time { year :: Int, month :: Int, day :: Int, hour :: Int, minute :: Int } deriving Show
data Event = GuardBegins { gid :: Int, guardTime :: Time } | GuardFallsAsleep { sleepTime :: Time } | GuardWakesUp { wakeTime :: Time } deriving Show
data GuardState = GuardState { currentGuard :: Int, asleepTime :: Time, guardMinutes :: M.Map Int (IOArray Int Int) }

defaultTime :: Time
defaultTime = Time 0 0 0 0 0

time :: Parser Time
time = do
  char '['
  year <- read <$> many digit
  char '-'
  month <- read <$> many digit
  char '-'
  day <- read <$> many digit
  char ' '
  hour <- read <$> many digit
  char ':'
  minute <- read <$> many digit
  char ']'
  return $ Time {year=year, month=month, day=day, hour=hour, minute=minute}

guardParser :: Parser Event
guardParser = do
  t <- time
  string " Guard #"
  gid <- read <$> many digit
  string " begins shift"
  return $ GuardBegins { gid=gid, guardTime=t }

wakeup :: Parser Event
wakeup = GuardWakesUp <$> time <* string " wakes up"

fallsAsleep :: Parser Event
fallsAsleep = GuardFallsAsleep <$> time <* string " falls asleep"

event :: Parser Event
event = try guardParser <|> try wakeup <|> try fallsAsleep

events :: Parser [Event]
events = many1 (event <* spaces)

-- End minute is not comprised
minutesInRange :: Time -> Time -> [Int]
minutesInRange (Time _ _ _ _ m1) (Time _ _ _ _ m2) = [m1..m2-1]

readInput :: IO [Event]
readInput = do
  content <- readFile "input.txt"
  let sortedContent = unlines . sort . lines $ content
  let res = parse events "" sortedContent
  return $ join $ rights [res]

addEvent :: GuardState -> Event -> IO GuardState
addEvent (GuardState _ _ gm) (GuardBegins gid _) = return $ GuardState gid defaultTime gm
addEvent (GuardState gid _ gm) (GuardFallsAsleep t) = return $ GuardState gid t gm
addEvent (GuardState gid st gm) (GuardWakesUp wt) = do
  minutes <- newArray (0,59) 0 :: IO (IOArray Int Int)
  let gm' = if gid `M.member` gm then gm
            else M.insert gid minutes gm
      gTable = gm' M.! gid
  forM_ (minutesInRange st wt) $ \m -> do
    oldVal <- readArray gTable m
    writeArray gTable m (oldVal+1)
  return $ GuardState gid st gm'

findBadGuard :: GuardState -> IO (Int, Int)
findBadGuard gs = do
  let gm = guardMinutes gs
  guards <- forM (M.assocs gm) $ \(guardId, minsArr) -> do
    mins <- getAssocs minsArr
    -- Need (most slept minute, (guardId, index of most slept minute))
    let mostSleptMin = maximumBy (O.comparing snd) mins
    return (snd mostSleptMin, (guardId, fst mostSleptMin))
  return $ snd $ maximumBy (O.comparing fst) guards

main :: IO ()
main = do
  events <- readInput
  let startingState = GuardState { currentGuard=0, asleepTime=defaultTime, guardMinutes=M.empty }
  finalState <- foldM addEvent startingState events
  badGuard <- findBadGuard finalState
  print $ (\(x,y) -> x*y) $ badGuard
