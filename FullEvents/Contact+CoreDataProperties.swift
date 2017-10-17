//
//  Contact+CoreDataProperties.swift
//  FullEvents
//
//  Created by user on 17/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import CoreData


extension Contact {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }
    
    @NSManaged public var status: String?
    @NSManaged public var id: String?
    @NSManaged public var modifiedAt: Int64
    @NSManaged public var bot: Bool
    @NSManaged public var photoId: String?
    @NSManaged public var createdAt: Int64
    @NSManaged public var name: String?
    @NSManaged public var title: String?
    @NSManaged public var accountId: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var login: String?
    
    
}
