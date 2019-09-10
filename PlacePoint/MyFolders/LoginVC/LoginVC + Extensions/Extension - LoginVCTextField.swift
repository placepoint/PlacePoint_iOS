//
//  Extension - LoginVCTextField.swift
//  PlacePoint
//
//  Created by Mac on 28/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

//MARK: TextField Delegate
extension LoginVC: UITextFieldDelegate {
    
    // MARK: - KeyBoard Delegates
    func keyBoardNotify() {
        
        index = IndexPath(row: 0, section: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // keyboardWillShow
    @objc func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y = -90
    }
    
    
    // keyboardWillHide
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y = 0
    }
    
    
    func indexPath(txtField: UITextField) -> IndexPath {
        
        let cell = txtField.superview?.superview
        
        return (tableViewLogin.indexPath(for: (cell as? RegisterCell)!) as IndexPath?)!
    }
    
    
    // MARK: - TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        index = self.indexPath(txtField: textField)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == .done {
            
            textField.resignFirstResponder()
        }
        else {
            
            let nextTage = textField.tag + 1
            
            let nextResponder = textField.superview?.superview?.superview?.superview?.viewWithTag(nextTage) as UIResponder?
            
            if (nextResponder != nil) {
                
                nextResponder?.becomeFirstResponder()
            }
        }
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
            
        case 0:
            
            guard (textField.text?.isValidEmail())! else {
                
                let alert = UIAlertController(title: ValidAlertTitle.EnterValidEmail,message: ValidAlertMsg.EnterValidEmail,preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    
//                    self.dismiss(animated: true, completion: nil)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
//                appDelegate?.window?.rootViewController?.showAlert(withTitle: ValidAlertTitle.EnterValidEmail, message: ValidAlertMsg.EnterValidEmail)
                
                return
            }
            
            dictLoginDetails["email"] = textField.text?.trim()
            
        case 1:
            
            dictLoginDetails["password"] = textField.text?.trim()
            
        default:
            break
        }
    }
}
