//
//  ZoomImagesCollectionViewCell.swift
//  PocketBrokerConsumer
//
//  ""s Technologies on 21/02/17.
//  Copyright © 2017  Technologies. All rights reserved.
//

import UIKit
import Kingfisher

class ZoomImagesCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet var svContainer: UIScrollView!
    
    @IBOutlet var imgBuilding: UIImageView!
    
   
    
    
    
    override func awakeFromNib() {
       
        super.awakeFromNib()
        
       
    }
    
   
    func setCellInfo(imgReady: String, strImageUrl: String, strImageTitle: String, image:UIImage) -> Void {
        
        svContainer.minimumZoomScale = 1.0
       
        svContainer.maximumZoomScale = 2.0
        
        svContainer.zoomScale = 1.0
        
        svContainer.delegate = self
        
//        imgBuilding.image = image
        
        
        if strImageUrl != "" {
            
            let url = URL(string: strImageUrl)!
            
            self.imgBg.kf.indicatorType = .activity
            
            (self.imgBg.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
            
            self.imgBg.kf.setImage(with: url,
                                               placeholder: #imageLiteral(resourceName: "placeholder-1"),
                                               options: [.transition(ImageTransition.fade(1))],
                                               progressBlock: { receivedSize, totalSize in
            },
                                               completionHandler: { image, error, cacheType, imageURL in
            })
            
            
            let urlImgBuilding = URL(string: strImageUrl)!
            
            self.imgBuilding.kf.indicatorType = .activity
            
            (self.imgBuilding.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
            
            self.imgBuilding.kf.setImage(with: urlImgBuilding,
                                   placeholder: #imageLiteral(resourceName: "placeholder-1"),
                                   options: [.transition(ImageTransition.fade(1))],
                                   progressBlock: { receivedSize, totalSize in
            },
                                   completionHandler: { image, error, cacheType, imageURL in
            })
            
        }
        
        
//        imgBg.image = image
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = imgBg.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        imgBg.addSubview(blurEffectView)
        
//        imgBg.alpha = 0.25

    }
    
    
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        

      return self.imgBuilding
        
    }
    
    
    func scrollViewDidZoom(_ sv: UIScrollView) {
       
        if let zoomView: UIView = sv.delegate?.viewForZooming!(in: sv) {
            var zvf: CGRect! = zoomView.frame
            
            //        zvf = (zoomView?.frame)!
            
            if (zvf.size.width) < sv.bounds.size.width {
                
                zvf.origin.x = (sv.bounds.size.width - (zvf.size.width)) / 2.0
            }
            else {
                
                zvf.origin.x = 0.0
            }
            if (zvf.size.height) < sv.bounds.size.height {
                
                zvf.origin.y = (sv.bounds.size.height - (zvf.size.height)) / 2.0
            }
            else {
                
                zvf.origin.y = 0.0
            }
            zoomView.frame = zvf
        }
        
       
        
       
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        scrollView.zoomScale = 1.0
    }
}
