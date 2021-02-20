//
//  TabBarViewController.swift
//  FullEvents
//
//  Created by user on 09/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
}
