//
//  FacebookSessionController.swift
//  coldcall
//
//  Created by Jason Crump on 8/22/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit

class FacebookSessionController {
    
    class var sharedInstance : FacebookSessionController {
    struct Static {
        static let instance : FacebookSessionController = FacebookSessionController()
        }
        return Static.instance
    }
    
    func findOrGetSession(controller: UIViewController) {
        let permissions = ["public_profile", "email", "user_friends"]
        let loggedIn = FBSession.openActiveSessionWithReadPermissions(permissions, allowLoginUI:false){ session, state, error in
            //do stuff with session
        }
        if loggedIn == false {
            displayFacebookLogin(controller)
        } else {
            let userSession = UserSessionController.sharedInstance
            userSession.userIsLoggedIn()
        }
    }

    func displayFacebookLogin(controller: UIViewController){
        let storyboard : UIStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil);
        let vc : LoginViewController = storyboard.instantiateViewControllerWithIdentifier("login_view") as LoginViewController
        controller.presentViewController(vc, animated: true, completion: nil);
    }
    
}
