{-# LANGUAGE FlexibleContexts #-}
import Debug.Trace
import Data.Array.IO
import Data.Either
import Control.Applicative
import Control.Monad (forM_, foldM)
import Data.List.Split (splitOn)
import Text.ParserCombinators.Parsec hiding (many)

data Command = RotateCol Int Int | RotateRow Int Int | Rectangle Int Int deriving (Show, Eq)
type Bit = Int
data LCD = LCD { screen :: IOArray (Int,Int) Bit
               , dimensions :: (Int, Int) }

instance Read Command where
  readsPrec _ str = map (\x -> (x,"")) $ rights [parsed]
    where rect = (,) <$> (string "rect " *> (many digit <* char 'x')) <*> many digit
          rotCol = (,) <$> (string "rotate column x=" *> (many digit <* string " by ")) <*> many digit
          rotRow = (,) <$> (string "rotate row y=" *> (many digit <* string " by ")) <*> many digit
          command = choice [ transform Rectangle <$> try rect
                           , transform RotateCol <$> try rotCol
                           , transform RotateRow <$> try rotRow]
                   <?> "valid command"
          parsed = parse command "" str
          transform tpe (x,y) = tpe (read x) (read y)

applyCommand :: LCD -> Command -> IO LCD
applyCommand lcd@(LCD screen (width, height)) (RotateCol x by) = do
  rotateArray screen (\y -> (x,y)) by height
  return lcd
applyCommand lcd@(LCD screen (width, height)) (RotateRow y by) = do
  rotateArray screen (\x -> (x,y)) by width
  return lcd
applyCommand lcd@(LCD screen (width, height)) (Rectangle x y) = do
  forM_ [0..x-1] $ \x ->
    forM_ [0..y-1] $ \y ->
      writeArray screen (x,y) 1
  return lcd

rotateArray :: Ix i => IOArray i b -> (Int -> i) -> Int -> Int -> IO ()
rotateArray arr toIx shift size = do
  let cut = size - shift
  reverseArray arr toIx 0 (cut-1)
  reverseArray arr toIx cut (size-1)
  reverseArray arr toIx 0 (size-1)

reverseArray :: Ix i => IOArray i b -> (Int -> i) -> Int -> Int -> IO ()
reverseArray arr toIx from to = do
  forM_ [0 .. (to - from) `div` 2] $ \i -> do
    let (i1, i2) = (toIx $ from + i, toIx $ to - i)
    tmp <- readArray arr i2
    readArray arr i1 >>= writeArray arr i2
    writeArray arr i1 tmp

readInput :: IO [Command]
readInput = do
  content <- readFile "input.txt"
  let commands = filter (not . null) $ splitOn "\n" content
  return $ map read commands

createLCD :: (Int,Int) -> Bit -> IO LCD
createLCD (x,y) defaultBit = do
  arr <- newArray ((0,0), (x-1,y-1)) defaultBit
  return $ LCD arr (x,y)

countLit :: LCD -> IO Int
countLit (LCD screen (width, height)) = do
  foldM (\i pos -> do
            bit <- readArray screen pos
            return $ if (bit == 1) then i+1 else i) 0 positions
  where positions = [(x,y) | x <- [0..width-1], y <- [0..height-1]]

printLCD :: LCD -> IO ()
printLCD (LCD screen (width, height)) = do
  forM_ [0..height-1] $ \y -> do
    forM_ [0..width-1] $ \x -> do
      bit <- readArray screen (x,y)
      if (bit == 1) then
        putStr "#"
      else
        putStr " "
    putStr "\n"

main :: IO ()
main = do
  commands <- readInput
  lcd <- createLCD (50,6) 0
  result <- foldM applyCommand lcd commands
  lights <- countLit result
  printLCD result
  print $ lights
