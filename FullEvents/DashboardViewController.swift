//
//  DashboardViewController.swift
//  FullEvents
//
//  Created by user on 09/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit


class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

          }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.topItem?.title = "Dashboard"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction(sender:)))
        
    }
    
    func addButtonAction(sender button: UIBarButtonItem) {
        
        print("Hello")
    }

   
}
