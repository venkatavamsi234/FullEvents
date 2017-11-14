//
//  EventDateTableViewController.swift
//  FullEvents
//
//  Created by user on 27/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol PassingDatesDelegate {
    func passingDates(startDate: Date , endDate: Date)
    func passTime(time: Int)
}

class EventDateTableViewController: UITableViewController, DatePassingDelegate, SendingTimeDelegate {
    
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var chooseDateLabel: UIButton!
    @IBOutlet weak var endDateLabel: UIButton!
    @IBOutlet weak var eventReminder: UIButton!
    
    var eventDateDelegate: PassingDatesDelegate?
    var eventDates: EventInfo?
    
    enum DateMode: String {
        case startDate
        case endDate
    }
    
    var dateMode: DateMode = .startDate
    var datePickerViewController:DatepickerAndTimeViewController?
    var chosedStartDate: Date?, chosedEndDate: Date?
    var dateString = String()
    var AddingMinToCurrentDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        if let eventStartDate = eventDates?.eventStartDate {
          let startDate = dateConversionToString(date: eventStartDate)
            chooseDateLabel.setTitle(startDate, for: .normal)
            chosedStartDate = eventStartDate
        }
        
        if let eventEndDate = eventDates?.eventEndDate {
            let endDate = dateConversionToString(date: eventEndDate)
            endDateLabel.setTitle(endDate, for: .normal)
            chosedEndDate = eventEndDate
        }
        
        if let time = eventDates?.eventReminderTime {
            eventReminder.setTitle(("\(time)" + " mins"), for: .normal)
        }
        
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
        let minutes = Calendar.current.component(.minute, from: Date())
        let remainder = minutes%5
        if remainder != 0 {
            let timeToAdd = 5 - remainder
            AddingMinToCurrentDate = Date().addingTimeInterval(TimeInterval(timeToAdd * 60))
        }
        datePickerViewController.minimumDate =  chosedStartDate ?? (AddingMinToCurrentDate ?? Date())
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
                if choosenDate > startDate {
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
    
 
    func sendTime(time: Int) {
       let timeString = "\(time)" + " mins"
        eventReminder.setTitle(timeString, for: .normal)
        eventDates?.eventReminderTime = time
        print(time)
       eventDateDelegate?.passTime(time:time)
    
    }
    
    @IBAction func presentRemainderTableViewController(_ sender: UIButton) {
        
        guard let eventRemainderVC = storyboard?.instantiateViewController(withIdentifier: "EventRemainderTableViewController") as? EventRemainderTableViewController else {
            return
        }
        
        eventRemainderVC.eventReminder = self
        if let reminderTime = eventDates?.eventReminderTime {
            eventRemainderVC.selectedTime = reminderTime
        }
        let navController = UINavigationController(rootViewController: eventRemainderVC)
        self.present(navController, animated:true, completion: nil)
    }

    @IBAction func redirectingToContactsAndStreamsVC(_ sender: UIBarButtonItem) {
        
        if (chosedStartDate != nil) && chosedEndDate != nil {
            eventDateDelegate?.passingDates(startDate: chosedStartDate! , endDate: chosedEndDate!)
            guard let contactsAndStreamsViewController = storyboard?.instantiateViewController(withIdentifier: "ContactsAndStreamsViewController") as? ContactsAndStreamsViewController else {
                return
            }
            if let parent = navigationController?.parent as? EventBaseViewController {
                contactsAndStreamsViewController.eventIdsDelegate = parent
                contactsAndStreamsViewController.event = parent.event
            }
            navigationController?.pushViewController(contactsAndStreamsViewController, animated: true)
            
            
        } else {
            let alert = UIAlertController(title: "", message: "Start date and end date is required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
}
