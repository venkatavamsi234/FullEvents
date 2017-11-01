//
//  EventNameTableTableViewController.swift
//  FullEvents
//
//  Created by user on 27/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class EventNameTableViewController: UITableViewController, UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventName.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventNameTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eventName.delegate = self
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    @IBAction func dismissEventNamePage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func redirectingToEventDatePage(_ sender: UIBarButtonItem) {
        
        guard let nameOfEvent = eventName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), !nameOfEvent.isEmpty else {
            let alert = UIAlertController(title: "", message: "Event Name is required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let eventDateViewController = storyboard?.instantiateViewController(withIdentifier: "EventDateTableViewController") as? EventDateTableViewController else {
            return
        }
        
        navigationController?.pushViewController(eventDateViewController, animated: true)
    }
    
    
    
    
}
