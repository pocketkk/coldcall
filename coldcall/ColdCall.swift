import CoreData

@objc(ColdCall)
class ColdCall: NSManagedObject {
    
    @NSManaged var date:   NSDate
    @NSManaged var note: Note
    @NSManaged var business: Business
    @NSManaged var contact: Contact
    @NSManaged var user: User
    
    class func newObject() -> ColdCall {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        let ent = NSEntityDescription.entityForName("ColdCalls", inManagedObjectContext: context)
        return ColdCall(entity: ent, insertIntoManagedObjectContext: context)
    }
    
}