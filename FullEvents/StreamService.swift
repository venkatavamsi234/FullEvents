//
//  StreamService.swift
//  FullEvents
//
//  Created by user on 19/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import SwiftyJSON


class StreamService {
    
    class func savingStreams(streamsJson: JSON) {
        
        for streamJson in streamsJson.arrayValue{
            
            let stream = container.viewContext.streams.create()
            
            stream.createdAt = streamJson["createdAt"].int64Value
            stream.desc = streamJson["desc"].string ?? ""
            stream.id = streamJson["id"].stringValue
            stream.modifiedAt = streamJson["modifiedAt"].int64Value
            let trimName = streamJson["name"].stringValue
            stream.name = trimName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            stream.status = streamJson["status"].stringValue
            stream.public = streamJson["public"].bool ?? false
            stream.members = streamJson["members"].arrayObject as! [NSString]
            
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
    
    class  func getContactObjectsUsingId(contactId: Array<String>) -> [UserStreams] {
        var user = [UserStreams]()
        let contactName = container.viewContext.streams
        for contact in contactId {
            if let userObject = contactName.first(where: {$0.id == contact}) {
                user.append(userObject)
            }
        }
        return user
    }
    
}
