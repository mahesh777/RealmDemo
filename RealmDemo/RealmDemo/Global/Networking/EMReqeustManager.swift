//
//  EMReqeustManager.swift
//  RealmDemo
//
//  Created by Mahesh on 15/12/16.
//  Copyright © 2016 brainvire. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias requestCompletionHandler = (EMJSONReponse) -> Void

class EMReqeustManager: NSObject {
    static let sharedInstance = EMReqeustManager()
    
    fileprivate override init() {
        super.init()
        
        
    }
    
    fileprivate func sendRequestWithURL(_ URL: String,
                                        method: HTTPMethod,
                                        queryParameters: [String: String]?,
                                        bodyParameters: [String: AnyObject]?,
                                        headers: [String: String]?,
                                        isLoginHeaderRequired:Bool,
                                        retryCount: Int = 0,
                                        needsLogin: Bool = false,
                                        completionHandler:@escaping requestCompletionHandler) {
        // If there's a querystring, append it to the URL.
        
        if (GLOBAL.sharedInstance.isInternetReachable == false) {
            let userInfo: [NSObject : AnyObject] =
                [
                    NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("No Internet", value: "No Internet Connection is there.", comment: "") as AnyObject,
                    NSLocalizedFailureReasonErrorKey as NSObject : NSLocalizedString("No Internet", value: "No Internet Connection is there.", comment: "") as AnyObject
            ]
            

            let error : NSError = NSError(domain: "HttpResponseErrorDomain", code: -1, userInfo: userInfo)
            let wrappedResponse = EMJSONReponse.init(error: error, dataDict: [:])
            completionHandler(wrappedResponse)
            print(error)
            return
        }
        
        let actualURL: String
        if let queryParameters = queryParameters {
            var components = URLComponents(string:URL)!
            components.queryItems = queryParameters.map { (key, value) in URLQueryItem(name: key, value: value) }
            actualURL = components.url!.absoluteString
        } else {
            actualURL = URL
        }
        
        var headerParams = [String: String]()
        
        if isLoginHeaderRequired == true {
            
            let headers: HTTPHeaders = [
                "Authorization": String.init(format: "Bearer %@", UserInfo.sharedInstance.getUserDefault(key: UserInfoKeys.accessToken) as! CVarArg),
                "Accept": "application/json"
            ]
            

            headerParams = headers
        } else {
            headerParams = [:]
        }

        print("Actual URL \(actualURL)")

        Alamofire.request(actualURL, method:method, parameters: bodyParameters, headers: headerParams)
            .responseJSON { response in
                print(response.result)   // result of response serialization
                
                switch response.result {
                case .success:
                    
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("JSON: \(JSON)")
                        
                        let wrappedResponse = EMJSONReponse.init(
                            data: response.result.value as! Dictionary<String, AnyObject>?,
                            response: response.response,
                            error: nil)
                        
                        DispatchQueue.main.async(execute: {
                            completionHandler(wrappedResponse)
                        })
                    }
                case .failure(let error):
                    let error = error
                    let wrappedResponse = EMJSONReponse.init(error: error, dataDict: [:])
                    completionHandler(wrappedResponse)
                    print(error)
                }
        }
    }
    
}

extension EMReqeustManager {
    
    func apiLogin(_ emailId : String, password : String, completionHandler:@escaping requestCompletionHandler) {

        let bodyParams: [String: String] = [APIRequestKeys.usernameKey: emailId,
                                            APIRequestKeys.passwordKey: password ,
                                            APIRequestKeys.grantTypeKey : "password" ,
                                            APIRequestKeys.scopeKey : "user"
                                            ]
        
        sendRequestWithURL(APIEndPoints.getLoginURL(), method: .post, queryParameters: nil, bodyParameters: bodyParams as [String : AnyObject]?, headers: nil, isLoginHeaderRequired: false, completionHandler: completionHandler)
    }
    
    func apiGetUserInfo(_ completionHandler:@escaping requestCompletionHandler) {
        
        let bodyParams : [String : String] = [:]
        
        sendRequestWithURL(APIEndPoints.getUserInfoURL(), method: .get, queryParameters: nil, bodyParameters: bodyParams as [String : AnyObject]?, headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiGetUserLessions(_ completionHandler:@escaping requestCompletionHandler) {
        
        let bodyParams : [String : String] = [:]
        
        let companyId = "585772cfd3a07bffe3000077"
        let userId = "58577374d3a07bffe30000cc"
        
        //let URL = String.init(format: "%@/%@/sq/users/%@/%@", APIEndPoints.getCompanyURL(),companyId,userId,APIEndPoints.getLessonURL())
        
        let URL = String.init(format: "%@/%@/sq/users/%@/%@", APIEndPoints.getCompanyURL(),companyId,userId,APIEndPoints.getLessonURL())
        
        sendRequestWithURL(URL, method: .get, queryParameters: nil, bodyParameters: bodyParams as [String : AnyObject]?, headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }

    
}
