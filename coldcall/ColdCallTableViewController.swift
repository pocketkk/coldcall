//
//  ColdCallTableViewController.swift
//  coldcall
//
//  Created by Jason Crump on 8/23/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit

class ColdCallTableViewController: UITableViewController, UITextFieldDelegate {

    var tablePresenter : ColdCallTablePresenter!
    @IBOutlet var revealButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePresenter = ColdCallTablePresenter(tableView: tableView, textFieldDelegate: self)
        tableView.allowsSelection = false
        setupMenuView()
        applyUIAttributesToNavigation()
        tablePresenter.prepareBusinessForDisplay()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMenuView() {
        self.revealButtonItem.target = self.revealViewController()
        self.revealButtonItem.action = "revealToggle:"
        self.navigationController?.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func applyUIAttributesToNavigation(){
        let red : CGFloat = 150/255
        let green : CGFloat = 212/255
        let blue : CGFloat = 86/255
        let navBarColor : UIColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        //        let shadow = NSShadow()
        //        shadow.shadowOffset = CGSizeMake(0.0, 1.0)
        //        shadow.shadowColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.darkGrayColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)
        ]
        let barTextDict: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.darkGrayColor(),
            //NSShadowAttributeName: shadow,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 17)
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(barTextDict, forState: UIControlState.Normal)
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        self.navigationController?.navigationBar.barTintColor = navBarColor
        self.navigationController?.navigationBar.translucent = true
    }

    

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tablePresenter.heightsCache[indexPath.row]
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tablePresenter.totalCells()

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tablePresenter.cellCache[indexPath.row]
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        println("should return")
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        //if new note field this should create a new note for business, add to business object and update notes
//        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
//        let context = appDel.cdh.managedObjectContext
//        println("did end editing")
//        if textField.tag == 1 {
//            let n = Note.newObject()
//            n.content = textField.text
//            userSession.currentBusiness?.addNote(n)
//            //save context
//            context.save(nil)
//            textField.text = ""
//            tablePresenter.cellQuantitiesDict["7_new_note"] = 0
//            tablePresenter.displayBusiness()
//        }
//        if textField.tag == 2 || textField.tag == 4 {
//            let psController = ProspectSearchController()
//            psController.delegate = self
//            psController.loadProspect(textField.text, controller: self)
//            textField.text = ""
//        }
//        println(textField.tag)
    }

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
