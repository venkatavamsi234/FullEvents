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
    
    let urlString = "\(Constants.baseUrlString)/auth?response_type=code&client_id=\(Constants.clientId)&redirect_uri=\(Constants.redirectUri)&scope=awapis.users.read%20awapis.account.read%20awapis.identity%20awapis.streams.read&access_type=offline&approval_prompt=force"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.loginHandler(_: )), name: NSNotification.Name(rawValue: "Login Response"), object: nil)
        
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
    
    
    func loginFailedAlert() {
        
        let alert = UIAlertController(title: "Login failed", message: "Please Try Again", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func loginHandler(_ sender: NSNotification) {
        
        svc?.dismiss(animated: false, completion: nil)
        
        guard let loginSuccess = sender.userInfo?["loginSuccess"] as? Bool, loginSuccess  else {
            loginFailedAlert()
            return
        }
        
        print("Successfullt oAuthorised")
        
        AccountHelper.accountAPICall() {
            
            guard let accountId = UserDefaults.standard.string(forKey: "accountId"), !accountId.isEmpty else {
                self.loginFailedAlert()
                return
            }
            
            print("Login is successful: \(accountId)")
            
            DispatchQueue.global(qos: .background).async {
                AccountHelper.accountAPIContacts()
                AwStreamHelpers.getStreams()
            }
            
            if let  tbVc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
                self.navigationController?.pushViewController(tbVc, animated: true)
            }
            
        }
    }
}



