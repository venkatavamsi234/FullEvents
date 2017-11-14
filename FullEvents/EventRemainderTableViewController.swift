//
//  EventRemainderTableViewController.swift
//  FullEvents
//
//  Created by user on 13/11/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol SendingTimeDelegate {
    func sendTime(time: Int)
}

class EventRemainderTableViewController: UITableViewController {
    
    let remainderTime = [5, 10, 15, 30, 60, 120]
    var eventReminder: SendingTimeDelegate? = nil
    var selectedTime = Int()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        putCheckMark()
    }

    func putCheckMark() {
        if let index = remainderTime.index(of: selectedTime) {
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
            cell.accessoryType = .checkmark
        }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        switch indexPath.row {
        case 0:
            eventReminder?.sendTime(time: remainderTime[0])
        case 1:
            eventReminder?.sendTime(time: remainderTime[1])
        case 2:
            eventReminder?.sendTime(time: remainderTime[2])
        case 3:
            eventReminder?.sendTime(time: remainderTime[3])
        case 4:
            eventReminder?.sendTime(time: remainderTime[4])
        case 5:
            eventReminder?.sendTime(time: remainderTime[5])
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func dismissEventReminderVc(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }


}
