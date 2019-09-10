//
//  SchedulePostCell.swift
//  PlacePoint
//
//  Created by Mac on 24/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

protocol OpenPicker: class {
    
    func openPicker(cellIndex: Int)
}

class SchedulePostCell: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var lblSchedule: UILabel!
    
    @IBOutlet var btnEdit: UIButton!
    
    weak var delegate: OpenPicker?
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        if let myImage = UIImage(named: "img_showTownBar") {
            
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            
            btnEdit.setImage(tintableImage, for: .normal)
            
            btnEdit.imageView?.tintColor = UIColor(red: 77.0/255.0, green: 183.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        }
        
    }
    
    
    //MARK: - UIActions
    @IBAction func btnEdit(_ sender: UIButton) {
        
        delegate?.openPicker(cellIndex: sender.tag)
        
    }
    
}
