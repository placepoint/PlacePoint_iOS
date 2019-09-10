
//
//  Extension+BusinessApi.swift
//  PlacePoint
//
//  Created by Mac on 19/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension BusinessVC {
    
    //MARK: - Api Get BusinessDetails
    func apiGetDetails(strBusinessId: String)  {
        
        var params = [String: String]()
        
        params["auth_code"] = UserDefaults.standard.getAuthCode()
        
        params["business_id"] = strBusinessId
        
        let checkBusinessLogin = UserDefaults.standard.getBusinessLogin()
        
        if checkBusinessLogin == true {
            
            params["mydetail"] = "true"
        }
        else {
            params["mydetail"] = "false"
        }
        
        self.loadingView.isHidden = false
        
        SVProgressHUD.show()
        
        FeedManager.sharedInstance.dictParams = params as! [String : Any]
        
        FeedManager.sharedInstance.getSingleBusinessDetails(completionHandler: { (dictResponse) in
            
            SVProgressHUD.dismiss()
            
            let strStatus = dictResponse["status"] as? String
            
            if strStatus == "false" {
                
                let action = dictResponse["action"] as? String
                
                let msg = dictResponse["msg"] as? String
                
                let strAuthCOde = UserDefaults.standard.getAuthCode()
                
                let strTown = UserDefaults.standard.getTown()
                
                var strCategory = String()
                
                var strSelectCat = String()
                
                if isAllCategories == true {
                    
                    strCategory = UserDefaults.standard.getAllCatName()
                }
                else {
                    
                    strCategory = UserDefaults.standard.getSelectedCat()
                    
                    strSelectCat = UserDefaults.standard.getSelectedCategory()
                    
                }
                
                let strSelectedTown = UserDefaults.standard.getSelectedTown()
                
                let userType = UserDefaults.standard.getBusinessUserType()
                
                if action == "logout" {
                    
                    let alert = UIAlertController(title: "",message: msg,preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                        
                        LogoutUser.sharedLogout.resetDefaults()
                        
                        goToShowFeed = false
                        
                        UserDefaults.standard.setBusinessUserType(userType: userType)
                        
                        UserDefaults.standard.setIsLoggedIn(value: false)
                        
                        UserDefaults.standard.setupAuthCode(auth: strAuthCOde)
                        
                        UserDefaults.standard.setTown(value: strTown)
                        
                        UserDefaults.standard.setisAppAuthFirst(isFirst: true)
                        
                        UserDefaults.standard.setSelectedCat(value: strCategory)
                        
                        UserDefaults.standard.setAllCatName(value: strCategory)
                        
                        UserDefaults.standard.selectedCategory(value: strSelectCat)
                        
                        UserDefaults.standard.setSelectedTown(value: strSelectedTown)
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                        appDelegate.setUpRootVC()
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            else if strStatus == "true" {
                
                DispatchQueue.main.async {
                    
                    SVProgressHUD.dismiss()
                    
                    self.loadingView.isHidden = true
                }
                
                DispatchQueue.main.async {
                    
                    let endTime = (dictResponse["end_time"] as? String)!
                    
                    let userType = (dictResponse["user_type"] as? String)!
                    
                    var selectedUserType = String()
                    
                    if userType == "3" {
                        
                        selectedUserType = "Free"
                        
                        UserDefaults.standard.setBusinessUserType(userType: "Free")
                        
                    }
                    else if userType == "2" {
                        
                        selectedUserType = "Standard"
                        
                        UserDefaults.standard.setBusinessUserType(userType: "Standard")
                        
                    }
                    else if userType == "1" {
                        
                        selectedUserType = "Premium"
                        
                        UserDefaults.standard.setBusinessUserType(userType: "Premium")
                    }
                    else{
                        
                        selectedUserType = "Admin"
                        
                        UserDefaults.standard.setBusinessUserType(userType: "Admin")
                        
                    }
                    
                    if selectedUserType == "Free" || selectedUserType == "Admin" {
                        
                        self.packageEndTime = endTime
                        
                        self.footerView.lblEndtime.isHidden = true
                        
                    }
                    else {
                        
                        let inputFormatter = DateFormatter()
                        
                        inputFormatter.dateFormat = "yyyy-MM-dd"
                        
                        let showDate = inputFormatter.date(from: endTime)
                        
                        inputFormatter.dateFormat = "MM/dd/yyyy"
                        
                        let resultString = inputFormatter.string(from: showDate!)
                        
                        let now = Date()
                        
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        
                        let resultCheckExpire: ComparisonResult = (showDate?.compare(now))!
                        
                        if resultCheckExpire == .orderedDescending || resultCheckExpire == .orderedSame {
                            
                            self.packageEndTime = resultString
                            
                            self.footerView.lblEndtime.isHidden = false
                            
                            self.footerView.lblEndtime.text = "Expires on - \(self.packageEndTime)"
                            
                        }
                        else if resultCheckExpire == .orderedDescending {
                            
                            self.packageEndTime = resultString
                            
                            self.footerView.lblEndtime.isHidden = false
                            
                            self.footerView.lblEndtime.text = "Expired on - \(self.packageEndTime)"
                            
                        }
                        
                    }
                    
                    let arrData = dictResponse["data"] as? [AnyObject]
                    
                    self.dictCreatedBusiness = arrData![0] as! [String : Any]
                    
                    let arrImages = self.dictCreatedBusiness["image_url"] as! NSArray
                    
                    let strVideoLink = self.dictCreatedBusiness["video_link"]  as? String
                    
                    if strVideoLink == "" && strVideoLink == nil {
                        
                        isYoutubeBtnSelected = false
                    }
                    
                    savedImages.removeAll()
                    
                    arrBusinessImages.removeAll()
                    
                    if arrImages.count > 0 {
                        
                        for i in 0..<arrImages.count {
                            
                            arrBusinessImages.append(arrImages[i] as AnyObject)
                            
                        }
                    }
                    
                    self.setUpTableView()
                    
                    let strOpeningTime = self.dictCreatedBusiness["opening_time"] as? String
                    
                    let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
                    
                    if selectedBusinessType == "Premium" || selectedBusinessType == "Standard" || selectedBusinessType == "Admin"{
                        
                        if strOpeningTime != "" && strOpeningTime != "null" {
                            
                            let arr = self.convertToDictionary(text: strOpeningTime!)!
                            
                            self.arrOpeningTime = arr
                            
                            self.arrHours =  self.arrOpeningTime
                            
                            self.selectWeekDay(tag: 0)
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        SVProgressHUD.dismiss()
                        
                        self.loadingView.isHidden = true
                    }
                    
                    self.view.isUserInteractionEnabled = true
                    
                }
            }
            else {
                
                DispatchQueue.main.async {
                    
                    SVProgressHUD.dismiss()
                    
                    self.view.isUserInteractionEnabled = true
                    
                }
            }
            
        }, failure: { (error) in
            return
        })
    }
    
    
    //MARK: - Api Post BusinessDetails
    func apiBusinessDetails() {
        
        SVProgressHUD.show()
        
        var jsonImagesSTring = ""
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if dictCreatedBusiness.count != 0 {
            
            if arrUrlSavedImages.count > 0 {
                
                do {
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: arrUrlSavedImages, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                        
                        jsonImagesSTring = JSONString
                    }
                }
                catch _ {
                    
                    print ("UH OOO")
                }
            }
            else {
                
                jsonImagesSTring = ""
            }
        }
        
        var coverImage = UIImage()
        
        if headerView.businessImage.image == #imageLiteral(resourceName: "placeholder") {
            
            coverImage = headerView.businessImage.image!
        }
        else {
            
            coverImage = CommonClass.sharedInstance.compressImage(headerView.businessImage.image!)
        }
        
        var videoLink = dictCreatedBusiness["video_link"] as? String
        
        if videoLink == nil || videoLink == "" {
            
            videoLink = ""
        }
        
        var townId = dictCreatedBusiness["town_id"] as? String
        
        if townId == nil || townId == "" {
            
            townId = ""
        }
        
        var strCategoryID = footerView.txtFieldCategory.text?.trim()
        
        let arrSelectedCategory = strCategoryID?.components(separatedBy: ",")
        
        var allCategoryId = [String]()
        
        for i in 0..<(arrSelectedCategory?.count)!{
            
            let arrCategoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
                [arrSelectedCategory![i]], array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
            
            let strCat = arrCategoryID.joined(separator: ",")
            
            allCategoryId.append(strCat)
            
        }
        
        var categoryId = allCategoryId.joined(separator: ",")
        
        if categoryId == nil || categoryId == "" {
            
            categoryId = ""
        }
        
        var address = footerView.lblAddress.text
        
        if address == nil || address == "No Address Selected" {
            
            address = ""
        }
        
        var email = UserDefaults.standard.getEmail()
        
        if email == nil || email == "" {
            
            email = ""
        }
        
        var businessEmail = footerView.txtFieldEmail.text
        
        if businessEmail == nil || businessEmail == "" {
            
            businessEmail = ""
        }
        
        var description = headerView.textView.text
        
        if description == nil || description == "" {
            
            description = ""
            
        }
        
        var contactNo = dictCreatedBusiness["contact_no"] as? String
        
        if contactNo == nil || contactNo == "" {
            
            let strContact = footerView.txtFldPhoneNumber.text
            
            if strContact == "" {
                
                contactNo = ""
            }
            else {
                
                contactNo = footerView.txtFldPhoneNumber.text
                
                dictCreatedBusiness["contact_no"] = contactNo
            }
        }
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Standard" || selectedBusinessType == "Premium" || selectedBusinessType == "Admin" {
            
            let openingHrsValidation: Bool = self.checkChosingOpeningHoursValidation()
            
            if openingHrsValidation != true {
                
                SVProgressHUD.dismiss()
                
                return
            }
            else {
                
                self.setJsonString()
                
            }
        }
        
        var dictParams = [String: Any]()
        
        if selectedBusinessType == "Free"{
            
            self.packageName = "3"
            
            if address != "" && email != "" {
                
                var statusImages:String = "false"
                
                if arrBusinessImages.count > 0 {
                    
                    statusImages = "true"
                }else {
                    
                    statusImages = "false"
                }
                
                dictParams = ["auth_code": UserDefaults.standard.getAuthCode(), "town_id": (townId)!, "category_id": categoryId, "video_link": (videoLink)!, "opening_hours": self.closingHoursString, "address": (address)!, "contact_no": (contactNo)!,"image_count": String(format:"%d", arrNewSavedImages.count),"email": email,"business_email": (businessEmail)!,"business_name": (headerView.textFieldBusinessName.text)!,"cover_image": coverImage,"image_status": statusImages,"description": (headerView.textView.text)!, "lat": "\(self.latitude)", "long": "\(self.longitude)","oldimages": jsonImagesSTring,"user_Type": packageName]
                
                print(dictParams)
                
                self.apiUpdateBusiness(params: dictParams)
                
                
            }
            else if address == "" {
                
                SVProgressHUD.dismiss()
                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "Address is missing")
            }
            else if email == "" && businessEmail == "" {
                SVProgressHUD.dismiss()
                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "email is missing")
            }
            
        }
        else if selectedBusinessType == "Standard" || selectedBusinessType == "Premium"  || selectedBusinessType == "Admin"{
            
            if selectedBusinessType == "Standard" {
                
                self.packageName = "2"
            }
            else if selectedBusinessType == "Premium" {
                
                self.packageName = "1"
            }
            else {
                
                self.packageName = "4"
            }
            
            if townId != "" && categoryId != "" && address != "" && businessEmail != "" && closingHoursString != "" && description != "" && coverImage != #imageLiteral(resourceName: "placeholder") {
                
                var statusImages:String = "false"
                
                if arrBusinessImages.count > 0 {
                    
                    statusImages = "true"
                }else {
                    
                    statusImages = "false"
                }
                
                dictParams = ["auth_code": UserDefaults.standard.getAuthCode(), "town_id": (townId)!, "category_id":categoryId, "video_link": (videoLink)!, "opening_hours": self.closingHoursString, "address": (address)!, "contact_no": (contactNo)!,"image_count": String(format:"%d", arrNewSavedImages.count),"email": email,"business_email": (businessEmail)!,"business_name": (headerView.textFieldBusinessName.text)!,"cover_image": coverImage,"image_status": statusImages,"description": (headerView.textView.text)!, "lat": "\(self.latitude)", "long": "\(self.longitude)","oldimages": jsonImagesSTring,"user_Type": packageName]
                
                print(dictParams)
                
                SVProgressHUD.show()
                
                self.view.isUserInteractionEnabled = false
                
                FeedManager.sharedInstance.imgPost = coverImage
                
                FeedManager.sharedInstance.arrImages = arrNewSavedImages as! [UIImage]
                
                self.apiUpdateBusiness(params: dictParams)
                
            }
            else if townId == "" {
                SVProgressHUD.dismiss()
                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "Town is missing")
                
            }
            else if categoryId == "" {
                SVProgressHUD.dismiss()
                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "Category is missing")
                
            }
            else if address == "" {
                SVProgressHUD.dismiss()
                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "Address is missing")
            }
            else if email == "" && businessEmail == "" {
                SVProgressHUD.dismiss()
                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "email is missing")
            }
                //            else if contactNo == "" {
                //                 SVProgressHUD.dismiss()
                //                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "contactNo is missing")
                //            }
            else if description == "" {
                SVProgressHUD.dismiss()
                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "description is missing")
            }
            else if coverImage == #imageLiteral(resourceName: "placeholder") {
                SVProgressHUD.dismiss()
                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "coverImage is missing")
            }
            else if closingHoursString == "" {
                SVProgressHUD.dismiss()
                appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "Please select time for all days")
            }
            else {
                SVProgressHUD.dismiss()
                appDelegate?.window?.rootViewController?.showAlert(withTitle: ValidAlertTitle.FieldMandatory, message: ValidAlertMsg.FieldMandatory)
            }
            
            
        }
        else if townId == "" {
            SVProgressHUD.dismiss()
            appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "Town is missing")
            
        }
        else if categoryId == "" {
            SVProgressHUD.dismiss()
            appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "Category is missing")
            
        }
        else if address == "" {
            SVProgressHUD.dismiss()
            appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "Address is missing")
        }
        else if email == "" && businessEmail == "" {
            SVProgressHUD.dismiss()
            appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "email is missing")
        }
        else if description == "" {
            SVProgressHUD.dismiss()
            appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "description is missing")
        }
        else if coverImage == #imageLiteral(resourceName: "placeholder") {
            SVProgressHUD.dismiss()
            appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "coverImage is missing")
        }
        else if closingHoursString == "" {
            SVProgressHUD.dismiss()
            appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "Please select time for all days")
        }
        else {
            SVProgressHUD.dismiss()
            appDelegate?.window?.rootViewController?.showAlert(withTitle: ValidAlertTitle.FieldMandatory, message: ValidAlertMsg.FieldMandatory)
        }
        
    }
    
    func apiUpdateBusiness(params: [String: Any]) {
        
        SVProgressHUD.show()
        
        FeedManager.sharedInstance.dictParams = params as [String: Any]
        
        self.isSavedPressed = true
        
        FeedManager.sharedInstance.postBusinessDetails(completionHandler: { (dictResponse) in
            
            let strStatus = dictResponse["status"] as? String
            
            SVProgressHUD.dismiss()
            
            if strStatus == "false" {
                
                let action = dictResponse["action"] as? String
                
                let msg = dictResponse["msg"] as? String
                
                let strAuthCOde = UserDefaults.standard.getAuthCode()
                
                let strTown = UserDefaults.standard.getTown()
                
                var strAllCat = String()
                
                var strCategory = String()
                
                var strSelectCat = String()
                
                if isAllCategories == true {
                    
                    strAllCat = UserDefaults.standard.getAllCatName()
                }
                else {
                    
                    strCategory = UserDefaults.standard.getSelectedCat()
                    
                    strSelectCat = UserDefaults.standard.getSelectedCategory()
                }
                
                let strSelectedTown = UserDefaults.standard.getSelectedTown()
                
                let userType = UserDefaults.standard.getBusinessUserType()
                
                if action == "logout" {
                    
                    let alert = UIAlertController(title: "",message:"msg",preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                        
                        LogoutUser.sharedLogout.resetDefaults()
                        
                        goToShowFeed = false
                        
                        UserDefaults.standard.setBusinessUserType(userType: userType)
                        
                        UserDefaults.standard.setIsLoggedIn(value: false)
                        
                        UserDefaults.standard.setupAuthCode(auth: strAuthCOde)
                        
                        UserDefaults.standard.setTown(value: strTown)
                        
                        UserDefaults.standard.setisAppAuthFirst(isFirst: true)
                        
                        UserDefaults.standard.setSelectedCat(value: strCategory)
                        
                        UserDefaults.standard.setAllCatName(value: strAllCat)
                        
                        UserDefaults.standard.selectedCategory(value: strSelectCat)
                        
                        UserDefaults.standard.setSelectedTown(value: strSelectedTown)
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                        appDelegate.setUpRootVC()
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            else if strStatus == "true" {
                
                let msg = dictResponse["msg"] as? String
                
                let name = self.headerView.textFieldBusinessName.text
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
                let alert = UIAlertController(title: "Alert",message: msg,preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    
                    let feedDetailsVC = BuisnessShowFeedVc(nibName: "BuisnessShowFeedVc", bundle: nil)
                    
                    let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
                    
                    if selectedBusinessType == "Standard" || selectedBusinessType == "Premium" || selectedBusinessType == "Admin"{
                        
                        isBusinessDetail = true
                        
                        isBusinessVc = true
                        
                        checkMyTimeLine = "My Posts"
                        
                        isShowMyTimeLine = true
                        
                        let strBusId = dictResponse["business_id"] as! String
                        
                        businessName = name!
                        
                        savedImages.removeAll()
                        
                        strBusinessId = strBusId
                        
                        self.navigationController?.pushViewController(feedDetailsVC, animated: true)
                        
                    }
                    else {
                        
                        isBusinessDetail = false
                        
                        isBusinessVc = false
                        
                        isShowMyTimeLine = true
                        
                        self.navigationController?.pushViewController(feedDetailsVC, animated: true)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "afterUpgarde"), object: nil)
                        
                        self.tabBarController?.selectedIndex = 0
                    }
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }, failure: { (error) in
            
            self.isSavedPressed = false
        })
    }
}
