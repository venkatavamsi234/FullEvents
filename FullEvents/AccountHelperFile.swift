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

class AccountHelperFile {
    
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
    
//    class func AccountAPI() {
//        
//        let accountAPIURL = Constants.baseApiUrl + "/account"
//        
//        guard let accountURL = URL(string:accountAPIURL) else {
//            
//            return
//            
//        }
//        
//        let param = ["scope": "awapis.account.read"]
//        
//        guard let accessToken = AccessTokenHelper.getAccessToken() else {
//            
//            return
//            
//        }
//        
//        Alamofire.request(accountURL, method: .get, parameters: param, encoding: URLEncoding.default, headers: ["Authorization": "Bearer \(accessToken)"]).responseJSON() { response in
//            
//            switch response.result {
//                
//            case .success:
//                
//                if let value = response.result.value {
//                    
//                    let json = JSON(value)
//                    
//                }
//                
//            case .failure(let error):
//                print(error)
//            }
//        }
//        
//    }
//    
}
