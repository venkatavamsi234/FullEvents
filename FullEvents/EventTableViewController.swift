//
//  EventsTableViewController.swift
//  FullEvents
//
//  Created by user on 24/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController, UITextFieldDelegate, DataPassingDelegate{
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet weak var DateAndTime: UITextField!
    
    @IBOutlet weak var Duration: UITextField!
    
    @IBOutlet weak var Description: UITextField!
    
    @IBOutlet weak var greetings: UITextField!
    
    @IBOutlet weak var dateAndTimePicker: UIButton!
    
    
    var activeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        dateAndTimePicker.layer.cornerRadius = 5
        dateAndTimePicker.layer.borderWidth = 0.1
        dateAndTimePicker.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60)
        navigationBar.topItem?.title = "Create Event"
        NotificationCenter.default.addObserver(self, selector: #selector(actionKeyboardDidShow(with:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(actionKeyboardWillHide(with:)), name: .UIKeyboardWillHide, object: nil)
        
        func textFieldDidBeginEditing(textField: UITextField) {
            self.activeTextField = textField
        }
        
        func textFieldDidEndEditing(textField: UITextField) {
            self.activeTextField = nil
            
        }
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func actionKeyboardDidShow(with: Notification) {
        let info = with.userInfo as! [String: AnyObject],
        keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        print(contentInsets, type(of: contentInsets))
        var aRect = self.view.frame
        print(aRect)
        aRect.size.height -= keyboardSize.height
        if let text = activeTextField {
            if !aRect.contains(text.frame.origin) {
                self.tableView.scrollRectToVisible(text.frame, animated: true)
            }
        }
        
    }
    
    func actionKeyboardWillHide(with: Notification) {
        let contentInsets = UIEdgeInsets.zero
        print(contentInsets)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        
    }
    
    
    @IBAction func pickingDateAndTime(_ sender: UIButton) {
        
        guard let datePickerViewController = storyboard?.instantiateViewController(withIdentifier: "DatepickerAndTimeViewController") as? DatepickerAndTimeViewController else {
            return
        }
        datePickerViewController.delegate = self
        datePickerViewController.modalPresentationStyle = .overCurrentContext
        
        self.present(datePickerViewController, animated: true, completion: nil)
    }
    
    func passData(date: String) {
        dateAndTimePicker.setTitle(date, for: .normal)
    }
    
    @IBAction func dismissEventTableView(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
