//
//  SessionController.swift
//  coldcall
//
//  Created by Jason Crump on 8/19/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit

protocol UserSessionControllerDelegate {
    func userSessionChanged()
}

class UserSessionController {

    class var sharedInstance : UserSessionController {
        struct Static {
            static let instance : UserSessionController = UserSessionController()
        }
        return Static.instance
    }

    private var loggedIn = false
    private var userImage : UIImage?
    private var userImageLarge : UIImage?
    
    var delegate : UserSessionControllerDelegate?
    var currentBusiness : Business? = Business.newObject()
    
    deinit { println("Deallocated UserSession") }
    
    func checkLoginState() {
        var userPrefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var userFirstName = userPrefs.stringForKey("fName")
    }
    
    func setUserImage(image: UIImage) {
        userImage = image
    }
    
    func getUserImage() -> UIImage {
        if userImage != nil {
            return userImage!
        } else {
            return UIImage()
        }
    }
    
    func setUserImageLarge(image: UIImage) {
        userImageLarge = image
    }
    
    func getUserImageLarge() -> UIImage {
        if userImageLarge != nil {
            return userImageLarge!
        } else {
            return UIImage()
        }
    }
    
    func clearUserImage() {
        userImage = nil
    }
    
    func userName() -> String {
        let userSession : UserSessionController = UserSessionController.sharedInstance
        if userSession.isUserLoggedIn() {
            var userPrefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            var userFirstName = userPrefs.stringForKey("fName")
            var userLastName = userPrefs.stringForKey("lName")
            println("user is logged in")
            return "\(userFirstName) \(userLastName)"
        } else {
            println("user is not logged in")
            return "Not logged in."
        }
    }
    func getUserFirstName() -> String {
        let userSession : UserSessionController = UserSessionController.sharedInstance
        if userSession.isUserLoggedIn() {
            var userPrefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            return userPrefs.stringForKey("fName")
        } else {
            return "First Name"
        }
    }
    
    func getUserLastName() -> String {
        let userSession : UserSessionController = UserSessionController.sharedInstance
        if userSession.isUserLoggedIn() {
            var userPrefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            return userPrefs.stringForKey("lName")
        } else {
            return "Last Name"
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return loggedIn
    }
    
    func getFacebookProfileImage(size: String = "small") {
        if size == "small" {
            dispatch_async(dispatch_get_main_queue()) {
                self.setUserImage(self.retrieveImageFromFacebook(size))
            }
        }
        if size == "large" {
            dispatch_async(dispatch_get_main_queue()) {
                self.setUserImageLarge(self.retrieveImageFromFacebook(size))
            }
        }
    }
    
    func retrieveImageFromFacebook(size: String) -> UIImage {
        var userPrefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userFBID = userPrefs.stringForKey("fbId")
        let userImageURL = "https://graph.facebook.com/\(userFBID)/picture?type=\(size)";
        let url = NSURL.URLWithString(userImageURL);
        let imageData = NSData(contentsOfURL: url);
        let image = UIImage(data: imageData);
        return image
    }
    
    func updateUserDefaults(user: FBGraphUser) {
        var userPrefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userPrefs.setObject(user.first_name, forKey: "fName")
        userPrefs.setObject(user.last_name, forKey: "lName")
        userPrefs.setObject(user.objectID, forKey: "fbId")
        let email: String = user.objectForKey("email") as String
        userPrefs.setObject(email, forKey: "email")
    }
    
    func clearUserDefaults(){
        var userPrefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userPrefs.setObject(nil, forKey: "fName")
        userPrefs.setObject(nil, forKey: "lName")
        userPrefs.setObject(nil, forKey: "fbId")
        userPrefs.setObject(nil, forKey: "email")
        clearUserImage()
    }
    
    func userIsLoggedIn() {
        if !loggedIn {
            loggedIn = true
            getFacebookProfileImage()
            getFacebookProfileImage(size: "large")
        }
    }
        
    func logIn(user: FBGraphUser) {
        if !loggedIn {
            loggedIn = true
            getFacebookProfileImage()
            getFacebookProfileImage(size: "large")
            updateUserDefaults(user)
            delegate?.userSessionChanged()
        }
    }
    
    func logOut() {
        if loggedIn {
            loggedIn = false
            clearUserDefaults()
            delegate?.userSessionChanged()
        }
    }
    
}

