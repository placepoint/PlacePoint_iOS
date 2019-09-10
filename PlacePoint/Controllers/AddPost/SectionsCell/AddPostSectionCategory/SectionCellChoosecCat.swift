//
//  SectionCellChoosecCat.swift
//  PlacePoint
//
//  Created by Mac on 27/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

protocol ChooseCategory: class {
    
    func chooseCategory()
    
}

class SectionCellChoosecCat: UITableViewCell {

    @IBOutlet var lblChooseCategory: UILabel!
    
    @IBOutlet var vwChooseCat: UIView!
    
    weak var delegate: ChooseCategory?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        vwChooseCat.layer.borderWidth = 0.5
        
        vwChooseCat.layer.cornerRadius = 5
        
        vwChooseCat.layer.borderColor = UIColor.black.cgColor
        
    }

    
    //MARK: - UIActions
    @IBAction func btnChooseCategory(_ sender: UIButton) {
        
        delegate?.chooseCategory()
    }
    
}
