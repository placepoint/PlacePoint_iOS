//
//  RegisterCell.swift
//  PlacePoint
//
//  Created by Mac on 28/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

protocol OpenForgotScreen: class {
    
    func openForgotVc()
    
}

class RegisterCell: UITableViewCell {
    
    @IBOutlet var btnPicker: UIButton!
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet weak var btnForgotPass: UIButton!
    
    @IBOutlet var txtFldRegister: UITextField!
    
    @IBOutlet weak var btnDropDown: UIButton!
    
    
    weak var delegate: OpenForgotScreen?
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        
        delegate?.openForgotVc()
        
    }
    
}
