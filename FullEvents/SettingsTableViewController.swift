//
//  SettingsTableViewController.swift
//
//
//  Created by user on 10/10/17.
//
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.topItem?.title = "Settings"
        
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "SignOut", message: "Would you like to SignOut", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "SignOut", style: UIAlertActionStyle.destructive, handler: userLogOut))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func userLogOut(action: UIAlertAction)  {
        
        guard  let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            return
        }
        
        UserDefaults.standard.removeObject(forKey: "accessToken")
        
        guard let apiToContact = try?"https://fullcreative.fullauth.com/o/oauth2/revoke?token=\(accessToken)".asURL() else {
            return
        }
        
        Alamofire.request(apiToContact, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseJSON() { response in
            
            switch response.result {
                
            case .success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    print(json)
                    print("The Token has been successfully revoked")
                    
                }
            case .failure(let error):
                print(error)
                
            }
            
        }
        
        let alert = UIAlertController(title: "", message: "Sign out successful", preferredStyle: UIAlertControllerStyle.alert)
        
        self.present(alert, animated: true, completion: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            alert.dismiss(animated: true, completion: nil)
            self.landToLoginPage()
        })
        
        
        
    }
    
    func landToLoginPage() {
        
        guard  let  lvc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            
            return
            
        }
        
        navigationController?.setViewControllers([lvc], animated: true)
        
    }
    
}
