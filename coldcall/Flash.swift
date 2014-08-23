//
//  Flash.swift
//  coldcall
//
//  Created by Jason Crump on 8/23/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit

class Flash : NSObject {
    
    var flashView : UIView?
    
    override init() {
        super.init()
    }
    
    func message(msg: String, view: UIView){
        let v = UIView(frame: view.bounds)
        let i = UIView(frame: CGRectMake(0, 0, 200.0, 100.0))
        i.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
        i.center = v.center
        i.layer.borderWidth = 2.0
        i.layer.borderColor = UIColor.clearColor().CGColor
        i.layer.cornerRadius = 5.0
        let defaultPadding : CGFloat = 10.0
        let label = UILabel(frame: CGRectMake(i.bounds.minX + defaultPadding, i.bounds.minY + defaultPadding, i.bounds.width - (defaultPadding * 2), i.bounds.height - (defaultPadding * 2)))
        label.text = msg
        label.numberOfLines = 0
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        i.addSubview(label)
        v.addSubview(i)
        view.addSubview(v)
        flashView  = v
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("removeFlashScreen"), userInfo: nil, repeats: false)
    }
    
    func removeFlashScreen() {
        flashView?.removeFromSuperview()
    }

}
