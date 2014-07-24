import UIKit

class BaseUIDefaults {
    
    class var sharedInstance : BaseUIDefaults {
    struct Static {
        static let instance : BaseUIDefaults = BaseUIDefaults()
        }
        return Static.instance
    }
    
    let bgColor = UIColor.whiteColor()
    let headTextColor = UIColor.blackColor()
    let bodyTextColor = UIColor.blueColor()
    let buttonColor = UIColor.greenColor()
    let buttonSize : CGFloat = 20.0
    let borderWidth : CGFloat = 0.0
    let borderColor = UIColor.blackColor().CGColor
    let cornerRadius : CGFloat = 5.0
    let frameWidth = 100
    var fontSize : CGFloat = 25.0
    var frameHeight : CGFloat = 35.0
    
    var defaultPaddingX : CGFloat = 10.0
    var defaultPaddingY : CGFloat = 10.0
    var viewBounds : CGRect?
    
    // Returns rect that is positioned centered by x and height is set to lineHeight
    func returnRectFor(view: UIView) -> CGRect {
        return CGRectMake(view.bounds.minX + defaultPaddingX, view.bounds.minY + defaultPaddingY, view.bounds.width - (defaultPaddingX * 2), frameHeight)
    }
    
    init() {
        
    }
    
}

protocol  Movable {
    func moveDownBy(offset: CGFloat)
    func moveRightBy(offset: CGFloat)
    func addToView(view: UIView)
}


class CCView : UIView, Movable {
    
    init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func moveDownBy(offset: CGFloat) {
        self.frame = CGRectOffset( self.frame, 0, offset )
    }
    
    func moveRightBy(offset: CGFloat) {
        self.frame = CGRectOffset(self.frame, offset, 0)
    }
    
    func addToView(view: UIView) {
        view.addSubview(self)
    }
    
}

class CCColumnView : UIView, Movable {
    
    init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func addViewsSidebySide(view1: UIView, view2: UIView) {
        self.addSubview(view1)
        view2.frame = CGRectOffset(view2.frame, view1.frame.width + 5, 0)
        view2.center.y = view1.center.y
        self.addSubview(view2)
        self.sizeToFit()
    }
    
    func moveDownBy(offset: CGFloat) {
        self.frame = CGRectOffset( self.frame, 0, offset )
    }
    
    func moveRightBy(offset: CGFloat) {
        self.frame = CGRectOffset(self.frame, offset, 0)
    }
    
    func addToView(view: UIView) {
        view.addSubview(self)
    }
    
}

class CCImage: UIImageView, Movable {
    
    let shared = BaseUIDefaults.sharedInstance
    
    init(path: String, view: UIView) {
        super.init(frame: shared.returnRectFor(view))
        let image = UIImage(named: path)
        self.image = image
        self.sizeToFit()
    }
    
    func moveDownBy(offset: CGFloat) {
        self.frame = CGRectOffset( self.frame, 0, offset )
    }
    
    func moveRightBy(offset: CGFloat) {
        self.frame = CGRectOffset(self.frame, offset, 0)
    }
    
    func addToView(view: UIView) {
        view.addSubview(self)
    }
    
}

class CCButton : UIButton, Movable {
    
    // Button should be centered
    
    let shared = BaseUIDefaults.sharedInstance
    
    init(view: UIView, text: String) {
        let viewBounds = shared.returnRectFor(view)
        super.init(frame: viewBounds)
    }
    
    func moveDownBy(offset: CGFloat) {
        self.frame = CGRectOffset( self.frame, 0, offset )
    }
    
    func moveRightBy(offset: CGFloat) {
        self.frame = CGRectOffset(self.frame, offset, 0)
    }
    
    func addToView(view: UIView) {
        view.addSubview(self)
    }
    
}

class CCTextField: UITextField, Movable {
    
    let shared = BaseUIDefaults.sharedInstance
    
    init(view: UIView) {
        let viewBounds = shared.returnRectFor(view)
        super.init(frame: viewBounds)
    }
    
