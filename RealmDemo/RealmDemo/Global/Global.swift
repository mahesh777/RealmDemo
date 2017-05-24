//
//  Global.swift
//
//  Created by Mahesh on 15/12/16.
//  Copyright © 2015 Brainvire. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import ReachabilitySwift

struct APPLICATION
{
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static var APP_STATUS_BAR_COLOR = UIColor(red: CGFloat(27.0/255.0), green: CGFloat(32.0/255.0), blue: CGFloat(42.0/255.0), alpha: 1)
    static var APP_NAVIGATION_BAR_COLOR = UIColor(red: CGFloat(41.0/255.0), green: CGFloat(48.0/255.0), blue: CGFloat(63.0/255.0), alpha: 1)
    static let applicationName = "RealmDemo"
}

struct MBHUDstatus {
    static var i = 0
}

struct DYNAMICFONTSIZE {
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    
    static let IS_IPHONE_6P = UIScreen.main.bounds.height == 736.0
    static let IS_IPHONE_6 = UIScreen.main.bounds.height == 667.0
    static let IS_IPHONE_5  = UIScreen.main.bounds.height == 568.0
    static let IS_IPHONE_4 = UIScreen.main.bounds.height == 480.0
    static let IPAD1_2_H  =  UIScreen.main.bounds.width == 1024.0
    static let IPAD3_H  =  UIScreen.main.bounds.width == 2048.0
    
    static var SCREEN_WIDTH = UIScreen.main.bounds.width
    static var SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    static var SCALE_FACT_H : CGFloat  = (((IS_IPAD) ? 1.80 : ((IS_IPHONE_6P) ? 1.30 : ((IS_IPHONE_6) ? 1.17 : ((IS_IPHONE_5) ? 1.00 : 1.00)))))
    
    static var SCALE_FACT_FONT : CGFloat  = (((IS_IPAD) ? 1.54 : ((IS_IPHONE_6P) ? 1.10 : ((IS_IPHONE_6) ? 1.00 : ((IS_IPHONE_5) ? 0.85 : 1.00)))))
    
}

struct EMError{
    static let domain = "CVErrorDomain"
    static let networkCode = -1
    static let userInfoKey = "description"
}

struct CacheConstants {
    static let isAppAlreadyLaunchedOnce = "isAppAlreadyLaunchedOnce"
    static let isUserLoggedIn = "isUserLoggedIn"
}

struct APIRequestKeys {
    static let usernameKey = "username"
    static let passwordKey = "password"
    static let grantTypeKey = "grant_type"
    static let scopeKey = "scope"
    
}

struct EMAPIResponseStatusKeys {
    static let success = "success"
    static let message = "message"
    static let status = "status"
    static let data = "data"
    static let tokenData = "tokendata"
}

struct UserInfoKeys {
    static let userID = "UserId"
    static let userName = "Name"
    static let emailID = "Email"
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
    static let tokenType = "tokenType"
    static let tokenExpiresIn = "tokenExpiresIn"
    static let isUserLoggedIn = "isUserLoggedIn"
    static let isNotificationEnabled = "isNotificationEnabled"
}

struct ValidationMessageKeys {
    static let name = "name"
    static let userName = "user name"
    static let emailID = "email address"
    static let password = "password"
}

class GLOBAL : NSObject {
    
    //sharedInstance
    static let sharedInstance = GLOBAL()
    
    var alertGlobal: UIAlertView!
    
    let isSimulator = TARGET_OS_SIMULATOR != 0
    
    
    override init() {
        dictionary = Dictionary < String , Any? > ()
    }
    
    var methodTitleNameOptionMenu : String = ""
    
    var dictionary : Dictionary < String , Any? >
    //    var dictionary = Dictionary < String , Any? > ()
    
    
    func getGlobalValue(_ KeyToReturn : String) -> Any? {
        
        if let ReturnValue = dictionary[KeyToReturn]
        {
            return ReturnValue
        }
        return nil
    }

    //MARK: - Internet Reachability
    var reachability: Reachability?
    var isInternetReachable : Bool? = false
    
