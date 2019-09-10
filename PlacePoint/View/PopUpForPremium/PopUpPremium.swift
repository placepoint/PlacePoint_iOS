//
//  PopUpPremium.swift
//  PlacePoint
//
//  Created by Mac on 06/08/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

protocol UpgradePlan: class{
    
    func upgradeSubPlan()
}


class PopUpPremium: UIView {

    @IBOutlet var popUpView: UIView!
    
    weak var delegate: UpgradePlan?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    //MARK: -UIAction
    @IBAction func btnUpgrade(_ sender: UIButton) {
        
        delegate?.upgradeSubPlan()
        
    }
}
