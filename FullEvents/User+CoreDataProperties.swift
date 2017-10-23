//
//  User+CoreDataProperties.swift
//  FullEvents
//
//  Created by user on 19/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var status: String
    @NSManaged public var lastName: String
    @NSManaged public var accountId: String
    @NSManaged public var firstName: String
    @NSManaged public var id: String
    @NSManaged public var modifiedAt: Int64
    @NSManaged public var bot: Bool
    @NSManaged public var createdAt: Int64
    @NSManaged public var photoId: String
    @NSManaged public var login: String
    @NSManaged public var title: String

}
