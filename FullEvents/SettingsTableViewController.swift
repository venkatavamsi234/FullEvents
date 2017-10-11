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
        
        guard  let accessToken = AccessTokenHelper.getAccessToken() else {
            
            return
            
        }
        
        guard  let refreshAccessToken = AccessTokenHelper.getRefreshAccessToken() else {
            
            return
            
        }
        
        AccessTokenHelper.removeRefreshAccessToken(refreshAccessToken: refreshAccessToken)
        
        
        guard let revokeAccessTokenUrl = try?"\(Constants.baseUrlString)/revoke?token=\(accessToken)".asURL() else {
            
            return
            
        }
        
        Alamofire.request(revokeAccessTokenUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseJSON() { response in
            
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
        
        AccessTokenHelper.removeAccessToken(accessToken: accessToken)
        
        guard  let  lvc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            
            return
            
        }
        
        navigationController?.setViewControllers([lvc], animated: true)
        
    }
    
}
