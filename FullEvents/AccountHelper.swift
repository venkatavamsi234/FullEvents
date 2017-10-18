   //
   //  AccountHelperFile.swift
   //  FullEvents
   //
   //  Created by user on 11/10/17.
   //  Copyright © 2017 user. All rights reserved.
   //
   
   import Foundation
   import Alamofire
   import SwiftyJSON
   import FullAuthIOSClient
   import CoreData
   
   class AccountHelper {
    
    class func userInfo(completionHandler:@escaping (JSON) -> Void) {
        
        let userAPIURL = Constants.baseApiUrl + "/user/me"
        
        guard let userInfoURL = URL(string:userAPIURL) else {
            
            return
            
        }
        
        let params = ["scope": "awapis.identity"]
        
        guard let accessToken = AccessTokenHelper.getAccessToken() else {
            
            return
            
        }
        
        Alamofire.request(userInfoURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: ["Authorization": "Bearer \(accessToken)"]).responseJSON() { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    completionHandler(json)
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    class func accountAPICall(completionHandler: @escaping () -> Void) {
        
        let accountAPIURL = Constants.baseApiUrl + "/account?scope=awapis.identity"
        
        guard  let accountURL = URL(string: accountAPIURL) else {
            return
        }
        
        guard let accessToken = AccessTokenHelper.getAccessToken() else {
            return
        }
        
        Alamofire.request(accountURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization": "Bearer \(accessToken)"]).responseJSON() { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    let data = json["data"]
                    let account = data["account"]
                    let accountId = account["id"].stringValue
                    UserDefaults.standard.set(accountId, forKey: "accountId")
                    completionHandler()
                }
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
    }
    
    
    class func accountAPIContacts(limit: Int = 15, cursorForContacts: String? = nil) {
        
        guard let accountId = UserDefaults.standard.string(forKey: "accountId") else {
            return
        }
        
        let accountAPIURL = Constants.baseApiUrl + "/account/\(accountId)/user"
        
        guard  let accountURL = URL(string: accountAPIURL) else {
            return
        }
        
        print(accountURL)
        
        guard let accessToken = AccessTokenHelper.getAccessToken() else {
            return
        }
        
        print(accessToken)
        
        var fieldsReq:[String:Any] = ["limit": limit]
        if let cursorForNextContacts = cursorForContacts{
            fieldsReq["cursor"] = cursorForNextContacts
        }
        
        print(fieldsReq)
        
        Alamofire.request(accountURL, method: .get, parameters: fieldsReq, encoding: URLEncoding.default, headers: ["Authorization": "Bearer \(accessToken)"]).responseJSON() { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    let json = JSON(value)
                    let user = json["data"]
                    let contactsJson = user["users"]
                    
                    
                    Contact.savingContacts(contactsJson: contactsJson)
                    
                    if let cursor = user["cursor"].string, !cursor.isEmpty {
                        UserDefaults.standard.set(cursor, forKey: "cursorForContacts")
                        accountAPIContacts(limit: limit, cursorForContacts: cursor)
                    } else {
                        return
                    }
                    
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
   }
