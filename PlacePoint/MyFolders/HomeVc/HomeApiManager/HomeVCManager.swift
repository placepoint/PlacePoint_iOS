//
//  HomeVCManager.swift
//  PlacePoint
//
//  "" on 27/11/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class HomeVCManager: NSObject {

    static let sharedInstance : HomeVCManager = {
        
        let instance = HomeVCManager()
        
        return instance
    }()
    
    var dictParams = [String: Any]()
    
    private override init() {}
    
    //MARK:- Get Feed Details
    func getHomeFlashPost(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "getFlashPostV1", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
    }
    
    
    
    func getClaimFlashPost(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "claimDeal", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
    }
    
    
    func updateOnesignalid(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "updateOnesignalid", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
    }
}
