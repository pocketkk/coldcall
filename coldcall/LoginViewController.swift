//
//  LoginViewController.swift
//  coldcall
//
//  Created by Jason Crump on 7/9/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {

    var fbl: FBLoginView = FBLoginView()
    
    @IBOutlet var loginView : FBLoginView
    @IBOutlet var profilePictureView : FBProfilePictureView
    @IBOutlet var userNameTxt : UILabel
    @IBOutlet var logStatusTxt : UILabel
    
    @IBAction func logMeOut() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fbl.delegate = self
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView) {
        logStatusTxt.text = "You are logged in!"
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView?, user: FBGraphUser) {
        profilePictureView.profileID = user.objectID
        userNameTxt.text = user.first_name + " " + user.last_name
        
        println(user)
        
        var userPrefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        userPrefs.setObject(user.first_name, forKey: "fName")
        userPrefs.setObject(user.last_name, forKey: "lName")
        userPrefs.setObject(user.objectID, forKey: "fbId")
        var email: String = user.objectForKey("email") as String
        userPrefs.setObject(email, forKey: "email")
        
        println(userPrefs.objectForKey("fbId"))
        println(userPrefs.objectForKey("email"))

    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView?) {
        profilePictureView.profileID = nil
        userNameTxt.text = ""
        logStatusTxt.text = "You are logged out!"
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
