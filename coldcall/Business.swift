import CoreData

@objc(Business)
class Business: NSManagedObject {
    
    @NSManaged var name:   String?
    @NSManaged var street: String?
    @NSManaged var city: String?
    @NSManaged var state: String?
    @NSManaged var phone: String?
    @NSManaged var url: String?
    @NSManaged var follow_up_date: NSDate?
    @NSManaged var interest: Int16
    @NSManaged var sale_closed: Bool
    @NSManaged var coldcalls: NSSet
    @NSManaged var contacts: NSSet
    @NSManaged var notes: NSSet
    
    class func newObject() -> Business {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        let ent = NSEntityDescription.entityForName("Businesses", inManagedObjectContext: context)
        return Business(entity: ent, insertIntoManagedObjectContext: context)
    }
    
    class func isUnique(business: Business) -> Bool {
        let context = (UIApplication.sharedApplication().delegate as AppDelegate).cdh.managedObjectContext
        var request = NSFetchRequest(entityName: "Businesses")
        let name = business.name
        let street = business.street

        request.predicate = NSPredicate(format: "name contains [c] %@ && street contains [c] %@", name!, street!)
        var businesses : [AnyObject] = context.executeFetchRequest(request, error: nil)
        return businesses.count == 0
 
    }
    
//    class func updateOriginalFromDuplicate(duplicate: Business) -> Business {
//        let context = (UIApplication.sharedApplication().delegate as AppDelegate).cdh.managedObjectContext
//        var request = NSFetchRequest(entityName: "Businesses")
//        let name = duplicate.name
//        let street = duplicate.street
//        var original : Business?
//        
//        request.predicate = NSPredicate(format: "name contains [c] %@ && street contains [c] %@", name!, street!)
//        var businesses : [AnyObject] = context.executeFetchRequest(request, error: nil)
//        if businesses.count == 1 {
//            original = businesses[0] as? Business
//            mergeBusinessesLeft(original!, right: duplicate)
//        }
//        context.deleteObject(duplicate)
//        context.save(nil)
//        return original!
//    }
//    
//    class func mergeBusinessesLeft(left: Business, right: Business) {
//        let context = (UIApplication.sharedApplication().delegate as AppDelegate).cdh.managedObjectContext
//
//        if left.city != right.city {
//            left.city = right.city
//        }
//        if left.state != right.state {
//            left.state = right.state
//        }
//        if left.phone != right.phone {
//            left.phone = right.phone
//        }
//        if left.url != right.url {
//            left.url = right.url
//        }
//    }
//    
//    class func fieldsEqual(left: String, right: String) -> Bool {
//        return left == right
//    }
    
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
    
    func addContact(cc: Contact) -> Bool{
        if !contacts.containsObject(cc) {
            contacts = contacts.setByAddingObject(cc)
            return true
        }
        return false
    }
    
    func removeContact(cc: Contact) -> Bool {
        var ccSet: NSMutableSet = self.contacts as NSMutableSet
        if ccSet.containsObject(cc) {
            ccSet.removeObject(cc)
            self.contacts = ccSet
            return true
        }
        return false
    }
    
    func addNote(cc: Note) -> Bool{
        if !notes.containsObject(cc) {
            notes = notes.setByAddingObject(cc)
            return true
        }
        return false
    }
    
    func removeNote(cc: Note) -> Bool {
        var ccSet: NSMutableSet = self.notes as NSMutableSet
        if ccSet.containsObject(cc) {
            ccSet.removeObject(cc)
            self.notes = ccSet
            return true
        }
        return false
    }
    
}