import Data.List
import Data.Ord
import Control.Monad

data Boss = Boss Int Stats deriving (Show,Eq)
data Player = Player Int Stats String deriving (Show,Eq)

data Stats = Stats { damage :: Int, armor :: Int } deriving (Show,Eq)

data Equipment = Equipment String Int Stats deriving (Show,Eq)

getStats :: Equipment -> Stats
getStats (Equipment _ _ s) = s

getCost :: Equipment -> Int
getCost (Equipment _ c _) = c

getName :: Equipment -> String
getName (Equipment n _ _) = n

totalCost :: [Equipment] -> Int
totalCost eq = sum $ map getCost eq

equipment :: (String, Int, Int, Int) -> Equipment
equipment (name, cost, atk, arm) = Equipment name cost (Stats atk arm)

weapons :: [Equipment]
weapons = map equipment
          [ ("Dagger"    , 8,4,0)
          , ("Shortsword",10,5,0)
          , ("Warhammer" ,25,6,0)
          , ("Longsword" ,40,7,0)
          , ("Greataxe"  ,74,8,0)]

armors :: [Equipment]
armors = map equipment
         [ ("Leather"   , 13,0,1)
         , ("Chainmail" , 31,0,2)
         , ("Splintmail", 53,0,3)
         , ("Bandedmail", 75,0,4)
         , ("Platemail" ,102,0,5)]

rings :: [Equipment]
rings = map equipment
        [ ("Damage +1" , 25,1,0)
        , ("Damage +2" , 50,2,0)
        , ("Damage +3" ,100,3,0)
        , ("Defense +1", 20,0,1)
        , ("Defense +2", 40,0,2)
        , ("Defense +3", 80,0,3)]

player :: [Equipment] -> Player
player eq = Player 100 playerStats eqName
  where playerStats = foldl1 (\(Stats d1 a1) (Stats d2 a2) -> Stats (d1 + d2) (a1 + a2)) $ map getStats eq
        eqName = intercalate "," $ map getName eq

turn :: (Player, Boss) -> (Player, Boss)
turn (Player hpp statsp eqName, Boss hpb statsb) = (player', boss')
  where player' = Player (hpp - (max 1 (damage statsb - armor statsp))) statsp eqName
        boss'   = Boss   (hpb - (max 1 (damage statsp - armor statsb))) statsb

winsAgainstBoss :: Player -> Boss -> Bool
winsAgainstBoss p@(Player h s _) b@(Boss hb sb)
  | hb <= 0 = True -- In case both die, the player wins because he takes the first action in a turn
  | h <= 0 = False
  | otherwise = uncurry winsAgainstBoss (turn (p,b))

equipmentPossibilities :: [(Player,Int)]
equipmentPossibilities = do
  weapon <- weapons
  armor <- [] : map return armors
  rings <- [] : map return rings ++ (filter (\(x:y:xs) -> x /= y ) $ replicateM 2 rings)
  let fullEquipment = weapon : armor ++ rings
  let cost = totalCost fullEquipment
  return (player fullEquipment, cost)

losses :: Boss -> [(Player,Int)]
losses boss = do
  (play,cost) <- equipmentPossibilities
  guard $ not $ winsAgainstBoss play boss
  return (play,cost)

main :: IO ()
main = do
  let boss = Boss 103 (Stats 9 2)
  let loss = maximumBy (comparing snd) $ losses boss
  print $ loss
