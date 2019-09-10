//
//  FlashPostTVcell.swift
//  PlacePoint
//
//  Created by Mind Roots on 23/11/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class FlashPostTVcell: UITableViewCell {

    @IBOutlet weak var switchFlashPost: UISwitch!
    
    @IBOutlet weak var btnOffers: UIButton!
    
    @IBOutlet weak var btnPersons: UIButton!
    
    @IBOutlet weak var btnExpiryTime: UIButton!
    
    @IBOutlet weak var btnExpiryDate: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
