# Problem with Records

## Recap on Records
We all love our custom data constructors

```hs
data Person = Person Name Age 

type Name = String
type Age  = Int
```

Of course accessing the Name and Age *fields* get tedious really fast

```hs
myself :: Person
myself = Person "Mathia" 27

ageOf :: Person -> Age
ageOf (Person _ age) = age

$> ageOf myself
$> 27
```

Behold, Records! And we get the accessor functions for free 

```hs
data PersonR = PersonR { name:: Name
                       , age :: Age
                       }

myselfR :: PersonR
myselfR = PersonR {name = "Mathia", age = 27}

$> age myselfR
$> 27
```

This is just a syntactic sugar over the data contructor `Person Name Age` with our automated accessors, though

```hs
myselfR2 :: PersonR
myselfR2 = PersonR "Mathia" 27

$> myselfR2 == myselfR
$> true
```

## Hassle ahead

But wait, what is the **name** inside of the PersonR's definition `data PersonR = PersonR {name :: Name, age :: Age}`?
Nothing but an instruction to desugar into definition of the accessor `name (Person name _) = name`.
First problem on the horizon

```hs
data PersonR = PersonR { name :: Name
                       , age  :: Age
                       }

data CatR = CatR { name :: Name       -- ERROR: Multiple declarations of `name`
                 , tailLenght :: Int 
                 }
```

<img src="https://idiomacy.files.wordpress.com/2015/07/facepalm.jpg" style="width:300px;box-shadow:none"/>

Of course, we can hack this by defining these Record types in separate modules and import then under different namespaces.
Some languages  solve this by having an atomic type (like String or Number) dedicated to labeling.
Image that we have a type `Label := <#>[a-z]* ` meaning that `#name`, `#age`, .. are all reserved  words like `0`, `1` ,`2`, .. or `"anyString"`
and belong to the god-given Label type. Hence we wouldn't define **name** twice and everything would be perfect!

```hs
data Person = Person { #name :: Name, .. }

data Cat = Cat { #name :: Name, .. }

person = Person {#name = "Mathia", ..}
cat = Cat {#name = "Alice", ..}

$> person #name
$> Mathia

$> cat #name
$> Alice
```

### Or would it?

<details>
  <summary>Spoiler alert</summary>

  > It wouldn't
</details>

<br/>

Now, let's see a more detailed example that demonstrates the root of the problem better!
We will formalize the [Tower of Hanoi](https://en.wikipedia.org/wiki/Tower_of_Hanoi) problem.

```hs
type Brick = Int
type Tower = [Brick]

data Towers = Towers { firstPole  :: Tower
                     , secondPole :: Tower
                     , thirdPole  :: Tower
                     }
```

Now we'd like to defina a function `moveBrick` that moves a brick from the one pole to another in the Towers data structure.
Let's address the pole positions by custom type `date Pole = First | Second | Third` instead of f.e. `Int` so we don't have partial function defined only on `0`, `1` and `2`.

```hs
```

```hs
data Pole = First | Second | Third

moveBrick :: Pole -> Pole -> Towers -> Towers
moveBrick fromPole toPole =
  let [fromTower, toTower] = map poleToAccessor [from,to]
      (topBrick:restBricks) = fromTower
    in (replaceTower from topBricks . replaceTower to (topBrick:toTower))

replaceTower :: Pole -> Tower -> Towers -> Towers
replaceTower pole newTower =
  case pole of
       First  -> Towers {firstPole  = newTower}
       Second -> Towers {secondPole = newTower}
       Third  -> Towers {thirdPole  = newTower}
```
*For educational purposes, we are not taking care of edge cases as fromTower having no bricks, ot the topBrick being bigger than the top brick on the top of toTower but that.*

Ah we had to define another function (`replaceTower`) that uses the forementioned correspondence

<img src="https://i1.sndcdn.com/artworks-000322933404-2qsvhm-t500x500.jpg" style="width:200px;box-shadow:none"/>

We are unable to use `poleToAccessor` for it returns the accessor function, not the field name.
Most of this hassle would indeed be solved by useing the `Label`s.

```hs

```

<!-- Now we'd like to defina a function `switchTowers` that switches a given tower with another one keeping their bircks. -->
<!-- Let's address the pole positions by custom type `date Pole = First | Second | Third` instead of `Int` or `Nat` -->
<!-- so we don't have partial function defined only on `0`, `1` and `2`. -->
<!-- For example `switchTowers First  Second (Towers first second third) = Towers second first third` -->
<!-- We could define the whole function `switchTowers` like that -->

<!-- ```hs -->
<!-- switchTowers :: Pole -> Pole -> Towers -> Towers -->
<!-- switchTowers First  Second (Towers first second third) = Towers second first third -->
<!-- switchTowers First  Third  (Towers first second third) = Towers third second first -->
<!-- ... -->
<!-- ``` -->

<!-- but we are obviously omissing the canocical relationship of Pole and Towers accessors -->

<!-- `First  ~ firstPole` -->

<!-- `Second ~ secondPole` -->

<!-- `Third  ~ thirdPole` -->

<!-- We can write poleToAccessor function then and rewrite the poleToAccessor function using this correspondece -->

<!-- ```hs -->
<!-- poleToAccessor :: Pole -> ? -->
<!-- poleToAccessor pole = -->
<!--   case pole of -->
<!--        First  -> firstPole -->
<!--        Second -> secondPole -->
<!--        Third  -> thirdPole -->

<!-- switchTowers :: Pole -> Pole -> Towers -> Towers -->
<!-- switchTowers pole1 pole2 towers =  -->
<!-- ``` -->

<!-- By extracting this relationship we alredy saved ourselves from 2^3 pattern matches in `switchTowers` and did only 3. -->
<!-- But why didn't I type the codomain of poleToAccessor? Because I've been lying to you. -->

<!-- Let's use [Either3](https://github.com/keera-studios/data-either3) (Either3 a b c = First a | Second b | Third c). -->
