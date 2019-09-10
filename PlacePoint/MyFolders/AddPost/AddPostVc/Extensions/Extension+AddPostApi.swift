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
import Alamofire
extension AddPostVC {
    
    //MARK: - Api AddPost
    func apiAddPost() {
        
        
        
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
        
//        print(isVideoSend)
//        print(isImageSend)
//        print(strDesc)
//        
//        print(strUrl)
//        
//        
//        return
        
        SVProgressHUD.show()
        
        if isImageSend == true {
            
            imageStatus = "true"
        }
        else {
            
            imageStatus = "false"
        }
        
        if boolScheduleCell {
            
            strSwitchStatus = "1"
        }
        else {
            strSwitchStatus = "0"
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
            
        } else if isVideoSend == true {
            
            
            print(dictParams)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
               
                for key in dictParams.keys{
                    let name = String(key)
                    
                    if name == "width" {
//                      let val = dictParams[name] as? Float
                  
                     multipartFormData.append("\(384.0)".data(using: .utf8)!, withName: name)
                    }else if name == "height" {
                          multipartFormData.append("\(0.0)".data(using: .utf8)!, withName: name)
                    } else {
                       let val = dictParams[name] as? String
                    
                        multipartFormData.append(val!.data(using: .utf8)!, withName: name)
                    
                    }
                    
                }
//                for (key, value) in dictParams {
//                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8)!, withName: key)
//                }
                
                
                
                multipartFormData.append(self.postVideoUrl!, withName: "upload_video")
                
            }, to:baseURL+"addPostVideo")
            { (result) in
                switch result {
                case .success(let upload, _ , _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        
                        print("uploding")
                    })
                    
                    upload.responseJSON { response in
                        
                        
                        print(response)
                        
                        print("done")
                        

                        DispatchQueue.main.async {
                            
                            self.showAlertPostAdded(msg: "Post Successfully Created")
                            
                            SVProgressHUD.dismiss()
                            
                            self.view.isUserInteractionEnabled = true
                            
                        }
                    }
                    
                case .failure(let encodingError):
                    print("failed")
                    print(encodingError)
                    
                }
            }
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
        
        if boolScheduleCell {
            
            strSwitchStatus = "1"
        }
        else {
            strSwitchStatus = "0"
            
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
        
        
      self.vwFlashPostPopUP.isHidden = false
      
        
//        let attributedString = NSMutableAttributedString(string: "Thanks for placing a flash deal. Your flash deal is currently awaiting approval, this normally is approved in a short space of time, if it’s urgent please contact us via the Facebook page.")
//        attributedString.addAttribute(.link, value: "https://www.hackingwithswift.com", range: NSRange(location: 19, length: 55))
////
////        textView.attributedText = attributedString
////
//         let alert = UIAlertController(title: "",message:"" ,preferredStyle: UIAlertControllerStyle.alert)
//
//        alert.setValue(attributedString, forKey: "attributedMessage")
//
//
//        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
//
//
//
//        }))
//
//        self.present(alert, animated: true, completion: nil)
        
        
        
        
        
    }
    
}
extension NSMutableAttributedString {
    
    public func setHyperLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
