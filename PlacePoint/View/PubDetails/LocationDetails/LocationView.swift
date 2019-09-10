//
//  LocationView.swift
//  PlacePoint
//
//  Created by Mac on 29/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

protocol mapDelegate: class {
    
    func showMapView()
}

class LocationView: UIView {
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblFullAddress: UILabel!
    
    @IBOutlet weak var lblSelectedTown: UILabel!
    
    @IBOutlet weak var lblSelectedCategory: UILabel!
    
    @IBOutlet var lblSubPlan: UILabel!
    
    @IBOutlet var vwSubPlan: UIView!
    
    weak var delegate: mapDelegate?
    
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        lblFullAddress.text = "DieSachbearbeiter \n Choriner Straße \n 4910435 Berlin \n E-Mail: moinsen@blindtextgenerator.com"
    }
    
    
    func setData(dict: [String: Any]) {
        
        if dict.isEmpty {
            return
        }
        
        let checkBusinessLogin = UserDefaults.standard.getBusinessLogin()
        
        if checkBusinessLogin == true {
        
            let businessId = UserDefaults.standard.getBusinessId()
            
            if businessId == dict["id"] as? String {
                
                vwSubPlan.isHidden = false
                
                if strBusinessUserType == "3" {
                    
                    self.lblSubPlan.text = "Free Package"
                }
                else if strBusinessUserType == "1" {
                    
                    self.lblSubPlan.text = "Premium Package"
                }
                else if strBusinessUserType == "2" {
                    
                    self.lblSubPlan.text = "Standard Package"
                }
                else {
                    
                    self.lblSubPlan.text = "Admin"
                }
                
            }
            else {
                
                vwSubPlan.isHidden = true
                
            }
          
        }
        else {
            
            vwSubPlan.isHidden = true
            
        }
        
        if let address = dict["address"] as? String, let contactno = dict["contact_no"] as? String,
            let email = dict["email"] as? String {
            
            self.lblFullAddress.text = "\(address) \n\n \(contactno) \n \(email)"
        }
        
        let townName = CommonClass.sharedInstance.getTownName(strTown: dict["town_id"] as! String, array: AppDataManager.sharedInstance.arrTowns as [AnyObject])
        
        self.lblSelectedTown.text = townName
        
        let strSelectedCategory = dict["category_id"] as? String
        
        let arrSelectedCategory = strSelectedCategory?.components(separatedBy: ",")
        
        let categoryName = CommonClass.sharedInstance.getCategoryArrayName(strCategory: arrSelectedCategory!, array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
        
        self.lblSelectedCategory.text = categoryName.joined(separator: ",")
        
    }
    
    
    //MARK: UIActions
    @IBAction func btnViewMap(_ sender: UIButton) {
        
        delegate?.showMapView()
    }
}
