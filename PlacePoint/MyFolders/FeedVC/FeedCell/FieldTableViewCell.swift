//
//  FieldTableViewCell.swift
//  PlacePoint
//
//  Created by Mac on 28/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher
import  AVKit
import YouTubePlayer
import SVProgressHUD


protocol OpenLink: class {
    
    func openUrlLink(videoUrl: String)
    
    func btnMore(index: Int)
    
    func btnFlash(index: Int)
}

class FieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vwTextUrl: UIView!
    @IBOutlet weak var lblFbLink: UILabel!
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var imgYouTubeThumb: UIImageView!
    @IBOutlet weak var btnFlash: UIButton!
    
    @IBOutlet weak var lblExpiry: UILabel!
    
    @IBOutlet weak var viewConatinedLblRedemtionLeft: UIView!
    
    @IBOutlet weak var lblRedemptionLeft: UILabel!
   
    @IBOutlet weak var imgViewShare: UIImageView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet var btnMore: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblDescription: FRHyperLabel!
    
    @IBOutlet var collectionViewImages: UICollectionView!
    
    @IBOutlet weak var btnClaimoffer: UIButton!
    @IBOutlet var viewShowImages: UIView!
    
    @IBOutlet weak var playButtonFbPlayer: UIButton!
    @IBOutlet weak var lblAlertSale: UILabel!
    
    @IBOutlet weak var imgPlayPause: UIImageView!
    //    @IBOutlet weak var heightConstraintBottomView: NSLayoutConstraint!
    @IBOutlet weak var heightOfCollectonView: NSLayoutConstraint!
    @IBOutlet weak var viewTopFlashOffer: UIView!
    
    @IBOutlet weak var btnBumpPost: UIButton!
    @IBOutlet weak var viewClaimButton: UIView!

    @IBOutlet weak var viewYouTubePlayer: YouTubePlayerView!
    @IBOutlet weak var viewFbPlayer: playerView!
  
    @IBOutlet weak var viewYoutube: UIView!
    //
