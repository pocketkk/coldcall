import UIKit

class CCProspectHeaderCell : UITableViewCell {
    
}

class CCToolbarCell : UITableViewCell {
    @IBOutlet weak var saveButton: UIButton!
}

class CCProspectSearchCell : UITableViewCell {
    @IBOutlet weak var prospectSearchField: UITextField!
}

class CCProspectCell : UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

}

class CCContactsHeaderCell : UITableViewCell {
    
}

class CCNewContactCell : UITableViewCell {
    @IBOutlet weak var fnameContactField: UITextField!
    @IBOutlet weak var lnameContactField: UITextField!
    @IBOutlet weak var titleContactField: UITextField!
    @IBOutlet weak var emailContactField: UITextField!
    @IBOutlet weak var phoneContactField: UITextField!
}

class CCContactCell : UITableViewCell {
    @IBOutlet weak var contactNameLabel: UILabel!
    
}

class CCNotesHeaderCell : UITableViewCell {
    
}

class CCNoteCell : UITableViewCell {
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet weak var noteContentLabel: UILabel!
}

class CCNoteEntryCell : UITableViewCell {
    @IBOutlet weak var newNoteField: UITextField!
    
}