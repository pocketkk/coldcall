//
//  SeedData.swift
//  coldcall
//
//  Created by Jason Crump on 7/5/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData

class SeedData {

    class func seedAll(num: Int) {

        let number = num as Int
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext

        for index in 1...num {
            var myGroup = Group.newObject() as Group
            myGroup.name = "Group \(index)"
            myGroup.id = "12345\(index)"
            var me = User.newObject() as User
            me.firstName = "First\(index)"
            me.lastName = "Last\(index)"
            myGroup.addUser(me)
            var bNote = Note.newObject() as Note
            var b2Note = Note.newObject() as Note
            bNote.content = "Business Note \(index)"
            b2Note.content = "Second Business Note \(index)"
            var cNote = Note.newObject() as Note
            cNote.content = "Contact Note \(index)"
            var ccNote = Note.newObject() as Note
            ccNote.content = "ColdCall Note \(index)"
            var contact = Contact.newObject() as Contact
            contact.firstName = "Paul \(index)"
            contact.lastName = "Dean \(index)"
            contact.title = "Executive Chef"
            contact.phone = "(503) 555-254\(index)"
            contact.email = "dean\(index)@email.com"
            contact.addNote(cNote)
            var contact2 = Contact.newObject() as Contact
            contact2.firstName = "Paula \(index)"
            contact2.lastName = "Deana \(index)"
            contact2.title = "Executive Chief"
            contact2.phone = "(503) 555-254\(index)"
            contact2.email = "deana\(index)@email.com"
            var business = Business.newObject() as Business
            business.city = "Oakland"
            business.name = "Chipotle \(index)"
            business.street = "1345\(index) Main Street"
            business.state = "CA"
            business.phone = "555-123-123\(index)"
            business.addNote(bNote)
            business.addNote(b2Note)
            business.addContact(contact)
            business.addContact(contact2)
            var cc = ColdCall.newObject() as ColdCall
            cc.user = me
            cc.business = business
            cc.note = ccNote
            appDel.cdh.saveContext()
        }
    }

}
