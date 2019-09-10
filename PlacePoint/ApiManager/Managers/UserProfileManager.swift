//
//  UserProfileManager.swift
//  PlacePoint
//
//  Created by Mac on 08/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class UserProfileManager: NSObject {
    
    static let sharedInstance : UserProfileManager = {
        
        let instance = UserProfileManager()
        
        return instance
    }()
    
    private override init() { }
    
    var userSelectedTownId: String?
    
    var userSelectedTownName: String?
    
    var userSelectedCategoryName: String?
    
    var userSelectedCategoryId: String?
    
}
