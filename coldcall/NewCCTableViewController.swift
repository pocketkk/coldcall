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
    var tablePresenter: TableViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePresenter = TableViewPresenter(table: tableView, textFieldDelegate: self)
        tablePresenter.createCellCache()
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
    
    @IBAction func addContact(sender: AnyObject) {
        println("Clicked")
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let path : NSIndexPath = tableView.indexPathForRowAtPoint(buttonPosition)
        println(path)

    }
    
    @IBAction func loadProspect(sender: AnyObject) {

        tablePresenter.resetCellQuantitiesDict()
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        var request = NSFetchRequest(entityName: "Businesses")
        request.returnsObjectsAsFaults = false
        
        // (name contains [c] %@) the [c] makes it case insensative
        
        request.predicate = NSPredicate(format: "name contains [c] %@", tablePresenter.nameField!.text)
        var businesses:Array = context.executeFetchRequest(request, error: nil)
        
        // if businesses.count > 1 then do popup for choice otherwise show business
        
        if businesses.count >= 2 {
            var actionSheet =  UIAlertController(title: "Choose Business", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            for business in businesses {
                var b = business as Business
                actionSheet.addAction(UIAlertAction(title: b.name, style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                    self.tablePresenter.businessCurrent = b
                    println(b.name)
                self.tablePresenter.cellQuantitiesDict["1_existing_prospect_tools"] = 1
                    self.tablePresenter.displayBusiness()
                    }))
            }
            actionSheet.addAction(UIAlertAction(title: "New Prospect", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!)in
                self.tablePresenter.businessCurrent = Business.newObject()
            self.tablePresenter.cellQuantitiesDict["1_existing_prospect_tools"] = 1
                self.tablePresenter.resetCellQuantitiesDict()
                self.tablePresenter.newBusiness()
                }))
            

            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
        
        if businesses.count == 1 {
            tablePresenter.businessCurrent = (businesses[0] as Business)
        tablePresenter.cellQuantitiesDict["1_existing_prospect_tools"] = 1
            tablePresenter.displayBusiness()
        }
        
    }

    @IBAction func addNote(sender: AnyObject) {
        if tablePresenter.cellQuantitiesDict["7_new_note"] == 0
        {
            tablePresenter.cellQuantitiesDict["7_new_note"] = 1
            tablePresenter.displayBusiness()
        }
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
        return tablePresenter.totalCells()
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {

        return tablePresenter.heightsCache[indexPath.row]
        
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        return tablePresenter.cellCache[indexPath.row]
        
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
        println("did end editing")
        if textField.tag == 1 {

            let n = Note.newObject()
            n.content = textField.text
            tablePresenter.businessCurrent?.addNote(n)
            //save context
            context.save(nil)
            textField.text = ""
            tablePresenter.cellQuantitiesDict["7_new_note"] = 0
            tablePresenter.displayBusiness()
            
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
