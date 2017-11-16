//
//  EventCoredataService.swift
//  FullEvents
//
//  Created by user on 09/11/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import UIKit
class EventService {
    
    class func saveDetails(eventDetails: EventInfo, day: String) {
        
        let event = container.viewContext.events.create()
        
        event.eventName = eventDetails.eventName
        event.eventDescrip = eventDetails.eventDescription
        
        guard let startDate = eventDetails.eventStartDate else {
            return
        }
        let startDateInLms = Int64((startDate.timeIntervalSince1970)*1000)
        event.startDate = startDateInLms
        
        guard let endDate = eventDetails.eventEndDate else {
            return
        }
        let endDateInLms = Int64((endDate.timeIntervalSince1970)*1000)
        event.endDate = endDateInLms
        
        event.duration = Int16(eventDetails.eventDuration)
        event.userIds = eventDetails.eventContactIds as [String]
        event.streamIds = eventDetails.eventStreamIds as [String]
        event.day = day
        event.eventId =  UUID().uuidString

        if let reminderTime = eventDetails.eventReminderTime {
            event.remindBefore = Int16(reminderTime)
        }
        
        do {
            try container.viewContext.save()
            if let reminderTime = eventDetails.eventReminderTime {
                if let reminderDate =  eventDetails.eventStartDate?.addingTimeInterval(TimeInterval(-60 * reminderTime)) {
                    NotificationHelper.scheduleNotification(at: reminderDate, event: eventDetails, eventId: event.eventId)
                }
                
            }
        }
            
        catch{
            print("Error:",error)
        }
    }
}
