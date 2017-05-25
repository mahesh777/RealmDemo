//
//  UserLessionsRealmModel.swift
//  RealmDemo
//
//  Created by Mahesh on 22/05/17.
//  Copyright © 2017 TestProject. All rights reserved.
//

import Foundation
import RealmSwift

// User Lessions model
class UserLessionsRealmModel : Object {
    dynamic var lessionId : String?
    dynamic var status : String?
    dynamic var lessionTitle : String?
    
    override static func primaryKey() -> String? {
        return "lessionId"
    }

}
