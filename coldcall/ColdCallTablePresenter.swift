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
    
    let cellTypesOrder : [String] = [
        "00_search_bar",
        "01_coldcall_tools",
        "10_prospect_header",
        "15_prospect_info",
        "3_contacts_header",
        "5_contact",
        "6_notes_header",
        "7_new_note",
        "8_note"
    ]
    
    let cellHeightsArr : [CGFloat] = [
        35.0,     // search bar
        35.0,     // tools header
        25.0,     // prospect header
        80.0,     // prospect
        35.0,     // contacts header
        25.0,     // contact
        35.0,     // notes header
        40.0,     // new note
        25.0      // note
    ]
    
    var cellQuantitiesDict : [String: Int] = [
        "00_search_bar": 1,
        "01_coldcall_tools": 1,
        "10_prospect_header": 1,
        "15_prospect_info": 1,
        "3_contacts_header": 1,
        "5_contact": 0,
        "6_notes_header": 1,
        "7_new_note": 1,
        "8_note": 0
    ]

    init(tableView: UITableView){
        super.init()
        self.tableView = tableView
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
        cellCache = []
        let cellsToCreate = cellTypesArray()
        for cellIdentifier in cellsToCreate {
            var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell

            if cellIdentifier == "00_search_bar" {

            }
            if cellIdentifier == "1_new_prospect_tools" {
                
            }
            if cellIdentifier == "2_new_prospect" {

            }
            if cellIdentifier == "4_new_contact" {

            }
            if cellIdentifier == "5_contact" {

            }
            if cellIdentifier == "7_new_note" {

            }
            if cellIdentifier == "8_note" {

            }
            cellCache.append(cell)
            cellHeightsArray()
        }
    }

}
