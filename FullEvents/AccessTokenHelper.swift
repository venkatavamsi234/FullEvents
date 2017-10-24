//
//  AccessTokenHelperClass.swift
//  FullEvents
//
//  Created by user on 10/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import FullAuthIOSClient
import SwiftyJSON
import Alamofire

class AccessTokenHelper {
    
    class func setAccessToken(accessToken: String) {
        
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        
    }
    
    class func setRefreshAccessToken(refreshToken: String) {
        
        UserDefaults.standard.set(refreshToken, forKey: "refreshAccessToken")
    }
    
    class  func getAccessToken() -> String? {
        
        return UserDefaults.standard.string(forKey: "accessToken")
        
    }
    
    class func getRefreshAccessToken() -> String? {
        
        return UserDefaults.standard.string(forKey: "refreshAccessToken")
        
    }
    
    class  func removeAccessToken(accessToken: String) {
        
        UserDefaults.standard.removeObject(forKey: "accessToken")
    }
    
    class  func removeRefreshAccessToken(refreshAccessToken: String) {
        
        UserDefaults.standard.removeObject(forKey: "refreshAccessToken")

    }
    
    
    class func refreshAccessToken() {
        
        let urlString = "\(Constants.baseUrlString)/v1/token"
        
        guard let url = URL(string: urlString) else {
            
            return
            
        }
        
        guard  let refreshAccessToken = getRefreshAccessToken() else {
            
            return
            
        }
        
        let param:[String:String] = ["refresh_token": refreshAccessToken,
                                     "client_id": Constants.clientId,
                                     "client_secret": Constants.clientSecret,
                                     "grant_type": "refresh_token"
        ]
        
        Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseData { (
            response) in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    
                    print(json)
                    
                }
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    
}


