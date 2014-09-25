//
//  MenuTableViewController.swift
//  coldcall
//
//  Created by Jason Crump on 7/22/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit

class SWUITableViewCell : UITableViewCell {
    @IBOutlet var label : UILabel!
}

class MenuViewController: UITableViewController, UserSessionControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userSession = UserSessionController.sharedInstance
        userSession.delegate = self
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if sender.isKindOfClass(UITableViewCell)
        {
        }
    }
    
    func prepareForSegueB(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if(segue.isKindOfClass(SWRevealViewControllerSegue))
        {
            var rvcs : SWRevealViewControllerSegue = segue as SWRevealViewControllerSegue
            var rvc : SWRevealViewController = self.revealViewController()
            
            rvcs.performBlock = {(rvc_segue, svc, dvc) in
                var nc:UINavigationController = dvc as UINavigationController
                rvc.pushFrontViewController(nc, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    func userSessionChanged() {
        println("userSessionChanged")
        tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        println(indexPath.row)
        var rowHeight : CGFloat = 0
        if indexPath.row == 0 {
            rowHeight = 65.0
        } else {
            rowHeight = 50.0
        }
        return rowHeight
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cellIdentifiers = ["title", "coldcalls", "prospects", "contacts", "map", "settings"]
        var cellIdentifier = "Cell"
        cellIdentifier = cellIdentifiers[indexPath.row]
        
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        if cellIdentifier == "title" {
            for sub in cell!.subviews {
                sub.removeFromSuperview()
            }
            let userSession = UserSessionController.sharedInstance
            var imageView = UIImageView(frame: CGRectMake(12,1,20,30))
            imageView.image = userSession.getUserImage()
            imageView.sizeToFit()
            imageView.layer.cornerRadius = imageView.frame.size.width / 2
            imageView.clipsToBounds = true
            imageView.center.y = (65.0 / 2)
            imageView.layer.borderWidth = 3.0
            imageView.layer.borderColor = UIColor.darkGrayColor().CGColor

            var nameLabel = UILabel(frame: CGRectMake(72,12,200,20))
            nameLabel.text = userSession.userName().uppercaseString
            nameLabel.textColor = UIColor.darkGrayColor()
            nameLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
            nameLabel.center.y = imageView.center.y
            cell?.addSubview(imageView)
            cell?.addSubview(nameLabel)
        }
        return cell
    }

}
