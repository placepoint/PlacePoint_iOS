//
//  RedeemVCManager.swift
//  PlacePoint
//
//  "" on 04/12/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class RedeemVCManager: NSObject {
    
    static let sharedInstance : RedeemVCManager = {
    
    let instance = RedeemVCManager()
    
    return instance
   
    }()
    
    var dictParams = [String: Any]()
    
    private override init() {}
    
    //MARK:- Get Feed Details
    func getClaimedFlashPost(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
    
    WebService.sharedInstance.postMethodWithParams(strURL: "getClaimedFlashPostList", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
    
    completionHandler(dictResponse)
    
    }, failure: { (strError :String) in
    
    failure(strError)
    })
        
    }
    
    
    //MARK:- Get Feed Details
    func bumpPost(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "bumppost", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    //MARK:- Get Feed Details
    func RedeemedFlashPost(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "changeFlashPostStatus", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    func sendEmail(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "sendEmail", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
}
