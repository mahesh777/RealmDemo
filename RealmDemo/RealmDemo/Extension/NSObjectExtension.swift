//
//  EMUIApplicationExtension.swift
//  RealmDemo
//
//  Created by Mahesh on 20/12/16.
//  Copyright © 2016 brainvire. All rights reserved.
//

import Foundation
import UIKit

let storyboard_R1 = UIStoryboard(name: ((UIDevice.current.userInterfaceIdiom == .pad) ? "Main" : "Main" ), bundle: nil)

extension NSObject {
    
    // MARK: - Storyboard operations
    public func makeStoryObj(storyboard : UIStoryboard, Identifier identifier : String) -> UIViewController{
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    public func pushStoryObj(obj : UIViewController, on vc: UIViewController){
        return (vc.navigationController?.pushViewController(obj, animated: true))!
    }
    
    public func pushStory(storyboard : UIStoryboard, identifier : String, on vc: UIViewController){
        vc.navigationController?.pushViewController(makeStoryObj(storyboard: storyboard, Identifier: identifier), animated: true)
    }            
}
