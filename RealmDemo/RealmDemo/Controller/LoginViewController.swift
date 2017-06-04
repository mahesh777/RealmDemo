//
//  ViewController.swift
//  RealmDemo
//
//  Created by Mahesh on 15/12/16.
//  Copyright © 2016 brainvire. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
   
    @IBOutlet weak var emailTextField : UITextField?
    @IBOutlet weak var paswordTextField : UITextField?

    var userInfoResponse : UserInfoResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //emailTextField?.text = "sqfos14@jombay.com"
        //paswordTextField?.text = "test123"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Normal Login Button Action Event
    @IBAction func userLoginButtonClicked() {
        let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
            action in
            
        })
        
        if (emailTextField?.text?.isStringBlank)! {
            GLOBAL.sharedInstance.showAlert(APPLICATION.applicationName, message: ValidationMessageKeys.emailID.getBlankValidationMessage(), actions: [okAction])
        } else if (emailTextField?.text?.isValidEmail == false) {
            GLOBAL.sharedInstance.showAlert(APPLICATION.applicationName, message: ValidationMessageKeys.emailID.getInvalidFieldValidationMessageWithSuggestion("email@example.com"), actions: [okAction])
        } else if (paswordTextField?.text?.isStringBlank)! {
            GLOBAL.sharedInstance.showAlert(APPLICATION.applicationName, message: ValidationMessageKeys.password.getBlankValidationMessage(), actions: [okAction])
            
        } else if (((paswordTextField?.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))?.length)! < 4 )
        {
            GLOBAL.sharedInstance.showAlert(APPLICATION.applicationName, message: ValidationMessageKeys.password.getMinCharsValidationMessage(4), actions: [okAction])
        }
        else {
            loginUser((emailTextField?.text)!, password: (paswordTextField?.text)!)
        }
    }

    //MARK: Login User API

    func loginUser(_ userName : String , password : String) {
        
        GLOBAL.sharedInstance.showLoadingIndicatorWithMessage("Loading")
        
        EMReqeustManager.sharedInstance.apiLogin(userName, password: password) {
            (feedResponse) -> Void in
            
            GLOBAL.sharedInstance.hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                GLOBAL.sharedInstance.showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    let responseModel = EMBaseModel.init(jsonDict: dictionary)
                    
                    self.parseTokenInfo(jsonDict: responseModel.data!)
                }
            }
        }
    }
    
    //MARK: Parse Login Token Info
    
    func parseTokenInfo(jsonDict: Dictionary<String, AnyObject>) {
        let accessToken = jsonDict["access_token"] as? String
        let tokenExpiresIn = jsonDict["expires_in"] as? Int
        let tokenType = jsonDict["token_type"] as? String
        let refreshToken = jsonDict["refresh_token"] as? String
        
        UserInfo.sharedInstance.setUserInfoInCache(value: accessToken as AnyObject?, key: UserInfoKeys.accessToken)
        UserInfo.sharedInstance.setUserInfoInCache(value: tokenExpiresIn as AnyObject?, key: UserInfoKeys.tokenExpiresIn)
        UserInfo.sharedInstance.setUserInfoInCache(value: tokenType as AnyObject?, key: UserInfoKeys.tokenType)
        UserInfo.sharedInstance.setUserInfoInCache(value: refreshToken as AnyObject?, key: UserInfoKeys.refreshToken)

        getUserInfo()
    }
    
    
    // MARK : Get User Info
    func getUserInfo() {
        
        EMReqeustManager.sharedInstance.apiGetUserInfo({           (feedResponse) -> Void in
            
            GLOBAL.sharedInstance.hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                GLOBAL.sharedInstance.showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    RealmHelper.sharedInstance.clearDB()
                    self.userInfoResponse = UserInfoResponse.init(jsonDict: dictionary["user"] as! Dictionary<String, AnyObject>)
                    
                    RealmHelper.sharedInstance.setUserInfoModel(self.userInfoResponse!)
                    
                    self.getUserLessions()
                }
            }
        
        })
    }

    // MARK : Get User Lessions

    func getUserLessions() {
        EMReqeustManager.sharedInstance.apiGetUserLessions({           (feedResponse) -> Void in
            
            GLOBAL.sharedInstance.hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                GLOBAL.sharedInstance.showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    let userLessionResponse = UserLessionsResponse.init(jsonDict: dictionary["user_profile"] as! Dictionary<String, AnyObject>)
                    
                    RealmHelper.sharedInstance.setUserLession(UserInfo.sharedInstance.getUserDefault(key: UserInfoKeys.userID) as! String, userLessonInfoResponse: userLessionResponse)
                    
                    GLOBAL.sharedInstance.hideLoadingIndicator()

                    self.launchHomeScreen()
                }
            }
            
        })
    }
    
    // MARK : Launch Home Screen

    func launchHomeScreen() {
        let homeVC = self.makeStoryObj(storyboard: storyboard_R1, Identifier: "idHomeViewController") as! HomeViewController
        self.pushStoryObj(obj: homeVC, on: self)

    }
}

