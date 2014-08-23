//
//  ProfileViewController.swift
//  coldcall
//
//  Created by Jason Crump on 8/21/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let userSession = UserSessionController.sharedInstance
        firstNameLabel.text = userSession.getUserFirstName()
        lastNameLabel.text = userSession.getUserLastName()
        setProfileImage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setProfileImage() {
        let userSession = UserSessionController.sharedInstance
        profileImageView.image = userSession.getUserImageLarge()
        profileImageView.sizeToFit()
        profileImageView.layer.cornerRadius = (profileImageView.frame.width/2)
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.borderColor = UIColor.darkGrayColor().CGColor
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
