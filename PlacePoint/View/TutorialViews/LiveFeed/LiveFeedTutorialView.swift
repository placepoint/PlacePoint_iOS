//
//  LiveFeedTutorialView.swift
//  PlacePoint
//
//  Created by MRoot on 10/10/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class LiveFeedTutorialView: UIView {

    @IBOutlet weak var imgBg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        
        UserDefaults.standard.setisFirstTutorialLive(isFirst: false)
        
        self.removeFromSuperview()
        
    }
}
