module Classes where
import Course
import Group
import Classroom

type WeekDay = Int
type DayTime = Int

-- Zajecia, o jakims czasie, dla jakiejs grupy i w jakims miejscu. (..., dzien tygodnia(0..5), godzina startu(8..max-2))
-- Uznaje, ze kazde zajecia trwaja 2h (tak jak to jest na naszym wydziale)
data Classes = Classes GroupName Course Classroom WeekDay DayTime deriving Show