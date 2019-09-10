//
//  HomeTutorialView.swift
//  PlacePoint
//
//  Created by MRoot on 10/10/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class HomeTutorialView: UIView {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        
        self.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        
        UserDefaults.standard.setisFirstlaunch(isFirst: false)
        
        self.removeFromSuperview()
        
    }
    
}