    func moveDownBy(offset: CGFloat) {
        self.frame = CGRectOffset( self.frame, 0, offset )
    }
    
    func moveRightBy(offset: CGFloat) {
        self.frame = CGRectOffset(self.frame, offset, 0)
    }
    
    func addToView(view: UIView) {
        view.addSubview(self)
    }
}

class CCLabel : UILabel, Movable {
    
    var defaultPaddingX : CGFloat = 10
    var defaultPaddingY : CGFloat = 10
    var viewBounds : CGRect
    var lineHeight : Double = 15.0
    
    let shared = BaseUIDefaults.sharedInstance
    
    init(view: UIView, fontSize: CGFloat) {
        viewBounds = shared.returnRectFor(view)
        super.init(frame: viewBounds)
    }
    
    func startPoint(view:UIView, paddingX: Double, paddingY: Double) -> Void {
        
    }
    
    func moveDownBy(offset: CGFloat) {
        self.frame = CGRectOffset( self.frame, 0, offset )
    }
    
    func moveRightBy(offset: CGFloat) {
        self.frame = CGRectOffset(self.frame, offset, 0)
    }
    
    func addToView(view: UIView) {
        view.addSubview(self)
    }
    
}

class UIFactory : BaseUIDefaults {
    
    // Return and use singleton of UIFactory
    
    override class var sharedInstance : UIFactory {
    struct Static {
        static let instance : UIFactory = UIFactory()
        }
        return Static.instance
    }
    
    func titleLabel(text: String, parentView: UIView) -> CCLabel {
        let b = CCLabel(view: parentView, fontSize: fontSize)
        b.text = text
        b.font = UIFont.systemFontOfSize(fontSize)
        b.textColor = headTextColor
        b.textAlignment = NSTextAlignment.Left
        return b
    }
    
    func bodyLabel(text: String, parentView: UIView) -> CCLabel  {
        let b = CCLabel(view: parentView, fontSize: fontSize)
        b.text = text
        b.font = UIFont.systemFontOfSize(fontSize - 10)
        b.textColor = bodyTextColor
        b.textAlignment = NSTextAlignment.Left
        return b
    }
    
    func ccView(frame: CGRect) -> CCView {
        var view = CCView(frame: frame)
        view.backgroundColor = bgColor
        view.layer.borderColor = borderColor
        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = cornerRadius
        return view
    }
    
    func ccButton(text: String, parentView: UIView) -> CCButton {
        var c = CCButton(view: parentView, text: text)
        c.setTitle(text, forState: .Normal)
        c.setTitleColor(buttonColor, forState: .Normal)
        c.sizeToFit()
        c.center.x = parentView.center.x
        return c
    }
    
    func ccTextField(placeHolder: String, parentView: UIView) -> CCTextField {
        var tf = CCTextField(view: parentView)
        tf.placeholder = placeHolder
        tf.borderStyle = UITextBorderStyle.RoundedRect
        tf.clearButtonMode = UITextFieldViewMode.WhileEditing
        tf.textAlignment = .Left
        tf.textColor = UIColor.darkGrayColor()
        tf.contentVerticalAlignment = .Center
        tf.autocapitalizationType = .None
        tf.font = UIFont.systemFontOfSize(14.0)
        return tf
    }
    
}

class ViewBuilder {
    
    class var sharedInstance : ViewBuilder {
    struct Static {
        static let instance : ViewBuilder = ViewBuilder()
        }
        return Static.instance
    }
    
    var scrollViewElements : [Movable] = []
    var contactsViewElements : [Movable] = []
    
    func addViewToScroll(view: Movable) {
        scrollViewElements.append(view)
    }
    
    func addViewToContacts(view: Movable) {
        contactsViewElements.append(view)
    }
    
    // Takes array of views that conform to Movable Protocol and places in view with padding.
    
    func arrangeObjectsInView(arrayOfMovables: [Movable], view: UIView, paddingY: CGFloat) -> Void {
        var count : CGFloat = 0.0
        for lbl in arrayOfMovables {
            lbl.moveDownBy(count)
            lbl.addToView(view)
            count += paddingY
        }
    }
    
}