//
//  PopUpFilterView.swift
//  PlacePoint
//
//  Created by MRoot on 15/10/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

var selectedFilterType: String = ""

protocol FilterActions: class {
    
    func selectedFilter(name: String)
  
    func dismissPopUp()
}

class PopUpFilterView: UIView {
    
    //Mark: IBOutlet
    @IBOutlet weak var btnListing: UIButton!
    
    @IBOutlet weak var imgListing: UIImageView!
    
    @IBOutlet weak var btnPaidToFree: UIButton!
    
    @IBOutlet weak var imgPaidToFree: UIImageView!
    
    weak var delegate: FilterActions?
    
    //Mark: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if selectedFilterType == "" {
            self.imgListing.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            self.imgPaidToFree.image = #imageLiteral(resourceName: "RadiBtn_off")
        }
        else if selectedFilterType == "Near me" {
            
            self.imgListing.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            self.imgPaidToFree.image = #imageLiteral(resourceName: "RadiBtn_off")
        }
        else {
            
            self.imgListing.image = #imageLiteral(resourceName: "RadiBtn_off")
            self.imgPaidToFree.image = #imageLiteral(resourceName: "Radiobtn_on")
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        
        self.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        
        self.removeFromSuperview()
        
    }
    
    //Mark: UIAction
    @IBAction func btnNearListingAction(_ sender: UIButton) {
        
        self.imgListing.image = #imageLiteral(resourceName: "Radiobtn_on")
        
        self.imgPaidToFree.image = #imageLiteral(resourceName: "RadiBtn_off")
        
        selectedFilterType = "Near me"
        
    }
    
    
    @IBAction func btnPaidToFreeAction(_ sender: UIButton) {
        
         self.imgPaidToFree.image = #imageLiteral(resourceName: "Radiobtn_on")
        
         self.imgListing.image = #imageLiteral(resourceName: "RadiBtn_off")
        
        selectedFilterType = "Paid to free"
        
    }
    
    @IBAction func btnOkAction(_ sender: UIButton) {
        
        delegate?.selectedFilter(name: selectedFilterType)
        
    }
    
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        delegate?.dismissPopUp()
        
    }
    
    
}


