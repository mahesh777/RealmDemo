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
    
    func setUserInfoModel(_ userInfoResponse : UserInfoResponse) -> Void {
        let realm = try! Realm()
        let userInfoModel = UserInfoRealmModel()
        userInfoModel.displayName = userInfoResponse.name
        userInfoModel.userId = userInfoResponse.userId
        userInfoModel.emailAddress = userInfoResponse.email
        userInfoModel.mobileNo = userInfoResponse.mobile
        userInfoModel.userName = userInfoResponse.username
        
        //if (userInfoResponse.companyIds?.count)! > 0 {
          //  userInfoModel.companyId = userInfoResponse.companyIds?[0]
        //}
        
        //realm.beginWrite()
        
        try! realm.write {
            realm.add(userInfoModel, update:true)
            try! realm.commitWrite()
        }

        
        
    }

    
    func getUserInfoModel(_ userId : String) -> UserInfoRealmModel {
        let realm = try! Realm()
        let persons = realm.objects(UserInfoRealmModel.self)
        print(persons)
        let compareUserId = String.init(format: "userId == '%@'", userId) as String
        let userInfoRealmModel = realm.objects(UserInfoRealmModel.self).filter(compareUserId).first

        return userInfoRealmModel!
    }

    public func getUserLessonList(_ userId : String) -> List<UserLessionsRealmModel> {
        let realm = try! Realm()
        let compareUserId = String.init(format: "userId = '%@'", userId) as String
        let userInfoRealmModel = realm.objects(UserInfoRealmModel.self).filter(compareUserId).first
        
        return (userInfoRealmModel?.userLessionList)!
    }

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
            //userInfoModel.companyId = userInfoResponse.companyIds?[0]
        }
        
        
        
        
    }

}
