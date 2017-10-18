//
//  Contact+CoreDataClass.swift
//
//
//  Created by user on 17/10/17.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Contact)
public class Contact: NSManagedObject {
    
    class func savingContacts(contactsJson: JSON) {
        
        let context = CoreDataHelper.persistentContainer.viewContext
        let contact = Contact(context: context)
        
        for contactJson in contactsJson.arrayValue {
            
            contact.accountId = contactJson["accountId"].stringValue
            contact.bot = contactJson["bot"].boolValue
            contact.createdAt = contactJson["createdAt"].int64Value
            contact.firstName = contactJson["firstName"].stringValue
            contact.id = contactJson["id"].stringValue
            contact.lastName = contactJson["lastName"].stringValue
            contact.login = contactJson["login"].stringValue
            contact.modifiedAt = contactJson["modifiedAt"].int64Value
            contact.photoId = contactJson["photoId"].stringValue
            contact.status = contactJson["status"].stringValue
            contact.title = contactJson["title"].stringValue
            
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            CoreDataHelper.saveContext()
            
        }
        
    }
    
    
}
