import UIKit
import CoreData

class TableViewPresenter {
    var tableView : UITableView!
    var tfDelegate : UITextFieldDelegate!
    var contactsCount = 0
    var notesCount = 0
    
    var businessCurrent : Business?
    var contacts = [Contact]()
    var notes = [Note]()
    
    var cellCache : [UITableViewCell] = []
    var heightsCache : [CGFloat] = []
    
    var coldcall : ColdCall?
    
    var nameField : UITextField?
    var addressField : UITextField?
    var cityField : UITextField?
    var stateField : UITextField?
    var phoneField : UITextField?
    
    var noteField : UITextField?
    
    var firstNameField : UITextField?
    var lastNameField : UITextField?
    var emailField : UITextField?
    var contactPhoneField : UITextField?
    var titleField : UITextField?
    
    let cellTypesOrder : [String] = ["0_prospect_header", "1_new_prospect_tools", "1_existing_prospect_tools", "2_new_prospect", "3_contacts_header", "4_new_contact", "5_contact", "6_notes_header", "7_new_note", "8_note"]
    let cellHeightsArr : [CGFloat] = [35.0,     // tools header
                                      35.0,     // tools header
                                      35.0,     // prospect header
                                      200.0,    // new prospect
                                      35.0,     // contacts header
                                      200.0,    // new contact
                                      25.0,     // contact
                                      35.0,     // notes header
                                      40.0,     // new note
                                      25.0      //
                                     ]
    var cellQuantitiesDict : [String: Int] = ["1_new_prospect_tools": 0, "1_existing_prospect_tools": 0, "0_prospect_header": 1, "2_new_prospect": 1, "3_contacts_header": 1, "4_new_contact": 0, "5_contact": 0, "6_notes_header": 1, "7_new_note": 0, "8_note": 0]
    
    init(table: UITableView, textFieldDelegate: UITextFieldDelegate){
        tableView = table
        tfDelegate = textFieldDelegate
        businessCurrent = Business.newObject() as Business
    }
    
    func resetCellQuantitiesDict() {
        cellQuantitiesDict = ["1_new_prospect_tools": 0, "1_existing_prospect_tools": 0, "0_prospect_header": 1, "2_new_prospect": 1, "3_contacts_header": 1, "4_new_contact": 0, "5_contact": 0, "6_notes_header": 1, "7_new_note": 0, "8_note": 0]
        contacts = []
        notes = []
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
            if cellIdentifier == "1_new_prospect_tools" {
                let red : CGFloat = 150/255
                let green : CGFloat = 212/255
                let blue : CGFloat = 86/255
                let navBarColor : UIColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                cell.backgroundColor = navBarColor
            }
            if cellIdentifier == "2_new_prospect" {
                self.nameField = (cell as NewProspectCell).nameField
                self.addressField = (cell as NewProspectCell).addressField
                self.cityField = (cell as NewProspectCell).cityField
                self.stateField = (cell as NewProspectCell).stateField
                self.phoneField = (cell as NewProspectCell).phoneField
                (cell as NewProspectCell).nameField.delegate = tfDelegate
                (cell as NewProspectCell).addressField.delegate = tfDelegate
                (cell as NewProspectCell).cityField.delegate = tfDelegate
                (cell as NewProspectCell).stateField.delegate = tfDelegate
                (cell as NewProspectCell).phoneField.delegate = tfDelegate
            }
            
            if cellIdentifier == "4_new_contact" {
                self.firstNameField = (cell as NewContactCell).firstNameField
                self.lastNameField = (cell as NewContactCell).lastNameField
                self.emailField = (cell as NewContactCell).emailField
                self.contactPhoneField = (cell as NewContactCell).phoneField
                self.titleField = (cell as NewContactCell).titleField
                (cell as NewContactCell).firstNameField.delegate = tfDelegate
                (cell as NewContactCell).lastNameField.delegate = tfDelegate
                (cell as NewContactCell).emailField.delegate = tfDelegate
                (cell as NewContactCell).phoneField.delegate = tfDelegate
                (cell as NewContactCell).titleField.delegate = tfDelegate
            }
            
            if cellIdentifier == "5_contact" {
                var c = contacts[contactsCount]
                (cell as ContactCell).nameLabel.text = c.firstName
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
                (cell as NoteCell).dateLabel.text = Date.toString(n.date)
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
        
        cellQuantitiesDict["5_contact"] = businessCurrent?.contacts.count
        cellQuantitiesDict["8_note"] = businessCurrent?.notes.count
        var c = businessCurrent!.coldcalls
        for call in c {
            var l = call as ColdCall
            println("There are \(l.note.content) notes for this prospect")
        }
        
        for contact in businessCurrent!.contacts {
            var c = contact as Contact
            println("add contact")
            contacts.append(c)
        }
        for note in businessCurrent!.notes {
            var n = note as Note
            println("add note")
            notes.append(n)
        }
        notes.sort({$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow})
        println("There are \(notes.count) notes and \(contacts.count) contacts")
        createCellCache()
        println(businessCurrent?)
        println(businessCurrent?.name)
        if (businessCurrent?.name) == nil {
            nameField!.text = ""
        } else {
            nameField!.text = businessCurrent?.name
        }
        if businessCurrent?.street == nil {
            addressField!.text = ""
        } else {
            addressField!.text = businessCurrent?.street
        }
        if businessCurrent?.city == nil {
            cityField!.text = ""
        } else {
            cityField!.text = businessCurrent?.city
        }
        if businessCurrent?.state == nil {
            stateField!.text = ""
        } else {
            stateField!.text = businessCurrent?.state
        }
        if businessCurrent?.phone == nil {
            phoneField!.text = ""
        } else {
            phoneField!.text = businessCurrent?.phone
        }

        tableView.reloadData()
    }
    
}
