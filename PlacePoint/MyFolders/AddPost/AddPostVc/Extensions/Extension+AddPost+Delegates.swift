//
//  Extension+AddPost+Delegates.swift
//  PlacePoint
//
//  Created by MRoot on 06/09/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


//MARK: - UITableView DataSource and Delegate
extension AddPostVC: UITableViewDataSource, UITableViewDelegate, FlashPostTVcellDelegate {
    
    func FlashActionDelegate() {
        
        self.view.endEditing(true)
        
        tblViewAddPost.reloadData()
    }
    

//
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        print(section)
        
        if section == 3 {
            
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "SchedulePostSectionCell") as! SchedulePostSectionCell
            
            headerCell.btnSchedulePost.addTarget(self, action: #selector(sectionHeaderTapped), for: UIControlEvents.touchUpInside)
            
            if isScheduleSelected == true {
                
                headerCell.imgArrow.image = #imageLiteral(resourceName: "up_ArrowBlue")
                
                viewForAllPicker.isHidden = true
                
                pickerSchedule.isHidden = true
                
                datePicker.isHidden = true
            }
            
            return headerCell
        }
        else {
            
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "flashPostTVcell") as! FlashPostTVcell
            
            headerCell.txtFldOffersTobeRedeemed.addTarget(self, action: #selector(txtFldSelectOffers), for: .editingChanged)
            
            headerCell.delegate = self
            
            headerCell.txtFldOffersTobeRedeemed.delegate = self
            
            if !boolScheduleCell {
                
                headerCell.viewContainedContent.isHidden = true
            }
            else {
                
                headerCell.viewContainedContent.isHidden = false
            }
            
            if strMaxOffers != "" {
                
                headerCell.txtFldOffersTobeRedeemed.text = strMaxOffers
            }
            
            if strMaxPersons != "" {
            
                headerCell.btnPersons.setTitle(strMaxPersons, for: .normal)
            }
            
            if strExpiryTime != "" {
                
                headerCell.btnExpiryTime.setTitle(strExpiryTime, for: .normal)
            }
            
            if strExpiryDate != "" {
                
                headerCell.btnExpiryDate.setTitle(strExpiryDate, for: .normal)
            }
            
//            if strSwitchStatus == "1" {
//
//                headerCell.switchFlashPost.setOn(true, animated: false)
//            }
//            else {
//                headerCell.switchFlashPost.setOn(false, animated: true)
//
//            }
//
             headerCell.btnFlashPostClicked.addTarget(self, action: #selector(FlashPostActionHeader), for: .touchUpInside)
            
            headerCell.btnFlashPostClicked.tag = section
            
//            headerCell.switchFlashPost.addTarget(self, action: #selector(switchFlashAction), for: .touchUpInside)

            headerCell.btnOffers.addTarget(self, action: #selector(btnOffersAction), for: .touchUpInside)
            
            headerCell.btnPersons.addTarget(self, action: #selector(btnPersonsAction), for: .touchUpInside)
            
            headerCell.btnExpiryTime.addTarget(self, action: #selector(btnExpiryTimeAction), for: .touchUpInside)
            
            headerCell.btnExpiryDate.addTarget(self, action: #selector(btnExpiryDateAction), for: .touchUpInside)

            return headerCell
            
        }
        
    }
    
    
    
    @objc func txtFldSelectOffers(sender: UITextField) {
        
        strMaxOffers = sender.text!
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 0
        }
        else if section == 1 {
            
            return 0
        }
        else if section == 2 {
            
            if !boolScheduleCell {
                
                return 50
            }
            else {
            return DeviceInfo.TheCurrentDeviceWidth*0.67
            }
        }
        else {
            
            return 50
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            if imgURl != "" {
                
                return 1
            }
            else if selectedImage == #imageLiteral(resourceName: "placeholder") {
                
                return 0
            }
                
            else {
                return 1
            }
        }
        else if section == 1 {
            
            return 1
        }
        else if section == 3 {
            
            if isScheduleSelected == true {
                
                return 1
            }
            else {
                
                return 0
            }
        }
        else {
            
            return 0
        }
    }
    
    
//    @objc func switchFlashAction(sender: UISwitch) {
//
//        if sender.isOn {
//
//            sender.setOn(true, animated: true)
//
//            strSwitchStatus = "1"
//        }
//        else {
//
//            strSwitchStatus = "0"
//
//            sender.setOn(false, animated: true)
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddPostViewCell", for: indexPath) as? AddPostViewCell else {
                fatalError()
            }
            
            if !(editDict.isEmpty) {
                
                let strHeight = editDict["height"] as? String
                
                if let numHeight = NumberFormatter().number(from: strHeight!) {
                    
                    let height = CGFloat(numHeight)
                    
                    self.imageHeight = height
                }
                
                if imgURl.contains("https://") {
                    
                    // cell.imgThumnail.isHidden = false
                    
                    cell.imgThumnail.isHidden = true
                    
                    let url = URL(string: imgURl)
                    
                    cell.imgThumnail.kf.indicatorType = .activity
                    
                    (cell.imgThumnail.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
                    
                    cell.imgThumnail.kf.setImage(with: url,
                                                 placeholder:#imageLiteral(resourceName: "placeholder"),
                                                 options: [.transition(ImageTransition.fade(1))],
                                                 progressBlock: { receivedSize, totalSize in
                    },
                                                 completionHandler: { image, error, cacheType, imageURL in
                    })
                    
                }
                
                cell.btnCross.isHidden = true
                
                //cell.btnCross.isHidden = false
                
                cell.delegate = self
                
                cell.selectionStyle = .none
                
                if self.imageHeight != 0.0 {
                    
                    DispatchQueue.main.async {
                        
                        let getImgViewHeight = cell.imgThumnail.frame.size.height
                        
                        let getImgViewWidth = cell.imgThumnail.frame.size.width
                        
                        let ratio = getImgViewWidth / getImgViewHeight
                        
                        let newHeight = 377 / ratio
                        
                        cell.heightContraintImgThumb.constant = newHeight
                        
                        self.imageHeight = newHeight
                        
                        self.view.layoutIfNeeded()
                    }
                    
                }
                
            }
            else {
                
                cell.btnCross.isHidden = true
                
                cell.selectionStyle = .none
                
                if self.imageHeight != 0.0 {
                    
                   // cell.imgThumnail.isHidden = false
                    
                    cell.imgThumnail.isHidden = true
                    
                    if isEditPost == true {
                        
                        DispatchQueue.main.async {
                            
                            let getImgViewHeight = cell.imgThumnail.frame.size.height
                            
                            let getImgViewWidth = cell.imgThumnail.frame.size.width
                            
                            let ratio = getImgViewWidth / getImgViewHeight
                            
                            let newHeight = 377 / ratio
                            
                            cell.heightContraintImgThumb.constant = newHeight
                            
                            self.imageHeight = newHeight
                            
                            self.view.layoutIfNeeded()
                            
                            if self.imgURl.contains("https://") {
                                
                                // cell.imgThumnail.isHidden = false
                                
                                cell.imgThumnail.isHidden = true
                                
                                let url = URL(string: self.imgURl)
                                
                                cell.imgThumnail.kf.indicatorType = .activity
                                
                                (cell.imgThumnail.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
                                
                                cell.imgThumnail.kf.setImage(with: url,
                                                             placeholder:#imageLiteral(resourceName: "placeholder"),
                                                             options: [.transition(ImageTransition.fade(1))],
                                                             progressBlock: { receivedSize, totalSize in
                                },
                                                             completionHandler: { image, error, cacheType, imageURL in
                                })
                                
                            }
                                
                            else  {
                                
                                DispatchQueue.main.async {
                                    
                                    let getImgViewHeight = 173
                                    
                                    let getImgViewWidth = 277
                                    
                                    let image = self.resizeImage(image: self.croppedImage, targetSize: CGSize(width: getImgViewWidth, height: getImgViewHeight))
                                    
                                    let ratio = image.size.width / image.size.height
                                    
                                    let newHeight = 377 / ratio
                                    
                                    cell.heightContraintImgThumb.constant = newHeight
                                    
                                    self.imageHeight = newHeight
                                    
                                    self.view.layoutIfNeeded()
                                    
                                    cell.imgThumnail.image = image
                                    
                                    cell.btnCross.isHidden = true
                                    
                                    //cell.btnCross.isHidden = false
                                    
                                    cell.delegate = self
                                    
                                    if cell.imgThumnail.image != nil {
                                        
                                        self.isImageSend = true
                                        
                                    }
                                    else {
                                        
                                        if self.footerView.btnPost.titleLabel?.text == "Post" {
                                            self.isImageSend = false
                                        }
                                        else {
                                            self.isImageSend = true
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                        
                        cell.btnCross.isHidden = true
                        
                        //cell.btnCross.isHidden = false
                        
                        cell.delegate = self
                        
                        cell.selectionStyle = .none
                        
                    }
                    else if isEditPost != true {
                        
                        DispatchQueue.main.async {
                            
                            let getImgViewHeight = 173
                            
                            let getImgViewWidth = 277
                            
                            let image = self.resizeImage(image: self.croppedImage, targetSize: CGSize(width: getImgViewWidth, height: getImgViewHeight))
                            
                            let ratio = image.size.width / image.size.height
                            
                            let newHeight = 377 / ratio
                            
                            cell.heightContraintImgThumb.constant = newHeight
                            
                            self.imageHeight = newHeight
                            
                            self.view.layoutIfNeeded()
                            
                            cell.imgThumnail.image = image
                            
                            cell.btnCross.isHidden = true
                            
                            //cell.btnCross.isHidden = false
                            
                            cell.delegate = self
                            
                            if cell.imgThumnail.image != nil {
                                
                                self.isImageSend = true
                                
                            }
                            else {
                                
                                if self.footerView.btnPost.titleLabel?.text == "Post" {
                                    self.isImageSend = false
                                }
                                else {
                                    self.isImageSend = true
                                    
                                }
                                
                            }
                        }
                        
                    }
                    else {
                        
                        cell.imgThumnail.isHidden = true
                        
                        cell.heightContraintImgThumb.constant = 0.0
                        
                        if footerView.btnPost.titleLabel?.text == "Post" {
                            
                            isImageSend = false
                        }
                        else {
                            
                            isImageSend = true
                            
                        }
                        
                        view.layoutIfNeeded()
                    }
                    
                }
                
            }
            
            cell.imgThumnail.isHidden = true
            
            cell.btnCross.isHidden = true
            
            return cell
        }
         if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCellChoosecCat", for: indexPath) as? SectionCellChoosecCat else {
                fatalError()
            }
            
            cell.selectionStyle = .none
            
            if !(editDict.isEmpty) {
                
                let category = editDict["category_id"] as? String
                
                let arrCategory = category?.components(separatedBy: ",")
                
                var arrCat = [String]()
                
                for i in 0..<(arrCategory?.count)! {
                    
                    let catName = CommonClass.sharedInstance.getCategoryName(strCategory: arrCategory![i], array: (AppDataManager.sharedInstance.arrCategories as? [AnyObject])!)
                    
                    arrCat.append(catName)
                    
                }
                
                let strCat = arrCat.joined(separator: ",")
                
                cell.lblChooseCategory.text = strCat
                
            }
            else if !(dictPostCategories.isEmpty){
                
                var arrSubCatName = [String]()
                
                let array = arrPostCategories as? [AnyObject]
                
                for i in 0..<(array?.count)! {
                    
                    let catName = array![i] as? String
                    
                    let dict = dictPostCategories[catName!] as? [String: Any]
                    
                    let arrChild = dict!["child"] as? [AnyObject]
                    
                    for a in 0..<(arrChild?.count)! {
                        
                        let dictSubCat = arrChild![a] as? [String: Any]
                        
                        let status = dictSubCat!["status"] as? String
                        
                        if status == "1" {
                            
                            let subCatName = dictSubCat!["subCat"] as? String
                            
                            arrSubCatName.append(subCatName!)
                        }
                    }
                    
                    let str = arrSubCatName.joined(separator: ",")
                    
                    cell.lblChooseCategory.text = str
                }
                
            }
            else if arrSelectedCategory.count > 0 {
                
                let categories = arrSelectedCategory.joined(separator: ",")
                
                if categories != "" {
                    
                    cell.lblChooseCategory.text = categories
                }
            }
            
            cell.delegate = self
            
            return cell
            
        }
         else {
            
            print(indexPath.row)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleAddPostCell", for: indexPath) as? ScheduleAddPostCell else {
                fatalError()
            }
            
            cell.selectionStyle = .none
            
            if selectedItem == "" {
                
                cell.vwSchedulePostTime.isHidden = true
                
                cell.viewScheduleforBtn.isHidden = false
                
            }
            else {
                
                cell.vwSchedulePostTime.isHidden = false
                
                cell.viewScheduleforBtn.isHidden = false
                
                cell.lblSchedule.text = selectedItem
                
            }
            
            if selectedDay != "" {
                
                if arrPicker == arrDayPicker {
                    
                    strDay = DayClass.sharedInstance.getDay(index: selectedDay)
                    
                    cell.lblDay.text = strDay
                    
                    
                }
                else if strDay != "" {
                    
                    cell.lblDay.text = strDay
                }
                else {
                    
                    cell.lblDay.text = selectedDay
                }
                
            }
            else {
                
                cell.lblDay.text = "Select"
                
                cell.lblTime.text = "Time"
            }
            
            if selectedTime != "" {
                
                cell.lblTime.text = selectedTime
            }
            if selectedDay != "" {
                
                if arrPicker == arrDayPicker {
                    
                    strDay = DayClass.sharedInstance.getDay(index: selectedDay)
                    
                    cell.lblDay.text = strDay
                }
                else if strDay != "" {
                    
                    cell.lblDay.text = strDay
                }
                else {
                    
                    cell.lblDay.text = selectedDay
                }
            }
            else {
                
                if isTime == true {
                    
                    cell.lblTime.text = "Time"
                }
                else {
                    cell.lblDay.text = "Select"
                    
                }
            }
            
            cell.delegate = self
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            
            return 60
        }
        else if indexPath.section == 3 {
            
            return UITableViewAutomaticDimension
        }
        else {
            
            if imageHeight != 0 {
                
                /*let height = self.imageHeight
                
                return height+20*/
                
                return 20
            }
            else {
                
                return 20
            }
        }
        
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let size = image.size
        
        let widthRatio  = targetSize.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}


//MARK: UIPickerView dataSource and delegate
extension AddPostVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return arrPicker.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
      
        if pickerLabel == nil {
            
            pickerLabel = UILabel()
        
            pickerLabel?.font = UIFont(name: CustomFont.ubuntuRegular.rawValue, size: 17)
            
            pickerLabel?.textAlignment = .center
        }
        
        pickerLabel?.text = arrPicker[row]
        pickerLabel?.textColor = UIColor.black
        
        return pickerLabel!
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerSelectedIndex = row
        
    }
    
}
