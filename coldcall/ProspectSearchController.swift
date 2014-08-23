//
//  ProspectSearchController.swift
//  coldcall
//
//  Created by Jason Crump on 8/23/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData
import MapKit

protocol ProspectSearchControllerDelegate {
    func didFindBusinessFromSearch(business: Business)
    func didChooseNewBusinessFromSearch()
    func didNotFindBusinessFromSearch()
}

class ProspectSearchController: NSObject {
    
    var delegate: ProspectSearchControllerDelegate?
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).cdh.managedObjectContext
    var request = NSFetchRequest(entityName: "Businesses")
    
    override init() {
        super.init()
        request.returnsObjectsAsFaults = false
    }
    
    func searchForProspect(name: String, address: String) -> [AnyObject] {
        request.predicate = NSPredicate(format: "name contains [c] %@ && street contains [c] %@", name, address)
        var businesses : [AnyObject] = context.executeFetchRequest(request, error: nil)
        return businesses
    }
    
    func loadProspect(searchTerm: String, controller: UIViewController) {
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name contains [c] %@", searchTerm)
        var businesses:Array = context.executeFetchRequest(request, error: nil)
        chooseBusiness(businesses as [Business], controller: controller)
    }
    
    func addBusinessToActionSheet(sheet: UIAlertController, business: Business) {
        sheet.addAction(UIAlertAction(title: business.name, style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!) in
            println("selected \(business.name)")
            self.delegate?.didFindBusinessFromSearch(business)
        }))
    }
    
    func addNewBusinessToActionSheet(sheet: UIAlertController) {
        sheet.addAction(UIAlertAction(title: "New Prospect", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!) in
            println("user selected new business")
            self.delegate?.didNotFindBusinessFromSearch()
            
        }))
    }
    
    func chooseBusiness(businesses: [Business], controller: UIViewController) {
        if businesses.count == 0 {
            self.delegate?.didNotFindBusinessFromSearch()
        }
        if businesses.count == 1 {
            self.delegate?.didFindBusinessFromSearch(businesses[0] as Business)
        }
        if businesses.count >= 2 {
            var actionSheet =  UIAlertController(title: "Choose Business", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            for business in businesses {
                var b = business as Business
                addBusinessToActionSheet(actionSheet, business: b)
            }
            addNewBusinessToActionSheet(actionSheet)
            controller.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
}
