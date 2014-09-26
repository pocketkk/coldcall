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
    let userSession = UserSessionController.sharedInstance
    @IBOutlet var loginView : FBLoginView!
    @IBOutlet var profilePictureView : FBProfilePictureView!
    @IBOutlet var userNameTxt : UILabel!
    @IBOutlet var logStatusTxt : UILabel!
    
    @IBAction func logMeOut() {
        println("Close Window")
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fbl.delegate = self
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView) {
        logStatusTxt.text = "You are logged in!"
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView?, user: FBGraphUser) {
        let userSession : UserSessionController = UserSessionController.sharedInstance
        println(user)
        profilePictureView.profileID = user.objectID
        profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width / 2
        profilePictureView.clipsToBounds = true
        profilePictureView.layer.borderWidth = 3.0
        profilePictureView.layer.borderColor = UIColor.darkGrayColor().CGColor
        userSession.logIn(user)
        userNameTxt.text = userSession.userName()
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView?) {
        profilePictureView.profileID = nil
        userNameTxt.text = ""
        logStatusTxt.text = "You are logged out!"
        userSession.logOut()
    }

}
