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
    
    var eventInfo: EventInfo?
    var totolCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Event Details"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        eventName.text = eventInfo?.eventName
        eventDescription.text = eventInfo?.eventDescription
        startDate.text = eventInfo?.eventStartDate
        endDate.text = eventInfo?.eventEndDate
        attendeeCount.text = "\(totolCount)"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
          navigationController?.popToViewController((navigationController?.viewControllers[0])!, animated: true)
        case (0,1):
            navigationController?.popToViewController((navigationController?.viewControllers[0])!, animated: true)
        case (1,0):
            navigationController?.popToViewController((navigationController?.viewControllers[1])!, animated: true)
        case (1,1):
            navigationController?.popToViewController((navigationController?.viewControllers[1])!, animated: true)
        case (2,0):
            if let contactsViewController = storyboard?.instantiateViewController(withIdentifier: "SelectedContactsTableViewController") as? SelectedContactsTableViewController {
                if let eventContacts = eventInfo?.eventContacts, eventContacts != [] {
                    contactsViewController.contacts = eventContacts
                    navigationController?.pushViewController(contactsViewController, animated: true)
                }
            }
        default:
            break
        }
        
    }
}

