//
//  EventBaseViewController.swift
//  FullEvents
//
//  Created by user on 26/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class EventBaseViewController: UIViewController, PassingEventNameAndEventDescriptionDelegate, PassingDatesDelegate, PassingContactsAndStreamsDelegate {
    
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
    
    func passingDates(startDate: String, endDate: String) {
       event?.eventStartDate = startDate
        event?.eventEndDate = endDate
    }
    
    func PassingContacts(contacts: Array<String>) {
        event?.eventContacts = contacts
    }
    
    func PassingStreams(stream: Array<String>) {
        event?.eventStream = stream
    }

}

struct EventInfo {
    var eventName: String = ""
    var eventDescription: String = ""
    var eventStartDate: String = ""
    var eventEndDate: String = ""
    var eventContacts: Array<String> = []
    var eventStream: Array<String> = []
}
