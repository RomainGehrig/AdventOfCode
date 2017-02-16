import Data.Either
import Control.Monad
import Debug.Trace
import Text.ParserCombinators.Parsec

data Token = Marker { len :: Int, repeat :: Int, str :: String } | PlainText String deriving Show

manyTill1 p1 end = do
  p <- p1
  ps <- manyTill p1 end
  return $ p:ps

marker :: Parser Token
marker = do
  char '('
  len <- read <$> many digit
  char 'x'
  repeat <- read <$> many digit
  char ')'
  str <- count len anyChar
  return $ Marker len repeat str

text :: Parser Token
text = PlainText <$> manyTill1 (spaces *> anyChar) (eof <|> (lookAhead (try marker) >> return ()))

tokenizer = many1 $ choice [try marker, try text]

toLength :: Token -> Int
toLength (Marker len repeat _) = len * repeat
toLength (PlainText str) = length str

totalLength :: [Token] -> Int
totalLength = sum . map (toLength)

readInput :: IO [Token]
readInput = do
  content <- readFile "input.txt"
  let res = parse tokenizer "" content
  return $ join $ rights [res]

main :: IO ()
main = do
  tokens <- readInput
  print $ totalLength tokens
