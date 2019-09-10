//
//  Extensions+AddPost+Protocols.swift
//  PlacePoint
//
//  Created by MRoot on 06/09/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

//MARK: - AdoptProtocol
extension AddPostVC: OpenImageProtocol {
    
    func openCamera() {
        
        if imgURl != "" {
            
            imgURl = ""
            
            self.imageHeight = 0.0
            
            var dict = editDict as? [String: Any]
            
            dict!["height"] = self.imageHeight
            
            dict!["image_url"] = ""
            
        }
        
        imgURl = ""
        
        editDict.removeAll()
        
        if isfirstYoutubeSelected == true {
            
            headerView.vwtextUrl.isHidden = false
            
            headerView.txtFieldUrl.isHidden = false
            
        }
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .camera
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = tblViewAddPost.cellForRow(at: indexPath) as? AddPostViewCell
        
        cell?.imgThumnail.isHidden = false
        
        imagePicker.allowsEditing = false
        
        imagePicker.modalPresentationStyle = .custom
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func openPhotoLibrary() {
        
        if imgURl != "" {
            
            imgURl = ""
            
            self.imageHeight = 0.0
            
            var dict = editDict as? [String: Any]
            
            dict!["height"] = self.imageHeight
            
            dict!["image_url"] = ""
            
        }
        
        imgURl = ""
        
        editDict.removeAll()
        
        if isfirstYoutubeSelected == true {
            
            headerView.vwtextUrl.isHidden = false
            
            headerView.txtFieldUrl.isHidden = false
        }
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = tblViewAddPost.cellForRow(at: indexPath) as? AddPostViewCell
        
        cell?.imgThumnail.isHidden = false
        
        imagePicker.allowsEditing = false
        
        imagePicker.modalPresentationStyle = .custom
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func addYouTubeLink() {
        
        self.isfirstYoutubeSelected = true
        
        headerView.vwtextUrl.isHidden = false
        
        headerView.txtFieldUrl.isHidden = false
        
    }
    
}
extension AddPostVC: DeleteImage {
    
    func deleteImage() {
        
        if imgURl != "" {
            
            self.imageHeight = 0.0
            
            var dict = editDict as? [String: Any]
            
            dict!["height"] = self.imageHeight
            
            dict!["image_url"] = ""
            
        }
        
        imgURl = ""
        
        editDict.removeAll()
        
        self.imageHeight = 0.0
        
        selectedImage = UIImage()
        
        croppedImage = UIImage()
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = tblViewAddPost.cellForRow(at: indexPath) as? AddPostViewCell
        
        cell?.imgThumnail.isHidden = true
        
        cell?.imgThumnail.image = UIImage(named: "")
        
        cell?.heightContraintImgThumb.constant = imageHeight
        
        isImageSend = true
        
        cell?.btnCross.isHidden = true
        
        cell?.btnCross.layer.zPosition = 1
        
        tblViewAddPost.reloadData()
        
    }
}
extension AddPostVC: SchedulePicker {
    
    func postNow() {
        
        let indexPath = IndexPath(row: 0, section: 2)
        
        let cell = tblViewAddPost.cellForRow(at: indexPath) as? ScheduleAddPostCell
        
        if cell?.btnPostThis.imageView?.image == #imageLiteral(resourceName: "UncheckBoxBlue") {
            
            cell?.btnPostThis.setImage(#imageLiteral(resourceName: "checkBoxBlue"), for: .normal)
            
            self.nowStatus = "1"
            
        }
        else {
            
            cell?.btnPostThis.setImage(#imageLiteral(resourceName: "UncheckBoxBlue"), for: .normal)
            
            self.nowStatus = "0"
        }
    }
    
    
    func openSchedulePicker(isDay: Bool, IsTime: Bool) {
        
        if isDay == false && IsTime == false {
            
            pickerSelectedIndex = 0
            
            self.isDatePicker = false
            
            self.strDay = ""
            
            self.selectedDay = ""
            
            self.selectedTime = ""
            
            viewForAllPicker.isHidden = false
            
            self.pickerSchedule.isHidden = false
            
            self.datePicker.isHidden = true
            
            arrPicker = arrSchedulePicker
            
            toolBar.isHidden = false
            
            pickerSchedule.dataSource = self
            
            pickerSchedule.delegate = self
        }
        else if isDay == true && IsTime == false {
            
            viewForAllPicker.isHidden = false
            
            self.pickerSchedule.isHidden = false
            
            self.datePicker.isHidden = true
            
            if self.selectedItem == "Schedule post on a specific day each month" {
                
                self.selectedType = "2"
                
                self.selectedDay = ""
                
                arrPicker = arrMonthPicker
            }
            else if self.selectedItem == "Schedule post for a specific day" {
                
                viewForAllPicker.isHidden = false
                
                self.selectedType = "3"
                
                pickerSchedule.isHidden = true
                
                datePicker.backgroundColor = UIColor.white
                
                isDatePicker = true
                
                datePicker.isHidden = false
                
                isTime = false
                
                datePicker.datePickerMode = .date
                
            }
            else {
                
                viewForAllPicker.isHidden = false
                
                self.selectedType = "1"
                
                self.selectedDay = ""
                
                arrPicker = arrDayPicker
                
            }
            
            toolBar.isHidden = false
            
            pickerSchedule.dataSource = self
            
            pickerSchedule.delegate = self
        }
        else {
            
            viewForAllPicker.isHidden = false
            
            self.pickerSchedule.isHidden = true
            
            self.toolBar.isHidden = false
            
            self.datePicker.isHidden = false
            
            self.datePicker.backgroundColor = UIColor.white
            
            isTime = true
            
            isDatePicker = true
            
            datePicker.datePickerMode = .time
            
        }
    }
    
}

extension AddPostVC: ChooseCategory{
    
    func chooseCategory() {
        
        self.setUpView()
        
        let selectCat = SelectCategories(nibName: "SelectCategories", bundle: nil)
        
        selectCat.delegate = self as SelectedCategories
        
        selectCat.isPostVc = true
        
        isAddPost = true
        
        let nav = UINavigationController(rootViewController: selectCat)
        
        nav.modalPresentationStyle = .custom
        
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
}


extension AddPostVC: ActionPost {
    
    func acionPost() {
        
        if footerView.btnPost.titleLabel?.text == "Post" {
            
            self.apiAddPost()
        }
        else {
            
            self.apiEditPost()
        }
        
    }
}


extension AddPostVC: SelectedCategories {
    
    func category(selectedCat: [String]) {
        
        self.arrSelectedCategory = selectedCat
        
        chooseCat = true
        
        self.setUpView()
        
        tblViewAddPost.reloadData()
        
    }
}


extension AddPostVC: UpgradePlan {
    
    func upgradeSubPlan() {
        
        isAddPost = true
        
        let strSelectedType = UserDefaults.standard.getBusinessUserType()
        
        if strSelectedType == "Free" {
            
            strUserType = "3"
        }
        else if strSelectedType == "Standard" {
            
            strUserType = "2"
        }
        else if strSelectedType == "Premium" {
            
            strUserType = "1"
        }
        else {
            
            strUserType = "4"
        }
        
        let subPlanVc = SubScriptionPlanVC(nibName: "SubScriptionPlanVC", bundle: nil)
        
        let nav = UINavigationController(rootViewController: subPlanVc)
        
        self.navigationController?.present(nav, animated: true, completion: nil)
        
    }
}

