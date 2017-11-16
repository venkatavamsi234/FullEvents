//
//  EventBaseViewController.swift
//  FullEvents
//
//  Created by user on 26/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class EventBaseViewController: UIViewController, PassingEventNameAndEventDescriptionDelegate, PassingDatesDelegate, PassingIdsDelegate, EventDetailsVCDelegate{
    
    var event: EventInfo? = EventInfo()
    var navVC: UINavigationController?
    var eventObject: Event?
    var typeOfFlow: flowType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NavController" {
            
            guard let navVC = segue.destination as? UINavigationController else {
                return
            }
            
            if typeOfFlow == .create {
                guard let eventNameView = storyboard?.instantiateViewController(withIdentifier: "EventNameTableViewController") as? EventNameTableViewController else {
                    return
                }
                
                eventNameView.eventNameDelegate = self
                eventNameView.typeOfFlow = .create
                navVC.setViewControllers([eventNameView], animated: true)
                
            } else {
                
                guard let eventDetails = storyboard?.instantiateViewController(withIdentifier: "EventDetailsTableViewController") as? EventDetailsTableViewController else {
                    return
                }
                if let name = eventObject?.eventName, let startDate = eventObject?.startDate, let endDate = eventObject?.endDate, let attendeesCount = eventObject?.userIds.count, let reminderTime = eventObject?.remindBefore, let attendees = eventObject?.userIds, let streams = eventObject?.streamIds {
                    event?.eventName = name
                    let startDate = Date(timeIntervalSince1970: (Double((startDate)) / 1000.0))
                    let endDate = Date(timeIntervalSince1970: (Double((endDate)) / 1000.0))
                    event?.eventStartDate = startDate
                    event?.eventEndDate = endDate
                    event?.attendeeCount = attendeesCount
                    event?.eventReminderTime = Int(reminderTime)
                    event?.eventContactIds = attendees
                    event?.eventStreamIds = streams
                }
                eventDetails.eventInfo = event
                eventDetails.typeOfFlow = .edit
                navVC.setViewControllers([eventDetails], animated: true)
                eventDetails.popVCDelegate = self
            }
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
        event?.attendeeCount = userIds.count
    }
    
    func passStreamIds(streamIds: Array<String>) {
        event?.eventStreamIds = streamIds
    }
    
    func clickOnBackButton() {
       navigationController?.popToRootViewController(animated: true)
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
    var attendeeCount:Int = 0
}
