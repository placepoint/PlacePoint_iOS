//
//  Extension+AddPostApi.swift
//  PlacePoint
//
//  Created by MRoot on 06/09/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension AddPostVC {
    
    //MARK: - Api AddPost
    func apiAddPost() {
        
        SVProgressHUD.show()
        
        self.view.isUserInteractionEnabled = false
        
        self.view.endEditing(true)
        
        var strUrl = String()
        
        if let url = headerView.txtFieldUrl.text {
            
            strUrl = url
        }
        
        var title = String()
        
        if let disTitle = headerView.lblUserName.text {
            
            title = disTitle
        }
        
        let strDesc = headerView.txtView.text as String
        
        if isImageSend == true {
            
            imageStatus = "true"
        }
        else {
            
            imageStatus = "false"
        }
        
        var dictParams = [String: Any]()
        
        let arrCategoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
            arrSelectedCategory as! [String], array: (AppDataManager.sharedInstance.arrCategories as? [AnyObject])!)
        
        let strCategoryID = arrCategoryID.joined(separator: ",")
        
        if isScheduleSelected == true  && selectedTime != "" && selectedDay != ""  {
            
            dictParams = (["auth_code": UserDefaults.standard.getAuthCode(), "description": strDesc, "type": "\(selectedType)", "day": "\(selectedDay)","time": "\(selectedTime)", "now_status": "\(nowStatus)", "video_link": strUrl as Any,"width": "\(self.view.frame.size.width - 30)","height": "\(self.imageHeight)", "image_status": "\(imageStatus)","category": strCategoryID,"title": title,"ftype":"\(strSwitchStatus)","max_redemption":"\(strMaxOffers)","validity_date":"\(strExpiryDate)","validity_time":"\(strExpiryTime)","per_person_redemption":"\(strMaxPersons)"] as? [String: Any])!
            
        }
        else if isScheduleSelected == false {
            
            if strDesc == "" || title == "" || strCategoryID == "" {
                
                self.view.isUserInteractionEnabled = true
                
                SVProgressHUD.dismiss()
                
                let alert = UIAlertController(title: "",message: "Post must not be empty",preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                return
                
            }
            
            dictParams = (["auth_code": UserDefaults.standard.getAuthCode(), "description": strDesc, "type": "", "day": "","time": "", "now_status": "1", "video_link": strUrl as Any,"width": self.view.frame.size.width - 30 ,"height": self.imageHeight, "image_status": imageStatus,"category": strCategoryID,"title": headerView.lblUserName.text!,"ftype":"\(strSwitchStatus)","max_redemption":"\(strMaxOffers)","validity_date":"\(strExpiryDate)","validity_time":"\(strExpiryTime)","per_person_redemption":"\(strMaxPersons)"] as? [String: Any])!
        }
        else if isScheduleSelected == true {
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            if self.selectedTime == "" && self.selectedDay == "" {
                
                self.view.isUserInteractionEnabled = true
                
                SVProgressHUD.dismiss()
                
                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "Please Select Scheduling Time and Day")
                
            }
            else if self.selectedTime == "" {
                
                self.view.isUserInteractionEnabled = true
                
                SVProgressHUD.dismiss()
                
                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "Please Select Scheduling Time")
                
            }
            else if self.selectedDay == "" {
                
                SVProgressHUD.dismiss()
                
                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "Please Select Scheduling Day")
            }
        }
        else if isScheduleSelected == true  && selectedTime == "" && selectedDay == "" {
            
            self.view.isUserInteractionEnabled = true
            
            SVProgressHUD.dismiss()
            
            let alert = UIAlertController(title: "",message: "You cannot left scheduling option empty",preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        if imageStatus == "true" {
            
            var image = UIImage()
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            let cell = tblViewAddPost.cellForRow(at: indexPath) as? AddPostViewCell
            
            image = CommonClass.sharedInstance.compressImage((cell?.imgThumnail.image)!)
            
            FeedManager.sharedInstance.imgPost = image
            
            FeedManager.sharedInstance.dictParams = dictParams
            
            FeedManager.sharedInstance.addPostWithImage(completionHandler: { (dictResponse) in
                
                let strStatus = dictResponse["status"] as? String
                
                if strStatus == "true" {
                    
                    let msg = dictResponse["msg"] as? String
                    
                    DispatchQueue.main.async {
                        
                        self.showAlertPostAdded(msg: msg!)
                        
                        SVProgressHUD.dismiss()
                        
                        self.view.isUserInteractionEnabled = true
                        
                    }
                }
                    
                else if strStatus == "false" {
                    
                    let msg = dictResponse["msg"] as? String
                    
                    DispatchQueue.main.async {
                        
                        self.showAlertPostAdded(msg: msg!)
                        
                        SVProgressHUD.dismiss()
                        
                        self.view.isUserInteractionEnabled = true
                    }
                    
                }
                
            }, failure: { (error) in
                
                return
                
            })
            
        }
        else {
            
            FeedManager.sharedInstance.dictParams = dictParams
        FeedManager.sharedInstance.addPostWithoutImage(completionHandler: { (dictResponse) in
                
                let strStatus = dictResponse["status"] as? String
                
                if strStatus == "true" {
                    
                    let msg = dictResponse["msg"] as? String
                    
                    DispatchQueue.main.async {
                        
                        isShowBusinessDetail = false
                        
                        self.showAlertPostAdded(msg: msg!)
                        
                        SVProgressHUD.dismiss()
                        
                        self.view.isUserInteractionEnabled = true
                    }
                }
                    
                else if strStatus == "false" {
                    
                    let msg = dictResponse["msg"] as? String
                    
                    DispatchQueue.main.async {
                        
                        self.showAlertPostAdded(msg: msg!)
                        
                        SVProgressHUD.dismiss()
                        
                        self.view.isUserInteractionEnabled = true
                    }
                }
                
            }, failure: { (error) in
                
                return
            })
        }
        
    }
    
    
    //MARK: Api editPost
    func apiEditPost() {
        
        isEditPost = false
        
        isScheduleVc = true
        
        isAddPost = true
        
        SVProgressHUD.show()
        
        self.view.isUserInteractionEnabled = false
        
        self.view.endEditing(true)
        
        var strUrl = String()
        
        if let url = headerView.txtFieldUrl.text {
            
            strUrl = url
        }
        
        var title = String()
        
        if let disTitle = headerView.lblUserName.text {
            
            title = disTitle
        }
        
        let strDesc = headerView.txtView.text as String
        
        if isImageSend == true {
            
            imageStatus = "true"
        }
        else {
            
            imageStatus = "false"
        }
        
        let arrCategoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
            arrSelectedCategory as! [String], array: (AppDataManager.sharedInstance.arrCategories as? [AnyObject])!)
        
        let strCategoryID = arrCategoryID.joined(separator: ",")
        
        var dictParams = [String: Any]()
        
        dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
        
        dictParams["width"] = self.view.frame.size.width - 30
        
        dictParams["height"] = self.imageHeight
        
        dictParams["description"] = strDesc
        
        dictParams["video_link"] = strUrl
        
        dictParams["image_status"] = imageStatus
        
        dictParams["post_id"] = self.postId
        
        dictParams["type"] = selectedType
        
        dictParams["day"] = selectedDay
        
        dictParams["time"] = selectedTime
        
        if strCategoryID == "" {
            
            dictParams["category"] = self.catId
        }
        else {
            
            dictParams["category"] = strCategoryID
        }
        
        dictParams["ftype"] = strSwitchStatus
        
        dictParams["max_redemption"] = strMaxOffers
        
        dictParams["validity_date"] = strExpiryDate
        
        dictParams["per_person_redemption"] = strMaxPersons
            
        dictParams["validity_time"] = strExpiryTime
        
        dictParams["title"] = title
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = tblViewAddPost.cellForRow(at: indexPath) as? AddPostViewCell
        
        if imageStatus == "true" && cell?.imgThumnail.isHidden == true {
            
            FeedManager.sharedInstance.dictParams = dictParams
            FeedManager.sharedInstance.editScheduleWithoutImage(completionHandler: { (dictResponse) in
                
                let strStatus = dictResponse["status"] as? String
                
                if strStatus == "true" {
                    
                    let msg = dictResponse["msg"] as? String
                    
                    DispatchQueue.main.async {
                        
                        self.showAlertPostAdded(msg: msg!)
                        
                        SVProgressHUD.dismiss()
                        
                        self.view.isUserInteractionEnabled = true
                        
                    }
                }
                    
                else if strStatus == "false" {
                    
                    let msg = dictResponse["msg"] as? String
                    
                    DispatchQueue.main.async {
                        
                        self.showAlertPostAdded(msg: msg!)
                        
                        SVProgressHUD.dismiss()
                        
                        self.view.isUserInteractionEnabled = true
                    }
                    
                }
                
            }, failure: { (error) in
                
                print(error.description)
                
                return
                
            })
            
        }
        else if imageStatus == "true" && cell?.imgThumnail.isHidden == false {
            
            var image = UIImage()
            
            image = CommonClass.sharedInstance.compressImage((cell?.imgThumnail.image)!)
            
            FeedManager.sharedInstance.imgPost = image
            
            FeedManager.sharedInstance.dictParams = dictParams
            
            SVProgressHUD.show()
            FeedManager.sharedInstance.editSchedulePostWithImage(completionHandler: { (dictResponse) in
                
                SVProgressHUD.dismiss()
                
                let strStatus = dictResponse["status"] as? String
                
                if strStatus == "true" {
                    
                    let msg = dictResponse["msg"] as? String
                    
                    DispatchQueue.main.async {
                        
                        self.showAlertPostAdded(msg: msg!)
                        
                        SVProgressHUD.dismiss()
                        
                        self.view.isUserInteractionEnabled = true
                        
                    }
                }
                    
                else if strStatus == "false" {
                    
                    let msg = dictResponse["msg"] as? String
                    
                    DispatchQueue.main.async {
                        
                        self.showAlertPostAdded(msg: msg!)
                        
                        SVProgressHUD.dismiss()
                        
                        self.view.isUserInteractionEnabled = true
                    }
                    
                }
                
            }, failure: { (error) in
                
                 return
                
            })
            
        }
        else {
            
            FeedManager.sharedInstance.dictParams = dictParams
            
            FeedManager.sharedInstance.editScheduleWithoutImage(completionHandler: { (dictResponse) in
                
                let strStatus = dictResponse["status"] as? String
                
                if strStatus == "true" {
                    
                    let msg = dictResponse["msg"] as? String
                    
                    DispatchQueue.main.async {
                        
                        self.showAlertPostAdded(msg: msg!)
                        
                        SVProgressHUD.dismiss()
                        
                        self.view.isUserInteractionEnabled = true
                        
                    }
                }
                else if strStatus == "false" {
                    
                    let msg = dictResponse["msg"] as? String
                    
                    DispatchQueue.main.async {
                        
                        self.showAlertPostAdded(msg: msg!)
                        
                        SVProgressHUD.dismiss()
                        
                        self.view.isUserInteractionEnabled = true
                    }
                    
                }
                
            }, failure: { (error) in
                
                 return
                
            })
            
        }
    }
    
    
    //MARK: Show Alert of post Added
    func showAlertPostAdded(msg: String) {
        
        let alert = UIAlertController(title: "",message:msg ,preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
            
            if self.isScheduleSelected == false {
                
                isAddPost = true
                
                isScheduleVc = false
                
                isEditPost = false
                
                let imageDataDict:[String: UIImage] = ["image": #imageLiteral(resourceName: "placeholder")]
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTabBarIndex"), object: nil, userInfo:imageDataDict)
                
                self.editDict.removeAll()
            }
            else {
                
                isAddPost = true
                
                isScheduleVc = true
                
                isEditPost = false
                
                let imageDataDict:[String: UIImage] = ["image": #imageLiteral(resourceName: "placeholder")]
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTabBarIndex"), object: nil, userInfo:imageDataDict)
                
                self.editDict.removeAll()
            }
            
            self.navigationController?.popViewController(animated:  true)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
