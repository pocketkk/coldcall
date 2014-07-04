import CoreData

@objc(Contact)
class Contact: NSManagedObject {
    
    @NSManaged var firstName:   String
    @NSManaged var lastName:    String
    @NSManaged var email:       String
    @NSManaged var phone:       String
    
}