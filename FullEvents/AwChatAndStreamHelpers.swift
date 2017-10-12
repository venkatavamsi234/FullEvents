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

class AwChatAndStreamHelpers {
    //
    //    func GetAnywhereWorksStreams() {
    //
    //        let streamApiUrl = "\(Constants.baseApiUrl)/account/{accountId}/stream"
    //
    //        guard let streamUrl = URL(string: streamApiUrl) else {
    //
    //            return
    //
    //        }
    //
    //        let params:[String:Any] = ["scope": "awapis.streams.read",
    //                                   "public": false,
    //                                   "status": "active",
    //                                   "limit": 30
    //        ]
    //
    //        guard let accessToken = AccessTokenHelper.getAccessToken() else {
    //
    //            return
    //        }
    //
    //        Alamofire.request(streamUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: ["Authorization": "Bearer \(accessToken)"]).responseJSON() { response in
    //
    //            switch response.result {
    //
    //            case .success:
    //
    //                if let value = response.result.value {
    //
    //                    let json = JSON(value)
    //
    //                    print(json)
    //
    //                }
    //
    //            case .failure(let error):
    //
    //         let newAccessToken = AccessTokenHelper.getRefreshAccessToken()
    //
    //                print(error)
    //            }
    //        }
    //    }
    
  
}
