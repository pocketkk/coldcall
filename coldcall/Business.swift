import CoreData

@objc(Business)
class Business: NSManagedObject {
    
    @NSManaged var name:   String
    @NSManaged var street: String
    @NSManaged var city: String
    @NSManaged var state: String
    @NSManaged var phone: String
    @NSManaged var coldcalls: NSSet
    @NSManaged var contacts: NSSet
    @NSManaged var notes: NSSet
    
    class func newObject() -> Business {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        let ent = NSEntityDescription.entityForName("Businesses", inManagedObjectContext: context)
        return Business(entity: ent, insertIntoManagedObjectContext: context)
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