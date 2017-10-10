//
//  LoginViewController.swift
//  FullEvents
//
//  Created by user on 09/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FullAuthIOSClient
import SafariServices

class LoginViewController: UIViewController, SFSafariViewControllerDelegate, UIWebViewDelegate{
    
    var svc: SFSafariViewController?
    
    
    let urlString = "https://access.anywhereworks.com/o/oauth2/auth?response_type=code&client_id=29354-4dfad15c1bcc7b057adb96651882db0f&redirect_uri=com.fullCreative.FullEvents:/oauth2callback&scope=awapis.users.read&access_type=offline&approval_prompt=force"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.accessTokenMethod(_: )), name: NSNotification.Name(rawValue: "Dismiss safari"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    
    @IBAction func loginWithAw(_ sender: UIButton) {
        
        guard let url = URL(string: self.urlString) else {
            return
        }
        
        svc = SFSafariViewController(url: url)
        
        guard let safariViewController = svc else {
            return
        }
        
        safariViewController.delegate = self
        self.present(safariViewController, animated: true, completion: nil)
        
    }
    
    func accessTokenMethod(_ sender: NSNotification) {
        
        if let loginfailed = sender.userInfo?["loginSuccess"] as? Bool {
            
            if loginfailed == false {
                

                svc?.dismiss(animated: false, completion: nil)
                
                if let  lVc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                    
                {
                    let alert = UIAlertController(title: "Login failed", message: "Please Try Again", preferredStyle: UIAlertControllerStyle.alert)
                    
                       alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    navigationController?.pushViewController(lVc, animated: false)
                }
                
                
            } else {
                
                svc?.dismiss(animated: false, completion: nil)
                
                if let  tbVc = storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
                    
                {
                    
                    navigationController?.pushViewController(tbVc, animated: false)
                }
                
            }
        }
        
        
    }
    
}


