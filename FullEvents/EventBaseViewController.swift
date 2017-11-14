//
//  EventBaseViewController.swift
//  FullEvents
//
//  Created by user on 26/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class EventBaseViewController: UIViewController, PassingEventNameAndEventDescriptionDelegate, PassingDatesDelegate, PassingIdsDelegate {
    
    var event:EventInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        event = EventInfo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NavController" {
            guard let navVC = segue.destination as? UINavigationController else {
                return
            }
            
            guard let evenNameVC = navVC.viewControllers[0] as? EventNameTableViewController else {
                return
            }
            evenNameVC.eventNameDelegate = self
        }
    }
    
    
    func PassingEventNameAndEventDescription(eventName: String, eventDescription: String?) {
        event?.eventName = eventName
        if let eventDesc = eventDescription {
            event?.eventDescription = eventDesc
        }
    }
    
    func passingDates(startDate: Date, endDate: Date) {
        event?.eventStartDate = startDate
        event?.eventEndDate = endDate
        
        let dateComponents = Calendar.current.dateComponents([.minute], from: startDate, to: endDate)
        if let duration = dateComponents.minute {
            event?.eventDuration = duration
        }
        
    }
    
    func passTime(time: Int) {
        event?.eventReminderTime = time
    }
    
    func passUserIds(userIds: Array<String>) {
        event?.eventContactIds = userIds
    }
    
    func passStreamIds(streamIds: Array<String>) {
        event?.eventStreamIds = streamIds
    }
    
}

struct EventInfo {
    var eventName: String = ""
    var eventDescription: String = ""
    var eventStartDate: Date?
    var eventEndDate: Date?
    var eventContactIds:[String] = []
    var eventStreamIds:[String] = []
    var eventDuration:Int = 0
    var eventReminderTime: Int?
}
