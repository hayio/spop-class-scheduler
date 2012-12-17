module AutomateSchedule where

import Group
import Classes
import Model
import Course
import Classroom
import Methods

-- Automatyczne układanie planu

class AutomateSchedule s where
    cleanClasses      :: s -> s
    schedule          :: s -> s

instance AutomateSchedule Model where
    cleanClasses (Model a b c _) = Model a b c []
    schedule (Model groups courses rooms _) = Model groups courses rooms classes where
        classes = scheduleForAll groups rooms