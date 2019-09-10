//
//  PopUpSubScriptionPlan.swift
//  PlacePoint
//
//  Created by Mac on 07/08/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

var selectedPlan = String()

var dictSelectedPlan = [String: String]()

protocol SelectedSubPlan: class {
    
    func setSubPlan(name: String)
}

class PopUpSubScriptionPlan: UIView {
    
    @IBOutlet var btnStd: UIButton!
    
    @IBOutlet var btnPrem: UIButton!
    
    @IBOutlet var btnFee: UIButton!
    
    @IBOutlet var imgFree: UIImageView!
    
    @IBOutlet var imgStd: UIImageView!
    
    @IBOutlet var imgPrem: UIImageView!
    
    @IBOutlet var imgAdmin: UIImageView!
    
    weak var delegate: SelectedSubPlan?
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        isSubSelectPlane = true
        
        self.imgPrem.image = #imageLiteral(resourceName: "Radiobtn_on")
        
        if !dictSelectedPlan.isEmpty {
            
            if dictSelectedPlan["statusFree"] == "true" {
                
                self.imgFree.image = #imageLiteral(resourceName: "Radiobtn_on")
                
                self.imgPrem.image = #imageLiteral(resourceName: "RadiBtn_off")
                
            }
            else if dictSelectedPlan["statusStandard"] == "true" {
                
                self.imgStd.image = #imageLiteral(resourceName: "Radiobtn_on")
                
                self.imgPrem.image = #imageLiteral(resourceName: "RadiBtn_off")
                
            }
            else if dictSelectedPlan["statusPremium"] == "true"{
                
                self.imgPrem.image = #imageLiteral(resourceName: "Radiobtn_on")
                
            }
            else if dictSelectedPlan["statusAdmin"] == "true"{
                
                self.imgAdmin.image = #imageLiteral(resourceName: "Radiobtn_on")
                
                self.imgPrem.image = #imageLiteral(resourceName: "RadiBtn_off")
                
            }
            else{
                print("nooo")
            }
            
        }
    }
    
    
    //MARK: UIActions
    @IBAction func btnChoosePlan(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            isSubSelectPlane = true
            
            self.imgFree.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            self.imgPrem.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            self.imgStd.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            self.imgAdmin.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            selectedPlan = "3"
            
            dictSelectedPlan["statusFree"] = "true"
            
            dictSelectedPlan["statusPremium"] = "false"
            
            dictSelectedPlan["statusStandard"] = "false"
            
            dictSelectedPlan["statusAdmin"] = "false"
            
        }
        else if sender.tag == 1 {
            
            self.imgStd.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            self.imgPrem.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            self.imgFree.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            self.imgAdmin.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            isSubSelectPlane = true
            
            selectedPlan = "2"
            
            dictSelectedPlan["statusStandard"] = "true"
            
            dictSelectedPlan["statusFree"] = "false"
            
            dictSelectedPlan["statusPremium"] = "false"
            
            dictSelectedPlan["statusAdmin"] = "false"
            
        }
        else if sender.tag == 2 {
            
            self.imgPrem.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            self.imgFree.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            self.imgStd.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            self.imgAdmin.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            selectedPlan = "1"
            
            isSubSelectPlane = true
            
            dictSelectedPlan["statusPremium"] = "true"
            
            dictSelectedPlan["statusFree"] = "false"
            
            dictSelectedPlan["statusStandard"] = "false"
            
            dictSelectedPlan["statusAdmin"] = "false"
            
        }
        else {
            
            self.imgAdmin.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            self.imgPrem.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            self.imgFree.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            self.imgStd.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            selectedPlan = "4"
            
            isSubSelectPlane = true
            
            dictSelectedPlan["statusAdmin"] = "true"
            
            dictSelectedPlan["statusFree"] = "false"
            
            dictSelectedPlan["statusPremium"] = "false"
            
            dictSelectedPlan["statusStandard"] = "false"
            
        }
    }
    
    
    @IBAction func btnOk(_ sender: UIButton) {
        
        delegate?.setSubPlan(name: selectedPlan)
    }
}
