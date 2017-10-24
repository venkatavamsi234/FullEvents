//
//  EventsTableViewController.swift
//  FullEvents
//
//  Created by user on 24/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.frame = CGRect(x: 0, y: 0, width: 375, height: 60)
        navigationBar.topItem?.title = "Create Meeting"
    }



}
