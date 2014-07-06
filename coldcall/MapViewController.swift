//
//  SecondViewController.swift
//  coldcall
//
//  Created by Jason Crump on 7/3/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData

@objc(MapViewController)
class MapViewController: UIViewController {
    
    @IBOutlet var revealButtonItem: UIBarButtonItem
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealButtonItem.target = self.revealViewController()
        self.revealButtonItem.action = "revealToggle:"
        self.navigationController.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Do any additional setup after loading the view, typically from a nib.
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        var request = NSFetchRequest(entityName: "Businesses")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "name contains %@", "Chipotle")
        var businesses:Array = context.executeFetchRequest(request, error: nil)
        
        for business: AnyObject in businesses {
            var b = business as Business
            println(b.name)
            for note: AnyObject in b.notes {
                var n = note as Note
                println(n.content)
            }
            for coldcall: AnyObject in b.coldcalls {
                var cc = coldcall as ColdCall
                println(cc.note.content)
                println(cc.user.firstName)
                println(cc.user.group.name)
            }
        }
        
        func viewDidAppear() {
            let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            let context = appDel.cdh.managedObjectContext
            var request = NSFetchRequest(entityName: "Businesses")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "name contains %@", "Chipotle")
            var businesses:Array = context.executeFetchRequest(request, error: nil)
            
            for business: AnyObject in businesses {
                var b = business as Business
                println(b.name)
                for note: AnyObject in b.notes {
                    var n = note as Note
                    println(n.content)
                }
                for coldcall: AnyObject in b.coldcalls {
                    var cc = coldcall as ColdCall
                    println(cc.note.content)
                    println(cc.user.firstName)
                    println(cc.user.group.name)
                }
            }
        }
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

