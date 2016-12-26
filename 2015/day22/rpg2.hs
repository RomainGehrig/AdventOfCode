{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
import qualified Data.Map as M
import Control.Monad
import Control.Monad.Writer
import Data.Ord
import Data.List

data Boss = Boss Int Stats deriving (Show,Eq)
data Player = Player Int Int Stats deriving (Show,Eq) -- Player HP Mana Stats
data Stats = Stats { damage :: Int, armor :: Int } deriving (Show,Eq)

data Effect a = Effect Int (a -> a) (a -> a) -- Effect Duration EffectDuring EffectAfter
newtype GameState a = GameState { getState :: (a, M.Map String (Effect a)) }
newtype Spell a = Spell { getSpell :: (String, Int, Effect a) }

instance Show a => Show (GameState a) where
  show (GameState (a, effects)) = "GameState: " ++ show a ++ ", effects: " ++ (show $ M.keys effects)

onBoss :: Int -> (Boss -> Boss) -> (Boss -> Boss) -> Effect (Player,Boss)
onBoss t f g =   Effect t (fOnBoss f) (fOnBoss g)
  where fOnBoss func = \(p,b) -> (p, func b)
onPlayer :: Int -> (Player -> Player) -> (Player -> Player) -> Effect (Player,Boss)
onPlayer t f g = Effect t (fOnPlayer f) (fOnPlayer g)
  where fOnPlayer func = \(p,b) -> (func p, b)

(.+.) :: Effect (a,b) -> Effect (a,b) -> Effect (a,b)
Effect t1 f1 g1 .+. Effect t2 f2 g2 = Effect (if t1 == t2 then t1 else error "Unmatched effect length") (f2 . f1) (g2 . g1)

spells :: [Spell (Player,Boss)]
spells = map Spell $ [ ("Magic Missile", 53, onBoss    0 (\(Boss hp s) -> Boss (hp - 4) s) id)
                     , ("Drain",         73, (onBoss   0 (\(Boss hp s) -> Boss (hp - 2) s) id) .+.
                                             (onPlayer 0 (\(Player hp mana s) -> Player (hp + 2) mana s)) id)
                     , ("Shield",       113, onPlayer  6 (\(Player hp mana (Stats atk arm)) -> Player hp mana (Stats atk 7))
                                                         (\(Player hp mana (Stats atk arm)) -> Player hp mana (Stats atk 0)))
                     , ("Poison",       173, onBoss    6 (\(Boss hp s) -> Boss (hp - 3) s) id)
                     , ("Recharge",     229, onPlayer  5 (\(Player hp mana s) -> Player hp (mana+101) s) id)
                     ]

performEffects :: GameState a -> GameState a
performEffects (GameState (p, eff)) = GameState (appliedAfterEffects, activeEffects)
  where appliedEffects = M.foldl (\h (Effect _ f _) -> f h) p eff
        appliedAfterEffects = M.foldl (\h (Effect _ _ g) -> g h) appliedEffects afterEffects
        (activeEffects, afterEffects) = M.partition active $ M.map (\(Effect i f g) -> Effect (i-1) f g) eff
        active (Effect i _ _) = i > 0

bossTurn :: GameState (Player,Boss) -> GameState (Player,Boss)
bossTurn (GameState ((Player hp mana s@(Stats atkP armP), b@(Boss _ (Stats atkB _))), eff)) = GameState ((Player hp' mana s, b), eff)
  where hp' = hp - max 1 (atkB - armP)

playerPossibilities :: GameState (Player,Boss) -> [(GameState (Player,Boss), Int, String)]
playerPossibilities (GameState ((Player hp mana stats, b), effects)) = do
  Spell (name, cost, eff) <- spells
  guard $ (cost < mana) && (not $ name `elem` M.keysSet effects)
  let newState = GameState ((Player hp (mana - cost) stats, b), M.insert name eff effects)
  return $ (newState, cost, name)

playerLives :: GameState (Player, a) -> Bool
playerLives (GameState ((Player hp _ _, _), _)) = hp > 0

bossLives :: GameState (a, Boss) -> Bool
bossLives (GameState ((_, Boss hp _), _)) = hp > 0

initialState :: GameState (Player, Boss)
initialState = GameState ((Player 50 500 (Stats 0 0), Boss 51 (Stats 9 0)), M.empty)


-- For part 2 -> deal one damage to the player
inevitableDeath :: GameState (Player,a) -> GameState (Player, a)
inevitableDeath (GameState ((Player hp mana s@(Stats atkP armP), b), eff)) = GameState ((Player (hp - 1) mana s, b), eff)

-- Four stages:
-- 1) Effects #1    Check if any dead
-- 2) Player Turn
-- 3) Effects #2    Check if any dead
-- 4) Boss Turn
play :: (GameState (Player,Boss), Int, [String]) -> [(GameState (Player, Boss), Int, [String])]
play (gs,totalMana,history) = do
  guard $ bossLives gs
  let gs2 = performEffects (inevitableDeath gs)
  guard $ playerLives gs2
  (finalGs, newMana, hist) <- if not (bossLives gs2) then [(gs2, totalMana, history ++ ["NOTHING"])]
                              else (do
                                       (playerTurn, cost, name) <- playerPossibilities gs2
                                       let gs3 = performEffects playerTurn
                                       let gs4 = if bossLives gs3 then bossTurn gs3 else gs3
                                       guard $ playerLives gs4
                                       return (gs4, totalMana + cost, history ++ [name])
                                   )
  return (finalGs, newMana, hist)

fst_ :: (a,b,c) -> a
fst_ (a,_,_) = a

snd_ :: (a,b,c) -> b
snd_ (_,b,_) = b

plays = iterate (\p -> sortOn snd_ $ concatMap play p) $ play (initialState,0,[])
filtered = Data.List.map (Data.List.filter (\l -> not $ bossLives $ fst_ l)) $ plays
filtered2 = map (minimumBy (comparing snd_)) $ filter (not . null) filtered

main :: IO ()
main = do
  print $ head . head $ dropWhile null filtered
