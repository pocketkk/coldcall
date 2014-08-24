//
//  LocationSearchController.swift
//  coldcall
//
//  Created by Jason Crump on 8/24/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import MapKit

protocol LocationSearchControllerDelegate {
    func didFindBusinessFromLocationSearch(business: Business)
    func didNotFindBusinessFromLocationSearch()
}

class LocationSearchController: NSObject, CLLocationManagerDelegate {
 
    var delegate : LocationSearchControllerDelegate?
    var callingController : UIViewController!
    var placemark: CLPlacemark?
    var placemarks = [MKMapItem]()
    var locationManager: CLLocationManager!
    var locationReceived: Bool?
    var currentLocation: CLLocation?
    var tempLocation: CLLocation?
    var geocoder = CLGeocoder()
    
    var userSession = UserSessionController.sharedInstance
    
    init(controller: UIViewController) {
        super.init()
        callingController = controller
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    deinit { println("Location Search delegate is being deinitialized") }
    
    func start() {
        println("Started Location Services")
        CLLocationManager.locationServicesEnabled()
        println(locationManager)
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        println("Found lcoations")
        currentLocation = locations[0] as? CLLocation
        locationManager.stopUpdatingLocation()
        localSearch()
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationReceived = false
        println(error)
        println("Error retrieving Location")
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
    
    func createBusinessObjectFromPlacemark(placeMark: CLPlacemark, mkitem: MKMapItem) -> Business {
        var business = Business.newObject() as Business
        business.name = mkitem.name
        business.street = "\(placeMark.subThoroughfare) \(placeMark.thoroughfare)"
        business.city = placeMark.locality
        business.state = placeMark.administrativeArea
        business.phone = mkitem.phoneNumber
        business.url = "\(mkitem.url)"
        return business
    }
    
    func addBusinessToActionSheet(actionSheet: UIAlertController, mkitem: MKMapItem) {
        actionSheet.addAction(UIAlertAction(title: mkitem.name, style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
            println("You chose: \(mkitem.name)")
            var placeMark = mkitem.placemark as CLPlacemark
            let b : [AnyObject] = ProspectSearchController().searchForProspect(mkitem.name, address: placeMark.subThoroughfare)
            if b.count == 0 {
                let business = self.createBusinessObjectFromPlacemark(placeMark, mkitem: mkitem)
                self.delegate?.didFindBusinessFromLocationSearch(business)
            } else {
                let business = b[0] as Business
                self.delegate?.didFindBusinessFromLocationSearch(business)
            }
        }))
    }
    
    func displayLocationSearchResults() {
        var actionSheet =  UIAlertController(title: "Choose Business from Location", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        if placemarks.count >= 1 {
            for pm in placemarks {
                addBusinessToActionSheet(actionSheet, mkitem: (pm as MKMapItem))
            }
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!)in
                println("Cancelled")
            }))
            callingController.presentViewController(actionSheet, animated: true, completion: nil)
        } else {
            delegate?.didNotFindBusinessFromLocationSearch()
        }
        
    }

    
}