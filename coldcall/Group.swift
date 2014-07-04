import CoreData

@objc(Group)
class Group: NSManagedObject {
    
    @NSManaged var name:   String
    @NSManaged var id:     String

    
}
