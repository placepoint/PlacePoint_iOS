//
//  AddPostViewCell.swift
//  PlacePoint
//
//  Created by Mac on 11/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

protocol DeleteImage: class {
    
    func deleteImage()
}

class AddPostViewCell: UITableViewCell {

    @IBOutlet weak var imgThumnail: UIImageView!
    
    @IBOutlet weak var btnCross: UIButton!
    
    @IBOutlet weak var heightContraintImgThumb: NSLayoutConstraint!
    
    @IBOutlet weak var widthConstraintImgthumb: NSLayoutConstraint!
    
    
    weak var delegate: DeleteImage?
    
    
    //MARK: - LIfeCycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        btnCross.layer.zPosition = 1
        
    }

    func setData(dict: [String: Any]) {
        
        print(dict)
        
    }
    
    
    //MARK: - UIActions
    @IBAction func btnDelete(_ sender: UIButton) {
        
        delegate?.deleteImage()
    }
}
