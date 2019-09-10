//
//  Extension - PickerView.swift
//  PlacePoint
//
//  Created by Mac on 29/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

//MARK: - PickerView DataSource and Delegate
extension RegisterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setUpPicker() -> Void {
        
        textField = UITextField(frame: .zero)
        
        self.view.addSubview(textField)
        
        picker.backgroundColor = UIColor.white
        
        textField.inputView = picker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
        
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                   target: self, action: #selector(RegisterVC.donePressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton,item], animated: false)
        
        toolbar.barTintColor = UIColor.themeColor()
        
        toolbar.tintColor = UIColor.white
        
        toolbar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolbar
    }
    
    
    @objc func pressButton(button: UIButton) {
        
        if button.tag == 4 {
            
            if selectedPlan == "" {
                
                let alert = UIAlertController(title: "",message: "Please Select type of Business first ",preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    
                }))
                
                alert.modalPresentationStyle = .custom
                
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                
                let indexPath = IndexPath(row: 4, section: 0)
                
                let cell = tableViewRegister.cellForRow(at: indexPath) as!RegisterCell
                
                var cellString = cell.btnPicker.titleLabel?.text
                
                cell.btnDropDown.setImage(#imageLiteral(resourceName: "dropDown"), for: .normal)
                
                var arrSelectedCat = [String]()
                
                if !(cellString?.isEmpty)!  {
                    
                    if cellString != "Select Category" {
                        
                        arrSelectedCat = (cellString?.components(separatedBy: ","))!
                    }
                }
                
                let selectCat = SelectCategories(nibName: "SelectCategories", bundle: nil)
                
                selectCat.delegate = self as SelectedCategories
                
                selectCat.isRegisterVc = true
                
                let nav = UINavigationController(rootViewController: selectCat)
                
                self.present(nav, animated: true, completion: nil)
                
                picker.delegate = self
                
                picker.dataSource = self
                
                picker.isHidden = false
                
                self.view.endEditing(true)
                
                textField.tintColor = UIColor.clear
                
                textField.resignFirstResponder()
                
            }
        }
        else {
            
            self.arrTowns.removeAll()
            
            if selectedPlan == "" {
                
                let alert = UIAlertController(title: "",message: "Please Select type of Business first ",preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    
                }))
                
                alert.modalPresentationStyle = .custom
                
                self.present(alert, animated: true, completion: nil)
                
                
            }
            else {
                AppDataManager.sharedInstance.getAppData(completionHandler: { (dictResponse) in
                    
                    let strStatus = dictResponse["status"] as? String
                    
                    if strStatus == "true" {
                        
                        if self.arrTowns.count == 0 {
                            
                            let arrNotSortedTown = dictResponse["location"] as? NSArray
                            
                            let descriptorTown: NSSortDescriptor = NSSortDescriptor(key: "townname", ascending: true)
                            
                            let sortedTown: NSArray = arrNotSortedTown!.sortedArray(using: [descriptorTown]) as NSArray
                            
                            self.arrTowns = sortedTown as [AnyObject]
                            
                            DispatchQueue.main.async {
                                
                                self.picker.delegate = self
                                
                                self.picker.dataSource = self
                                
                                self.picker.isHidden = false
                                
                                self.view.endEditing(true)
                                
                                self.textField.becomeFirstResponder()
                                
                            }
                            
                        }
                    }
                    else {
                        
                        print("No Data")
                    }
                    
                }, failure: { (errorCode) in
                    
                     return
                })
                
            }
        }
    }
    
    
    // MARK: PickerView Delegate and DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return arrTowns.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        strSelectedLocation =  arrTowns[row]["townname"] as? String
        
        return strSelectedLocation
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        strSelectedLocation =  arrTowns[row]["townname"] as? String
    }
    
    
    // MARK: Add ToolBar
    func addToolBar(pickerView: UIPickerView) {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        
        toolBar.isTranslucent = true
        
        toolBar.barTintColor = UIColor.themeColor()
        
        toolBar.tintColor = UIColor.white
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePressed))
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        
        toolBar.sizeToFit()
        
        pickerView.addSubview(toolBar)
    }
    
    
    @objc func donePressed() {
        
        let indexPath = IndexPath(row: 3, section: 0)
        
        let cell = tableViewRegister.cellForRow(at: indexPath) as! RegisterCell
        
        cell.btnPicker.setTitle(strSelectedLocation, for: .normal)
        
        self.view.frame.origin.y = 0
        
        view.endEditing(true)
        
    }
    
    
    @objc func cancelPressed() {
        
        view.endEditing(true)
    }
}

