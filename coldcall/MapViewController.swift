//
//  SecondViewController.swift
//  coldcall
//
//  Created by Jason Crump on 7/3/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet var revealButtonItem: UIBarButtonItem!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealButtonItem.target = self.revealViewController()
        self.revealButtonItem.action = "revealToggle:"
        self.navigationController?.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func viewDidAppear() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

