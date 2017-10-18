//
//  AppDelegate.swift
//  FullEvents
//
//  Created by user on 09/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let notificationKey =  Notification.Name(rawValue: "Login Response")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        if let cursorForContacts = UserDefaults.standard.string(forKey: "cursorForContacts"), !cursorForContacts.isEmpty  {
            DispatchQueue.global(qos: .background).async {
                AccountHelper.accountAPIContacts(cursorForContacts: cursorForContacts)
                if let cursorForStreams = UserDefaults.standard.string(forKey: "cursorForStreams") {
                    AwStreamHelpers.getStreams(cursor: cursorForStreams)
                }
            }
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let str = url.query {
            let strng =  str.components(separatedBy: "=")
            getAccessToken(str: strng[1])
        }
        
        return true
    }
    
    func getAccessToken(str: String){
        
        
        let url = try! "\(Constants.baseUrlString)/v1/token".asURL()
        
        let params: [String: Any] = ["code": str,
                                     "client_id": Constants.clientId,
                                     "client_secret": Constants.clientSecret,
                                     "redirect_uri": Constants.redirectUri,
                                     "grant_type": "authorization_code"
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseData { (
            response) in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    
                    guard let accessToken = json["access_token"].string, let refreshAccessToken = json["refresh_token"].string else {
                        
                        NotificationCenter.default.post(name: self.notificationKey, object: self, userInfo: ["loginSuccess": false] )
                        
                        return
                        
                    }
                    
                    AccessTokenHelper.setAccessToken(accessToken: accessToken )
                    AccessTokenHelper.setRefreshAccessToken(refreshToken: refreshAccessToken)
                    
                    NotificationCenter.default.post(name: self.notificationKey, object: self, userInfo: ["loginSuccess": true] )
                    
                }
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
    }
    
}

