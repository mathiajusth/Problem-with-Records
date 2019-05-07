module ExamplePersonAndCat where

data Person = Person Name Age 

type Name = String
type Age  = Int

myself :: Person
myself = Person "Mathia" 27

ageOf :: Person -> Age
ageOf (Person _ age) = age

data PersonR = PersonR { name:: Name
                       , age :: Age
                       }

myselfR :: PersonR
myselfR = PersonR {name = "Mathia", age = 27}

myselfR2 :: PersonR
myselfR2 = PersonR "Mathia" 27

data CatR = CatR { tailLenght :: Int 
                 -- , name :: Name       -- ERROR: Multiple declarations of `name`
                 }
