//
//  ForgotPasswordVc.swift
//  PlacePoint
//
//  Created by Mac on 05/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordVc: UIViewController {
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        txtFieldEmail.delegate = self
        
        self.keyBoardNotify()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.first != nil{
            
            self.view.endEditing( true)
        }
        
    }
    
    
    // MARK: - KeyBoard Delegates
    func keyBoardNotify() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // MARK: - KeyBoardNotify
    @objc  func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0 {
                
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
            
            self.view.frame.origin.y = 0
        }
    }
    
    
    //MARK: - Api Register
    func apiForgotPassword()  {
        
        SVProgressHUD.show()
        
        var params = [String: String]()
        
        params["email"] = txtFieldEmail.text?.trim()
        
        params["auth_code"] = UserDefaults.standard.getAuthCode()
        
        AppDataManager.sharedInstance.dictParams = params as! [String : String]
        
        AppDataManager.sharedInstance.apiForgotPass(completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
                let strStatus = dictResponse["status"] as? String
                
                let strMsg = dictResponse["msg"] as? String
                
                if strStatus == "true" {
                    
                    self.view.endEditing(true)
                    
                    let alert = UIAlertController(title: "",message: strMsg,preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else  {
                    
                    let alert = UIAlertController(title: "",message: strMsg,preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            }
            
        }, failure: { (errorCode) in
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
        })
    }
    
    //MARK: - UIActions
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        self.apiForgotPassword()
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: UITextField Delegate
extension ForgotPasswordVc: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}
