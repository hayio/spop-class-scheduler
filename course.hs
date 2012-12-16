module Course where
-- Przedmiot, (nazwa przedmiotu)
data Course = Course String deriving Show

instance Eq Course where
    (Course name1) == (Course name2) | name1 == name2 = True
                                     | otherwise      = False