//
//  NewViewController.swift
//  coldcall
//
//  Created by Jason Crump on 7/6/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData

@objc(NewViewController)

class NewViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var revealButtonItem: UIBarButtonItem

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.revealButtonItem.target = self.revealViewController()
        self.revealButtonItem.action = "revealToggle:"
        self.navigationController.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
        displayFacebookLogin()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayFacebookLogin(){
        let storyboard : UIStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil);
        let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("login_view") as UIViewController;
        self.presentViewController(vc, animated: true, completion: nil);
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
