import CoreData

@objc(Contact)
class Contact: NSManagedObject {
    
    @NSManaged var firstName:   String
    @NSManaged var lastName:    String
    @NSManaged var email:       String
    @NSManaged var phone:       String
    @NSManaged var business:    Business
    @NSManaged var notes:       NSSet
    
    class func newObject() -> Contact {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        let ent = NSEntityDescription.entityForName("Contacts", inManagedObjectContext: context)
        return Contact(entity: ent, insertIntoManagedObjectContext: context)
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