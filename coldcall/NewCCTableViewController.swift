//
//  NewCCTableViewController.swift
//  coldcall
//
//  Created by Jason Crump on 7/25/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData

class NewCCTableViewController: UITableViewController, LoginViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet var revealButtonItem: UIBarButtonItem!
    
    var contactsCount = 0
    var notesCount = 0
    
    var businessCurrent : Business?
    var contacts = [Contact]()
    var notes = [Note]()
    
    var coldcall : ColdCall?

    var nameField : UITextField?
    var addressField : UITextField?
    var cityField : UITextField?
    var stateField : UITextField?
    var phoneField : UITextField?
    
    var noteField : UITextField?
    
    var firstNameField : UITextField?
    var lastNameField : UITextField?
    var emailField : UITextField?
    var contactPhoneField : UITextField?
    var titleField : UITextField?

    let cellTypesOrder : [String] = ["1_prospect_header", "2_new_prospect", "3_contacts_header", "4_new_contact", "5_contact", "6_notes_header", "7_new_note", "8_note"]
    let cellHeightsArr : [CGFloat] = [35.0, 200.0, 25.0, 200.0, 25.0, 25.0, 37.0, 25.0]
    var cellQuantitiesDict : [String: Int] = ["1_prospect_header": 1, "2_new_prospect": 1, "3_contacts_header": 1, "4_new_contact": 0, "5_contact": 0, "6_notes_header": 1, "7_new_note": 0, "8_note": 0]

    func resetCellQuantitiesDict() {
        cellQuantitiesDict = ["1_prospect_header": 1, "2_new_prospect": 1, "3_contacts_header": 1, "4_new_contact": 0, "5_contact": 0, "6_notes_header": 1, "7_new_note": 0, "8_note": 0]
    }
    
    func cellHeightsDic() -> [String: CGFloat] {
        var dict = [String: CGFloat]()
        var count = 0
        for cell in cellTypesOrder {
            dict[cell] = cellHeightsArr[count]
            ++count
        }
        return dict
    }
    
    func cellTypesArray() -> [String] {
        var arr : [String] = []
        for (cellName, cellQty) in cellQuantitiesDict {
            cellQty.times{arr.append(cellName)}
        }
        arr.sort {$0 < $1}
        return arr
    }
    
    func cellHeightsArray() -> [CGFloat] {
        let cells = cellTypesArray()
        let heights = cellHeightsDic()
        var arr = [CGFloat]()
        for cell in cells {
            let h = heights[cell]
            arr.append(h!)
        }
        return arr
        
    }
    
    func totalCells() -> Int {
        // could use cellTypesArray().count instead
        return ([Int](cellQuantitiesDict.values)).reduce(0,+)
    }
    
    @IBAction func addContact(sender: AnyObject) {
        println("Clicked")
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let path : NSIndexPath = tableView.indexPathForRowAtPoint(buttonPosition)
        println(path)

    }
    
    @IBAction func buttonUpdate(sender: AnyObject) {
        
    }
    
    @IBAction func loadProspect(sender: AnyObject) {
        println("Load")
        resetCellQuantitiesDict()
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        var request = NSFetchRequest(entityName: "Businesses")
        request.returnsObjectsAsFaults = false
        
        // (name contains [c] %@) the [c] makes it case insensative
        
        request.predicate = NSPredicate(format: "name contains [c] %@", nameField!.text)
        var businesses:Array = context.executeFetchRequest(request, error: nil)
        
        // if businesses.count > 1 then do popup for choice otherwise show business
        
        if businesses.count >= 2 {
            var actionSheet =  UIAlertController(title: "Choose Business", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            for business in businesses {
                var b = business as Business
                actionSheet.addAction(UIAlertAction(title: b.name, style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                    self.businessCurrent = b
                    println(b.name)
                    self.displayBusiness()
                    }))
            }
            actionSheet.addAction(UIAlertAction(title: "New Prospect", style: UIAlertActionStyle.Cancel, handler: nil))
                

            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
        
        if businesses.count == 1 {
            businessCurrent = (businesses[0] as Business)
            displayBusiness()
        }
        
    }
    
    func displayBusiness(){
        var b = businessCurrent as Business
        contacts = []
        notes = []
        
        nameField!.text = b.name
        addressField!.text = b.street
        cityField!.text = b.city
        stateField!.text = b.state
        phoneField!.text = b.phone
        
        cellQuantitiesDict["5_contact"] = b.contacts.count
        cellQuantitiesDict["8_note"] = b.notes.count
        println("You have called on this account \(b.coldcalls.count) times.")
        var c = b.coldcalls
        for call in c {
            var l = call as ColdCall
            println("There are \(l.note.content) notes for this prospect")
        }
        
        for contact in b.contacts {
            var c = contact as Contact
            contacts.append(c)
        }
        for note in b.notes {
            var n = note as Note
            notes.append(n)
        }
        notes.sort({$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow})
        tableView.reloadData()
    }
    
    @IBAction func addNote(sender: AnyObject) {
        if cellQuantitiesDict["7_new_note"] == 0 {
            cellQuantitiesDict["7_new_note"] = 1
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let red : CGFloat = 150/255
        let green : CGFloat = 212/255
        let blue : CGFloat = 86/255
        let navBarColor : UIColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        self.navigationController.navigationBar.titleTextAttributes = titleDict
        self.navigationController.navigationBar.barTintColor = navBarColor
        
        self.revealButtonItem.target = self.revealViewController()
        self.revealButtonItem.action = "revealToggle:"
        self.navigationController.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.allowsSelection = false
        // Do any additional setup after loading the view.
        //displayFacebookLogin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return totalCells()
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
            let height = cellHeightsArray()
            return height[indexPath.row]
        }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {

        let arr = cellTypesArray()
        println(arr)
        var cellIdentifier = arr[indexPath.row]

        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        
        if cellIdentifier == "1_prospect_header" {
            //This is only called once per layout session and it is safe to reset counts here
            contactsCount = 0
            notesCount = 0
        }
        
        if cellIdentifier == "2_new_prospect" {
            self.nameField = (cell as NewProspectCell).nameField
            self.addressField = (cell as NewProspectCell).addressField
            self.cityField = (cell as NewProspectCell).cityField
            self.stateField = (cell as NewProspectCell).stateField
            self.phoneField = (cell as NewProspectCell).phoneField
            (cell as NewProspectCell).nameField.delegate = self
            (cell as NewProspectCell).addressField.delegate = self
            (cell as NewProspectCell).cityField.delegate = self
            (cell as NewProspectCell).stateField.delegate = self
            (cell as NewProspectCell).phoneField.delegate = self
        }

        if cellIdentifier == "4_new_contact" {
            self.firstNameField = (cell as NewContactCell).firstNameField
            self.lastNameField = (cell as NewContactCell).lastNameField
            self.emailField = (cell as NewContactCell).emailField
            self.contactPhoneField = (cell as NewContactCell).phoneField
            self.titleField = (cell as NewContactCell).titleField
            (cell as NewContactCell).firstNameField.delegate = self
            (cell as NewContactCell).lastNameField.delegate = self
            (cell as NewContactCell).emailField.delegate = self
            (cell as NewContactCell).phoneField.delegate = self
            (cell as NewContactCell).titleField.delegate = self
        }
        
        if cellIdentifier == "5_contact" {
            
            var c = contacts[contactsCount]
            (cell as ContactCell).nameLabel.text = c.firstName
            ++contactsCount
            
        }
        
        if cellIdentifier == "7_new_note" {
            self.noteField = (cell as NewNoteCell).noteField
            (cell as NewNoteCell).noteField.delegate = self
            (cell as NewNoteCell).noteField.tag = 1
        }
        
        if cellIdentifier == "8_note" {
            let n = notes[notesCount]
            (cell as NoteCell).noteLabel.text = n.content
            (cell as NoteCell).dateLabel.text = Date.toString(n.date)
            ++notesCount
        }
        
        return cell
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        println("should return")
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        //if new note field this should create a new note for business, add to business object and update notes
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        
        if textField.tag == 1 {

            let n = Note.newObject()
            n.content = textField.text
            if businessCurrent == nil {
                businessCurrent = Business.newObject()
            }
            businessCurrent?.addNote(n)
            //save context
            context.save(nil)
            textField.text = ""
            cellQuantitiesDict["7_new_note"] = 0
            displayBusiness()
            
        }
        println(textField.tag)


    }
    
    func closeFacebookLogin(){
        println("Close Window")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        for view in self.view.subviews {
            if view is UITextField && view.isFirstResponder() {
                view.resignFirstResponder()
            }
        }
        println("touches began")
        self.view.endEditing(true)
    }
    
    func displayFacebookLogin(){
        let storyboard : UIStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil);
        let vc : LoginViewController = storyboard.instantiateViewControllerWithIdentifier("login_view") as LoginViewController
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil);
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
