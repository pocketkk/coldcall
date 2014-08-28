//
//  NewCCTableViewController.swift
//  coldcall
//
//  Created by Jason Crump on 7/25/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class ProspectTableViewController: UITableViewController, UITextFieldDelegate, ProspectSearchControllerDelegate, LocationSearchControllerDelegate  {

    @IBOutlet var revealButtonItem: UIBarButtonItem!
    var tablePresenter: ProspectTableViewPresenter!
    var lsController : LocationSearchController!
    let userSession = UserSessionController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePresenter = ProspectTableViewPresenter(table: tableView, textFieldDelegate: self)
        applyUIAttributesToNavigation()
        setupMenuView()
        tableView.allowsSelection = false
        lsController = LocationSearchController(controller: self)
        lsController.delegate = self
        FacebookSessionController.sharedInstance.findOrGetSession(self)
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
        self.navigationController.navigationBar.titleTextAttributes = titleDict
        self.navigationController.navigationBar.barTintColor = navBarColor
        self.navigationController.navigationBar.translucent = true
    }
    
    func setupMenuView() {
        self.revealButtonItem.target = self.revealViewController()
        self.revealButtonItem.action = "revealToggle:"
        self.navigationController.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    @IBAction func addContact(sender: AnyObject) {
        tablePresenter.addContact()
    }
    @IBAction func saveBusiness(sender: AnyObject) {
        tablePresenter.saveBusiness()
    }
    
    @IBAction func saveContact(sender: AnyObject) {
        tablePresenter.saveContact()
    }
    @IBAction func updateBusiness(sender: AnyObject) {
        tablePresenter.saveBusiness()
    }
    
    @IBAction func updateLocation() {
        lsController.start()
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
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        println("whhy is this nil? \(tablePresenter)")
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
            userSession.currentBusiness?.addNote(n)
            //save context
            context.save(nil)
            textField.text = ""
            tablePresenter.cellQuantitiesDict["7_new_note"] = 0
            tablePresenter.displayBusiness()
        }
        if textField.tag == 2 || textField.tag == 4 {
            let psController = ProspectSearchController()
            psController.delegate = self
            psController.loadProspect(textField.text, controller: self)
            textField.text = ""
        }
        println(textField.tag)
    }
    
    /* ProspectSearchControllerDelegate protocol functions */
    
    func didFindBusinessFromSearch(business: Business) {
        reloadTableWithBusiness(business: business)
    }
    
    func didNotFindBusinessFromSearch() {
        reloadTableWithBusiness(newBusiness: true)
        Flash().message("NO PROSPECTS FOUND MATCHING SEARCH.", view: tableView)
    }
    
    func didChooseNewBusinessFromSearch(){
        reloadTableWithBusiness(newBusiness: true)
    }
    
    /* LocationSearchControllerDelegate protocol functions */
    
    func didFindBusinessFromLocationSearch(business: Business) {
        reloadTableWithBusiness(business: business)
    }
    
    func didNotFindBusinessFromLocationSearch() {
        reloadTableWithBusiness(newBusiness: true)
        Flash().message("NO PROSPECT FOUND MATCHING SEARCH.", view: tableView)
    }
    
    /* Location and Prospect Search display helper function */
    
    func reloadTableWithBusiness(business: Business = Business.newObject(), newBusiness: Bool = false) {
        tablePresenter.resetCellQuantitiesDict()
        userSession.currentBusiness = business
        if newBusiness { tablePresenter.newBusiness() }
        tablePresenter.displayBusiness()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        //tablePresenter.prepareBusinessForSegue()
        
    }


    
   
}
