import CoreData

@objc(Note)
class Note: NSManagedObject {
    
    @NSManaged var content:   String
    
}