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
import AVKit
import MediaPlayer

//MARK: - TableView Data Source and Delegate
extension FeedLiveVC: UITableViewDataSource, UITableViewDelegate, YouTubePlayerDelegate {
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
       
        if playerState == .Playing {
            isYouTubePlayerPlaying = true
            let iP = IndexPath(row: tagVideo, section: 0)
            playPauseTag = tagVideo
            let fullyVisibleCell = tblFields.cellForRow(at: iP) as! FieldTableViewCell
            
//             fullyVisibleCell.playButtonFbPlayer.setTitle("Play", for: .normal)
            fullyVisibleCell.imgPlayPause.image = UIImage(named:"Play")
            fullyVisibleCell.viewFbPlayer.player?.pause()
             playPauseTag = tagVideo
  
        }
        
   
        print(playerState)
        
    }
    
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrDetails.count
    }

//    @objc func playerDidFinishPlaying(note: NSNotification) {
//
//
//        let iP = IndexPath(row: tagVideo, section: 0)
//
//        let fullyVisibleCell = tblFields.cellForRow(at: iP) as! FieldTableViewCell
//
//        fullyVisibleCell.viewFbPlayer.player?.play()
//
//    }
    
    @objc private func playerClick(_ sender: UIButton?) {
        
        if playPauseTag != 987658 {
            
            if (sender!.tag != tagVideo) {
                
                if let cell = tblFields.cellForRow(at: IndexPath(row: tagVideo, section: 0)) as? FieldTableViewCell {
                    
    //                cell.viewFbPlayer.player?.play()
                    tblFields.reloadRows(at: [IndexPath(row: tagVideo, section: 0)], with: .automatic)
                    
                    cell.imgPlayPause.image = UIImage(named:"Play")
                    
                }
            }
            
            
            let iP = IndexPath(row: sender!.tag, section: 0)
            
            let fullyVisibleCell = tblFields.cellForRow(at: iP) as! FieldTableViewCell
            
//            fullyVisibleCell.imgPlayPause.image = UIImage(named:"Pause")
            fullyVisibleCell.imgPlayPause.image = UIImage(named:"")
            
            fullyVisibleCell.viewFbPlayer.player?.seek(to: kCMTimeZero)
            
            
            let iPYouTube = IndexPath(row: tagYouTubeVideo, section: 0)
            
            let YouTubeCell = tblFields.cellForRow(at: iPYouTube) as? FieldTableViewCell
            
            if YouTubeCell != nil {
                
                YouTubeCell!.viewYouTubePlayer.pause()
            }
            
            fullyVisibleCell.viewFbPlayer.player?.play()
            
            fullyVisibleCell.viewFbPlayer.player?.playImmediately(atRate: 1.0)
            
            tagVideo = sender!.tag
            
            playPauseTag = 987658
            
            
        } else {

            if (sender!.tag != tagVideo) {
                if let cell = tblFields.cellForRow(at: IndexPath(row: tagVideo, section: 0)) as? FieldTableViewCell {
                    
                    //                cell.viewFbPlayer.player?.play()
                    tblFields.reloadRows(at: [IndexPath(row: tagVideo, section: 0)], with: .automatic)
                    
                    cell.imgPlayPause.image = UIImage(named:"Play")
                }
                
                tagVideo = sender!.tag
                playPauseTag = sender!.tag
                
                self.playerClick(sender)
            }
            else {
                
                let iP = IndexPath(row: sender!.tag, section: 0)
                
                let fullyVisibleCell = tblFields.cellForRow(at: iP) as! FieldTableViewCell
                
                fullyVisibleCell.imgPlayPause.image = UIImage(named:"Play")
                
                fullyVisibleCell.viewFbPlayer.player?.pause()
                
                tagVideo = sender!.tag
                playPauseTag = sender!.tag
            }
            
            
        }
        print(arrDetails[sender!.tag])
       

        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {


        let iP = IndexPath(row: tagYouTubeVideo, section: 0)

        let YouTubeCell = tblFields.cellForRow(at: iP) as? FieldTableViewCell

        if YouTubeCell != nil {

            YouTubeCell!.viewYouTubePlayer.pause()

        }
        
        let iPVideo = IndexPath(row: tagVideo, section: 0)
        
        let fullyVisibleCell = tblFields.cellForRow(at: iPVideo) as? FieldTableViewCell
        
        if fullyVisibleCell != nil {
            
            fullyVisibleCell!.imgPlayPause.image = UIImage(named:"Play")
            fullyVisibleCell!.viewFbPlayer.player?.pause()
             playPauseTag = tagVideo
            
        }
    }
    

    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         var cell = tableView.dequeueReusableCell(withIdentifier: "FieldTableViewCell", for: indexPath) as? FieldTableViewCell
        
        cell?.btnOpenUrl.isHidden = true
        
        var user_email = ""
      
        let isKeyExists = CommonClass.sharedInstance.keyAlreadyExists(Key: "email")
        if isKeyExists ==  true {
            user_email = UserDefaults.standard.getEmail()
        } else {
            user_email = ""
        }
        
        cell?.iconBump.isHidden = true
        
        cell?.btnBumpPost.isHidden = true
    
        if user_email == "help@placepoint.ie" {
            
            cell?.iconBump.isHidden = false
            
            cell?.btnBumpPost.isHidden = false
            
            
        } else {
            if  checkMyTimeLine == "My Posts" {
                
                cell?.iconBump.isHidden = false
                
                cell?.btnBumpPost.isHidden = false
            }
            else {
                
                cell?.iconBump.isHidden = true
                
                cell?.btnBumpPost.isHidden = true
            }
        }
       
        
        
        cell?.btnBumpPost.tag = indexPath.row
      
        
        cell?.btnClaimoffer.addTarget(self, action: #selector(btnClaimOfferAction), for: .touchUpInside)
        
        cell?.btnClaimoffer.tag = indexPath.row
        
        if boolComingFromSubCategory {
            
            let strFtypeStatus = arrDetails[indexPath.row].value(forKey: "ftype") as! String
            
            if strFtypeStatus == "1" {
                
                cell = getCellAccordingCheck(bool: true, cell: cell!, indexPath: indexPath)
                
            }
            else {
                
                cell = getCellAccordingCheck(bool: false, cell: cell!, indexPath: indexPath)
                
            }
        }
        else {
            
            cell = getCellAccordingCheck(bool: false, cell: cell!, indexPath: indexPath)
        }
        
        return cell!
        
    }
    
    
    func getCellAccordingCheck(bool: Bool, cell: FieldTableViewCell, indexPath: IndexPath) -> FieldTableViewCell {
        
        if bool {
            
            let currentSource = preparedSources(index: indexPath)[0]
            
            let cell = cell as? FieldTableViewCell
            
            cell?.btnOpenUrl.isHidden = true
            
            cell?.viewClaimButton.isHidden = false
            
            cell?.viewTopFlashOffer.isHidden = false
            
            cell?.btnFlash.isHidden = true
            
            cell?.imgViewShare.isHidden = false
            
            cell?.btnMore.isHidden = false
            
            if isFlashPostsShow {
                
                cell?.btnFlash.isHidden = false
                
                cell?.imgViewShare.isHidden = true
                
                cell?.btnMore.isHidden = true
                
                 cell?.iconBump.frame = (cell?.btnMore.frame)!
                 cell?.btnBumpPost.frame = (cell?.btnMore.frame)!
                
                cell?.imgViewShare.image = UIImage(named: "flashIcon")
                
                cell?.viewTopFlashOffer.isHidden = false
                
                cell?.lblAlertSale.text = "***Flash Offers***"
                
//                cell?.lblAlertSale.backgroundColor = UIColor.LblALertSale()
                
                 cell?.lblAlertSale.backgroundColor = UIColor.clear
            }
            else {
                
                cell?.imgViewShare.image = UIImage(named: "share")
            }
            
            let strExpiryStatus = arrDetails[indexPath.row].value(forKey: "expired") as! Int
            
            let strValidity = arrDetails[indexPath.row].value(forKey: "validity_date") as! String
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateValidity = dateFormatter.date(from: strValidity)
            
            let currentDate = Date()
            
            timeFormatter.usesAbbreviatedCalendarUnits = true
            
            let  strLastSeen = timeFormatter .stringForTimeInterval(from: currentDate, to: dateValidity)
            
            
            
            if strExpiryStatus == 1 {
                
                let strRedeemed = arrDetails[indexPath.row].value(forKey: "redeemed") as! String
                
                if strRedeemed == "0" {
                    
                    cell?.lblAlertSale.text = "***Expired***"
                    
                } else {
                    
                cell?.lblAlertSale.text = String(format:"*Expired \(strRedeemed) offer(s) claimed* %@ ",strLastSeen! )
//                     cell?.lblTimeAgo.text = String(format:"%@",strLastSeen! )
//                    cell?.lblAlertSale.text = String(format:"***Expired %@ ***",strLastSeen! )
//                    cell?.lblAlertSale.text = "***Expired \(strRedeemed) offer(s) claimed***"
                }
                
                cell?.viewClaimButton.isHidden = true
                
                cell?.lblAlertSale.backgroundColor = UIColor.LblExpired()
                
                cell?.viewConatinedLblRedemtionLeft.isHidden = true
                
            }
            else {
                
                cell?.lblAlertSale.text = "***Flash Alert Sale***"
                
//                cell?.lblAlertSale.backgroundColor = UIColor.LblALertSale()
                cell?.lblAlertSale.backgroundColor = UIColor.clear
                let expiryDate = arrDetails[indexPath.row].value(forKey: "validity_date") as! String
                
                let strCalculatedDifference = calCulateDate(strDate: expiryDate)
                
                let strMax_redemption = arrDetails[indexPath.row].value(forKey: "max_redemption") as! String
                
                let strRedeemed = arrDetails[indexPath.row].value(forKey: "redeemed") as! String
                
                let intMax_redemption = Int(strMax_redemption)
                
                let intRedeemed = Int(strRedeemed)
                
                var result = Int()
                
                if arrIndexPath.contains(indexPath.row) {
                    
                    if arrStatus1[indexPath.row] == " " {
                        
                        if intRedeemed != 0 {
                            
                            cell?.lblRedemptionLeft.layer.cornerRadius = 8
                            
                            let strintClaimedPerEmailId = String(intClaimedPerEmailId)
                            
                            if intClaimedPerEmailId == 1 {
                                
                                cell?.lblRedemptionLeft.text = "\(strintClaimedPerEmailId) Offer successfully Claimed. To redeem visit the business and mention your name and email address."
                            }
                            else {
                                
                                cell?.lblRedemptionLeft.text = "\(strintClaimedPerEmailId) Offers successfully Claimed. To redeem visit the business and mention your name and email address."
                            }
                            
                            cell?.viewConatinedLblRedemtionLeft.isHidden = false
                        }
                    }
                    else if arrStatus1[indexPath.row] == "ios" {
                        
                        cell?.lblRedemptionLeft.layer.cornerRadius = 8
                        
                        if intRedeemed == 1 {
                            
                            cell?.lblRedemptionLeft.text = "\(strRedeemed) Offer successfully Claimed. To redeem visit the business and mention your name and email address."
                        }
                        else {
                            
                            cell?.lblRedemptionLeft.text = "\(strRedeemed) Offers successfully Claimed. To redeem visit the business and mention your name and email address."
                        }
                        
                        cell?.viewConatinedLblRedemtionLeft.isHidden = false
                    }
                }
                else {
                    
                    cell?.viewConatinedLblRedemtionLeft.isHidden = true
                }
                
                
                if intRedeemed! < intMax_redemption! {
                    
                    result = intMax_redemption! - intRedeemed!
                    
                    cell?.lblExpiry.text = "Hurry Expires in \(strCalculatedDifference) - Only \(String(result)) left"
                    
                    cell?.viewTopFlashOffer.isHidden = false
                    
                    cell?.viewClaimButton.isHidden = false
                    
                    cell?.btnClaimoffer.isHidden = false
                    
                    //                    cell?.heightConstraintBottomView.constant = 90
                }
                else if intRedeemed! == intMax_redemption! {
                    
//                    cell?.lblAlertSale.text = String(format:"***Expired %@ ***",strLastSeen! )
                    
                cell?.lblAlertSale.text = String(format:"*Expired \(strMax_redemption) offer(s) claimed* %@ ",strLastSeen! )
//                     cell?.lblTimeAgo.text = String(format:"%@",strLastSeen! )
//                    cell?.lblAlertSale.text = "***Expired \(strMax_redemption) offer(s) claimed***"
                    
                    cell?.viewClaimButton.isHidden = true
                    
                    cell?.lblAlertSale.backgroundColor = UIColor.LblExpired()
                    
                    cell?.viewConatinedLblRedemtionLeft.isHidden = true
                   
                }
           
            }
            
            if arrDetails.count > 0 {
                
                let strVideoLink = arrDetails[indexPath.row].value(forKey: "video_link") as? String
                
                if strVideoLink != "" {
                    
                    cell?.viewYoutube.isHidden = false
                    
                    if (strVideoLink?.contains("youtu"))! {
                        
                         tagYouTubeVideo = indexPath.row
                        
                        cell?.playButtonFbPlayer.isHidden = true
                        
                        cell?.imgPlayPause.isHidden = true
                    
                        cell?.viewFbPlayer.isHidden = true
                         cell?.viewYouTubePlayer.delegate = self
                        cell?.viewYouTubePlayer.isHidden = false
                        
                        cell?.imgYouTubeThumNail.isHidden = false
                        
                        cell?.btnOpenUrl.tag = indexPath.row
                        
                        let strvideoURL = URL(string:strVideoLink!)
                        
                        cell?.viewYouTubePlayer.loadVideoURL(strvideoURL!)
                        
                        
                    } else if ((strVideoLink?.contains("flv"))!
                        || ((strVideoLink?.contains("facebook"))!)) {
                        
                        cell?.viewYoutube.backgroundColor = UIColor.white
                        cell?.viewYoutube.isHidden = true
                        
                        cell?.viewFbPlayer.isHidden = true
                        //                 cell?.imgYouTubeThumb.isHidden = false
                        cell?.imgPlayPause.isHidden = true
                        
                        cell?.playButtonFbPlayer.isHidden = true
                        
                        cell?.imgYouTubeThumNail.isHidden = true
                        
                        cell?.btnOpenUrl.tag = indexPath.row
                        
                        //                     cell?.vwTextUrl.isHidden = false
                        
                        cell?.btnOpenUrl.isHidden = false
                        cell?.btnOpenUrl.setTitle(strVideoLink, for: .normal)
                        
//                        cell?.viewYoutube.backgroundColor = UIColor.white
//                        cell?.viewYoutube.isHidden = false
//
//                        cell?.viewFbPlayer.isHidden = true
//                        //                 cell?.imgYouTubeThumb.isHidden = false
//                        cell?.imgPlayPause.isHidden = true
//
//                        cell?.playButtonFbPlayer.isHidden = true
//
//                        cell?.imgYouTubeThumNail.isHidden = true
//
//                        cell?.btnOpenUrl.tag = indexPath.row
//
//                        //                     cell?.vwTextUrl.isHidden = false
//
//                        cell?.btnOpenUrl.isHidden = false
//
//                        cell?.lblFbLink.isHidden = false
//
//                        cell?.lblFbLink.text = strVideoLink
                        //                        let url = self.createThumbnailUrlVideoFromFileURL(videoURL: strVideoLink!)
                        //
                        //                        cell?.imgYouTubeThumNail.kf.indicatorType = .activity
                        //
                        //                        (cell?.imgYouTubeThumNail.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
                        //
                        //                        cell?.imgYouTubeThumNail.kf.setImage(with: url,
                        //                                                             placeholder:#imageLiteral(resourceName: "placeholder"),
                        //                                                             options: [.transition(ImageTransition.fade(1))],
                        //                                                             progressBlock: { receivedSize, totalSize in
                        //                        },
                        //                                                             completionHandler: { image, error, cacheType, imageURL in
                        //                        })
                    } else {

                        let strvideoURL = URL(string:strVideoLink!)

                         player = AVPlayer(url: strvideoURL!)
                        
                         cell?.playButtonFbPlayer.isHidden = false
                          cell?.imgPlayPause.isHidden = false
                        
                         cell?.viewFbPlayer.playerLayer.frame = (cell?.viewYoutube.bounds)!
                        
//                        tagVideo = indexPath.row
//                        playPauseTag = indexPath.row
                         cell?.playButtonFbPlayer.tag = indexPath.row
                        
                          cell?.playButtonFbPlayer.addTarget(self, action: #selector(playerClick(_:)), for: .touchUpInside)
 
                         cell?.viewYouTubePlayer.pause()
                        
                        cell?.viewYouTubePlayer.isHidden = true
                        
                        cell?.viewFbPlayer.isHidden = false

                        cell?.viewFbPlayer.playerLayer.player = player
                        
                 NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object:  cell?.viewFbPlayer.player!.currentItem, queue: nil) { (_) in
                            cell?.viewFbPlayer.player?.seek(to: kCMTimeZero)

                            cell?.viewFbPlayer.player?.play()
                            cell?.viewFbPlayer.player?.playImmediately(atRate: 1.0)
                
                        }

                    }
 

                }
                else {
                    
                    cell?.viewYoutube.isHidden = true
                    
                    cell?.imgYouTubeThumNail.isHidden = true
                }
                
                cell?.btnMore.isHidden = false
                
                cell?.delegate = self
                
                cell?.btnMore.tag = indexPath.row
                
               // cell?.lblDescription.setLessLinkWith(lessLink: " ...less", attributes: [.foregroundColor: UIColor.themeColor()], position: currentSource.textAlignment)
                
                cell?.layoutIfNeeded()
                
              //  cell?.lblDescription.delegate = self
                
              //  cell?.lblDescription.shouldCollapse = true
                
               // cell?.lblDescription.textReplacementType = currentSource.textReplacementType
                
               // cell?.lblDescription.numberOfLines = currentSource.numberOfLines
                
              //  cell?.lblDescription.collapsed = states[indexPath.row]
                
               // cell?.lblDescription.text = currentSource.text
                
                let strHttp = currentSource.text.components(separatedBy: " ")
                
                var strLink = String()
                
                if let strValue = strHttp.first(where: { (($0 as String).hasPrefix("(http")) || (($0 as String).hasPrefix("http")) || (($0 as String).hasPrefix("www"))}) {
                    
                    strLink = strValue
                }
                
                let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                  NSAttributedStringKey.font: UIFont(name: CustomFont.ubuntuRegular.rawValue, size: 15)]
                
                cell?.lblDescription.attributedText = NSAttributedString(string: currentSource.text, attributes: attributes as [NSAttributedStringKey : Any])
                
                //Step 2: Define a selection handler block
                let handler = {
                    (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
                    
                    guard let url = URL(string: substring!) else {
                        return
                    }
                    
                    if #available(iOS 10.0, *) {
                        
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    else {
                        
                        UIApplication.shared.openURL(url)
                    }
                }
                
                //Step 3: Add link substrings
                cell?.lblDescription.setLinksForSubstrings([strLink], withLinkHandler: handler)
                
                cell?.setData(arr: arrDetails, index: indexPath.row)
                
                cell?.selectionStyle = .none
                
                if arrDetails.count > 0 {
                    
                    cell?.reloadCollectionView(dict: (arrDetails[indexPath.row] as! NSDictionary))
                }
                
            }
            
            return (cell)!
            
            
        }
        else {
            
            let currentSource = preparedSources(index: indexPath)[0]
            
            let cell = cell as? FieldTableViewCell
            
            cell?.viewConatinedLblRedemtionLeft.isHidden = true
            
            cell?.viewClaimButton.isHidden = true
            
            cell?.viewTopFlashOffer.isHidden = true
            
            cell?.btnFlash.isHidden = true
            
            cell?.imgViewShare.isHidden = false
            
            cell?.btnMore.isHidden = false
            
            if isFlashPostsShow {
                
                cell?.btnFlash.isHidden = false
                
                cell?.imgViewShare.isHidden = true
                
                cell?.btnMore.isHidden = true
                
                cell?.iconBump.isHidden = true
                
                cell?.btnBumpPost.isHidden = true
                
                cell?.iconBump.frame = (cell?.btnMore.frame)!
                
                cell?.btnBumpPost.frame = (cell?.btnMore.frame)!
                
                cell?.imgViewShare.image = UIImage(named: "flashIcon")
                
                cell?.viewTopFlashOffer.isHidden = false
                
                cell?.lblAlertSale.text = "***Flash Offers***"
                
//                cell?.lblAlertSale.backgroundColor = UIColor.LblALertSale()
              
                cell?.lblAlertSale.backgroundColor = UIColor.clear
            }
            else {
                
//                cell?.iconBump.isHidden = false
//                
//                cell?.btnBumpPost.isHidden = false
                
                cell?.imgViewShare.image = UIImage(named: "share")
            }
               cell?.viewYoutube.backgroundColor = UIColor.black
            if arrDetails.count > 0 {
                
                let strVideoLink = arrDetails[indexPath.row].value(forKey: "video_link") as? String
                
                if strVideoLink != "" {
                    
                    cell?.viewYoutube.isHidden = false
                    
                     cell?.viewYouTubePlayer.pause()
                    
                    if (strVideoLink?.contains("youtu"))! {
                        tagYouTubeVideo = indexPath.row
                        
                       cell?.playButtonFbPlayer.isHidden = true
                        cell?.imgPlayPause.isHidden = true
                        
                        let strvideoURL = URL(string:strVideoLink!)
                        
                        cell?.imgYouTubeThumNail.isHidden = false
                        
                        cell?.viewFbPlayer.isHidden = true
                        
                        cell?.btnOpenUrl.tag = indexPath.row
                        
                        cell?.viewYouTubePlayer.isHidden = false
                        
                        cell?.viewYouTubePlayer.loadVideoURL(strvideoURL!)
                         cell?.viewYouTubePlayer.delegate = self
                        
                        
                    } //Raj fb check
                    else if ((strVideoLink?.contains("flv"))!
                        || ((strVideoLink?.contains("facebook"))!)) {
                        
                        
                        cell?.viewYoutube.backgroundColor = UIColor.white
                        cell?.viewYoutube.isHidden = true
                        
                        cell?.viewFbPlayer.isHidden = true
                        //                 cell?.imgYouTubeThumb.isHidden = false
                        cell?.imgPlayPause.isHidden = true
                        
                        cell?.playButtonFbPlayer.isHidden = true
                        
                        cell?.imgYouTubeThumNail.isHidden = true
                        
                        cell?.btnOpenUrl.tag = indexPath.row
                        
                        //                     cell?.vwTextUrl.isHidden = false
                        
                        cell?.btnOpenUrl.isHidden = false
                        cell?.btnOpenUrl.setTitle(strVideoLink, for: .normal)
                        
//                      c
//                        cell?.viewYoutube.backgroundColor = UIColor.white
//                        cell?.viewYoutube.isHidden = false
//
//                        cell?.viewFbPlayer.isHidden = true
//                        //                 cell?.imgYouTubeThumb.isHidden = false
//                        cell?.imgPlayPause.isHidden = true
//
//                        cell?.playButtonFbPlayer.isHidden = true
//
//                        cell?.imgYouTubeThumNail.isHidden = true
//
//                        cell?.btnOpenUrl.tag = indexPath.row
//
//                        //                     cell?.vwTextUrl.isHidden = false
//
//                        cell?.btnOpenUrl.isHidden = false
//
//                        cell?.lblFbLink.isHidden = false
//
//                        cell?.lblFbLink.text = strVideoLink
//                        let url = self.createThumbnailUrlVideoFromFileURL(videoURL: strVideoLink!)
//
//                        cell?.imgYouTubeThumNail.kf.indicatorType = .activity
//
//                        (cell?.imgYouTubeThumNail.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
//
//                        cell?.imgYouTubeThumNail.kf.setImage(with: url,
//                                                             placeholder:#imageLiteral(resourceName: "placeholder"),
//                                                             options: [.transition(ImageTransition.fade(1))],
//                                                             progressBlock: { receivedSize, totalSize in
//                        },
//                                                             completionHandler: { image, error, cacheType, imageURL in
//                        })
                    }
                        
//                    else if (strVideoLink?.contains("facebook"))! {
//
//                        cell?.viewYoutube.isHidden = true
//
//                        cell?.imgYouTubeThumNail.isHidden = true
////                        let strvideoURL = URL(string:strVideoLink!)
////
////                        let player = AVPlayer(url: strvideoURL!)
////
////                        //                        tagVideo = indexPath.row
////                        //                        playPauseTag = indexPath.row
////                        cell?.playButtonFbPlayer.isHidden = true
////                        cell?.imgPlayPause.isHidden = true
////
////                        cell?.playButtonFbPlayer.tag = indexPath.row
////
////                        cell?.playButtonFbPlayer.addTarget(self, action: #selector(playerClick(_:)), for: .touchUpInside)
////
//////                        cell?.viewFbPlayer.playerLayer.frame = (cell?.viewYoutube.bounds)!
////
////                        cell?.viewYouTubePlayer.isHidden = true
////
////                        cell?.viewFbPlayer.isHidden = true
//
////                        cell?.viewFbPlayer.playerLayer.player = player
////
////                        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object:  cell?.viewFbPlayer.player!.currentItem, queue: nil) { (_) in
////
////                            cell?.viewFbPlayer.player?.seek(to: kCMTimeZero)
////                            //                        cell?.imgPlayPause.image = UIImage(named:"Play")
////                            //
////                            cell?.viewFbPlayer.player?.play()
////                            cell?.viewFbPlayer.player?.playImmediately(atRate: 1.0)
////                        }
//                    }
                    else {
                        
                        let strvideoURL = URL(string:strVideoLink!)
                        
                        let player = AVPlayer(url: strvideoURL!)
                        
//                        tagVideo = indexPath.row
//                        playPauseTag = indexPath.row
                        cell?.playButtonFbPlayer.isHidden = false
                         cell?.imgPlayPause.isHidden = false
                        
                        cell?.playButtonFbPlayer.tag = indexPath.row
                        
                        cell?.playButtonFbPlayer.addTarget(self, action: #selector(playerClick(_:)), for: .touchUpInside)
                        
                        cell?.viewFbPlayer.playerLayer.frame = (cell?.viewYoutube.bounds)!
                        
                        cell?.viewYouTubePlayer.isHidden = true
                        
                        cell?.viewFbPlayer.isHidden = false
                        
                        cell?.viewFbPlayer.playerLayer.player = player
                        
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object:  cell?.viewFbPlayer.player!.currentItem, queue: nil) { (_) in
                        
                        cell?.viewFbPlayer.player?.seek(to: kCMTimeZero)
//                        cell?.imgPlayPause.image = UIImage(named:"Play")
//
                        cell?.viewFbPlayer.player?.play()
                        cell?.viewFbPlayer.player?.playImmediately(atRate: 1.0)

                    }
                        


                    }
                }
                else {
                    
                    cell?.viewYoutube.isHidden = true
                    
                    cell?.imgYouTubeThumNail.isHidden = true
                }
                
                cell?.btnMore.isHidden = false
                
                cell?.delegate = self
                
                cell?.btnMore.tag = indexPath.row

                
                cell?.layoutIfNeeded()
                
              //  cell?.lblDescription.delegate = self
                
              //  cell?.lblDescription.shouldCollapse = true
                
              //  cell?.lblDescription.textReplacementType = currentSource.textReplacementType
                
              //  cell?.lblDescription.numberOfLines = currentSource.numberOfLines
                
               // cell?.lblDescription.collapsed = states[indexPath.row]
                
               // cell?.lblDescription.text = currentSource.text
                
                let strHttp = currentSource.text.components(separatedBy: " ")
                
                var strLink = String()
                
                if let strValue = strHttp.first(where: { (($0 as String).hasPrefix("(http")) || (($0 as String).hasPrefix("http")) || (($0 as String).hasPrefix("www"))}) {
                    
                    strLink = strValue
                }
                
                let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                  NSAttributedStringKey.font: UIFont(name: CustomFont.ubuntuRegular.rawValue, size: 15)]
                
                cell?.lblDescription.attributedText = NSAttributedString(string: currentSource.text, attributes: attributes as [NSAttributedStringKey : Any])
                
                //Step 2: Define a selection handler block
                let handler = {
                    (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
                    
                    guard let url = URL(string: substring!) else {
                        return
                    }
                    
                    if #available(iOS 10.0, *) {
                        
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    else {
                        
                        UIApplication.shared.openURL(url)
                    }
                }
                
                //Step 3: Add link substrings
                cell?.lblDescription.setLinksForSubstrings([strLink], withLinkHandler: handler)
                
                cell?.setData(arr: arrDetails, index: indexPath.row)
                
                cell?.selectionStyle = .none
                
                if arrDetails.count > 0 {
                    
                    cell?.reloadCollectionView(dict: (arrDetails[indexPath.row] as! NSDictionary))
                }
            }
            
            return (cell)!
            
        }
    }
    
    
    func calCulateDate(strDate: String) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        var date = dateFormatter.date(from: strDate)
        
        if date == nil {
            
            dateFormatter.dateFormat = "YYYY-dd-MM"
            
            date = dateFormatter.date(from: strDate)
        }
        
        let calCulatedString = offsetFrom(date: date!)
        
        return calCulatedString
    }
    
    
    func offsetFrom(date : Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: Date(), to: date);
        
        //        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " "
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day = difference.day, day > 0 { return days }
        if let hour = difference.hour, hour > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        //        if let second = difference.second, second > 0 { return seconds }
        
        if let day = difference.day, day < 0 { return days }
        if let hour = difference.hour, hour < 0 { return hours }
        if let minute = difference.minute, minute < 0 { return minutes }
        //        if let second = difference.second, second < 0 { return seconds }
        
        return ""
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
        
        let strid = arrDetails[index].value(forKey: "id") as! String
        
        vc.strIdFromFlashpost = strid
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .custom
        
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
