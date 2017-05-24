//
//  UserInfoRealm.swift
//  RealmDemo
//
//  Created by Mahesh on 22/05/17.
//  Copyright © 2017 TestProject. All rights reserved.
//

import Foundation
import RealmSwift

// UserInfo model
class UserInfoRealmModel : Object {
    dynamic var userId : String?
    dynamic var userName : String?
    dynamic var emailAddress : String?
    dynamic var mobileNo : String?
    dynamic var displayName : String?
    dynamic var companyId : String?
    let userLessionList = List<UserLessionsRealmModel>()
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
