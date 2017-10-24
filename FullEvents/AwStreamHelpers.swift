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
    
    class func getStreams(limit: Int = 10, cursor: String? = nil) {
        
        guard let accountId = UserDefaults.standard.string(forKey: "accountId") else {
            return
        }
        
        print(accountId)
        
        let streamApiUrl = Constants.baseApiUrl + "/account/\(accountId)/stream"
        
        guard let streamUrl = URL(string: streamApiUrl) else {
            return
        }
        
        print(streamUrl)
        var params:[String:Any] = ["public": "false", "status": "active" , "limit": limit]
        
        
        if let cursorForStreams = cursor {
            params["cursor"] = cursorForStreams
        }
        
        
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
                    StreamService.savingStreams(streamsJson: streams)
                    print(streams)
                    
                    guard let cursor = data["cursor"].string, !cursor.isEmpty else  {
                        UserDefaults.standard.removeObject(forKey: "cursorForStreams")
                        return
                    }
                    
                    getStreams(cursor: cursor)
                    UserDefaults.standard.set(cursor, forKey: "cursorForStreams")
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    
}
