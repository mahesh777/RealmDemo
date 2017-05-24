//
//  UserInfo.swift
//  RealmDemo
//
//  Created by Mahesh on 22/12/16.
//  Copyright © 2016 brainvire. All rights reserved.
//

import Foundation

class UserInfo : NSObject {
    
    static let sharedInstance = UserInfo()

    fileprivate override init() {
        super.init()
    }
    
    // MARK: - Get-Set NSUserDefaults Global Value
    func setUserInfoInCache(value : AnyObject?  , key : String)
    {
        let defaults = UserDefaults.standard
        
        if (value != nil){
            defaults.set(value, forKey: key)
        }
        defaults.synchronize()
    }
    
    func getUserDefault(key : String) -> AnyObject?
    {
        let defaults = UserDefaults.standard
        
        if let name = defaults.value(forKey: key){
            return name as AnyObject?
        }
        return nil
    }
    
    func removeCacheValue(key : String)
    {
        let defaults = UserDefaults.standard
        
        if defaults.value(forKey: key) != nil{
            defaults.removeObject(forKey: key)
        }
    }
    
    func clearUserInfoWhenUserLoggedOut() {
        
        UserInfo.sharedInstance.removeCacheValue(key: UserInfoKeys.userID)
        UserInfo.sharedInstance.removeCacheValue(key: UserInfoKeys.userName)
        UserInfo.sharedInstance.removeCacheValue(key: UserInfoKeys.emailID)
        UserInfo.sharedInstance.removeCacheValue(key: UserInfoKeys.userID)
        
        UserInfo.sharedInstance.removeCacheValue(key: UserInfoKeys.accessToken)
        UserInfo.sharedInstance.removeCacheValue(key: UserInfoKeys.refreshToken)
        UserInfo.sharedInstance.removeCacheValue(key: UserInfoKeys.tokenExpiresIn)
        UserInfo.sharedInstance.removeCacheValue(key: UserInfoKeys.tokenType)
        
        UserInfo.sharedInstance.setUserInfoInCache(value: false as AnyObject?, key: UserInfoKeys.isUserLoggedIn)
    }
}
