//
//  AppDataManager.swift
//  PlacePoint
//
//  Created by Mac on 08/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class AppDataManager: NSObject {
    
    static let sharedInstance : AppDataManager = {
        
        let instance = AppDataManager()
        
        return instance
    }()
    
    private override init() { }
    
    var dictParams = [String : String]()
    
    var arrTowns = [AnyObject]()
    
    var arrCategories = [AnyObject]()
    
    var arrAllFeeds = [AnyObject]()
    
    var arrAllBusinesses = [AnyObject]()
    
    
    // MARK: - GetAppDataApi
    func getAppData(completionHandler:@escaping (_ dict: NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.getMethedWithoutParams("getAppData", completionHandler: { (dictResponse) in
            
            let strStatus = dictResponse["status"] as? String
            
            if strStatus == "true" {
                
                let arrNotSortedTown = dictResponse["location"] as? NSArray
                print(arrNotSortedTown)
                
                let descriptorTown: NSSortDescriptor = NSSortDescriptor(key: "townname", ascending: true)
                
                let sortedTown: NSArray = arrNotSortedTown!.sortedArray(using: [descriptorTown]) as NSArray
                
                self.arrTowns = sortedTown as [AnyObject]
                
                let arrNotSortedCategories = (dictResponse["category"] as? NSArray)!
                
                print(arrNotSortedCategories)
                
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                
                let sortedResults: NSArray = arrNotSortedCategories.sortedArray(using: [descriptor]) as NSArray
                
                print(sortedResults)
                
                self.arrCategories = sortedResults as [AnyObject]
                
                 UserDefaults.standard.setArrCategories(value: sortedResults as [AnyObject])
                
            }
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
    }
    
    
    func getAppAuth(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        let device = UIDevice.current
        
        let currentId = device.identifierForVendor?.uuidString
        
        let strLocationId = CommonClass.sharedInstance.getLocationId(strLocation: selectedTown, array: arrTowns as [AnyObject])
        
        let dictParams = ["device_id":currentId, "town_id":strLocationId, "device_type":"ios"]
        
        WebService.sharedInstance.postMethodWithParams(strURL: "getAppAuth", dict: dictParams as NSDictionary, completionHandler: { (dictResponse) in
            
            let strStatus = dictResponse["status"] as? String
            
            let arrData = dictResponse["data"] as? [AnyObject]
            
            if strStatus == "true" {
                
                let strAuthCode = arrData![0]["auth_code"]
                
                UserDefaults.standard.setupAuthCode(auth: strAuthCode as! String)
                
                UserDefaults.standard.setisAppAuthFirst(isFirst: true)
                
            }
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
    }
    
    
    func apiForgotPass(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "forgotPassword", dict: dictParams as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    func apiUpdatePass(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "updatePassword", dict: dictParams as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    func apiRegister(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "register", dict: dictParams as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    func apiApplyCoupon(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "apply_coupon", dict: dictParams as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    func getAppDataWithTown(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "getAllFeeds", dict: dictParams as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    func apiLogin(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "login", dict: dictParams as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
}
