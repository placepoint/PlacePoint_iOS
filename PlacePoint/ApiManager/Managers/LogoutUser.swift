//
//  LogoutUser.swift
//  PlacePoint
//
//  Created by Mac on 22/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class LogoutUser: NSObject {
    
    static let sharedLogout:LogoutUser = {
        let instance = LogoutUser()
        return instance
    }()
    
    var dictParams = [String : String]()
    
    func apiLogout() {
        
        let strAuthCOde = UserDefaults.standard.getAuthCode()
        
        let strTown = UserDefaults.standard.getTown()
        
        var  strCategory = String()
        
        var strSelectCat = String()
        
        if isAllCategories == true {
            
             strCategory = UserDefaults.standard.getAllCatName()
        }
        else {
            
            let isKeyExists = CommonClass.sharedInstance.keyAlreadyExists(Key: "selectedCategory")
            
            if isKeyExists == true {
            
            strCategory = UserDefaults.standard.getSelectedCat()
            
            strSelectCat = UserDefaults.standard.getSelectedCategory()
            }
        }

        let strSelectedTown = UserDefaults.standard.getSelectedTown()
        
        let userType = UserDefaults.standard.getBusinessUserType()
        
        let dictParams: NSDictionary = ["auth_code":strAuthCOde] as NSDictionary
        
        self.dictParams = dictParams as! [String : String]
        
        self.apiLogOutUser(completionHandler: { (dictRespnse) in
            
            DispatchQueue.main.async {
                
                let strStatus = dictRespnse["status"] as? String
                
                if strStatus == "true" {
                    
                    goToShowFeed = false
                    
                    self.resetDefaults()
                    
                    UserDefaults.standard.setfirstTimeLoginPopUp(value: true)
                    
                    UserDefaults.standard.setBusinessUserType(userType: userType)
                    
                    UserDefaults.standard.setIsLoggedIn(value: false)
                    
                    UserDefaults.standard.setupAuthCode(auth: strAuthCOde)
                    
                    UserDefaults.standard.setTown(value: strTown)
                    
                    UserDefaults.standard.setisAppAuthFirst(isFirst: true)
                    
                    let isKeyExists = CommonClass.sharedInstance.keyAlreadyExists(Key: "selectedCategory")
                    
                    if isKeyExists == true {
                    
                    UserDefaults.standard.setSelectedCat(value: strCategory)
                    
                    UserDefaults.standard.setAllCatName(value: strCategory)
                    
                    UserDefaults.standard.selectedCategory(value: strSelectCat)
                    }
                    UserDefaults.standard.setSelectedTown(value: strSelectedTown)
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.setUpRootVC()
                    
                    SVProgressHUD.dismiss()
                }
            }
            
        }, failure: { (errorCode) in
            SVProgressHUD.dismiss()
            
        })
    }
    
    
    func resetDefaults() {
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        
        dictionary.keys.forEach { key in
            
            if key == "kDeviceId" || key == "kDeviceIdSentToApi" || key == "arrTown"{
                
                print("here")
            }
    
            if (key != "catSelected") && (key != "kDeviceId") && (key != "kDeviceIdSentToApi") && (key != "arrTown") {
                
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    
    func apiLogOutUser(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "logout", dict: dictParams as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
}
