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

class NewCCTableViewController: UITableViewController, UITextFieldDelegate, CLLocationManagerDelegate, ProspectSearchControllerDelegate  {

    @IBOutlet var revealButtonItem: UIBarButtonItem!
    var tablePresenter: TableViewPresenter!
    var placemark: CLPlacemark?
    var placemarks = [MKMapItem]()
    var locationManager: CLLocationManager = CLLocationManager()
    var locationReceived: Bool?
    var currentLocation: CLLocation?
    var tempLocation: CLLocation?
    var geocoder = CLGeocoder()
    let userSession = UserSessionController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePresenter = TableViewPresenter(table: tableView, textFieldDelegate: self)
        applyUIAttributesToNavigation()
        setupMenuView()
        tableView.allowsSelection = false
        
        CLLocationManager.locationServicesEnabled()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        println("Started Location Services")
        println(locationManager)
        
        FacebookSessionController.sharedInstance.findOrGetSession(self)
    }
    
    func applyUIAttributesToNavigation(){
        let red : CGFloat = 150/255
        let green : CGFloat = 212/255
        let blue : CGFloat = 86/255
        let navBarColor : UIColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        self.navigationController.navigationBar.titleTextAttributes = titleDict
        self.navigationController.navigationBar.barTintColor = navBarColor
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
        tablePresenter.resetCellQuantitiesDict()
        userSession.currentBusiness = business
        tablePresenter.displayBusiness()
    }
    
    func didNotFindBusinessFromSearch() {
        tablePresenter.resetCellQuantitiesDict()
        userSession.currentBusiness = Business.newObject()
        tablePresenter.newBusiness()
        tablePresenter.displayBusiness()
        Flash().message("NO BUSINESSES FOUND MATCHING SEARCH.", view: tableView)
    }
    
    func didChooseNewBusinessFromSearch(){
        tablePresenter.resetCellQuantitiesDict()
        userSession.currentBusiness = Business.newObject()
        tablePresenter.newBusiness()
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
                    let b : [AnyObject] = ProspectSearchController().searchForProspect(p.name, address: placeMark.subThoroughfare)
                    if b.count == 0 {
                        self.userSession.currentBusiness = Business.newObject() as Business
                        self.userSession.currentBusiness!.name = p.name
                        self.userSession.currentBusiness!.street = "\(placeMark.subThoroughfare) \(placeMark.thoroughfare)"
                        self.userSession.currentBusiness!.city = placeMark.locality
                        self.userSession.currentBusiness!.state = placeMark.administrativeArea
                        self.userSession.currentBusiness!.phone = p.phoneNumber
                        self.userSession.currentBusiness!.url = "\(p.url)"
                        println(p.name)
                    } else {
                        self.userSession.currentBusiness = b[0] as? Business
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
