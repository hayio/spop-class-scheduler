module Schedule where
import Classes

-- Plan zajec (lista Zajec w planie)
-- cls jest skrotem od classes
data Schedule = ScheduleC [Classes] deriving Show

class Scheduler s where
    empty      :: s
    getClasses :: s -> [Classes]
    setClasses :: [Classes] -> s -> s
	
    addClasses :: Classes -> s -> s
    addClasses toAdd schedule   = setClasses cls' schedule where
        cls'                    = toAdd : cls
        cls                     = getClasses schedule

instance Scheduler Schedule where
    empty                               = ScheduleC []
    getClasses (ScheduleC cls)           = cls
    setClasses cls (ScheduleC oldCls)    = ScheduleC cls