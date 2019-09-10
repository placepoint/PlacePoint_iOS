//
//  Extension+PickerDelegate.swift
//  PlacePoint
//
//  Created by Mac on 19/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

// MARK: - PickerView Delegate and DataSource
extension BusinessVC: UIPickerViewDelegate, UIPickerViewDataSource, ViewDropDownListDelegates {
    
    func popMultiSelection( strSelectedCat: String) -> Void {
        
//        isAddPost = false
        
        self.setUpView()
        
        var arrSelectedCat = [String]()
        
        if !strSelectedCat.isEmpty {
            
            arrSelectedCat = strSelectedCat.components(separatedBy: ",")
        }
        
        
        let selectCat = SelectCategories(nibName: "SelectCategories", bundle: nil)
        
        selectCat.delegate = self
        
//         isAddPost = false
        
        let cat = UserDefaults.standard.getSelectedCategory()
        
        selectedcategories = [cat]
            
        selectCat.isPostVc = true

        let nav = UINavigationController(rootViewController: selectCat)
        
        nav.modalPresentationStyle = .custom
        
        self.navigationController?.present(nav, animated: true, completion: nil)
        
    }
    
    
    //MARK: - DropDown
    func openDropDownList(title: String, isMultiSelect: Bool, arrList: [String], arrSelected: [String]?) -> Void {
        
        dropDownViewObj =  Bundle.main.loadNibNamed("ViewDropDownList", owner: nil, options: nil)?[0] as! ViewDropDownList
        
        dropDownViewObj.delegate = self
        
        if isMultiSelect == false {
            
            dropDownViewObj.setList(title: title, list: arrList, arrSelecedList: arrSelected, isCornerRaduis: true, isMultipleSelection: isMultiSelect)
        }
        else {
            
            dropDownViewObj.setList(title: title, list: arrList, arrSelecedList: arrSelected, isCornerRaduis: true, isMultipleSelection: isMultiSelect)
        }
        
        dropDownViewObj.setFrame(startPoints: CGPoint(x: 0, y: 0), size: CGSize(width: DeviceInfo.TheCurrentDeviceWidth, height: self.view.frame.size.height))
        
        self.view.addSubview(dropDownViewObj)
    }
    
    
    func cancelDropDownList() {
        
        dropDownViewObj.removeFromSuperview()
        
        dropDownViewObj = nil
    }
    
    
    func doneDropDownList(arrList: [String], arrSelecedIndex: [Int], isMultiSelection: Bool) {
        
        self.cancelDropDownList()
    }
    
    
    func doneDropDownList(arrList:[String], isMultiSelection: Bool) {
        
        if !arrList.isEmpty {
            
            footerView.txtFieldCategory.text = arrList.joined(separator: ",")
            
            UserDefaults.standard.selectedCategory(value: footerView.txtFieldCategory.text!)
        }
        else {
            
            footerView.txtFieldCategory.text = ""
            
            UserDefaults.standard.selectedCategory(value: footerView.txtFieldCategory.text!)
        }
        
        self.cancelDropDownList()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return arrPicker.count
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.selectedItem = arrPicker[row]
        
        return arrPicker[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectedItem = arrPicker[row]
    }
}


// MARK: - TextField Delegate
extension BusinessVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
            
        case 101:
            
            UserDefaults.standard.setBusinessName(value: textField.text!.trim())
            
//        case 102:
//            
//            dictCreatedBusiness["contact_no"] = textField.text?.trim()
            
        case 1000:
            
            dictCreatedBusiness["video_link"] = textField.text?.trim()
            
        default:
            
            break
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 1 || textField.tag == 2{
            
            if textField.tag == 1 {
                
                let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
                
                if selectedBusinessType == "Free"{
                    
                    popUpPremiumView = Bundle.main.loadNibNamed("PopUpPremium", owner: nil, options: nil)?[0] as! PopUpPremium
                    
                    popUpPremiumView.frame = self.tblBusinessDetails.frame
                    
                    self.tblBusinessDetails.isHidden = true
                    
                    popUpPremiumView.delegate = self
                    
                    self.view.addSubview(popUpPremiumView)
                    
                    textField.resignFirstResponder()
                    
                }
                else {
                    selectedDropIndex = 1
                    
                    arrPicker = arrTown as! [String]
                    
                    pickerTextFld = textField
                    
                    self.setUpPickerView()
                }
            }
            else if textField.tag == 2 {
                
                let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
                
                if selectedBusinessType == "Free"{
                    
                    
                    popUpPremiumView = Bundle.main.loadNibNamed("PopUpPremium", owner: nil, options: nil)?[0] as! PopUpPremium
                    
                    popUpPremiumView.frame = self.tblBusinessDetails.frame
                    
                    self.tblBusinessDetails.isHidden = true
                    
                    popUpPremiumView.delegate = self
                    
                    self.view.addSubview(popUpPremiumView)
                    
                    textField.resignFirstResponder()
                    
                }
                else {
                    
                    if self.isSavedPressed == false {
                        
                        textField.resignFirstResponder()
                        
                        self.popMultiSelection(strSelectedCat: textField.text!.trim())
                        
                    }
                }
               
            }
            else {
                
                selectedDropIndex = 2
                
                arrPicker = arrCat
                
                pickerTextFld = textField
                
                self.setUpPickerView()
            }
        }
        else {
            
            pickerView.isHidden = true
            toolBar.isHidden = true
        }
        
    }
    
    
    // MARK: - KeyBoard Notification
    func keyBoardNotify() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(BusinessVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BusinessVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // keyboardWillShow
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + 60, 0.0)
            
            tblBusinessDetails.contentInset = contentInsets
        }
    }
    
    
    // keyboardWillHide
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            
            let contentInset: UIEdgeInsets = .zero
            
            tblBusinessDetails.contentInset = contentInset
        }
    }
}


