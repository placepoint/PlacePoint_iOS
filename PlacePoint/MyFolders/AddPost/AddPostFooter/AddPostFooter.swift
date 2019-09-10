//
//  AddPostFooter.swift
//  PlacePoint
//
//  Created by Mac on 20/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

protocol ActionPost: class {
    
    func acionPost()
}

class AddPostFooter: UIView {

    weak var delegate: ActionPost?
    
    @IBOutlet var btnPost: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    
    //MARK: UIAction
    @IBAction func btnPost(_ sender: UIButton) {
        
        delegate?.acionPost()
        
    }
    
}
