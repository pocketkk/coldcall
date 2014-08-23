import UIKit
import CoreData

class TableViewPresenter : NSObject {
    var tableView : UITableView!
    var tfDelegate : UITextFieldDelegate!
    var flashView : UIView?
    var contactsCount = 0
    var notesCount = 0
    //var userSession.currentBusiness : Business?
    var contacts = [Contact]()
    var notes = [Note]()
    var cellCache : [UITableViewCell] = []
    var heightsCache : [CGFloat] = []
    var coldcall : ColdCall?
    var searchField : UITextField!
    var nameField : UITextField!
    var addressField : UITextField!
    var cityField : UITextField!
    var stateField : UITextField!
    var phoneField : UITextField!
    var urlField : UITextField!
    var noteField : UITextField?
    var firstNameField : UITextField!
    var lastNameField : UITextField!
    var emailField : UITextField!
    var contactPhoneField : UITextField!
    var titleField : UITextField!
    
    let userSession = UserSessionController.sharedInstance
    
    let cellTypesOrder : [String] = ["00_search_bar", "0_prospect_header", "1_new_prospect_tools", "1_existing_prospect_tools", "2_new_prospect", "3_contacts_header", "4_new_contact", "5_contact", "6_notes_header", "7_new_note", "8_note"]
    
    let cellHeightsArr : [CGFloat] = [35.0,     // search bar
                                      35.0,     // tools header
                                      35.0,     // tools header
                                      25.0,     // prospect header
                                      240.0,    // new prospect
                                      35.0,     // contacts header
                                      250.0,    // new contact
                                      25.0,     // contact
                                      35.0,     // notes header
                                      40.0,     // new note
                                      25.0      //
                                     ]
    
    var cellQuantitiesDict : [String: Int] = ["00_search_bar": 0, "1_new_prospect_tools": 0, "1_existing_prospect_tools": 1, "0_prospect_header": 1, "2_new_prospect": 1, "3_contacts_header": 1, "4_new_contact": 0, "5_contact": 0, "6_notes_header": 1, "7_new_note": 0, "8_note": 0]
    
    init(table: UITableView, textFieldDelegate: UITextFieldDelegate){
        super.init()
        tableView = table
        tfDelegate = textFieldDelegate
        userSession.currentBusiness = Business.newObject() as Business
        createCellCache()
    }
    
    func resetCellQuantitiesDict() {
        cellQuantitiesDict = ["00_search_bar": 0, "1_new_prospect_tools": 0, "1_existing_prospect_tools": 1, "0_prospect_header": 1, "2_new_prospect": 1, "3_contacts_header": 1, "4_new_contact": 0, "5_contact": 0, "6_notes_header": 1, "7_new_note": 0, "8_note": 0]
        contacts = []
        notes = []
    }
    
    func saveBusiness(){
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        if fieldsValidate() {
            updateBusinessModel()
            context.save(nil)
            clearFields([nameField, addressField, cityField, stateField, phoneField, urlField])
            userSession.currentBusiness = Business.newObject() as Business
            displayBusiness()
            Flash().message("BUSINESS SAVED!", view: tableView)
        } else {
            Flash().message("All required fields must be completed.", view: tableView)
        }
    }
    
    func updateBusinessModel(){
        userSession.currentBusiness!.name = nameField.text
        userSession.currentBusiness!.street = addressField.text
        userSession.currentBusiness!.city = cityField.text
        userSession.currentBusiness!.state = stateField.text
        userSession.currentBusiness!.phone = phoneField.text
        userSession.currentBusiness!.url = urlField.text
    }
    
    func clearFields(arr: [UITextField]) {
        for field in arr {
            field.text = ""
        }
    }

