//
//  DatepickerAndTimeViewController.swift
//  FullEvents
//
//  Created by user on 25/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol DataPassingDelegate {
    func passData(date: Date)
}

class DatepickerAndTimeViewController: UIViewController {
    
    var delegate: DataPassingDelegate?
    
    @IBOutlet weak var datepicker: UIDatePicker!
    var selectedDate: Date?
    var minimumDate: Date?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        datepicker.minimumDate = minimumDate
        datepicker.date = selectedDate ?? Date()
    }
    
    @IBAction func hideDatePicker(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)

    }
   
    @IBAction func doneButton(_ sender: UIButton) {
        let date = datepicker.date
        delegate?.passData(date: date)
        self.dismiss(animated: true, completion: nil)
    }
 
    

}
