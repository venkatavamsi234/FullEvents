//
//  NotificationHelper.swift
//  FullEvents
//
//  Created by user on 14/11/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import UserNotifications


class NotificationHelper {
    
    class func scheduleNotification(at date: Date, event: EventInfo, eventId: String) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = event.eventName.capitalized
        guard let reminderTime = event.eventReminderTime else {
            return
        }
        content.body = "you have an event in \(reminderTime) minutes"
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: eventId, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("We had an error: \(error)")
            }
        }
    }

}
