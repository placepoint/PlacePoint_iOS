//
//  Extesion+ShowBusinessTime.swift
//  PlacePoint
//
//  Created by Mac on 04/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

// MARK : - ShowTimePicker Protocol
extension BusinessVC: showTimePicker {
    func getContactNumber(str: String) {
        print("ContactNumber")
    }
    
    
    func upgradePlanPopUp() {
        
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
    
    
    func showPopUpPremView() {
        
        popUpPremiumView = Bundle.main.loadNibNamed("PopUpPremium", owner: nil, options: nil)?[0] as! PopUpPremium
        
        popUpPremiumView.frame = self.tblBusinessDetails.frame
        
        self.tblBusinessDetails.isHidden = true
        
        popUpPremiumView.delegate = self
        
        self.view.addSubview(popUpPremiumView)
        
    }
    
    
    
//    func checkClosingHours(closeHour: Bool?) {
//        
//        if closeHour == true {
//            
//            selectCloseHours = true
//            
//            self.setHoursData()
//            
//            footerView.btnClosingFrom.setTitle("12:00 AM", for: .normal)
//            
//            footerView.btnClosingTo.setTitle("12:00 AM", for: .normal)
//            
//            footerView.btnClosingFrom.alpha = 0.6
//            
//            footerView.btnClosingTo.alpha = 0.6
//        }
//        else {
//            
//            selectCloseHours = false
//            
//            var dictWeekDetails = [String: String]()
//            
//            if let strStartTime1 = footerView.btnOpenFrom.titleLabel?.text {
//                
//                dictWeekDetails["startFrom"] = strStartTime1
//                
//            }
//            if let strEndTime1 = footerView.btnOpenTo.titleLabel?.text {
//                
//                dictWeekDetails["startTo"] = strEndTime1
//                
//            }
//            
//            dictWeekDetails["closeFrom"] = "12:00 AM"
//            
//            dictWeekDetails["closeTo"] = "12:00 AM"
//            
//            dictWeekDetails["status"] = "false"
//            
//            dictWeekDetails["closeStatus"] = "false"
//            
//            
//            arrHours[selectedDay!] = dictWeekDetails as AnyObject
//            
//        }
//    }
    
    
    func checkClosedDay(dayClose: Bool?) {
        
        if dayClose == true {
            
            selectCloseDay = true
            
            self.setHoursData()
            
            footerView.btnOpenFrom.setTitle("12:00 AM", for: .normal)
            
            footerView.btnOpenTo.setTitle("12:00 AM", for: .normal)
            
            footerView.btnClosingFrom.setTitle("12:00 AM", for: .normal)
            
            footerView.btnClosingTo.setTitle("12:00 AM", for: .normal)
            
            footerView.btnOpenFrom.alpha = 0.6
            
            footerView.btnOpenTo.alpha = 0.6
            
            footerView.btnClosingFrom.alpha = 0.6
            
            footerView.btnClosingTo.alpha = 0.6
            
        }
        else {
            
            selectCloseDay = false
            
            let dict = self.setDefaultTime()
            
            arrHours[selectedDay!] = dict as AnyObject
        }
        
        self.setJsonString()
    }
    
    
//    func getContactNumber(str:String)  {
//
//        dictCreatedBusiness["contact_no"] = str
//    }
    

    
    func openMap() {
        
        self.view.endEditing(true)
        
        let addressVc = BuisnessAddressVC(nibName: "BuisnessAddressVC", bundle: nil)
        
        addressVc.delegate = self
        
        let nav = UINavigationController(rootViewController: addressVc)
        
        nav.modalPresentationStyle = .custom
        
        nav.modalPresentationCapturesStatusBarAppearance = true
        
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    
    func applyTimeToAll(isApply: Bool) {
        
        let arrOldHours = arrHours
        
        if isApply == true {
            
            let alert = UIAlertController(title: "",message: "Are you sure you want to apply this time to all days?",preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                
                UserDefaults.standard.setApplyToAll(isApply: true)
                
                self.setSameTime(arr: self.arrHours)
        
              
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
                self.footerView.btnApplyAll.setImage(#imageLiteral(resourceName: "checkApplyAll"), for: .normal)
                
                self.setSameTime(arr: arrOldHours)
                

            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            
            UserDefaults.standard.setApplyToAll(isApply: false)
            
            self.setSameTime(arr: arrOldHours)
            
            
        }
        
    }
    
    func setSameTime(arr: [AnyObject]) {
        
        var arrHourSelected = arr
        
        let dict = arrHourSelected[selectedDay!] as? [String: Any]
        
        for i in 0..<arr.count {
            
            arrHourSelected[i] = dict as AnyObject
            
            footerView.btnOpenFrom.setTitle(dict!["startFrom"] as? String, for: .normal)
            
            footerView.btnOpenTo.setTitle(dict!["startTo"] as? String, for: .normal)
            
            footerView.btnClosingTo.setTitle(dict!["closeTo"] as? String, for: .normal)
            
            footerView.btnClosingFrom.setTitle(dict!["closeFrom"] as? String, for: .normal)
            
            footerView.btnClosingTo.setTitle(dict!["closeTo"] as? String, for: .normal)
            
            self.arrHours = arrHourSelected
            
        }
    }
    
    
    func selectWeekDay(tag: Int?) {
        
        strStartTimeFrom = ""
        
        strEndTimeTo = ""
        
        strCloseTimeTo = ""
        
        strCloseTimeFrom = ""
        
        selectedDay = tag
        
        let strTime = arrHours[selectedDay!]["status"] as? String
        
        if strTime == "true" {
            
            footerView.btnClosed.setBackgroundImage( #imageLiteral(resourceName: "iconClosed"), for: .normal)
            
            footerView.btnOpenFrom.isUserInteractionEnabled = false
            
            footerView.btnOpenTo.isUserInteractionEnabled = false
            
            footerView.btnClosingFrom.isUserInteractionEnabled = false
            
            footerView.btnClosingTo.isUserInteractionEnabled = false
            
            footerView.btnOpenFrom.alpha = 0.6
            
            footerView.btnOpenTo.alpha = 0.6
            
            footerView.btnClosingFrom.alpha = 0.6
            
            footerView.btnClosingTo.alpha = 0.6
            
            footerView.btnClosed.tag = 9
            
            selectCloseDay = true
            
            footerView.btnOpenFrom.setTitle("12:00 AM", for: .normal)
            
            footerView.btnOpenTo.setTitle("12:00 AM", for: .normal)
            
            footerView.btnClosingFrom.setTitle("12:00 AM", for: .normal)
            
            footerView.btnClosingTo.setTitle("12:00 AM", for: .normal)
            
        }
        else {
            
            let dict =  arrHours[selectedDay!] as! [String: AnyObject]
            
            footerView.btnOpenFrom.setTitle(dict["startFrom"] as? String, for: .normal)
            
            footerView.btnOpenTo.setTitle(dict["startTo"] as? String, for: .normal)
            
            if dict["closeStatus"] as! String == "true" {
                
                footerView.btnClosingFrom.alpha = 0.6
                
                footerView.btnClosingFrom.isUserInteractionEnabled = false
                
                footerView.btnClosingFrom.setTitle(dict["closeFrom"] as? String, for: .normal)
                
                if dict["closeStatus"] as! String == "true" {
                    
                    footerView.btnClosingTo.alpha = 0.6
                    
                    footerView.btnClosingTo.isUserInteractionEnabled = false
                    
                    footerView.btnClosingTo.setTitle(dict["closeTo"] as? String, for: .normal)
                    
                }
            }
            else {
                
                footerView.btnClosingFrom.setTitle(dict["closeFrom"] as? String, for: .normal)
                
                footerView.btnClosingTo.setTitle(dict["closeTo"] as? String, for: .normal)
            }
            
            selectCloseDay = false
        }
        
    }
    
    
    //MARK: - openingHoursValidation
    func checkChosingOpeningHoursValidation() -> Bool {
        
        let chkAllDaysSelected =  self.checkforOpeningHours()
        
        if chkAllDaysSelected == false {
            
            let dayNotSet = self.getDayFromIndex(index: self.selectedDayToCheckOpen)
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "OpenFrom and OpenTo cannot be same on \(dayNotSet)")
            
            return false
        }
        else {
            
            return true
        }
    }
    
    
    //MARK: - closingHoursValidation
    func checkChosingClosingHoursValidation() -> Bool {
        
        let chkAllCloseDaysSelected =  self.checkforClosingHours()
        
        let dayNotSet = self.getDayFromIndex(index: self.selectedDayToCheckOpen)
        
        if chkAllCloseDaysSelected == false {
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            appDelegate?.window?.rootViewController?.showAlert(withTitle: "", message: "CloseFrom and CloseTo cannot be same on \(dayNotSet)")
            
            return false
            
        }
        else {
            
            return true
        }
    }
    
    
    func setHoursData()  {
        
        var dictWeekDetails = [String: String]()
        
        if selectCloseDay == true {
            
            dictWeekDetails["startFrom"] = "12:00 AM"
            
            dictWeekDetails["startTo"] = "12:00 AM"
            
            dictWeekDetails["closeFrom"] = "12:00 AM"
            
            dictWeekDetails["closeTo"] = "12:00 AM"
            
            dictWeekDetails["status"] = "true"
            
            dictWeekDetails["closeStatus"] = "true"
            
            arrHours[selectedDay!] = dictWeekDetails as AnyObject
        }
        else if selectCloseHours == true {
            
            if let strStartTime1 = footerView.btnOpenFrom.titleLabel?.text {
                
                dictWeekDetails["startFrom"] = strStartTime1
                
            }
            if let strEndTime1 = footerView.btnOpenTo.titleLabel?.text {
                
                dictWeekDetails["startTo"] = strEndTime1
                
            }
            if strCloseTimeFrom == "" && strCloseTimeTo == "" {
                
                dictWeekDetails["closeFrom"] = "12:00 AM"
                
                dictWeekDetails["closeTo"] = "12:00 AM"
            }
            else {
                
                dictWeekDetails["closeFrom"] = strCloseTimeFrom
                
                dictWeekDetails["closeTo"] = strCloseTimeTo
            }
            
            dictWeekDetails["status"] = "false"
            
            dictWeekDetails["closeStatus"] = "true"
            
            arrHours[selectedDay!] = dictWeekDetails as AnyObject
        }
        else {
            
            dictWeekDetails["startFrom"] = strStartTimeFrom
            
            dictWeekDetails["startTo"] = strEndTimeTo
            
            dictWeekDetails["closeFrom"] = strCloseTimeFrom
            
            dictWeekDetails["closeTo"] = strCloseTimeTo
            
            dictWeekDetails["status"] = "false"
            
            dictWeekDetails["closeStatus"] = "false"
            
            arrHours[selectedDay!] = dictWeekDetails as AnyObject
        }
        
        self.setJsonString()
    }
    
    
    //MARK: - Array into Json
    func setJsonString()  {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arrHours, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                
                closingHoursString = JSONString
            
            }
        }
        catch _ {
            
            print ("UH OOO")
        }
    }
    
    
    func selectTime(selectedBtn: Int) {
        
        self.view.endEditing(true)
        
        let viewPicker = self.loadNibNamed(nibName:"PickerViewList") as! PickerViewList
        
        if selectedBtn == 0 {
            
            viewPicker.loadPickerView(btntagId: selectedBtn, parentVC: self, btnText: (footerView.btnOpenFrom.titleLabel?.text)!)
            
        }
        else if selectedBtn == 1 {
            
            viewPicker.loadPickerView(btntagId: selectedBtn, parentVC: self, btnText: (footerView.btnOpenTo.titleLabel?.text)!)
            
        }
        else if selectedBtn == 2 {
            
            viewPicker.loadPickerView(btntagId: selectedBtn, parentVC: self, btnText: (footerView.btnClosingFrom.titleLabel?.text)!)
        }
        else if selectedBtn == 3 {
            
            viewPicker.loadPickerView(btntagId: selectedBtn, parentVC: self, btnText: (footerView.btnClosingTo.titleLabel?.text)!)
        }
        
        viewPicker.delegate = self
    }
    
    
    // MARK: - NIB Load And Remove
    func removeViewPicker() -> Void {
        
        for view in self.view.subviews {
            
            view.removeFromSuperview()
        }
    }
    
    func loadNibNamed(nibName:String) -> UIView {
        
        let arr : NSArray = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)! as NSArray
        
        let view = arr.object(at: 0) as! UIView
        
        return view
    }
}

