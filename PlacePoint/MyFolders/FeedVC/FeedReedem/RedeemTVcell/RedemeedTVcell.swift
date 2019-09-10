//
//  RedemeedTVcell.swift
//  PlacePoint
//
//  "" on 04/12/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class RedemeedTVcell: UITableViewCell {

    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
   
    @IBOutlet weak var lblDateDescription: UILabel!
    
    @IBOutlet weak var btnSelect: UIButton!
    
    @IBOutlet weak var btnPhone: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
