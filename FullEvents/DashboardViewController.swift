//
//  DashboardViewController.swift
//  FullEvents
//
//  Created by user on 09/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class DashboardViewController: UIViewController {
    
    @IBOutlet weak var userEmail: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.topItem?.title = "Dashboard"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction(sender:)))
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        
    }
    
    func addButtonAction(sender button: UIBarButtonItem) {
        
        print("Hello")
        
    }
    
}
