//
//  HomeVCManager.swift
//  PlacePoint
//
//  Created by Mind Root on 27/11/18.
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
        
        WebService.sharedInstance.postMethodWithParams(strURL: "getFlashPost", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
    }
}
