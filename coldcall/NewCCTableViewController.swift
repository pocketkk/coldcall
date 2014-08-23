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

class NewCCTableViewController: UITableViewController, UITextFieldDelegate, CLLocationManagerDelegate  {

    @IBOutlet var revealButtonItem: UIBarButtonItem!
    var tablePresenter: TableViewPresenter!
    var placemark: CLPlacemark?
    var placemarks = [MKMapItem]()
    var locationManager: CLLocationManager = CLLocationManager()
    var locationReceived: Bool?
    var currentLocation: CLLocation?
    var tempLocation: CLLocation?
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePresenter = TableViewPresenter(table: tableView, textFieldDelegate: self)
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
        
        CLLocationManager.locationServicesEnabled()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        println("Started Location Services")
        println(locationManager)
        
        FacebookSessionController.sharedInstance.findOrGetSession(self)
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
    
    func searchForProspect(name: String, address: String) -> [AnyObject] {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        var request = NSFetchRequest(entityName: "Businesses")
        request.returnsObjectsAsFaults = false
        // (name contains [c] %@) the [c] makes it case insensative
        request.predicate = NSPredicate(format: "name contains [c] %@ && street contains [c] %@", name, address)
        var businesses : [AnyObject] = context.executeFetchRequest(request, error: nil)
        return businesses
    }
    
    func loadProspect(searchTerm: String) {
        tablePresenter.resetCellQuantitiesDict()
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        var request = NSFetchRequest(entityName: "Businesses")
        request.returnsObjectsAsFaults = false
        // (name contains [c] %@) the [c] makes it case insensative
        request.predicate = NSPredicate(format: "name contains [c] %@", searchTerm)
        var businesses:Array = context.executeFetchRequest(request, error: nil)
        // if businesses.count > 1 then do popup for choice otherwise show business
        if businesses.count >= 2 {
            var actionSheet =  UIAlertController(title: "Choose Business", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            for business in businesses {
                var b = business as Business
                actionSheet.addAction(UIAlertAction(title: b.name, style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                    self.tablePresenter.businessCurrent = b
                    println(b.name)
                    self.tablePresenter.displayBusiness()
                    }))
            }
            actionSheet.addAction(UIAlertAction(title: "New Prospect", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!)in
                self.tablePresenter.businessCurrent = Business.newObject()
                self.tablePresenter.resetCellQuantitiesDict()
                self.tablePresenter.newBusiness()
                }))
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
        if businesses.count == 1 {
            tablePresenter.businessCurrent = (businesses[0] as Business)
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
        if textField.tag == 2 || textField.tag == 4 {
            loadProspect(textField.text)
            textField.text = ""
        }
        println(textField.tag)
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
    
       @IBAction func updateLocation() {
        println("Started to look...")
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        currentLocation = locations[0] as? CLLocation
        locationManager.stopUpdatingLocation()
        localSearch()

    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationReceived = false
        println(error)
        println("Error retrieving Location")
    }
    
    func displayLocationSearchResults() {
        var actionSheet =  UIAlertController(title: "Choose Business from Location", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        if placemarks.count >= 1 {
            for pm in placemarks {
                let p = pm as MKMapItem
                actionSheet.addAction(UIAlertAction(title: p.name, style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                    println("You chose: \(p.name)")
                    var placeMark = p.placemark as CLPlacemark
                    let b : [AnyObject] = self.searchForProspect(p.name, address: placeMark.subThoroughfare)
                    if b.count == 0 {
                        self.tablePresenter.businessCurrent = Business.newObject() as Business
                        self.tablePresenter.businessCurrent!.name = p.name
                        self.tablePresenter.businessCurrent!.street = "\(placeMark.subThoroughfare) \(placeMark.thoroughfare)"
                        self.tablePresenter.businessCurrent!.city = placeMark.locality
                        self.tablePresenter.businessCurrent!.state = placeMark.administrativeArea
                        self.tablePresenter.businessCurrent!.phone = p.phoneNumber
                        self.tablePresenter.businessCurrent!.url = "\(p.url)"
                        println(p.name)
                    } else {
                        self.tablePresenter.businessCurrent = b[0] as? Business
                    }
                    self.tablePresenter.displayBusiness()
                    }))
            }
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!)in
                println("Cancelled")

                }))
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }

    }
    
    func localSearch() {
        
        //There is a location bug where sometimes this code unwraps nil
        
        var request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "restaurant"
        println("Looking for restuarants")
        
        let distance : Double = 1500.00
        
        var userRegion : MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(currentLocation!.coordinate, distance, distance)
        
        request.region = userRegion
        
        var search:MKLocalSearch = MKLocalSearch(request: request)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        search.startWithCompletionHandler {
            (response:MKLocalSearchResponse!, error:NSError!) in
            println("Response: \(response)")
            self.placemarks = []
            if !error {
                    for pm in response.mapItems {
                        let p = pm as MKMapItem
                        self.placemarks.append(p)
                        println(p.name)
                    }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.displayLocationSearchResults()
                
            } else {
                println("Error in local map search")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                //Do something in case of error
            }
        }
    }
    
}
