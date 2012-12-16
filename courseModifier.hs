module CourseModifier where
import Model
import Course
import Methods
import Group

class CourseModifier c where
    getCourses      :: c -> [Course]
    setCourses      :: [Course] -> c -> c
    
    createCourse    :: Course -> c -> c
    changeCourse    :: Course -> Course -> c -> c

instance CourseModifier Model where
    getCourses (Model _ courses _ _)    = courses
    setCourses newVal (Model a _ b c)   = (Model a newVal b c)
    
    createCourse course (Model a courses b c) = (Model a (course : courses) b c)
    
    changeCourse toChange newVal (Model groups courses cr classes) = Model changedGroups changedCourses cr changedClasses where
        changedCourses = replace toChange newVal courses
        changedClasses = replaceClassesCourses toChange newVal classes
        changedGroups  = map (\ (Group name crs) -> (Group name (newVal : (filter (/= toChange) crs)))) groups