//
//  UserService.swift
//  FullEvents
//
//  Created by user on 19/10/17.
//  Copyright © 2017 user. All rights reserved.
//
//
import Foundation
import AlecrimCoreData
import CoreData
import SwiftyJSON

class UserService {
    
    
    class func savingUserData(usersJson: JSON) {
        
        
        for userJson in usersJson.arrayValue {
            
            let user = container.viewContext.users.create()
            
            user.accountId = userJson["accountId"].stringValue
            user.bot = userJson["bot"].bool ?? false
            user.createdAt = userJson["createdAt"].int64Value
            let trimFirstName = userJson["firstName"].stringValue
            user.firstName = trimFirstName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            user.id = userJson["id"].stringValue
            user.lastName = userJson["lastName"].string ?? ""
            user.login = userJson["login"].stringValue
            user.modifiedAt = userJson["modifiedAt"].int64Value
            user.photoId = userJson["photoId"].string ?? ""
            user.status = userJson["status"].stringValue
            user.title = userJson["title"].string ?? ""
            
        }
        
        func save(){
            
            do {
                
                try container.viewContext.save()
            }
                
            catch{
                
                print("Error:",error)
            }
        }
        
        save()
        
    }
    
    class  func getContactObjectsUsingId(contactId: Array<String>) -> [User] {
        var user = [User]()
        let contactName = container.viewContext.users
        for contact in contactId {
            if let userObject = contactName.first(where: {$0.id == contact}) {
                user.append(userObject)
            }
        }
        return user
    }
}


