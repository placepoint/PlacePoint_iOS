//
//  Extension - TextField.swift
//  PlacePoint
//
//  Created by Mac on 28/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

//MARK: TextField Delegate
extension RegisterVC: UITextFieldDelegate {
    
    // MARK: - KeyBoard Delegates
    func keyBoardNotify() {
        
        index = IndexPath(row: 0, section: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // keyboardWillShow
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + 60, 0.0)
            
            tableViewRegister.contentInset = contentInsets
        }
    }
    
    
    // keyboardWillHide
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            
            let contentInset: UIEdgeInsets = .zero
            
            tableViewRegister.contentInset = contentInset
        }
    }
    
    
    func indexPath(txtField: UITextField) -> IndexPath {
        
        let cell = txtField.superview?.superview
        
        return (tableViewRegister.indexPath(for: (cell as? RegisterCell)!) as IndexPath?)!
        
    }
    
    
    // MARK: - TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if selectedPlan == "" {
            
            let alert = UIAlertController(title: "",message: "Please Select type of Business first ",preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                
            }))
            
            alert.modalPresentationStyle = .custom
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            
            picker.isHidden = true
            
            self.view.frame.origin.y = 0
            
            if textField.tag != 100 {
                
                index = self.indexPath(txtField: textField)
                
            }
            
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtFieldCoupon {
            
            if selectedPlan != "" {
                
                self.apiApplyCoupon()
                
                textField.resignFirstResponder()
            }
            else {
                
                let alert = UIAlertController(title: "",message: "Please Select type of Business first ",preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    
                }))
                
                alert.modalPresentationStyle = .custom
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else if textField.returnKeyType == .done {
            
            textField.resignFirstResponder()
            
        }
        else {
            
            let nextTage = textField.tag + 1
            
            let nextResponder = textField.superview?.superview?.superview?.superview?.viewWithTag(nextTage) as UIResponder?
            
            if nextResponder != nil {
                
                nextResponder?.becomeFirstResponder()
            }
        }
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
            
        case 0:
            
            guard !((textField.text?.isEmpty)!)  else {
                
                let alert = UIAlertController(title: ValidAlertTitle.Error,message: "Please Enter Email",preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    
                }))
                alert.modalPresentationStyle = .custom
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            guard (textField.text?.isValidEmail())! else {
                
                let alert = UIAlertController(title: ValidAlertTitle.EnterValidEmail,message: ValidAlertMsg.EnterValidEmail,preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    
                }))
                
                alert.modalPresentationStyle = .custom
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            dictRegisterDetails["email"] = textField.text?.trim()
            
        case 1:
            
            dictRegisterDetails["password"] = textField.text?.trim()
            
        case 2:
            
            dictRegisterDetails["buisneessName"] = textField.text?.trim()
            
        case 100:
            
            if selectedPlan != "" {
                
                self.apiApplyCoupon()
            }
            
        default:
            break
        }
    }
}
