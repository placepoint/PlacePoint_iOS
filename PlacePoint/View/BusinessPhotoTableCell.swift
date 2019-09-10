//
//  BusinessPhotoTableCell.swift
//  PlacePoint
//
//  Created by Mac on 20/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher

protocol OpenPreviewImages: class {
    
    func openImagePreview(index: Int)
}

class BusinessPhotoTableCell: UITableViewCell {
    
    @IBOutlet weak var collectionPhotos: UICollectionView!
    
    weak var delegate: OpenPreviewImages?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib(nibName: "ViewImageCollectionCell", bundle: nil)
        
        self.collectionPhotos.register(nib, forCellWithReuseIdentifier: "ViewImageCollectionCell")
    }
    
}


//MARK: - UICollectionView DataSource and Delegate
extension BusinessPhotoTableCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if arrBusinessImages.count > 0 {
            
            return arrBusinessImages.count
            
        } else{
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewImageCollectionCell", for: indexPath) as? ViewImageCollectionCell else {
            fatalError()
        }
        
        cell.imgCollection.isHidden = true
        
        cell.btnDelete.isHidden = true
        
        if arrBusinessImages.count > 0 {
            
        let strHttp = NSString(format: "%@", (arrBusinessImages[indexPath.row] as! CVarArg))
        
        if strHttp.contains("https://") {
            
            cell.imgCollection.isHidden = false
            
            let url = URL(string:strHttp as String)!
            
            cell.imgCollection.kf.indicatorType = .activity
            
            (cell.imgCollection.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
            
            cell.imgCollection.kf.setImage(with: url,
                                           placeholder: #imageLiteral(resourceName: "placeholder"),
                                           options: [.transition(ImageTransition.fade(1))],
                                           progressBlock: { receivedSize, totalSize in
            },
                                           completionHandler: { image, error, cacheType, imageURL in
            })
            
            }
        } else {
            
            cell.imgCollection.isHidden = false
            
            cell.imgCollection.image = arrBusinessImages[indexPath.row] as! UIImage
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if arrBusinessImages.count > 0 {
            
            return CGSize(width: 80, height: 80)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.openImagePreview(index: indexPath.row)
        
    }
}
