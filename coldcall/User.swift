import CoreData

@objc(User)
class User: NSManagedObject {
    
    @NSManaged var firstName:   String
    @NSManaged var lastName:    String
    
}