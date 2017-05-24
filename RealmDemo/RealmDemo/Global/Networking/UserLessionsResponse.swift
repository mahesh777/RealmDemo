//
//  UserLessionsResponse.swift
//  RealmDemo
//
//  Created by Mahesh on 24/05/17.
//  Copyright © 2017 TestProject. All rights reserved.
//

import Foundation

class UserLessionsResponse {
    
    public var userId: String?
    public var userLessionInfoList: Array<UserLessionInfo>?
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.userId = jsonDict["_id"] as? String
        
        let userLessionsArray = jsonDict["user_lessons"] as? Array<Dictionary<String, AnyObject>>

        userLessionInfoList = Array<UserLessionInfo>.init()
        
        for userLession in userLessionsArray! {
            
            let userLessionInfo = UserLessionInfo.init(jsonDict: userLession)
            
            userLessionInfoList?.append(userLessionInfo)
        }

    }
    
    struct UserLessionInfo {
        var lessionId: String?
        var lessionTitle : String?
        var status : String?
        
        init(jsonDict: Dictionary<String, AnyObject>) {
            self.lessionId = jsonDict["lesson_id"] as? String
            self.status = jsonDict["status"] as? String
            let lessonDict = jsonDict["lesson"] as? Dictionary<String, AnyObject>
            self.lessionTitle = lessonDict?["title"] as? String
        }
    }
}
