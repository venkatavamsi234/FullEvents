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
import AlecrimCoreData
import CoreData

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var userProfile: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Settings"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
            
        case (0, 0):
            
            // If indexpath is equal to section 0 and row 0 it will push profile view controller into the stack
            
            guard let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {
                
                return
                
            }
            
            navigationController?.pushViewController(profileVC, animated: true)
            
        case (1, 0):
            
            // If indexpath is equal to section 1 and row 0 it will perform the signout action
            
            let alert = UIAlertController(title: "SignOut", message: "Would you like to SignOut", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "SignOut", style: UIAlertActionStyle.destructive, handler: userLogOut))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        default:
            
            break
            
        }
        
    }
    
    func clearCoreData(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(batchDeleteRequest)
            print(container.viewContext.users.count()
            )
        } catch {
            print("error, coredata is not cleared")
        }
    }
    
    func userLogOut(action: UIAlertAction)  {
        
        guard  let accessToken = AccessTokenHelper.getAccessToken() else {
            
            return
            
        }
        
        guard  let refreshAccessToken = AccessTokenHelper.getRefreshAccessToken() else {
            
            return
            
        }
        
        AccessTokenHelper.removeRefreshAccessToken(refreshAccessToken: refreshAccessToken)
        
        
        guard let revokeAccessTokenUrl = try? "\(Constants.baseUrlString)/revoke?token=\(accessToken)".asURL() else {
            
            return
            
        }
        
        UserDefaults.standard.removeObject(forKey: "cursorForContacts")
        UserDefaults.standard.removeObject(forKey: "cursorForStreams")
        
        
        
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
        
        clearCoreData(entityName: "User")
        clearCoreData(entityName: "UserStreams")
        guard  let  lvc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return
        }
        tabBarController?.navigationController?.setViewControllers([lvc], animated: true)
        
    }
    
}
