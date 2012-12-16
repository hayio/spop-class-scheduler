type ID = Int
type Attrib = (String, String)
data Object = Obj ID [Attrib] deriving Show
object :: ID -> [Attrib] -> Object
object i as = Obj i as
getID :: Object -> ID
getID (Obj i as) = i
getAtts :: Object -> [Attrib]
getAtts (Obj i as) = as
getName :: Object -> String
getName o =
    snd (head (filter ((== "name").fst) (getAtts o)))

class Databases d where
    empty :: d
    getLastID :: d -> ID
    getObjects :: d -> [Object]
    setLastID :: ID -> d -> d
    setObjects :: [Object] -> d -> d
    insert :: [Attrib] -> d -> d
    insert as db = setLastID i' db' where
        db' = setObjects os' db
        os' = o : os
        os = getObjects db
        o = object i' as
        i' = 1 + getLastID db
    select :: ID -> d -> Object
    select i db =
        head (filter ((== i).getID) (getObjects db))
    selectBy :: (Object -> Bool) -> d -> [Object]
    selectBy f db = filter f (getObjects db)

data DBS = DB ID [Object] deriving Show

instance Databases DBS where
    empty = DB 0 []
    getLastID (DB i os) = i
    setLastID i (DB j os) = DB i os
    getObjects (DB i os) = os
    setObjects os (DB i ps) = DB i os
    
d0, d1, d2 :: DBS
d0 = empty
d1 = insert [("name", "john"),("age", "30")] d0
d2 = insert [("name", "mary"),("age", "20")] d1