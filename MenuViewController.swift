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

class MenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.tableView.backgroundColor = UIColor.lightGrayColor()
        self.tableView.separatorColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        if sender.isKindOfClass(UITableViewCell) {
//            var c : UILabel = sender.label
//            var nav : UINavigationController = segue.destinationViewController as UINavigationController
//            var cvc : ColorViewController = nav.childViewControllers[0] as ColorViewController
//            cvc.color = c.textColor
//            cvc.text = c.text
        }
        
    }
    
    func prepareForSegueB(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        if (segue.destinationViewController.isKindOfClass(ColorViewController) && sender.isKindOfClass(UITableViewCell)) {
//            var c : UILabel = sender.label
//            var cvc : ColorViewController = segue.destinationViewController as ColorViewController
//            cvc.color = c.textColor
//            cvc.text = c.text
//        }
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
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cellIdentifiers = ["title", "coldcalls", "contacts", "map", "settings"]

        var cellIdentifier = "Cell"
        
        cellIdentifier = cellIdentifiers[indexPath.row]
        
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
