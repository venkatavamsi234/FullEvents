//
//  EventDetailsTableViewController.swift
//  FullEvents
//
//  Created by user on 01/11/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class EventDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var attendeeCount: UILabel!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    var eventInfo: EventInfo?
    var count = Int()
    var contactAttendees = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightBarButton.title = "Create"
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Event Details"
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
        
        attendeeCount.text = "\(count)"
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
        if let contactsViewController = storyboard?.instantiateViewController(withIdentifier: "SelectedContactsTableViewController") as? SelectedContactsTableViewController {
            if contactAttendees != [] {
                contactsViewController.attendees = contactAttendees
                navigationController?.pushViewController(contactsViewController, animated: true)
            }
        }
    }
    
    func redirectToContactsAndStreamsViewController(action: UIAlertAction) {
        navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        // (0,0) corresponds to event name, (0,1) corresponds to event description, (1,0) corresponds to start date, (1,1) corresponds to end date.
        case (0,0):
            navigationController?.popToViewController((navigationController?.viewControllers[0])!, animated: true)
        case (0,1):
            navigationController?.popToViewController((navigationController?.viewControllers[0])!, animated: true)
        case (1,0):
            navigationController?.popToViewController((navigationController?.viewControllers[1])!, animated: true)
        case (1,1):
            navigationController?.popToViewController((navigationController?.viewControllers[1])!, animated: true)
        case (2,0):
            
            let alert = UIAlertController(title: "", message: "Choose the preferred one", preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.addAction(UIAlertAction(title: "View", style: UIAlertActionStyle.default, handler: redirectToSelectedViewController))
            alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler: redirectToContactsAndStreamsViewController))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    @IBAction func createEvent(_ sender: UIBarButtonItem) {
        
        guard let eventData = eventInfo else {
            return
        }
        
        guard let eventday = eventInfo?.eventStartDate else {
            return
        }
        
        let eventStartday = dateObjectConversionToDay(date: eventday)
        
        EventService.saveDetails(eventDetails: eventData, day: eventStartday)
        
        self.dismiss(animated: true, completion: nil)
        
    }
}