//    @IBOutlet weak var viewYoutube: playerView!
    @IBOutlet weak var btnOpenUrl: UIButton!
    
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var iconBump: UIImageView!
    //    @IBOutlet weak var viewYoutube: UIView!
    @IBOutlet weak var imgYouTubeThumNail: UIImageView!
    
     var avPlayerLayer: AVPlayerLayer?
    
    var videoLink: String?
    
    var delegate: OpenLink?
    
    var imageCollection: String?
    
    var arrayImages = [AnyObject]()
    
     var dictFeedCell = NSDictionary()
    
    var dictFPosts = NSDictionary()

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
        
        if let createdBy = (arr[index]).value(forKey: "created_by") as? String {
            
            if createdBy == "0" {
                
           
            let strBsnName = arr[index]["business_name"] as? String ?? ""
                
                
                let attrString = NSMutableAttributedString(string: strBsnName,
                                                           attributes: [ NSAttributedStringKey.font: UIFont(name: CustomFont.ubuntuMedium.rawValue, size: 18) ])
                
                attrString.append(NSMutableAttributedString(string: " (shared)",
                                                            attributes: [NSAttributedStringKey.font: UIFont(name: CustomFont.ubuntuRegular.rawValue, size: 13)]))
                
                 self.lblTitle.attributedText = attrString
                
            }
            else {
                
                self.lblTitle.text = arr[index]["business_name"] as? String
            }
        }
        
        if let createdDate = (arr[index]).value(forKey: "created_at") as? String {
            
            let dateFormatter = DateFormatter()
            
            let tempLocale = dateFormatter.locale // save locale temporarily
            
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date = dateFormatter.date(from: createdDate)
            
            dateFormatter.dateFormat = "MMM dd, hh:mm a" ; //"dd-MM-yyyy HH:mm:ss"
            
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
        
       // lblDescription.collapsed = true
        
        //viewYoutube.player.play()
//        viewFbPlayer.player?.play()
        lblDescription.text = nil
        
        imgYouTubeThumNail.image = nil
        
        collectionViewImages.collectionViewLayout.invalidateLayout()
    }
    
    
    func showFPostTown(dict: NSDictionary)  {
        
          dictFPosts = dict
        
    }
    
    
    //MARK: - Reload CollectionView
    func reloadCollectionView(dict: NSDictionary)  {
        
      dictFeedCell = dict
        
      
        
        imageCollection = dict["image_url"] as? String
        
        videoLink = dict["video_link"] as? String
        
        if imageCollection != "" {
            
            let strheight = dict["height"] as? String
            
            let strWidth = dict["width"] as? String
            
            
            if strheight != "" && strWidth != "" {
                
                if let height = NumberFormatter().number(from: strheight!) as? CGFloat, let width = NumberFormatter().number(from: strWidth!) as? CGFloat {
                    
                    if height != 0 && width != 0 {
                        let ratio = width / height
                        
                        let newHeight = collectionViewImages.frame.size.width / ratio
                        //                    if newHeight != nil      {
                        self.heightOfCollectonView.constant = newHeight
                        //                    }
                    }
                    
                    
                    
                   
                    
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
    
    @IBAction func btnBumpPost(_ sender: UIButton) {
        
        self.callBumpPostApi(idPost: (dictFeedCell["id"] as? String)!)
        
    }
    
    
    func callBumpPostApi(idPost:String) {
        
        SVProgressHUD.show()
        
     
        var dictParams = [String: Any]()
        
        dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
        
        dictParams["post_id"] = idPost
        
        
        RedeemVCManager.sharedInstance.dictParams = dictParams
        
        RedeemVCManager.sharedInstance.bumpPost(completionHandler: { (response) in
            
            DispatchQueue.main.async {
                
                print(response)
                
                let strStatus = response["status"] as? String
                
                if strStatus == "true" {
                    
                    let alert = UIAlertController(title: "", message:"Post bumped successfully", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show alert
                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                    alertWindow.rootViewController = UIViewController()
                    alertWindow.windowLevel = UIWindowLevelAlert + 1;
                    alertWindow.makeKeyAndVisible()
                    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                   
                }
                else {
                    
                    
                    
                }
                
                SVProgressHUD.dismiss()
                
              
                
            }
            
        }, failure: { (strError :String) in
            
            
            
        })
    }
    
    
    @IBAction func btnMoreAction(_ sender: UIButton) {
        
        if imgViewShare.image == #imageLiteral(resourceName: "share") {
        
            delegate?.btnMore(index: sender.tag)
        }
        else {
            
            //delegate?.btnFlash(index: sender.tag)
        }
    }
    
    @IBAction func btnFlashAction(_ sender: UIButton) {
      
        delegate?.btnFlash(index: sender.tag)
    }
}


//MARK: - CollectionView DataSource and Delegate
extension FieldTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionCell", for: indexPath as IndexPath) as! FeedCollectionCell
        
        if dictFPosts.count > 0 {
    
            cell.lblTown.text = dictFPosts["town"] as? String
            
            cell.lblTown.isHidden = false
            
        } else {
            
             cell.lblTown.isHidden = true
            
        }
        
        cell.setData(url: imageCollection!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let customView = Bundle.main.loadNibNamed("ViewWithZoomImages", owner: self, options: nil)?[0] as! ViewWithZoomImages
        
        customView.arrImageWithContents.removeAll()
        
        let url = URL(string: imageCollection!)!
        
        customView.arrImageWithContents.append(url as AnyObject)
        
        customView.imageUrl  = imageCollection!
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            
            window.addSubview(customView)
            
        }
       
        
        customView.createUI(arrImageWithContents: customView.arrImageWithContents, index: 0)
        
        print(indexPath.row)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height:  self.heightOfCollectonView.constant)
        
    }
}
