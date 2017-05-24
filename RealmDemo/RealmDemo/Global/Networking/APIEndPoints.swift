//
//  APIEndPoints.swift
//  RealmDemo
//
//  Created by Mahesh on 16/12/16.
//  Copyright © 2016 brainvire. All rights reserved.
//

import Foundation

class APIEndPoints {
    static func getBaseURL() -> String {
        return "https://api.es-q.co/"
    }

    static func getLoginURL() -> String {
        return getBaseURL() + "oauth/token.json"
    }
    
    static func getUserInfoURL() -> String {
        return getBaseURL() + "users/current.json"
    }
    
    static func getCompanyURL() -> String {
        return getBaseURL() + "companies"
        //https://api.es-q.co/companies/585772cfd3a07bffe3000077/sq/users/58577374d3a07bffe30000cc/user_profile?include[user_lessons][only][]=status&include[user_lessons][include][lesson][only]=title&include[user_lessons][only][]=lesson_id&select=_id
    }
    
    static func getLessonURL() -> String {
        return "user_profile?include[user_lessons][only][]=status&include[user_lessons][include][lesson][only]=title&include[user_lessons][only][]=lesson_id&select=_id"
    }
    
}
