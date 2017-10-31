//
//  EventDateTableViewController.swift
//  FullEvents
//
//  Created by user on 27/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class EventDateTableViewController: UITableViewController, DataPassingDelegate {
    
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var chooseDateLabel: UIButton!
    @IBOutlet weak var endDateLabel: UIButton!
    
    enum DateMode: String {
        case startDate
        case endDate
    }

    var dateMode: DateMode = .startDate
    var datePickerViewController:DatepickerAndTimeViewController?
    var chosedStartDate: Date?, chosedEndDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Event Date"
    }
    
    
    
    func presentDatePicker() {
        guard let datePickerViewController = storyboard?.instantiateViewController(withIdentifier: "DatepickerAndTimeViewController") as? DatepickerAndTimeViewController else {
            return
        }
        
        datePickerViewController.modalPresentationStyle = .overCurrentContext
        datePickerViewController.delegate = self
        datePickerViewController.minimumDate = chosedStartDate ?? Date()
        datePickerViewController.selectedDate = (dateMode == .startDate) ? chosedStartDate : chosedEndDate
        self.present(datePickerViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func chooseDate(_ sender: UIButton) {
        dateMode = .startDate
        presentDatePicker()
    }
    
    
    func passData(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd-yyyy hh:mm a"
        let dateString = dateFormatter.string(from: date)
        switch dateMode {
        case .startDate:
            chooseDateLabel.setTitle(dateString, for: .normal)
            chosedStartDate = date
        case .endDate:
            chosedEndDate = date
            endDateLabel.setTitle(dateString, for: .normal)
        }
    }
    
    @IBAction func endDate(_ sender: UIButton) {
        dateMode = .endDate
        presentDatePicker()
    }
    
    @IBAction func redirectingToContactsAndStreamsVC(_ sender: UIBarButtonItem) {
        guard let peersViewController = storyboard?.instantiateViewController(withIdentifier: "PeersViewController") as? PeersViewController else {
            return
        }
        navigationController?.pushViewController(peersViewController, animated: true)
    }
    
}