    func fieldsValidate() -> Bool {
        if nameField.text.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func saveContact(){
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        var c = Contact.newObject() as Contact
        c.firstName = firstNameField.text
        c.lastName = lastNameField.text
        c.title = titleField.text
        c.email = emailField.text
        c.phone = contactPhoneField.text
        userSession.currentBusiness?.addContact(c)
        cellQuantitiesDict["4_new_contact"] = 0
        context.save(nil)
        clearFields([firstNameField, lastNameField, titleField, emailField, contactPhoneField])
        displayBusiness()
        Flash().message("CONTACT SAVED!", view: tableView)
    }
    
    func createCellCache() {
        cellCache = []
        let cellsToCreate = cellTypesArray()
        for cellIdentifier in cellsToCreate {
            var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
            if cellIdentifier == "0_prospect_header" {
                //This is only called once per layout session and it is safe to reset counts here
                contactsCount = 0
                notesCount = 0
            }
            if cellIdentifier == "00_search_bar" {
                self.searchField = (cell as SearchCell).searchField
                (cell as SearchCell).searchField.delegate = tfDelegate
                (cell as SearchCell).searchField.tag = 2
            }
            if cellIdentifier == "1_new_prospect_tools" {

            }
            if cellIdentifier == "2_new_prospect" {
                self.nameField = (cell as NewProspectCell).nameField
                self.addressField = (cell as NewProspectCell).addressField
                self.cityField = (cell as NewProspectCell).cityField
                self.stateField = (cell as NewProspectCell).stateField
                self.phoneField = (cell as NewProspectCell).phoneField
                self.urlField = (cell as NewProspectCell).urlField
                (cell as NewProspectCell).nameField.delegate = tfDelegate
                (cell as NewProspectCell).addressField.delegate = tfDelegate
                (cell as NewProspectCell).cityField.delegate = tfDelegate
                (cell as NewProspectCell).stateField.delegate = tfDelegate
                (cell as NewProspectCell).phoneField.delegate = tfDelegate
                (cell as NewProspectCell).urlField.delegate = tfDelegate
            }
            if cellIdentifier == "4_new_contact" {
                self.firstNameField = (cell as NewContactCell).firstNameField
                self.lastNameField = (cell as NewContactCell).lastNameField
                self.emailField = (cell as NewContactCell).emailField
                self.contactPhoneField = (cell as NewContactCell).phoneField
                self.titleField = (cell as NewContactCell).titleField
                (cell as NewContactCell).firstNameField.tag = 3
                (cell as NewContactCell).lastNameField.tag = 3
                (cell as NewContactCell).emailField.tag = 3
                (cell as NewContactCell).phoneField.tag = 3
                (cell as NewContactCell).titleField.tag = 3
                (cell as NewContactCell).firstNameField.delegate = tfDelegate
                (cell as NewContactCell).lastNameField.delegate = tfDelegate
                (cell as NewContactCell).emailField.delegate = tfDelegate
                (cell as NewContactCell).phoneField.delegate = tfDelegate
                (cell as NewContactCell).titleField.delegate = tfDelegate
            }
            if cellIdentifier == "5_contact" {
                var c = contacts[contactsCount]
                (cell as ContactCell).nameLabel.text = c.fullNameWithTitle()
                ++contactsCount
            }
            if cellIdentifier == "7_new_note" {
                self.noteField = (cell as NewNoteCell).noteField
                (cell as NewNoteCell).noteField.delegate = tfDelegate
                (cell as NewNoteCell).noteField.tag = 1
            }
            if cellIdentifier == "8_note" {
                let n = notes[notesCount]
                (cell as NoteCell).noteLabel.text = n.content
                (cell as NoteCell).dateLabel.text = Date.toString(n.date!)
                ++notesCount
            }
            cellCache.append(cell)
            cellHeightsArray()
        }
    }
    
    func cellHeightsDic() -> [String: CGFloat] {
        var dict = [String: CGFloat]()
        var count = 0
        for cell in cellTypesOrder {
            dict[cell] = cellHeightsArr[count]
            ++count
        }
        return dict
    }
    
    func cellTypesArray() -> [String] {
        var arr : [String] = []
        for (cellName, cellQty) in cellQuantitiesDict {
            cellQty.times{arr.append(cellName)}
        }
        arr.sort {$0 < $1}
        return arr
    }
    
    func cellHeightsArray() -> [CGFloat] {
        let cells = cellTypesArray()
        let heights = cellHeightsDic()
        var arr = [CGFloat]()
        for cell in cells {
            let h = heights[cell]
            arr.append(h!)
        }
        heightsCache = arr
        return arr
    }
    
    func totalCells() -> Int {
        // could use cellTypesArray().count instead
        return ([Int](cellQuantitiesDict.values)).reduce(0,+)
    }
    
    func addContact() {
        if cellQuantitiesDict["4_new_contact"] == 0
        {
            updateBusinessModel()
            cellQuantitiesDict["4_new_contact"] = 1
            displayBusiness()
        }
    }
    
    func newBusiness() {
        createCellCache()
        nameField!.text = ""
        addressField!.text = ""
        cityField!.text = ""
        stateField!.text = ""
        phoneField!.text = ""
        tableView.reloadData()
    }
    
    func displayBusiness(){
        contacts = []
        notes = []
        contactsCount = 0
        notesCount = 0
        cellQuantitiesDict["5_contact"] = userSession.currentBusiness?.contacts.count
        cellQuantitiesDict["8_note"] = userSession.currentBusiness?.notes.count
        var c = userSession.currentBusiness!.coldcalls
        for call in c {
            var l = call as ColdCall
            println("There are \(l.note.content) notes for this prospect")
        }
        
        for contact in userSession.currentBusiness!.contacts {
            var c = contact as Contact
            println("add contact")
            contacts.append(c)
        }
        for note in userSession.currentBusiness!.notes {
            var n = note as Note
            println("add note")
            notes.append(n)
        }
        notes.sort({$0.date?.timeIntervalSinceNow > $1.date?.timeIntervalSinceNow})
        println("There are \(notes.count) notes and \(contacts.count) contacts")
        createCellCache()
        println(userSession.currentBusiness?)
        println(userSession.currentBusiness?.name)
        if (userSession.currentBusiness?.name) == nil {
            nameField!.text = ""
        } else {
            nameField!.text = userSession.currentBusiness?.name
        }
        if userSession.currentBusiness?.street == nil {
            addressField!.text = ""
        } else {
            addressField!.text = userSession.currentBusiness?.street
        }
        if userSession.currentBusiness?.city == nil {
            cityField!.text = ""
        } else {
            cityField!.text = userSession.currentBusiness?.city
        }
        if userSession.currentBusiness?.state == nil {
            stateField!.text = ""
        } else {
            stateField!.text = userSession.currentBusiness?.state
        }
        if userSession.currentBusiness?.phone == nil {
            phoneField!.text = ""
        } else {
            phoneField!.text = userSession.currentBusiness?.phone
        }
        if userSession.currentBusiness?.url == nil {
            urlField!.text = ""
        } else {
            urlField!.text = userSession.currentBusiness?.url
        }
        tableView.reloadData()
    }
}
