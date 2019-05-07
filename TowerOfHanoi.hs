module ExampleTowerOfHanoi where


type Brick = Int
type Tower = [Brick]

data Towers = Towers { firstPole  :: Tower
                     , secondPole :: Tower
                     , thirdPole  :: Tower
                     }

data Pole = First | Second | Third

moveBrick :: Pole -> Pole -> Towers -> Towers
moveBrick fromPole toPole towers =
  let [fromTower, toTower] = map (extractTower towers) [fromPole,toPole]
      (brick:bricks) = fromTower
    in (replaceTower fromPole bricks . replaceTower toPole (brick:toTower)) towers

extractTower :: Towers -> Pole -> Tower
extractTower towers pole =
  case pole of
       First  -> firstPole towers
       Second -> secondPole towers
       Third  -> secondPole towers

replaceTower :: Pole -> Tower -> Towers -> Towers
replaceTower pole newTower towers =
  case pole of
       First  -> towers {firstPole  = newTower}
       Second -> towers {secondPole = newTower}
       Third  -> towers {thirdPole  = newTower}
