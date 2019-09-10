//
//  SubscriptionCollectionCell.swift
//  PlacePoint
//
//  Created by Mac on 08/08/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

protocol SubDetails: class {
    
    func getSubDetails(index: Int)
    
}
class SubscriptionCollectionCell: UICollectionViewCell {

    @IBOutlet var imgVwSubPlan: UIImageView!
    
    @IBOutlet var lblPackage: UILabel!
    
    @IBOutlet var lblPlanDes: UILabel!
    
    @IBOutlet var lblAmount: UILabel!
    
    @IBOutlet var btnUpgrade: UIButton!
    
    weak var delegate: SubDetails?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        lblPlanDes.text = "∙ Lorem ipsum dolor sit amet. \n∙ consectetur adipiscing elit. \n∙ sed do eiusmod tempor incididunt ut. \n∙ labore et dolore magna aliqua."
       
    }


    @IBAction func btnUpgarde(_ sender: UIButton) {
        
        delegate?.getSubDetails(index: sender.tag)
        
    }
    
}
