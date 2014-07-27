//
//  FirstViewController.swift
//  coldcall
//
//  Created by Jason Crump on 7/3/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData

class ColorViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var revealButtonItem: UIBarButtonItem!
    var color: UIColor = UIColor.brownColor()
    var text: String = "Text"

    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealButtonItem.target = self.revealViewController()
        self.revealButtonItem.action = "revealToggle:"
        self.navigationController.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Test Core Data Models, creation and relationships.
        
//        SeedData.seedAll(10)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

