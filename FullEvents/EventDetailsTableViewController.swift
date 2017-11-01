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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Event Details"
    }
    
    
}
