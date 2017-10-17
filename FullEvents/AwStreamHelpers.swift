//
//  AwChatAndStreamHelpers.swift
//  FullEvents
//
//  Created by user on 11/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FullAuthIOSClient

class AwStreamHelpers {
    
   class func getAnywhereWorksStreams(limit: Int = 10, cursor: String? = nil) {
        
            guard let accountId = UserDefaults.standard.string(forKey: "accountId") else {
                return
            }
    
            print(accountId)
    
            let streamApiUrl = Constants.baseApiUrl + "/account/\(accountId)/stream"
    
            guard let streamUrl = URL(string: streamApiUrl) else {    
                return
            }
    
            print(streamUrl)
            let params:[String:Any] = ["public": "false", "status": "active" , "limit": limit]
            
            guard let accessToken = AccessTokenHelper.getAccessToken() else {
    
                return
            }
    
            print(accessToken)
    
            Alamofire.request(streamUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: ["Authorization": "Bearer \(accessToken)"]).responseJSON() { response in
    
                switch response.result {
    
                case .success:
    
                    if let value = response.result.value {
    
                        let json = JSON(value)
                        let data = json["data"]
                        let streams = data["streams"]
                        UserStreams.savingStreams(streamsJson: streams)
                    }
    
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
    
  
}
