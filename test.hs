module Test where
import Classes
import Course
import Group
import Classroom
import GroupModifier
import CourseModifier
import ClassroomModifier
import ClassesModifier
import Model
import AutomateSchedule
import Methods
import Config

-- Testy, przypadki uzycia


-- ponizej testy dla grupy
--course = Course "kurs 1"
--course2 = Course "kurs 2"

--g1 :: Group
--g1 = (Group "g1" [course, (Course "course1"), (Course "course2")])

--room = Classroom 5
 
--cl :: Classes
--cl = Classes "g1" course room 5 1

--model = (Model [g1] [] [] [cl])
--model2 = createGroup "created group" model
--g2 = changeGroupName "g1" "g2" model
--g3 = addCourseToGroup course2 "g2" g2
--g4 = removeCourseFromGroup course "g2" g3

-- ponizej testy dla kursu
--m1 = Model [] [] [] []
--m2 = createCourse (Course "kurs1") m1
--m3 = changeCourse (Course "kurs 1") (Course "kurs 1 zmieniony") g3

-- ponizej testy dla sal
--m22 = createClassroom (Classroom 4) m1
--g44 = createClassroom (Classroom 5) g3
--m33 = changeClassroom (Classroom 5) (Classroom 55) g44

-- ponizej testy dla zajec (grupa-przedmiot-sala
--modelCls1 = addClasses (Classes "g2" (Course "course1") (Classroom 5) 7 2) g44
--modelCls2 = removeClassesByTime 5 1 modelCls1

-- testy automatycznego ukladania planu

c1 = Course "rzucanie sniezkami w balwana"
c2 = Course "lepienie balwana"
c3 = Course "kurs haskella"

r1 = Classroom 1
r2 = Classroom 2

conf = Config 2 8 12

m1 = Model [] [] [] []

m2 = createGroup "grupa smierci" m1
m3 = createGroup "L.A. Lakers" m2

m4 = createCourse c1 m3
m5 = createCourse c2 m4
m6 = createCourse c3 m5

m7 = createClassroom r1 m6
m8 = createClassroom r2 m7

m9 = addCourseToGroup c1 "grupa smierci" m8
m10 = addCourseToGroup c2 "grupa smierci" m9
m11 = addCourseToGroup c3 "grupa smierci" m10
m12 = addCourseToGroup c1 "L.A. Lakers" m11

m13 = schedule m12 conf