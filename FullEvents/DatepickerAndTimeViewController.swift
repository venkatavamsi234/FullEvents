//
//  DatepickerAndTimeViewController.swift
//  FullEvents
//
//  Created by user on 25/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol DataPassingDelegate {
    func passData(date: String)
}

class DatepickerAndTimeViewController: UIViewController {
    
    var delegate: DataPassingDelegate?
    
    @IBOutlet weak var datepicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func hideDatePicker(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)

    }
   
    
    
    @IBAction func doneButton(_ sender: UIButton) {
        
        let date = datepicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd-yyyy hh:mm a"
        let dateString = dateFormatter.string(from: date)
        delegate?.passData(date: dateString)
        self.dismiss(animated: true, completion: nil)

    }
 
    

}
