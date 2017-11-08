//
//  DatepickerAndTimeViewController.swift
//  FullEvents
//
//  Created by user on 25/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol DatePassingDelegate {
    func passData(choosenDate: Date)
}

class DatepickerAndTimeViewController: UIViewController {
    
    var delegate: DatePassingDelegate?
    
    @IBOutlet weak var datepicker: UIDatePicker!
    var selectedDate: Date?
    var minimumDate: Date?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        datepicker.minimumDate = minimumDate
        datepicker.date = selectedDate ?? minimumDate ?? Date()
        
        datepicker.minuteInterval = 5
    }
    
    @IBAction func hideDatePicker(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)

    }
   
    @IBAction func doneButton(_ sender: UIButton) {
        let date = datepicker.date
        delegate?.passData(choosenDate: date)
        self.dismiss(animated: true, completion: nil)
    }
 
    

}
