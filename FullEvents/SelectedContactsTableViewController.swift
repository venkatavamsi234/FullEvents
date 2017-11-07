//
//  SelectedContactsTableViewController.swift
//  FullEvents
//
//  Created by user on 02/11/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class SelectedContactsTableViewController: UITableViewController {
    
    var contacts = [String]()
    var attendeeNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
         attendeeNames = UserService.getContactUsingId(contactId: contacts)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        title =    "Selected contacts"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendeeNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventName", for: indexPath)
        cell.textLabel?.text = attendeeNames[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
