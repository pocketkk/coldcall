import CoreData

@objc(Note)
class Note: NSManagedObject {
    
    @NSManaged var content:   String?
    @NSManaged var date: NSDate?
    @NSManaged var business: Business
    @NSManaged var coldcall: ColdCall
    @NSManaged var contact: Contact
    
    class func newObject() -> Note {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        let ent = NSEntityDescription.entityForName("Notes", inManagedObjectContext: context)
        var n = Note(entity: ent, insertIntoManagedObjectContext: context)
        n.date = NSDate()
        return n
    }
    
}