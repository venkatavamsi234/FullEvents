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
import AlecrimCoreData


class DashboardViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        navigationController?.navigationBar.topItem?.title = "Dashboard"
        
    }
    
    @IBAction func addingEvents(_ sender: Any) {
    }
    
    
    
}
