//
//  FieldTableViewCell.swift
//  PlacePoint
//
//  Created by Mac on 28/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher

protocol OpenLink: class {
    
    func openUrlLink(videoUrl: String)
    
    func btnMore(index: Int)
    
    func btnFlash(index: Int)
}

class FieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgViewShare: UIImageView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet var btnMore: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblDescription: ExpandableLabel!
    
    @IBOutlet var collectionViewImages: UICollectionView!
    
    @IBOutlet var viewShowImages: UIView!
    
    @IBOutlet weak var heightOfCollectonView: NSLayoutConstraint!
    @IBOutlet weak var viewTopFlashOffer: UIView!
    
    @IBOutlet weak var viewClaimButton: UIView!
    @IBOutlet weak var viewYoutube: UIView!
    
    @IBOutlet weak var btnOpenUrl: UIButton!
    
    @IBOutlet weak var imgYouTubeThumNail: UIImageView!
    
    var videoLink: String?
    
    var delegate: OpenLink?
    
    var imageCollection: String?
    
    var arrayImages = [AnyObject]()
    
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        userImage.layer.cornerRadius = userImage.frame.width / 2
        
        userImage.clipsToBounds = true
        
        let nib = UINib(nibName: "FeedCollectionCell", bundle: nil)
        
        self.collectionViewImages.register(nib, forCellWithReuseIdentifier: "FeedCollectionCell")
        
    }
    
    
    func setData(arr: [AnyObject], index: Int) {
        
        if arr.isEmpty {
            return
        }
        
        self.lblTitle.text = arr[index]["business_name"] as? String
        
        if let createdDate = (arr[index]).value(forKey: "created_at") as? String {
            
            let dateFormatter = DateFormatter()
            
            let tempLocale = dateFormatter.locale // save locale temporarily
            
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date = dateFormatter.date(from: createdDate)
            
            dateFormatter.dateFormat = "MMM-dd-yyyy 'at' hh:mm a " ; //"dd-MM-yyyy HH:mm:ss"
            
            dateFormatter.locale = tempLocale // reset the locale --> but no need here
            
            let dateString = dateFormatter.string(from: date!)
            
            self.lblDate.text = "\(dateString)"
            
        }
        
        let strUrl = (arr[index] as AnyObject).value(forKey: "image_url") as! String
        
        if strUrl == "" {
            
            self.imageCollection = ""
            
            self.viewShowImages.isHidden = true
            
            self.collectionViewImages.isHidden = true
            
        }
        else {
            
            self.imageCollection = (arr[index] as AnyObject).value(forKey: "image_url") as? String
            
            self.viewShowImages.isHidden = false
            
            self.collectionViewImages.isHidden = false
        }
        
        let strVideoUrl = (arr[index] as AnyObject).value(forKey: "video_link") as! String
        
        if strVideoUrl != "" {
            
            self.videoLink = strVideoUrl
            
        }
        
    }
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        lblDescription.collapsed = true
        
        lblDescription.text = nil
        
        imgYouTubeThumNail.image = nil
        
        collectionViewImages.collectionViewLayout.invalidateLayout()
    }
    
    
    //MARK: - Reload CollectionView
    func reloadCollectionView(dict: NSDictionary)  {
        
        imageCollection = dict["image_url"] as? String
        
        videoLink = dict["video_link"] as? String
        
        if imageCollection != "" {
            
            let strheight = dict["height"] as? String
            
            let strWidth = dict["width"] as? String
            
            
            if strheight != "" && strWidth != "" {
                
                if let height = NumberFormatter().number(from: strheight!) as? CGFloat, let width = NumberFormatter().number(from: strWidth!) as? CGFloat {
                    
                    let ratio = width / height
                    
                    let newHeight = collectionViewImages.frame.size.width / ratio
                    
                    self.heightOfCollectonView.constant = newHeight
                    
                }
            }
            
        }
        
        collectionViewImages.delegate = self
        
        collectionViewImages.dataSource = self
        
        collectionViewImages.reloadData()
        
    }
    
    
    //MARK: - UIActions
    @IBAction func btnOpenUrl(_ sender: UIButton) {
        
        delegate?.openUrlLink(videoUrl: self.videoLink!)
        
    }
    
    
    @IBAction func btnMoreAction(_ sender: UIButton) {
        
        if imgViewShare.image == #imageLiteral(resourceName: "share") {
        
        delegate?.btnMore(index: sender.tag)
        }
        else {
            
            delegate?.btnFlash(index: sender.tag)
        }
    }
}


//MARK: - CollectionView DataSource and Delegate
extension FieldTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionCell", for: indexPath as IndexPath) as! FeedCollectionCell
        
        cell.setData(url: imageCollection!)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height:  self.heightOfCollectonView.constant)
        
    }
}
