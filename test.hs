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

-- Testy, przypadki uzycia


-- ponizej testy dla grupy
course = Course "kurs 1"
course2 = Course "kurs 2"

g1 :: Group
g1 = (Group "g1" [course, (Course "course1"), (Course "course2")])

room = Classroom 5
 
cl :: Classes
cl = Classes "g1" course room 5 1

model = (Model [g1] [] [] [cl])
model2 = createGroup "created group" model
g2 = changeGroupName "g1" "g2" model
g3 = addCourseToGroup course2 "g2" g2
g4 = removeCourseFromGroup course "g2" g3

-- ponizej testy dla kursu
m1 = Model [] [] [] []
m2 = createCourse (Course "kurs1") m1
m3 = changeCourse (Course "kurs 1") (Course "kurs 1 zmieniony") g3

-- ponizej testy dla sal
m22 = createClassroom (Classroom 4) m1
g44 = createClassroom (Classroom 5) g3
m33 = changeClassroom (Classroom 5) (Classroom 55) g44

-- ponizej testy dla zajec (grupa-przedmiot-sala
modelCls1 = addClasses (Classes "g2" (Course "course1") (Classroom 5) 7 2) g44
modelCls2 = removeClassesByTime 5 1 modelCls1