import Data.Either
import Control.Monad
import Text.ParserCombinators.Parsec
import Data.Array.IO

data Claim = Claim { claimId :: Int, pos :: (Int, Int), dim :: (Int, Int) } deriving Show

claim :: Parser Claim
claim = do
  char '#'
  claimId <- read <$> many digit
  string " @ "
  x <- read <$> many digit
  char ','
  y <- read <$> many digit
  string ": "
  dx <- read <$> many digit
  char 'x'
  dy <- read <$> many digit
  return $ Claim {claimId=claimId, pos=(x,y), dim=(dx,dy)}

claims :: Parser [Claim]
claims = many1 (claim <* spaces)

readInput :: IO [Claim]
readInput = do
  content <- readFile "input.txt"
  let res = parse claims "" content
  return $ join $ rights [res]

insertClaim :: IOArray (Int,Int) Int -> Claim -> IO ()
insertClaim arr (Claim claimId (x,y) (dx, dy)) =
  -- [0 .. dx] valid ?
  forM_ [ (x + dxx, y + dyy) | dxx <- [0..dx-1], dyy <- [0..dy-1] ] $ \i -> do
    val <- readArray arr i
    writeArray arr i (val+1)

countClaims :: IOArray (Int,Int) Int -> IO Int
countClaims arr = do
  elems <- getElems arr
  return $ length $ filter (>=2) elems

main :: IO ()
main = do
  claims <- readInput
  arr <- newArray ((0,0), (1000,1000)) 0
  mapM_ (insertClaim arr) claims
  count <- countClaims arr
  print $ count
