module GroupModifier where
import Model
import Group
import Methods
import Course
import Classes

class GroupModifier g where
    getGroups               :: g -> [Group]
    getGroupCourses         :: String -> g -> [Course]
    getGroupNames           :: g -> [GroupName]
    setGroups               :: [Group] -> g -> g
    
    createGroup             :: GroupName -> g -> g
    changeGroupName         :: GroupName -> GroupName -> g -> g
    addCourseToGroup        :: Course -> GroupName -> g -> g
    removeCourseFromGroup   :: Course -> GroupName -> g -> g

instance GroupModifier Model where
    getGroups (Model groups _ _ _)                  = groups
    getGroupCourses groupName (Model groups _ _ _)  = findGroupCourses (Group groupName []) groups
    getGroupNames (Model groups _ _ _)              = getGroupNamesFromGroups groups
    setGroups newVal (Model _ a b c)                = (Model newVal a b c)
    
    createGroup name (Model groups a b c) = (Model ((Group name []) : groups) a b c)
    
    changeGroupName toChange newVal (Model groups co cr classes) = (Model changed co cr newClasses) where
        changed                 = replace (Group toChange []) (Group newVal courses) groups
        (Group _ courses)       = head (filter (\ (Group name1 _) -> name1 == toChange) groups)
        newClasses              = replaceClassesGroupName toChange newVal classes
        
    addCourseToGroup course groupName (Model groups courses rooms classes) = Model newGroups courses rooms classes where
        newGroups   = replace (Group groupName []) (Group groupName newCourses) groups
        newCourses  = course : (findGroupCourses (Group groupName []) groups)
        
    removeCourseFromGroup course groupName (Model groups courses rooms classes) = Model groupsChanged courses rooms classesChanged where
        groupsChanged = replace (Group groupName []) (Group groupName groupCourses) groups
        groupCourses  = filter (/= course) (findGroupCourses (Group groupName []) groups)
        classesChanged = filter (\ (Classes name c _ _ _) -> name /= groupName || c /= course ) classes