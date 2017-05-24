//
//  UserInfoResponse.swift
//  RealmDemo
//
//  Created by Mahesh on 22/05/17.
//  Copyright © 2017 TestProject. All rights reserved.
//

import UIKit

class UserInfoResponse {
    
    public var userId: String?
    var createdAt: String?
    var email: String?
    var mobile : String?
    var name : String?
    var username : String?
    var companyIds : [String]?
    var roleIds : [String]?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.userId = jsonDict["_id"] as? String
        UserInfo.sharedInstance.setUserInfoInCache(value: userId as AnyObject?, key: UserInfoKeys.userID)

        self.createdAt = jsonDict["created_at"] as? String
        self.email = jsonDict["email"] as? String
        
        self.mobile = jsonDict["mobile"] as? String
        self.name = jsonDict["name"] as? String
        self.username = jsonDict["username"] as? String
        
        let companyIdsArray = jsonDict["company_ids"] as? Array<String>
        
        for companyId in companyIdsArray! {
            companyIds?.append(companyId)
        }
        
        
        let roleIdsArray = jsonDict["role_ids"] as? Array<String>
        
        for roleId in roleIdsArray! {
            roleIds?.append(roleId)
        }
        
        
    }
}

