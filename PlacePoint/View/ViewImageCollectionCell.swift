//
//  ViewImageCollectionCell.swift
//  placepoint
//
//  Created by Mac on 11/06/18.
//  Copyright © 2018 "". All rights reserved.
//

import UIKit
import Kingfisher

protocol DeleteCell: class {
    
    func deleteSavedImage(selectedIndex: Int)
}

class ViewImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var imgCollection: UIImageView!
    
    var delegate: DeleteCell?
    
    var cellIndex = Int()
    
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    
    func setData(arr: [AnyObject], index: Int) {
        
        if arr.isEmpty {
            return
        }
        
        
        let strHttp = NSString(format: "%@", (arr[index] as! CVarArg))
        
        if strHttp.contains("https://") {
            
            self.imgCollection.isHidden = false
            
            let url = URL(string:strHttp as String)!
            
            self.imgCollection.kf.indicatorType = .activity
            
            (self.imgCollection.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
            
            self.imgCollection.kf.setImage(with: url,
                                           placeholder:#imageLiteral(resourceName: "placeholder"),
                                           options: [.transition(ImageTransition.fade(1))],
                                           progressBlock: { receivedSize, totalSize in
            },
                                           completionHandler: { image, error, cacheType, imageURL in
            })
    
        }
        else {
            
            self.imgCollection.isHidden = false
            
            self.imgCollection.image = arr[index] as? UIImage
            
        }
    }
    
    
    //MARK: UIActions
    @IBAction func btnClose(_ sender: UIButton) {
        
        delegate?.deleteSavedImage(selectedIndex: sender.tag)
        
    }
    
}
