module Group where
import Course

type GroupName = String

-- Grupa studencka, (nazwa grupy, przedmioty grupy)
data Group = Group GroupName [Course] deriving Show

instance Eq Group where
    (Group name1 _) == (Group name2 _) | name1 == name2 = True
                                       | otherwise      = False