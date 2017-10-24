//
//  UserStreams+CoreDataProperties.swift
//  FullEvents
//
//  Created by user on 19/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import CoreData


extension UserStreams {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserStreams> {
        return NSFetchRequest<UserStreams>(entityName: "UserStreams")
    }

    @NSManaged public var desc: String
    @NSManaged public var acctId: String
    @NSManaged public var status: String
    @NSManaged public var `public`: Bool
    @NSManaged public var id: String
    @NSManaged public var modifiedAt: Int64
    @NSManaged public var members: [NSString]
    @NSManaged public var createdAt: Int64
    @NSManaged public var name: String

}
