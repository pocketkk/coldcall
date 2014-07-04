import CoreData

@objc(Business)
class Business: NSManagedObject {
    
    @NSManaged var name:   String
    @NSManaged var street: String
    @NSManaged var city: String
    @NSManaged var state: String
    @NSManaged var phone: String
    
}