//
//  RealmHelper.swift
//  RealmDemo
//
//  Created by Mahesh on 22/05/17.
//  Copyright © 2017 TestProject. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper : NSObject {
    
    //sharedInstance
    static let sharedInstance = RealmHelper()
    
    // MARK : Set User Info Model
    func setUserInfoModel(_ userInfoResponse : UserInfoResponse) -> Void {
        let realm = try! Realm()
        let userInfoModel = UserInfoRealmModel()
        userInfoModel.displayName = userInfoResponse.name
        userInfoModel.userId = userInfoResponse.userId
        userInfoModel.emailAddress = userInfoResponse.email
        userInfoModel.mobileNo = userInfoResponse.mobile
        userInfoModel.userName = userInfoResponse.username
        
        try! realm.write {
            realm.add(userInfoModel, update:true)
            try! realm.commitWrite()
        }
    }

    // MARK : Get User Info Model
    func getUserInfoModel(_ userId : String) -> UserInfoRealmModel {
        let realm = try! Realm()
        let persons = realm.objects(UserInfoRealmModel.self)
        print(persons)
        let compareUserId = String.init(format: "userId == '%@'", userId) as String
        let userInfoRealmModel = realm.objects(UserInfoRealmModel.self).filter(compareUserId).first

        return userInfoRealmModel!
    }

    // MARK : Get User Lession List
    public func getUserLessonList(_ bodyParameters: [String: AnyObject]?) -> [UserLessionsRealmModel]? {
        var lessionArray: [UserLessionsRealmModel] = []
        let status = bodyParameters?["status"] as! String
        let realm = try! Realm()
        let statusQuery = String.init(format: "status = '%@'", status)
        let userLessionList = realm.objects(UserLessionsRealmModel.self).filter(statusQuery)
        
        for object in userLessionList{
            lessionArray += [object]
        }
        
        return lessionArray.count > 0 ? lessionArray : nil
    }

    // MARK : Set User Lession List
    func setUserLession(_ userId : String, userLessonInfoResponse : UserLessionsResponse) -> Void {
        let userInfoModel = getUserInfoModel(userId)
        
        let realm = try! Realm()
        //let userInfoModel = UserInfoRealmModel()
        
        if (userLessonInfoResponse.userLessionInfoList?.count)! > 0 {
            let userLessionList = userLessonInfoResponse.userLessionInfoList
            
            for userLessionInfo in userLessionList! {
                let userLessionsRealmModel = UserLessionsRealmModel()
                userLessionsRealmModel.lessionId = userLessionInfo.lessionId
                userLessionsRealmModel.status = userLessionInfo.status
                userLessionsRealmModel.lessionTitle = userLessionInfo.lessionTitle

                realm.beginWrite()
                userInfoModel.userLessionList.append(userLessionsRealmModel)
                try! realm.commitWrite()
                
                try! realm.write {
                    realm.add(userInfoModel, update: true)
                    try! realm.commitWrite()
                }
            }
        }
    }
    
    public func clearDB() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

}
