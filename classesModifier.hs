module ClassesModifier where
import Model
import Classes
import Methods

-- Plan zajec (lista Zajec w planie)

class ClassesModifier cls where
    getClasses :: cls -> [Classes]
    setClasses :: [Classes] -> cls -> cls
    
    addClasses :: Classes -> cls -> cls
    removeClassesByTime :: WeekDay -> DayTime -> cls -> cls

instance ClassesModifier Model where
    getClasses (Model _ _ _ cls)         = cls
    setClasses newVal (Model a b c _)    = (Model a b c newVal)
    
    addClasses toAdd (Model a b c classes) = Model a b c (toAdd : classes)
    removeClassesByTime day hour (Model a b c classes) = Model a b c changedClasses where
        changedClasses = removeClasses day hour classes