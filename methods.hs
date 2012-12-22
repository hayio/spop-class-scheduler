module Methods where
import Classes
import Group
import Course
import Classroom
import Config

isNotEmpty :: [a] -> Bool
isNotEmpty [] = False
isNotEmpty _  = True

replace y z [] = []
replace y z (x:xs)
  | x==y           = z:replace y z xs
  | otherwise      = x:replace y z xs
  
sumCourses :: Course -> Int -> [Course]
sumCourses course 1 = [course]
sumCourses course q = course : (sumCourses course (q - 1))
  
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
    
removeClasses :: WeekDay -> DayTime -> [Classes] -> [Classes]
removeClasses removeDay removeHour [] = []
removeClasses removeDay removeHour ((Classes a b c day hour) : xs)
  | hour /= removeDay || hour /= removeHour = (Classes a b c day hour) : removeClasses removeDay removeHour xs
  | otherwise                              = removeClasses removeDay removeHour xs

-- metody dla automatycznego schedulera  
scheduleForAll :: [Group] -> [Classroom] -> [Classes] -> Config -> [Classes]
scheduleForAll [] _ classes _ = classes
scheduleForAll ((Group name groupCourses) : xs) rooms classes config = (scheduleForAll xs rooms (scheduleForGroup name groupCourses rooms config classes) config) 
    
scheduleForGroup :: GroupName -> [Course] -> [Classroom] -> Config -> [Classes] -> [Classes]
scheduleForGroup name [] _ _ classes = classes
scheduleForGroup name (course : cs) rooms config classes = (scheduleForGroup name cs rooms config ((Classes name course room day hour) : classes)) where
            (room, day, hour) = getNextTimeForGroupAndCourse name course rooms classes config

-- Daj liste wolnych pokoi o danej porze 
getRoomAvail :: [Classroom] -> [Classes] -> WeekDay -> DayTime -> [Classroom]
getRoomAvail rooms [] _ _ = rooms
getRoomAvail (room : rooms) classes day hour | isRoomAvail room classes day hour = room : (getRoomAvail rooms classes day hour)
                                             | otherwise                         = getRoomAvail rooms classes day hour

-- Czy pokoj jest dostepny o danej porze
isRoomAvail :: Classroom -> [Classes] -> WeekDay -> DayTime -> Bool
isRoomAvail _ [] _  _ = True
isRoomAvail (Classroom no1) ((Classes group course (Classroom no2) day hour) : xs) dayTime hourTime | no1 == no2 && dayTime == day && hourTime == hour = False
                                                                                                    | otherwise                                        = isRoomAvail (Classroom no1) xs dayTime hourTime
            
-- Czy grupa moze miec jeszcze zajecia w dany dzien (czy nie przekroczyla swojego limitu zajec)
isGroupReachedMaxDayTime :: GroupName -> Int -> WeekDay -> [Classes] -> Bool
isGroupReachedMaxDayTime name timeToSpare day ((Classes groupName _ _ d _) : xs) | name == groupName && day == d && timeToSpare <= 1 = True
                                                                                 | name == groupName && day == d                     = isGroupReachedMaxDayTime name (timeToSpare - 1) day xs
                                                                                 | otherwise                                         = isGroupReachedMaxDayTime name timeToSpare day xs
isGroupReachedMaxDayTime _ _ _ [] = False

-- Daj natepny mozliwy czas ruszenia danego przedmiotu dla danej grupy
getNextTimeForGroupAndCourse :: GroupName -> Course -> [Classroom] -> [Classes] -> Config -> (Classroom, WeekDay, DayTime)
getNextTimeForGroupAndCourse group course rooms classes (Config max start end) = getNextTmp group course rooms classes (Config max start end) 0 start 

-- Daj natepny mozliwy czas ruszenia danego przedmiotu dla danej grupy, poczynajac od danego czasu
getNextTmp :: GroupName -> Course -> [Classroom] -> [Classes] -> Config -> WeekDay -> DayTime -> (Classroom, WeekDay, DayTime)
getNextTmp _ _ _ _ _ 5 _ = error "Plan nie zostal calkowicie ulozony."
getNextTmp group course rooms classes (Config max start end) day hour | (isGroupReachedMaxDayTime group max day classes) || hour == end = getNextTmp group course rooms classes (Config max start end) (day + 1) start
                                                                | canRunGroupAndCourseOnTime group course classes day hour
                                                                    && (isNotEmpty availRooms)                                         = ((head availRooms), day, hour)
                                                                | otherwise                                                         = getNextTmp group course rooms classes (Config max start end) day (hour + 1) where
                                                                        availRooms = getRoomAvail rooms classes day hour   

-- Czy dana grupa moze miec kurs o danej porze
canRunGroupAndCourseOnTime :: GroupName -> Course -> [Classes] -> WeekDay -> DayTime -> Bool
canRunGroupAndCourseOnTime _ _ [] _ _ = True
canRunGroupAndCourseOnTime group course ((Classes someGroup someCourse _ someWeek someDay) : xs) day  hour | day  == someWeek && hour == someDay && (group == someGroup || course == someCourse) = False
                                                                                                           | otherwise                                                                           = canRunGroupAndCourseOnTime group course xs day hour