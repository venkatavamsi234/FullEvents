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
    @IBOutlet weak var stream: UILabel!
    
    var eventInfo: EventInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Event Details"
        eventName.text = eventInfo?.eventName
        eventDescription.text = eventInfo?.eventDescription
        startDate.text = eventInfo?.eventStartDate
        endDate.text = eventInfo?.eventEndDate
        stream.text = eventInfo?.eventStream[0]
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 && indexPath.row == 0 {
            if let contactsViewController = storyboard?.instantiateViewController(withIdentifier: "SelectedContactsTableViewController") as? SelectedContactsTableViewController {
                if let eventContacts = eventInfo?.eventContacts {
                    contactsViewController.contacts = eventContacts
                }
            navigationController?.pushViewController(contactsViewController, animated: true)
            }
        }
    }
    }

