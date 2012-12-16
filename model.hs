module Model where
import Group
import Course
import Classroom
import Classes

data Model = Model [Group] [Course] [Classroom] [Classes] deriving Show 