//
//  FeedLiveVC + Extensions.swift
//  PlacePoint
//
//  Created by Mac on 05/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

//MARK: - TableView Data Source and Delegate
extension FeedLiveVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrDetails.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let currentSource = preparedSources(index: indexPath)[0]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FieldTableViewCell") as? FieldTableViewCell
        
        cell?.viewClaimButton.isHidden = true
        
        cell?.viewTopFlashOffer.isHidden = true
        
        if isFlashPostsShow {
            
            cell?.imgViewShare.image = UIImage(named: "flashIcon")
        }
        else {
            cell?.imgViewShare.image = UIImage(named: "share")
        }
        
        if arrDetails.count > 0 {
            
            let strVideoLink = arrDetails[indexPath.row].value(forKey: "video_link") as? String
            
            if strVideoLink != "" {
                
                cell?.viewYoutube.isHidden = false
                
                cell?.imgYouTubeThumNail.isHidden = false
                
                cell?.btnOpenUrl.tag = indexPath.row
                
                let url = self.createThumbnailUrlVideoFromFileURL(videoURL: strVideoLink!)
                
                cell?.imgYouTubeThumNail.kf.indicatorType = .activity
                
                (cell?.imgYouTubeThumNail.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
                
                cell?.imgYouTubeThumNail.kf.setImage(with: url,
                                               placeholder:#imageLiteral(resourceName: "placeholder"),
                                               options: [.transition(ImageTransition.fade(1))],
                                               progressBlock: { receivedSize, totalSize in
                },
                                               completionHandler: { image, error, cacheType, imageURL in
                })
                
            }
            else {
                
                cell?.viewYoutube.isHidden = true
                
                 cell?.imgYouTubeThumNail.isHidden = true
            }
            
            cell?.btnMore.isHidden = false
            
            cell?.delegate = self
            
            cell?.btnMore.tag = indexPath.row
            
            cell?.lblDescription.setLessLinkWith(lessLink: " ...less", attributes: [.foregroundColor: UIColor.themeColor()], position: currentSource.textAlignment)
            
            cell?.layoutIfNeeded()
            
            cell?.lblDescription.delegate = self
            
            cell?.lblDescription.shouldCollapse = true
            
            cell?.lblDescription.textReplacementType = currentSource.textReplacementType
            
            cell?.lblDescription.numberOfLines = currentSource.numberOfLines
            
            cell?.lblDescription.collapsed = states[indexPath.row]
            
            cell?.lblDescription.text = currentSource.text
        
            cell?.setData(arr: arrDetails, index: indexPath.row)
            
            cell?.selectionStyle = .none
           
            if arrDetails.count > 0 {
                
                 cell?.reloadCollectionView(dict: (arrDetails[indexPath.row] as! NSDictionary))
            }
           
        }
        
        return (cell)!
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        if arrDetails.count < totalCount {
//            
//            offsetCount += 1
//            
//            self.getParsedArray()
//            
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isBusinessDetail == false {
            
            let feedDetailsVC = BuisnessShowFeedVc(nibName: "BuisnessShowFeedVc", bundle: nil)
            
            isBusinessDetail = true
            
            isShowBusinessDetail = true
            
            let dict = arrDetails[indexPath.row] as? NSDictionary
            
            let strBusId =   dict!["bussness_id"] as! String
            
            let strBusinessName = dict!["business_name"] as? String
            
            businessName = strBusinessName!
            
            if isChooseCategoryVc == true {
                
                let category = UserDefaults.standard.getSelectedCat()
                
                selectedCategory = category
                
            }
            
            strBusinessId = strBusId
            
            self.navigationController?.pushViewController(feedDetailsVC, animated: true)
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}


//MARK: Adopt Protocols
extension FeedLiveVC: OpenLink {
    
    func btnMore(index: Int) {
        
        let alert = UIAlertController(title: "Alert",message: "You are about to share an image to Facebook. Facebook does not allow us to send the text from the image automatically. We have copied the text from the post to the clipboard for your convenience. If you would like to add the text to the image please paste it into the comment section on the next section when sharing the post.",preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
            
            let indexPath = IndexPath(row: index, section: 0)
            
            let cell = self.tblFields.cellForRow(at: indexPath) as? FieldTableViewCell
            
            let textToShare = cell?.lblDescription.text
            
            let dict = self.arrDetails[indexPath.row] as? NSDictionary
            
            let imgUrl = dict!["image_url"] as? String
            
            if let myWebsite = NSURL(string: imgUrl!) {
                
                let objectsToShare = [textToShare, myWebsite] as [Any]
                
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                activityVC.popoverPresentationController?.sourceView = self.view
                
                self.present(activityVC, animated: true, completion: nil)
            }
            
            let text = dict!["description"] as? String
           
             UIPasteboard.general.string = text
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openUrlLink(videoUrl: String) {
        
        self.openUrl(strVideoUrl: videoUrl)
    }
    
    
    func btnFlash(index: Int) {
        
        let vc = RedeemVC(nibName: "RedeemVC", bundle: nil)
        
        let nav = UINavigationController(rootViewController: vc)
        
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
}


//MARK: - ExpandableLabel Delegate
extension FeedLiveVC: ExpandableLabelDelegate {
    
    func willExpandLabel(_ label: ExpandableLabel) {
        
        tblFields.beginUpdates()
    }
    
    
    func didExpandLabel(_ label: ExpandableLabel) {
        
        let point = label.convert(CGPoint.zero, to: tblFields)
        
        if let indexPath = tblFields.indexPathForRow(at: point) as IndexPath? {
            
            states[indexPath.row] = false
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tblFields.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
        tblFields.endUpdates()
    }
    
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        
        tblFields.beginUpdates()
    }
    
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
        let point = label.convert(CGPoint.zero, to: tblFields)
        
        if let indexPath = tblFields.indexPathForRow(at: point) as IndexPath? {
            
            states[indexPath.row] = true
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tblFields.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
        tblFields.endUpdates()
    }
}


extension String {
    
    func specialPriceAttributedStringWith(_ color: UIColor) -> NSMutableAttributedString {
        
        let attributes = [NSAttributedStringKey.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int),
                          .foregroundColor: color, .font: fontForPrice()]
        
        return NSMutableAttributedString(attributedString: NSAttributedString(string: self, attributes: attributes))
    }
    
    
    func priceAttributedStringWith(_ color: UIColor) -> NSAttributedString {
        
        let attributes = [NSAttributedStringKey.foregroundColor: color, .font: fontForPrice()]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    
    func priceAttributedString(_ color: UIColor) -> NSAttributedString {
        
        let attributes = [NSAttributedStringKey.foregroundColor: color]
        
        return NSAttributedString(string: self, attributes: attributes)
        
    }
    
    
    fileprivate func fontForPrice() -> UIFont {
        
        return UIFont(name: "Helvetica-Neue", size: 13) ?? UIFont()
    }
}
