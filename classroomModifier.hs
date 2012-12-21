module ClassroomModifier where
import Model
import Classroom
import Classes
import Methods

class ClassroomModifier cr where
    getClassrooms  :: cr -> [Classroom]
    setClassrooms  :: [Classroom] -> cr -> cr
    
    createClassroom :: Classroom -> cr -> cr
    changeClassroom :: Classroom -> Classroom -> cr -> cr
    deleteClassroom :: Classroom -> cr -> cr

instance ClassroomModifier Model where
    getClassrooms (Model _ _ classrooms _)     = classrooms
    setClassrooms newVal (Model a b _ c)   = (Model a b newVal c)

    createClassroom room (Model a b rooms c) = (Model a b (room : rooms) c)
    
    changeClassroom toChange newVal (Model gr co rooms classes) = Model gr co changedRooms changedClasses where
        changedRooms = replace toChange newVal rooms
        changedClasses = replaceClassesRooms toChange newVal classes
        
    deleteClassroom toDelete (Model gr co rooms classes) = Model gr co changedRooms changedClasses where
        changedRooms = filter (/= toDelete) rooms
        changedClasses = filter (\ (Classes _ _ room _ _) -> room /= toDelete) classes