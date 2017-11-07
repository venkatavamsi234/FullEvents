//
//  EventDateTableViewController.swift
//  FullEvents
//
//  Created by user on 27/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol PassingDatesDelegate {
    func passingDates(startDate: String, endDate: String)
}

class EventDateTableViewController: UITableViewController, DatePassingDelegate {
    
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var chooseDateLabel: UIButton!
    @IBOutlet weak var endDateLabel: UIButton!
    
    var eventDateDelegate: PassingDatesDelegate?
    
    enum DateMode: String {
        case startDate
        case endDate
    }
    
    var dateMode: DateMode = .startDate
    var datePickerViewController:DatepickerAndTimeViewController?
    var chosedStartDate: Date?, chosedEndDate: Date?
    var dateString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Event Date"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    
    
    func presentDatePicker() {
        guard let datePickerViewController = storyboard?.instantiateViewController(withIdentifier: "DatepickerAndTimeViewController") as? DatepickerAndTimeViewController else {
            return
        }
        datePickerViewController.modalPresentationStyle = .overCurrentContext
        datePickerViewController.delegate = self
        datePickerViewController.minimumDate =  chosedStartDate ?? Date()
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
    
    func dateConversionToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"
        return dateFormatter.string(from: date)
        
    }
    
    
    func passData(choosenDate: Date) {
        dateString = dateConversionToString(date: choosenDate)
        switch dateMode {
        case .startDate:
            if  let selectedEndDate = chosedEndDate {
                if choosenDate < selectedEndDate {
                    chooseDateLabel.setTitle(dateString, for: .normal)
                    chosedStartDate = choosenDate
                } else {
                    let alert = UIAlertController(title: "", message: "Start date cannot be greater than end date", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)))
                    self.present(alert, animated: true, completion: nil)
                }
            }  else {
                chooseDateLabel.setTitle(dateString, for: .normal)
                chosedStartDate = choosenDate
            }
            
        case .endDate:
            if let startDate = chosedStartDate {
                print(startDate)
            if choosenDate > startDate {
                print(choosenDate)
            chosedEndDate = choosenDate
            endDateLabel.setTitle(dateString, for: .normal)
            } else {
                let alert = UIAlertController(title: "", message: "End date should be greater than start date", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func endDate(_ sender: UIButton) {
        guard chosedStartDate != nil else {
            let alert = UIAlertController(title: "", message: "Start date is required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)))
            self.present(alert, animated: true, completion: nil)
            return
        }
        dateMode = .endDate
        presentDatePicker()
    }
    
    @IBAction func redirectingToContactsAndStreamsVC(_ sender: UIBarButtonItem) {
        
        if (chosedStartDate != nil) && chosedEndDate != nil {
            let startDateString = dateConversionToString(date: chosedStartDate!),  endDateString = dateConversionToString(date: chosedEndDate!)
            eventDateDelegate?.passingDates(startDate: startDateString , endDate: endDateString)
            guard let contactsAndStreamsViewController = storyboard?.instantiateViewController(withIdentifier: "ContactsAndStreamsViewController") as? ContactsAndStreamsViewController else {
                return
            }
            
            navigationController?.pushViewController(contactsAndStreamsViewController, animated: true)
            
            
        } else {
            let alert = UIAlertController(title: "", message: "Start date and end date is required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
