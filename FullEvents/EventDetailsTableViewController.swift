//
//  EventDetailsTableViewController.swift
//  FullEvents
//
//  Created by user on 01/11/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol EventDetailsVCDelegate {
    func clickOnBackButton()
}

class EventDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var attendeeCount: UILabel!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var reminderTime: UILabel!
    @IBOutlet weak var leftBarbutton: UIBarButtonItem!
    
    var eventInfo: EventInfo?
    var contactAttendees = [String]()
    var typeOfFlow:flowType?
    var popVCDelegate: EventDetailsVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if typeOfFlow == .create {
        rightBarButton.title = "Create"
        leftBarbutton.title = nil
        } else {
            rightBarButton.title = "Save"
            leftBarbutton.title = "Back"
        }
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Event Details"
        
        self.navigationController?.navigationItem.title = "Event Details"
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        eventName.text = eventInfo?.eventName
        eventDescription.text = eventInfo?.eventDescription
        
        if let date = eventInfo?.eventStartDate {
            let eventStartDate = dateConversionToString(date: date)
            startDate.text = eventStartDate
        }
        
        if let date = eventInfo?.eventEndDate {
            let eventEndDate = dateConversionToString(date: date)
            endDate.text = eventEndDate
        }
        
        reminderTime.text = "\(eventInfo?.eventReminderTime ?? 0)" + " minutes"
        
        attendeeCount.text = "\(eventInfo?.attendeeCount ?? 0)"
        
        if let attendees = eventInfo?.eventContactIds {
            contactAttendees = attendees
        }
    }
    
    func dateConversionToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"
        return dateFormatter.string(from: date)
        
    }
    
    
    func dateObjectConversionToDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter.string(from: date)
        
    }
    
    func redirectToSelectedViewController(action: UIAlertAction) {
        guard let contactsViewController = storyboard?.instantiateViewController(withIdentifier: "SelectedContactsTableViewController") as? SelectedContactsTableViewController else {
            return
        }
            if contactAttendees != [] {
                contactsViewController.attendees = contactAttendees
                navigationController?.pushViewController(contactsViewController, animated: true)
            }
    }
    
    func redirectToContactsAndStreamsViewController(action: UIAlertAction) {
        guard let eventContactsVC = storyboard?.instantiateViewController(withIdentifier: "ContactsAndStreamsViewController") as? ContactsAndStreamsViewController else {
            return
        }
        guard let parent = navigationController?.parent as? EventBaseViewController else {
            return
        }
        eventContactsVC.eventIdsDelegate = parent
        eventContactsVC.event = eventInfo
        eventContactsVC.typeOfFlow = typeOfFlow
        navigationController?.pushViewController(eventContactsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    
        switch (indexPath.section) {
            
        case (0):
            guard let eventNameVC = storyboard?.instantiateViewController(withIdentifier: "EventNameTableViewController") as? EventNameTableViewController else {
                return
            }
            guard let parent = navigationController?.parent as? EventBaseViewController else {
                return
            }
            eventNameVC.eventNameDelegate = parent
            eventNameVC.eventInfo = eventInfo
            eventNameVC.typeOfFlow = typeOfFlow
            navigationController?.pushViewController(eventNameVC, animated: true)
            
            
        case (1):
            guard let eventDateVC = storyboard?.instantiateViewController(withIdentifier: "EventDateTableViewController") as? EventDateTableViewController else {
                return
            }
            guard let parent = navigationController?.parent as? EventBaseViewController else {
                return
            }
            eventDateVC.eventDateDelegate = parent
            eventDateVC.eventInfo = eventInfo
            eventDateVC.typeOfFlow = typeOfFlow
            navigationController?.pushViewController(eventDateVC, animated: true)
            
        case (2):
            
            let alert = UIAlertController(title: "", message: "Choose the preferred one", preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.addAction(UIAlertAction(title: "View", style: UIAlertActionStyle.default, handler: redirectToSelectedViewController))
            alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler: redirectToContactsAndStreamsViewController))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
     popVCDelegate?.clickOnBackButton()
    }
    
    
    
    
    @IBAction func createEvent(_ sender: UIBarButtonItem) {
        
        guard let eventData = eventInfo else {
            return
        }
        
        guard let eventday = eventInfo?.eventStartDate else {
            return
        }
        
        let eventStartday = dateObjectConversionToDay(date: eventday)
        
        if typeOfFlow == .create {
        EventService.saveDetails(eventDetails: eventData, day: eventStartday)
            typeOfFlow = .edit
        } else {
            
        }
        self.dismiss(animated: true, completion: nil)
        
    }
}