    func setupReachability(_ hostName: String?) {
        
        GLOBAL.sharedInstance.reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        
        
        NotificationCenter.default.addObserver(GLOBAL.sharedInstance, selector: #selector(reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: nil)
        
    }
    
    func startNotifier() {
        
        setupReachability("google.com")
        
        print("--- start notifier")
        do {
            try GLOBAL.sharedInstance.reachability?.startNotifier()
        } catch {
            print("Unable to create Reachability")
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        GLOBAL.sharedInstance.reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        GLOBAL.sharedInstance.reachability = nil
    }
    
    func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            GLOBAL.sharedInstance.isInternetReachable = true
        } else {
            GLOBAL.sharedInstance.isInternetReachable = false
        }
    }
            
    //MARK: - Progress HUD
    
    func showLoadingIndicatorWithMessage(_ message : String){
        let hud = MBProgressHUD.showAdded(to: APPLICATION.appDelegate.window!, animated: true)
        
        hud.label.text = message
    }
    
    func hideLoadingIndicator(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for:APPLICATION.appDelegate.window! , animated: true)
        }
    }
    
    func showLoadingIndicatorWithMessageAndUserInteraction(_ message : String,view:UIView){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = message
    }
    
    func hideLoadingIndicatorUserInteraction(_ view:UIView){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for:APPLICATION.appDelegate.window! , animated: true)
        }
    }
   
    //MARK: - App Launch First Time
    
    func isAppLaunchedFirstTime()->Bool{
        let defaults = UserDefaults.standard
        
        let isAppLaunchedFirstTimeValue = defaults.bool(forKey: CacheConstants.isAppAlreadyLaunchedOnce)
        
        if isAppLaunchedFirstTimeValue == false {
            print("App launched first time")
            defaults.set(true, forKey: CacheConstants.isAppAlreadyLaunchedOnce)
            return true
        } else {
            return false
        }
    }
    
    //MARK: is User Logged In
    func isUserLoggedIn()->Bool{
        let isUserLogedIn = UserInfo.sharedInstance.getUserDefault(key: UserInfoKeys.isUserLoggedIn)
        
        if isUserLogedIn == nil {
            return false
        } else {
            let isUserLoggedInBoolValue = isUserLogedIn as! Bool
            
            if (isUserLoggedInBoolValue) {
                print("User is logged In!")
                return true
            } else {
                print("User is not logged In!")
                return false
            }
        }
    }
 
    
    //MARK: - App Launch First Time Pass save = 1 to marked as Login and save = 0 to logout user
    /*
    func manageUserLoggedIn(_ save : Bool)->Void{
        let defaults = UserDefaults.standard
        
        if save {
            if !defaults.bool(forKey: CacheConstants.isUserLoggedIn) {
                print("Mark User Logged In")
                defaults.set(true, forKey: CacheConstants.isUserLoggedIn)
            }
        } else {
            if !defaults.bool(forKey: CacheConstants.isUserLoggedIn) {
                print("User is not logged in")
            } else {
                print("Mark User Logged Out")
                defaults.set(false, forKey: CacheConstants.isUserLoggedIn)
            }
        }
    }
    */
    // MARK: - Show Alert
    
    func showAlert(_ title:String?, message: String, actions:[UIAlertAction]?)
    {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if let actions = actions{
            for action in actions{
                alertViewController.addAction(action)
            }
        }else{
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertViewController.addAction(okAction)
        }
        
        
        DispatchQueue.main.async(execute: {
            APPLICATION.appDelegate.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
        })
        
    }
    
    func showDebugAlert(_ title:String?, message: String, actions:[UIAlertAction]?)
    {
        
        //TODO: Handle #if __DEBUG and #endif for this function
        let alertViewController = UIAlertController(title: "_Debug Message", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if let actions = actions{
            for action in actions{
                alertViewController.addAction(action)
            }
        }else{
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertViewController.addAction(okAction)
        }
        
        APPLICATION.appDelegate.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    // MARK: - Get-Set NSUserDefaults Global Value
    func setUserDefault(ObjectToSave : AnyObject?  , KeyToSave : String)
    {
        let defaults = UserDefaults.standard
        
        if (ObjectToSave != nil){
            defaults.set(ObjectToSave, forKey: KeyToSave)
        }
        defaults.synchronize()
    }
    
    func getUserDefault(KeyToGetValue : String) -> AnyObject?
    {
        let defaults = UserDefaults.standard
        
        if let name = defaults.value(forKey: KeyToGetValue){
            return name as AnyObject?
        }
        return nil
    }
}

