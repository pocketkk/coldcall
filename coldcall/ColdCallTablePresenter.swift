//
//  ColdCallTablePresenter.swift
//  coldcall
//
//  Created by Jason Crump on 8/24/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit

class ColdCallTablePresenter : NSObject {
    
    let tableView : UITableView!
    let userSession = UserSessionController.sharedInstance
    var cellCache : [UITableViewCell] = []
    var heightsCache : [CGFloat] = []
    var tfDelegate : UITextFieldDelegate!
    
    var contactsCount = 0
    var notesCount = 0
    var contacts = [Contact]()
    var notes = [Note]()
    
    var prospectSearchField : UITextField?
    var nameLabel : UILabel?
    var cityLabel : UILabel?
    
    var fnameContactField : UITextField?
    var lnameContactField : UITextField?
    var titleContactField : UITextField?
    var emailContactField : UITextField?
    var phoneContactField : UITextField?
    
    var contactNameLabel : UILabel?
    
    var noteDateLabel : UILabel?
    var noteContentLabel : UILabel?
    
    var noteEntryField : UITextField?
    
    let cellTypesOrder : [String] = [
        "00_search_bar",
        "01_coldcall_tools",
        "10_prospect_header",
        "15_prospect_info",
        "3_contacts_header",
        "5_contact",
        "6_notes_header",
        "7_new_note",
        "80_note",
        "90_outcome_header",
        "95_outcome"
    ]
    
    let cellHeightsArr : [CGFloat] = [
        35.0,     // search bar
        45.0,     // tools header
        25.0,     // prospect header
        66.0,     // prospect
        35.0,     // contacts header
        45.0,     // contact
        35.0,     // notes header
        88.0,     // new note
        25.0,     // note
        35.0,     // outcome header
        90.0      // outcome
    ]
    
    var cellQuantitiesDict : [String: Int] = [
        "00_search_bar": 0,
        "01_coldcall_tools": 1,
        "10_prospect_header": 0,
        "15_prospect_info": 1,
        "3_contacts_header": 1,
        "5_contact": 0,
        "6_notes_header": 1,
        "7_new_note": 1,
        "80_note": 0,
        "90_outcome_header": 1,
        "95_outcome": 1
    ]
    
    func resetCellQuantitiesDict() {
        cellQuantitiesDict = [
            "00_search_bar": 0,
            "01_coldcall_tools": 1,
            "10_prospect_header": 1,
            "15_prospect_info": 1,
            "3_contacts_header": 1,
            "5_contact": 0,
            "6_notes_header": 1,
            "7_new_note": 1,
            "80_note": 0,
            "90_outcome_header": 1,
            "95_outcome": 1
        ]
        contacts = []
        notes = []
    }

    init(tableView: UITableView, textFieldDelegate: UITextFieldDelegate){
        super.init()
        self.tableView = tableView
        self.tfDelegate = textFieldDelegate
        createCellCache()
    }
    
    deinit { println("Deallocated CCTablePresenter") }
    
    func totalCells() -> Int {
        // could use cellTypesArray().count instead
        return ([Int](cellQuantitiesDict.values)).reduce(0,+)
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
    
    func createCellCache() {
        println("creating cell cache")
        cellCache = []
        let cellsToCreate = cellTypesArray()
        println(cellsToCreate)
        for cellIdentifier in cellsToCreate {
            println("in loop for \(cellIdentifier)")
            var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell

            if cellIdentifier == "00_search_bar" {
                self.prospectSearchField = (cell as CCProspectSearchCell).prospectSearchField
                //This is only called once per layout session and it is safe to reset counts here
                contactsCount = 0
                notesCount = 0
            }
            if cellIdentifier == "01_coldcall_tools" {
                
            }
            if cellIdentifier == "15_prospect_info" {
                (cell as CCProspectCell).nameLabel.text = userSession.currentBusiness?.name?.uppercaseString
                (cell as CCProspectCell).cityLabel.text = userSession.currentBusiness?.city
            }
            if cellIdentifier == "5_contact" {
                var c = contacts[contactsCount]
                (cell as CCContactCell).contactNameLabel.text = c.fullNameWithTitle()
                ++contactsCount
            }
            if cellIdentifier == "7_new_note" {

            }
            if cellIdentifier == "80_note" {
                println("caching note cell")
                let n = notes[notesCount]
                (cell as CCNoteCell).noteContentLabel.text = n.content
                (cell as CCNoteCell).noteDateLabel.text = Date.toString(n.date!)
                ++notesCount
            }
            if cellIdentifier == "95_outcome" {

            }
            cellCache.append(cell)
            cellHeightsArray()
        }
    }
    
    func prepareBusinessForDisplay(){
        println("String prepareBusinessForDisplay")
        contacts = []
        notes = []
        contactsCount = 0
        notesCount = 0
        println("Through variable resets")
        cellQuantitiesDict["5_contact"] = userSession.currentBusiness?.contacts.count
        //skip notes
        //cellQuantitiesDict["80_note"] = userSession.currentBusiness?.notes.count
        println("set cell Quantities")
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
//        for note in userSession.currentBusiness!.notes {
//            var n = note as Note
//            println("add note")
//            notes.append(n)
//        }
        println("Sorting notes")
//        notes.sort({$0.date?.timeIntervalSinceNow > $1.date?.timeIntervalSinceNow})
        createCellCache()
        
        tableView.reloadData()
    }

}
