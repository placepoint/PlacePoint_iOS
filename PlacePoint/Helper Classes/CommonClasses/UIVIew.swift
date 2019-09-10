//
//  UIView.swift
//  Citify App
//
//  Created by MRoot on 24/10/18.
//  Copyright © 2018 MRoot. All rights reserved.
//

import Foundation
import UIKit


//extension UITextField {
//
//    @IBInspectable var doneAccessory: Bool{
//        get{
//            return self.doneAccessory
//        }
//        set (hasDone) {
//            if hasDone{
//                addDoneButtonOnKeyboard()
//            }
//        }
//    }
//
//    func addDoneButtonOnKeyboard() {
//
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//
//        doneToolbar.barStyle = .default
//
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
//
//        let items = [flexSpace, done]
//
//        doneToolbar.items = items
//
//        doneToolbar.sizeToFit()
//
//        self.inputAccessoryView = doneToolbar
//    }
//
//    @objc func doneButtonAction() {
//
//        self.resignFirstResponder()
//    }
//
//}

extension String {
    
//    func isValidEmail() -> Bool {
//
//        let stricterFilter: Bool = true
//
//        let stricterFilterString: String = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
//
//        let laxString: String = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
//
//        let emailRegex: String = stricterFilter ? stricterFilterString : laxString
//
//        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//
//        return emailTest.evaluate(with: self)
//    }
}

extension UIView {
    
    func dropShadow(scale: Bool = true) {

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 5.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 1.0
        layer.masksToBounds = false
    }
    
    
    func shadow() {
        
        // * Set masks bounds to NO to display shadow visible *
        self.layer.masksToBounds = false;
        // * Set light gray color as shown in sample *
        self.layer.shadowColor = UIColor.gray.cgColor;
        // * * Use following to add Shadow top, left ***
        //        self.viewCell.layer.shadowOffset = CGSize(width: -5.0, height: -5.0) // CGSizeMake(-5.0, -5.0);
        
        // * Use following to add Shadow bottom, right *
        //self.avatarImageView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
        
        // * Use following to add Shadow top, left, bottom, right *
        self.layer.shadowOffset = CGSize.zero;
        self.layer.shadowRadius = 3.0;
        
        // * Set shadowOpacity to full (1) *
        self.layer.shadowOpacity = 0.35;
    }
    
    func setShadowBottom() -> Void {
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 8.0
    }
    
    func setShadowBottomImage() -> Void {
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize.zero;
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize.zero;
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 12.0
    }

    
    @IBInspectable var borderColor: UIColor? {
        get { return layer.borderColor.map(UIColor.init) }
        set { layer.borderColor = newValue?.cgColor }
    }
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
}
