import CoreData

@objc(Group)
class Group: NSManagedObject {
    
    @NSManaged var name:   String
    @NSManaged var id:     String
    @NSManaged var users:  NSSet

    class func newObject() -> Group {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        let ent = NSEntityDescription.entityForName("Groups", inManagedObjectContext: context)
        return Group(entity: ent, insertIntoManagedObjectContext: context)
    }
    
    func addUsers(usersArray: NSArray) -> Bool {
        users = users.setByAddingObjectsFromArray(usersArray)
        return true
    }

    func addUser(user: User) -> Bool{
        if !users.containsObject(user) {
            users = users.setByAddingObject(user)
            return true
        }
        return false
    }
    
    func removeUser(user: User) -> Bool {
        var usersSet: NSMutableSet = self.users as NSMutableSet
        if usersSet.containsObject(user) {
            usersSet.removeObject(user)
            self.users = usersSet
            return true
        }
        return false
    }
}
