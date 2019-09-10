//
//  FeedCollectionCell.swift
//  PlacePoint
//
//  Created by Mac on 06/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher

class FeedCollectionCell: UICollectionViewCell {
   
    
    @IBOutlet weak var lblTown: InsetLabel!
   
    @IBOutlet weak var imagesCollections: UIImageView!

    
    //MARK: Life Cycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
        

    }
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        imagesCollections.image = UIImage(named: "")
    
    }

    
    func setData(url: String) {
        
        if url == "" {
            
            return
        }
        
         let strUrl = url
        
        if strUrl != "" {
            
            let url = URL(string: strUrl)!
            
            self.imagesCollections.kf.indicatorType = .activity
            
            (self.imagesCollections.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
            
            self.imagesCollections.kf.setImage(with: url,
                                               placeholder: #imageLiteral(resourceName: "placeholder-1"),
                                               options: [.transition(ImageTransition.fade(1))],
                                               progressBlock: { receivedSize, totalSize in
            },
                                               completionHandler: { image, error, cacheType, imageURL in
            })
            
        }
    }
}
@IBDesignable class InsetLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset)
        }
        set {
            topInset = newValue.top
            leftInset = newValue.left
            bottomInset = newValue.bottom
            rightInset = newValue.right
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjSize = super.sizeThatFits(size)
        adjSize.width += leftInset + rightInset
        adjSize.height += topInset + bottomInset
        
        return adjSize
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += leftInset + rightInset
        contentSize.height += topInset + bottomInset
        
        return contentSize
    }
}
