module Methods where
import Classes
import Group
import Course
import Classroom

replace y z [] = []
replace y z (x:xs)
  | x==y           = z:replace y z xs
  | otherwise      = x:replace y z xs
  
  
replaceClassesGroupName :: GroupName -> GroupName -> [Classes] -> [Classes]
replaceClassesGroupName y z [] = []
replaceClassesGroupName nameFrom nameTo ((Classes groupName a b c d) : xs)
    | groupName == nameFrom  = (Classes nameTo a b c d) : replaceClassesGroupName nameFrom nameTo xs
    | otherwise           = (Classes groupName a b c d) : replaceClassesGroupName nameFrom nameTo xs
        
findGroupCourses :: Group -> [Group] -> [Course]
findGroupCourses group [] = []
findGroupCourses group ((Group n courses) : xs) | group == (Group n courses)    = courses
                                                | otherwise                     = findGroupCourses group xs
                                                
getGroupNamesFromGroups :: [Group] -> [GroupName]
getGroupNamesFromGroups [] = []
getGroupNamesFromGroups ((Group name _) : xs) = name : (getGroupNamesFromGroups xs)

replaceClassesCourses :: Course -> Course -> [Classes] -> [Classes]
replaceClassesCourses y z [] = []
replaceClassesCourses from to ((Classes a course b c d) : xs)
    | course == from  = (Classes a to b c d) : replaceClassesCourses from to xs
    | otherwise       = (Classes a course b c d) : replaceClassesCourses from to xs
    
replaceClassesRooms :: Classroom -> Classroom -> [Classes] -> [Classes]
replaceClassesRooms y z [] = []
replaceClassesRooms from to ((Classes a b room c d) : xs)
    | room == from   = (Classes a b to c d) : replaceClassesRooms from to xs
    | otherwise      = (Classes a b to c d) : replaceClassesRooms from to xs
    
removeClasses :: WeekDay -> HourTime -> [Classes] -> [Classes]
removeClasses removeDay removeHour [] = []
removeClasses removeDay removeHour ((Classes a b c day hour) : xs)
  | day /= removeDay || hour /= removeHour = (Classes a b c day hour) : removeClasses removeDay removeHour xs
  | otherwise                              = removeClasses removeDay removeHour xs

-- metody dla automatycznego schedulera  
scheduleForAll :: [Group] -> [Classroom] -> [Classes]
scheduleForAll [] _ = []
scheduleForAll ((Group name groupCourses) : xs) rooms = (scheduleForGroup name groupCourses rooms) ++ (scheduleForAll xs rooms) 
    
scheduleForGroup :: GroupName -> [Course] -> [Classroom] -> [Classes]
scheduleForGroup name [] _ = []
scheduleForGroup name (course : cs) (room : rs) = (Classes name course room 5 6) : (scheduleForGroup name cs (room : rs))