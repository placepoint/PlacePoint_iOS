//
//  AddPostTutorial.swift
//  PlacePoint
//
//  Created by MRoot on 10/10/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class AddPostTutorial: UIView {
    
    @IBOutlet weak var imgTakePhotoArrow: UIImageView!
    
    @IBOutlet weak var lblTakePhotoArrow: UILabel!
    
    @IBOutlet weak var imgGalleryArrow: UIImageView!
    
    @IBOutlet weak var lblGallery: UILabel!
    
    @IBOutlet weak var imgYoutubeArrow: UIImageView!
    
    @IBOutlet weak var lblYoutube: UILabel!
    
    @IBOutlet weak var imgChooseCat: UIImageView!
    
    @IBOutlet weak var lblChooseCat: UILabel!
    
    @IBOutlet weak var imgScheduleArrow: UIImageView!
    
    @IBOutlet weak var lblSchedule: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIScreen.main.bounds.size.height == 736.0 {
            
            imgTakePhotoArrow.frame = CGRect(x: 370.0, y: 290.0, width: 50.0, height: 36.0)

            lblTakePhotoArrow.frame = CGRect(x: 270.0, y: 270.0, width: 100.0, height: 57.0)

            imgGalleryArrow.frame = CGRect(x: 475.0, y: 280.0, width: 36.0, height: 36.0)

            lblGallery.frame = CGRect(x: 400.0, y: 220.0, width: 150.0, height: 57.0)

            imgYoutubeArrow.frame = CGRect(x: 500.0, y: 330.0, width: 36.0, height: 36.0)

            lblYoutube.frame = CGRect(x: 450.0, y: 365.0, width: 120.0, height: 57.0)

            imgChooseCat.frame = CGRect(x: 310.0, y: 390.0, width: 80.0, height: 50.0)

            lblChooseCat.frame = CGRect(x: 400.0, y: 420.0, width: 130.0, height: 75.0)

            imgScheduleArrow.frame = CGRect(x: 100.0, y: 440.0, width: 80.0, height: 40.0)

            lblSchedule.frame = CGRect(x: 200.0, y: 450.0, width: 150.0, height: 90.0)
          
            
        }
            
        else if UIScreen.main.bounds.size.height == 812.0 {
           
         imgTakePhotoArrow.frame = CGRect(x: 370.0, y: 280.0, width: 50.0, height: 36.0)
            
       lblTakePhotoArrow.frame = CGRect(x: 270.0, y: 250.0, width: 100.0, height: 57.0)
        
        imgGalleryArrow.frame = CGRect(x: 465.0, y: 280.0, width: 36.0, height: 36.0)

        lblGallery.frame = CGRect(x: 400.0, y: 220.0, width: 150.0, height: 57.0)

        imgYoutubeArrow.frame = CGRect(x: 490.0, y: 315.0, width: 36.0, height: 36.0)

          lblYoutube.frame = CGRect(x: 450.0, y: 350.0, width: 120.0, height: 57.0)
           
         imgChooseCat.frame = CGRect(x: 310.0, y: 380.0, width: 80.0, height: 50.0)

           lblChooseCat.frame = CGRect(x: 400.0, y: 410.0, width: 130.0, height: 75.0)
            
        imgScheduleArrow.frame = CGRect(x: 100.0, y: 420.0, width: 80.0, height: 40.0)

            lblSchedule.frame = CGRect(x: 200.0, y: 430.0, width: 150.0, height: 90.0)
            
        
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        
        self.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        
       UserDefaults.standard.setisFirstTutorialPost(isFirst: false)
        
        self.removeFromSuperview()
        
    }

}
