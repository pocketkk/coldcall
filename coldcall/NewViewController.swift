//
//  NewViewController.swift
//  coldcall
//
//  Created by Jason Crump on 7/6/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData

extension Array {
    func firstOfType<X: AnyObject>(c: X.Type) -> X? {
        for x in self {
            if x is X { return (x as X) }
        }
        return nil
    }
}

class NewViewController: UIViewController, LoginViewControllerDelegate {

    @IBOutlet var revealButtonItem: UIBarButtonItem!
    
    func searchSubviews<X: AnyObject>(view: UIView, type: X.Type) -> X? {
        if view.subviews.count > 0 {
            let x : X? = view.subviews.firstOfType(type)
            if x {
                return (x as X)
            } else {
                searchSubviews(x, type: type)
            }
        }
        return nil
    }
    
    func addContact(){
        var elements = ViewBuilder.sharedInstance.contactsViewElements
        println(elements)
        for v in view.subviews {
            let y = v as UIView
            let s = y.subviews.firstOfType(UIScrollView)
            println(s)
            for x in y.subviews {
                let z = x as UIView
                let zz = z.subviews.firstOfType(UIScrollView)
            }
        }

    }
    
    func createNewCCView(){
        let factory = UIFactory.sharedInstance
        let builder = ViewBuilder.sharedInstance
        let container = CCView(frame: self.view.bounds)
        let scrollView = UIScrollView(frame: container.bounds)
        
        let prospectLbl = factory.titleLabel("Prospect", parentView: scrollView)
        builder.addViewToScroll(prospectLbl)
        
        let nameField = factory.ccTextField("Name", parentView: scrollView)
        let addressField = factory.ccTextField("Address", parentView: scrollView)
        let cityField = factory.ccTextField("City", parentView: scrollView)
        let stateField = factory.ccTextField("State", parentView: scrollView)
        let phoneField = factory.ccTextField("Phone", parentView: scrollView)
        
        for field in [nameField, addressField, cityField, stateField, phoneField] {
            builder.addViewToScroll(field)
        }
        
        let contactsContainer = factory.ccView(self.view.bounds)

        let contactsLbl = factory.titleLabel("Contact", parentView: scrollView)
        builder.addViewToScroll(contactsLbl)
        let contactNameField = factory.ccTextField("Name", parentView: contactsContainer)
        builder.addViewToContacts(contactNameField)
        let contactPhoneField = factory.ccTextField("Phone", parentView: contactsContainer)
        builder.addViewToContacts(contactPhoneField)
        
        let addContactButton : CCButton = factory.ccButton("Add", parentView: contactsContainer)
        addContactButton.addTarget(self, action: "addContact", forControlEvents: .TouchUpInside)
        builder.addViewToContacts(addContactButton)
        
        builder.arrangeObjectsInView(builder.contactsViewElements, view: contactsContainer, paddingY: 40.0)
        builder.addViewToScroll(contactsContainer)
        

        
        
        builder.arrangeObjectsInView(builder.scrollViewElements, view: scrollView, paddingY: 45.0)
        scrollView.scrollEnabled = true
        scrollView.contentSize = CGSize(width: container.bounds.maxX, height: 900)
        container.addSubview(scrollView)
        view.addSubview(container)
    }
    
    override func viewDidLoad() {
        let red : CGFloat = 150/255
        let green : CGFloat = 212/255
        let blue : CGFloat = 86/255
        let navBarColor : UIColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        self.navigationController.navigationBar.titleTextAttributes = titleDict
        
        super.viewDidLoad()
        self.navigationController.navigationBar.barTintColor = navBarColor
        
        self.revealButtonItem.target = self.revealViewController()
        self.revealButtonItem.action = "revealToggle:"
        self.navigationController.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        createNewCCView()
        // Do any additional setup after loading the view.
        //displayFacebookLogin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeFacebookLogin(){
        println("Close Window")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func displayFacebookLogin(){
        let storyboard : UIStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil);
        let vc : LoginViewController = storyboard.instantiateViewControllerWithIdentifier("login_view") as LoginViewController
        vc.delegate = self
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
