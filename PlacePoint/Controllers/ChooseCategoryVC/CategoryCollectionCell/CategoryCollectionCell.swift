//
//  CategoryCollectionCell.swift
//  PlacePoint
//
//  Created by Mac on 10/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCategoryView: UIImageView!
    
    @IBOutlet weak var viewCategory: UIView!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet var vwBackgroundCategory: UIView!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        viewCategory.layer.borderWidth = 1
        
        viewCategory.layer.borderColor = UIColor.black.cgColor
        
        vwBackgroundCategory.layer.borderWidth = 1
        
        vwBackgroundCategory.layer.borderColor = UIColor.black.cgColor
    }
    
    
    func setSubCategoryData(arr: [AnyObject], index: Int) {
        
        if arr.isEmpty {
            return
        }
        
        let dict = arr[index] as? [String: Any]
        
        if (dict?.isEmpty)! {
            
            self.lblCategory.text = "All"
            
            let arr = AppDataManager.sharedInstance.arrCategories as? [AnyObject]
            
            for i in 0..<(arr?.count)! {
                
                let dict = arr![i] as? [String: Any]
                
                let name = dict!["name"] as? String
                
                if name == parentCategory {
                    
                    let strImgUrl = dict!["image_url"] as? String
                    
                    if strImgUrl != "" {
                        
                        let url = URL(string:strImgUrl as! String)!
                        
                        self.imageCategoryView.kf.indicatorType = .activity
                        
                        (self.imageCategoryView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
                        
                        self.imageCategoryView.kf.setImage(with: url,
                                                           placeholder: #imageLiteral(resourceName: "placeholder"),
                                                           options: [.transition(ImageTransition.fade(1))],
                                                           progressBlock: { receivedSize, totalSize in
                        },
                                                           completionHandler: { image, error, cacheType, imageURL in
                        })
                    }
                    
                }
                
            }
            
        }
        else {
            
            self.lblCategory.text = (arr[index] as AnyObject).value(forKey: "subCat") as? String
            
            let strUrl = (arr[index] as AnyObject).value(forKey: "img_url") as? String
            
            if strUrl != "" {
                
                let url = URL(string:strUrl as! String)!
                
                self.imageCategoryView.kf.indicatorType = .activity
                
                (self.imageCategoryView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
                
                self.imageCategoryView.kf.setImage(with: url,
                                                   placeholder: #imageLiteral(resourceName: "placeholder"),
                                                   options: [.transition(ImageTransition.fade(1))],
                                                   progressBlock: { receivedSize, totalSize in
                },
                                                   completionHandler: { image, error, cacheType, imageURL in
                })
            }
        }
    }
    
    
    func setData(arr: [AnyObject], index: Int) {
        
        if arr.isEmpty {
            return
        }
        
        self.lblCategory.text = (arr[index] as AnyObject).value(forKey: "parentCat") as? String
        
        let strUrl = (arr[index] as AnyObject).value(forKey: "img_url") as? String
        
        if strUrl != "" {
            
            let url = URL(string:strUrl as! String)!
            
            self.imageCategoryView.kf.indicatorType = .activity
            
            (self.imageCategoryView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
            
            self.imageCategoryView.kf.setImage(with: url,
                                               placeholder: #imageLiteral(resourceName: "placeholder"),
                                               options: [.transition(ImageTransition.fade(1))],
                                               progressBlock: { receivedSize, totalSize in
            },
                                               completionHandler: { image, error, cacheType, imageURL in
            })
        }
    }
    
}
