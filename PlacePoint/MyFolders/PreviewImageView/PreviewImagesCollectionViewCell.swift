//
//  PreviewImagesCollectionViewCell.swift
//  PlacePoint
//
//  Created by Mac on 20/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher

class PreviewImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPreviewCollection: UIImageView!
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    func setData(arr: [AnyObject],index: Int) {
        
        if arr.isEmpty {
            return
        }
        
        let strHttp = NSString(format: "%@", (arr[index] as! CVarArg))
        
        if strHttp.contains("https://") {
            
            let url = URL(string:strHttp as String)!
            
            self.imgPreviewCollection.kf.indicatorType = .activity
            
            (self.imgPreviewCollection.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
            
            self.imgPreviewCollection.kf.setImage(with: url,
                                                  placeholder: #imageLiteral(resourceName: "placeholder"),
                                                  options: [.transition(ImageTransition.fade(1))],
                                                  progressBlock: { receivedSize, totalSize in
            },
                                                  completionHandler: { image, error, cacheType, imageURL in
            })
        }
        else {
            
            self.imgPreviewCollection.isHidden = false
            
            self.imgPreviewCollection.image = arr[index] as! UIImage
            
        }
        
    }
}
