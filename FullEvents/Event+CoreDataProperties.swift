//
//  Event+CoreDataProperties.swift
//  
//
//  Created by user on 27/10/17.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var eventDescrip: String?
    @NSManaged public var startDate: Int64
    @NSManaged public var eventName: String
    @NSManaged public var `repeat`: NSObject?
    @NSManaged public var remindBefore: Int64
    @NSManaged public var streamIds: [String]?
    @NSManaged public var duration: Int16
    @NSManaged public var userIds: [String]
    @NSManaged public var endDate: Int64
    @NSManaged public var day: String

}
