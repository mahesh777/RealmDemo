//
//  EMJSONReponse.swift
//  RealmDemo
//
//  Created by Mahesh on 15/12/16.
//  Copyright © 2016 brainvire. All rights reserved.
//

import Foundation

class EMJSONReponse {
    let data: Dictionary<String, AnyObject>?
    let response: URLResponse?
    var error: Error?
    var message : String?
    
    init(data: Dictionary<String, AnyObject>?, response: URLResponse?,error: Error?){
        self.data = data
        self.response = response
        self.error = error
    }
    
    init(error: Error? ,dataDict : NSDictionary ){
        self.data = nil
        self.response = nil
        self.error = error
    }
    
    var HTTPResponse: HTTPURLResponse! {
        return response as? HTTPURLResponse
    }
    
    var responseDict: AnyObject? {
        return data as AnyObject?
    }
    
    var responseMessage: String? {
        return message 
    }
}
