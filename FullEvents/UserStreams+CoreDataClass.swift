//
//  UserStreams+CoreDataClass.swift
//
//
//  Created by user on 17/10/17.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(UserStreams)
public class UserStreams: NSManagedObject {
    
    class func savingStreams(streamsJson: JSON) {
        
        let context = CoreDataHelper.persistentContainer.viewContext
        let stream = UserStreams(context: context)
        
        for streamJson in streamsJson.arrayValue{
            
            stream.createdAt = streamJson["createdAt"].int64Value
            stream.desc = streamJson["desc"].stringValue
            stream.id = streamJson["id"].stringValue
            stream.modifiedAt = streamJson["modifiedAt"].int64Value
            stream.name = streamJson["name"].stringValue
            stream.status = streamJson["status"].stringValue
            stream.public = streamJson["public"].boolValue
            stream.members = streamJson["members"].arrayObject as NSObject?
            
            
//            func encode(with aCoder: NSCoder) {
//                 let members = streamJson["members"].arrayValue
//                    aCoder.encode(members, forKey: "members")
//            }
//            
            
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            CoreDataHelper.saveContext()
            
            
        }
        
    }
}
