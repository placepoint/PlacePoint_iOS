//
//  Extension+BusinessVC.swift
//  PlacePoint
//
//  Created by Mac on 06/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// MARK: - MyPickerView Protocol
extension BusinessVC: MyPickerViewProtocol {
    
    func myPickerDidSelectRow(str: String, btnTag: Int) {
        
        var dictHrs = arrHours[selectedDay!] as! [String: AnyObject]
        
        strStartTimeFrom = dictHrs["startFrom"] as! String
        
        strEndTimeTo = dictHrs["startTo"] as! String
        
        strCloseTimeFrom = dictHrs["closeFrom"] as! String
        
        strCloseTimeTo = dictHrs["closeTo"] as! String
        
        if btnTag == 0 {
            
            footerView.btnOpenFrom.setTitle(str, for: .normal)
            
            self.selectedItem = str
            
            strStartTimeFrom = self.selectedItem!
            
            dictHrs["startFrom"] = str as AnyObject
        }
        else if btnTag == 1 {
            
            footerView.btnOpenTo.setTitle(str, for: .normal)
            
            self.selectedItem = str
            
            strEndTimeTo = self.selectedItem!
            
            dictHrs["startTo"] = str as AnyObject
        }
        else if btnTag == 2 {
            
            footerView.btnClosingFrom.setTitle(str, for: .normal)
            
            self.selectedItem = str
            
            strCloseTimeFrom = self.selectedItem!
            
            dictHrs["closeFrom"] = str as AnyObject
        }
        if btnTag == 3 {
            
            footerView.btnClosingTo.setTitle(str, for: .normal)
            
            self.selectedItem = str
            
            strCloseTimeTo = self.selectedItem!
            
            dictHrs["closeTo"] = str as AnyObject
        }
        
        arrHours[selectedDay!] = dictHrs as AnyObject
        
        self.checkIfClosed(startTime: strStartTimeFrom, endTime: strEndTimeTo, closeTimeFrom: strCloseTimeFrom, closeTimeTo: strCloseTimeTo)
    }
}


//MARK: - Protocol showImagePicker and OpenPhotos
extension BusinessVC: ShowImagePicker, OpenPhotos {
    
    func showpremiumPopUp() {
        
        popUpPremiumView = Bundle.main.loadNibNamed("PopUpPremium", owner: nil, options: nil)?[0] as! PopUpPremium
        
        popUpPremiumView.frame = self.tblBusinessDetails.frame
        
        self.tblBusinessDetails.isHidden = true
        
        popUpPremiumView.delegate = self
        
        self.view.addSubview(popUpPremiumView)
        
    }
    
    
    func collectionHaveNoImage() {
        
        tblBusinessDetails.reloadData()
    }
    
    
    func openYoutube() {
        
        isYoutubeBtnSelected = true
        
        tblBusinessDetails.reloadData()
    }
    
    
    func openCameraPhoto() {
        
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        
        fusuma.islibrary = false
        
        fusuma.allowMultipleSelection = true
        
        fusumaSavesImage = true
        
        fusuma.modalPresentationStyle = .custom
        
        self.present(fusuma, animated: true, completion: nil)
        
    }
    
    
    func openYouTube() {
        
        tblBusinessDetails.reloadData()
        
    }
    
    
    func openLibrary() {
        
        self.isGalleryFirstSelected = true
        
        // Show Fusuma
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        
        fusuma.allowMultipleSelection = true
        
        fusumaSavesImage = true
        
        fusuma.modalPresentationStyle = .custom
        
        self.present(fusuma, animated: true, completion: nil)
        
    }
    
    
    func showImagePicker() {
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free"{
            
            popUpPremiumView = Bundle.main.loadNibNamed("PopUpPremium", owner: nil, options: nil)?[0] as! PopUpPremium
            
            popUpPremiumView.frame = self.tblBusinessDetails.frame
            
            self.tblBusinessDetails.isHidden = true
            
            popUpPremiumView.delegate = self
            
            self.view.addSubview(popUpPremiumView)
            
        }
        else {
            
            self.showActionSheetForImageCropper(vc: self)
            
        }
        
    }
    
    func showPopUp() {
        
        popUpPremiumView = Bundle.main.loadNibNamed("PopUpPremium", owner: nil, options: nil)?[0] as! PopUpPremium
        
        popUpPremiumView.frame = self.tblBusinessDetails.frame
        
        self.tblBusinessDetails.isHidden = true
        
        popUpPremiumView.delegate = self
        
        self.view.addSubview(popUpPremiumView)
        
    }
    
}


//MARK: - Protocol SelectedAddress
extension BusinessVC: SelectedAddress {
    
    func addressSelected(address: String, lat: CLLocationDegrees, long: CLLocationDegrees) {
        
        self.latitude = lat
        
        self.longitude = long
        
        footerView.lblAddress.text = address
      
    }
}

//MARK: - Protocol FusumaDelegate
extension BusinessVC: FusumaDelegate {
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        switch source {
            
        case .camera:
            
            print("Image captured from Camera")
            
        case .library:
            
            print("Image selected from Camera Roll")
            
        default:
            
            print("Image selected")
        }
        
        selectedImages.append(image)
        
//        self.dismiss(animated: true, completion: nil)
        
        let imageVc = ImageCropperView(nibName: "ImageCropperView", bundle: nil)
        
        imageVc.selectedImages = selectedImages
        
        imageVc.modalPresentationStyle = .custom
        
        self.present(imageVc, animated: true, completion: nil)
        
    }
    
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
        selectedImages = images
        
//        self.dismiss(animated: true, completion: nil)
//
        let imageVc = ImageCropperView(nibName: "ImageCropperView", bundle: nil)
        
        imageVc.selectedImages = selectedImages
        
        imageVc.modalPresentationStyle = .custom
        
        self.present(imageVc, animated: true, completion: nil)
    }
    
    
    func fusumaCameraRollUnauthorized() {
        
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
            
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                
                UIApplication.shared.openURL(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        })
        
        guard let vcRoot = UIApplication.shared.delegate?.window??.rootViewController,
            
            let presented = vcRoot.presentedViewController else {
                
                return
        }
        
        presented.present(alert, animated: true, completion: nil)
    }
    
    
    func fusumaClosed() {
        
        print("Called when the FusumaViewController disappeared")
    }
    
    
    func fusumaWillClosed() {
        
        noImage = true
        
        print("Called when the close button is pressed")
    }
    
}
extension BusinessVC: UpgradePlan {
    
    func upgradeSubPlan() {
        
        isBusinessVc = true
        
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
        
        nav.modalPresentationStyle = .custom
        
        self.navigationController?.present(nav, animated: true, completion: nil)
        
        
    }
}
