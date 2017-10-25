//
//  Event+CoreDataProperties.swift
//  FullEvents
//
//  Created by user on 25/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var eventName: String?
    @NSManaged public var date: Int64
    @NSManaged public var time: Int64
    @NSManaged public var content: String?
    @NSManaged public var greetings: String?
    @NSManaged public var remindBefore: Int64
    @NSManaged public var eventRepeating: NSObject?

}
