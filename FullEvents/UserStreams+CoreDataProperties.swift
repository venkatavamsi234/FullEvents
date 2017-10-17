//
//  UserStreams+CoreDataProperties.swift
//  
//
//  Created by user on 17/10/17.
//
//

import Foundation
import CoreData


extension UserStreams {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserStreams> {
        return NSFetchRequest<UserStreams>(entityName: "UserStreams")
    }

    @NSManaged public var status: String?
    @NSManaged public var id: String?
    @NSManaged public var modifiedAt: Int64
    @NSManaged public var `public`: Bool
    @NSManaged public var members: NSObject?
    @NSManaged public var createdAt: Int64
    @NSManaged public var name: String?
    @NSManaged public var desc: String?

}
