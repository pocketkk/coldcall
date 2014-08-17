import UIKit

class FacebookCellHeader : UITableViewCell {
}

class ProspectHeaderCell : UITableViewCell {
}

class NewProspectCell : UITableViewCell {
    @IBOutlet var nameField : UITextField!
    @IBOutlet var addressField : UITextField!
    @IBOutlet var cityField : UITextField!
    @IBOutlet var stateField : UITextField!
    @IBOutlet var phoneField : UITextField!
    @IBOutlet var urlField : UITextField!
}

class ContactsHeaderCell : UITableViewCell {

}

class ContactCell : UITableViewCell {
    @IBOutlet var nameLabel : UILabel!
}

class NewContactCell : UITableViewCell {
    @IBOutlet var firstNameField : UITextField!
    @IBOutlet var lastNameField : UITextField!
    @IBOutlet var emailField : UITextField!
    @IBOutlet var titleField : UITextField!
    @IBOutlet var phoneField : UITextField!
}

class NotesHeaderCell : UITableViewCell {
    
}

class NoteCell : UITableViewCell {
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var noteLabel : UILabel!
}

class NewNoteCell : UITableViewCell {
    @IBOutlet var noteField : UITextField!
}

class SearchCell : UITableViewCell {
    @IBOutlet var searchField : UITextField!
}