//
//  EMBaseModel.swift
//  RealmDemo
//
//  Created by Mahesh on 15/12/16.
//  Copyright © 2016 brainvire. All rights reserved.
//

import Foundation

class EMBaseModel {

    var data : Dictionary<String,AnyObject>?
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        data = jsonDict
    }
}



