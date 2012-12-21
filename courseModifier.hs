module CourseModifier where
import Model
import Course
import Methods
import Group
import Classes

-- Klasa odpowiadajaca za zmienianie stanu modelu poprzez dodawanie/edycje/usuwanie modelu
class CourseModifier c where
    getCourses      :: c -> [Course]
    setCourses      :: [Course] -> c -> c
    
    createCourse    :: Course -> c -> c
    changeCourse    :: Course -> Course -> c -> c
    deleteCourse    :: Course -> c -> c

instance CourseModifier Model where
    getCourses (Model _ courses _ _)    = courses
    setCourses newVal (Model a _ b c)   = (Model a newVal b c)
    
    createCourse course (Model a courses b c) = (Model a (course : courses) b c)
    
    changeCourse toChange newVal (Model groups courses cr classes) = Model changedGroups changedCourses cr changedClasses where
        changedCourses = replace toChange newVal courses
        changedClasses = replaceClassesCourses toChange newVal classes
        changedGroups  = map (\ (Group name crs) -> (Group name (map (\ course -> if course == toChange then newVal else course) crs))) groups
        
    deleteCourse toDelete (Model groups courses cr classes) = Model changedGroups changedCourses cr changedClasses where
        changedCourses = filter (/= toDelete) courses
        changedClasses = filter (\ (Classes _ course _ _ _) -> course /= toDelete) classes
        changedGroups  = map (\ (Group name crs) -> (Group name (filter (/= toDelete) crs)) ) groups