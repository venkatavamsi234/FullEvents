//
//  NavigationViewController.swift
//  FullEvents
//
//  Created by user on 10/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let token = AccessTokenHelper.getAccessToken()
        
        guard let accessToken = token, !accessToken.isEmpty else {
            
            if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                if let lvc = mainStoryboard.instantiateViewController(withIdentifier:"LoginViewController") as? LoginViewController {
                    let nav = UINavigationController(rootViewController: lvc)
                    appdelegate.window?.rootViewController = nav
                }
            }
            return
        }
        
    }
}
