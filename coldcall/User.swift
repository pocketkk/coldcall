import CoreData

@objc(User)
class User: NSManagedObject {
    
    @NSManaged var firstName:   String
    @NSManaged var lastName:    String
    @NSManaged var group:       Group
    @NSManaged var coldcalls:   NSSet
    
    class func newObject() -> User {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        let ent = NSEntityDescription.entityForName("Users", inManagedObjectContext: context)
        return User(entity: ent, insertIntoManagedObjectContext: context)
    }
    
    func addColdCalls(coldcallsArray: NSArray) -> Bool {
        coldcalls = coldcalls.setByAddingObjectsFromArray(coldcallsArray)
        return true
    }
    
    func addColdCall(cc: ColdCall) -> Bool{
        if !coldcalls.containsObject(cc) {
            coldcalls = coldcalls.setByAddingObject(cc)
            return true
        }
        return false
    }
    
    func removeColdCall(cc: ColdCall) -> Bool {
        var ccSet: NSMutableSet = self.coldcalls as NSMutableSet
        if ccSet.containsObject(cc) {
            ccSet.removeObject(cc)
            self.coldcalls = ccSet
            return true
        }
        return false
    }
    
}