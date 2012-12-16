module Classroom where
-- Klasa, pomieszczenie (numer klasy)
data Classroom = Classroom Int deriving Show

instance Eq Classroom where
    (Classroom no1) == (Classroom no2) | no1 == no2 = True
                                       | otherwise      = False