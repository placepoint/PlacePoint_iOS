
import UIKit
import SVProgressHUD

class UpdatePasswordVC: UIViewController {
    
    @IBOutlet weak var txtFieldCurrentPass: UITextField!
    
    @IBOutlet weak var txtFieldNewPass: UITextField!
    
    @IBOutlet weak var txtFieldConfirmPass: UITextField!
    
    var dict = [String: String]()
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        dict["currentPass"] = ""
        
        dict["newPass"] = ""
        
        dict["confirmPass"] = ""
        
        txtFieldNewPass.delegate = self
        
        txtFieldConfirmPass.delegate = self
        
        txtFieldCurrentPass.delegate = self
        
        self.keyBoardNotify()
        
        self.txtFieldCurrentPass.attributedPlaceholder = NSAttributedString(string: "Current Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeHolderTextColor()])
        
        self.txtFieldNewPass.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeHolderTextColor()])
        
        self.txtFieldConfirmPass.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeHolderTextColor()])
        
    }
    
    
    // MARK: - KeyBoard Delegates
    func keyBoardNotify() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // keyboardWillShow
    @objc func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y = -90
    }
    
    
    // keyboardWillHide
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y = 0
    }
    
    
    //MARK: - UIActions
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        //appDelegate?.centerContainer?.closeDrawer(animated: true, completion: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Api updatePassword
    func apiUpdatePassword()  {
        
        SVProgressHUD.show()
        
        var params = [String: String]()
        
        params["auth_code"] = UserDefaults.standard.getAuthCode()
        
        params["old_password"] = dict["currentPass"]
        
        params["new_password"] = dict["newPass"]
        
        AppDataManager.sharedInstance.dictParams = params
        
        AppDataManager.sharedInstance.apiUpdatePass(completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
                let strStatus = dictResponse["status"] as? String
                
                if strStatus == "true" {
                    
                    self.view.endEditing(true)
                    
                    let strMsg = dictResponse["msg"] as? String
                    
                    let alert = UIAlertController(title: "",message: strMsg,preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                        
                       self.dismiss(animated: true, completion: nil)
                        
                       // self.appDelegate?.centerContainer?.closeDrawer(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else if strStatus == "false" {
                    
                    self.view.endEditing(true)
                    
                    let strMsg = dictResponse["msg"] as? String
                    
                    let alert = UIAlertController(title: "",message: strMsg,preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }, failure: { (errorCode) in
            
            DispatchQueue.main.async {
            
                SVProgressHUD.dismiss()
            
                self.view.isUserInteractionEnabled = true
            }
        })
    }
    
    
    //MARK: - UIActions
    @IBAction func btnSubmit(_ sender: UIButton) {
        
        let strNewPass = dict["newPass"]
        
        let strCurrentPass = dict["currentPass"]
        
        let strConfirmPass = dict["confirmPass"]
        
        if strNewPass == "" || strCurrentPass == "" || strConfirmPass == "" {
            
            let alert = UIAlertController(title: "",message: "All fields are mandatory!",preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                
                self.appDelegate?.centerContainer?.closeDrawer(animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else if strNewPass != strConfirmPass {
            
            let alert = UIAlertController(title: "",message: "Password and Confirm Password must be same!",preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                
                self.appDelegate?.centerContainer?.closeDrawer(animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else if (strNewPass?.characters.count)! < 5 || (strConfirmPass?.characters.count)! < 5 {
            
            let alert = UIAlertController(title: "",message: "Password must be greater than 4 character!",preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                
                self.appDelegate?.centerContainer?.closeDrawer(animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            self.apiUpdatePassword()
        }
    }
}


//MARK: TextField Delegate
extension UpdatePasswordVC : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtFieldCurrentPass {
            
            txtFieldCurrentPass.text = textField.text?.trim()
            
            dict["currentPass"] = txtFieldCurrentPass.text
        }
        else if textField == txtFieldNewPass {
            
            txtFieldNewPass.text = textField.text?.trim()
            
            dict["newPass"] = txtFieldNewPass.text
        }
        else {
            
            txtFieldConfirmPass.text = textField.text?.trim()
            
            dict["confirmPass"] = txtFieldConfirmPass.text
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == .done {
            
            textField.resignFirstResponder()
            
        } else {
            
            let nextTage = textField.tag + 1
            
            let nextResponder = textField.superview?.superview?.viewWithTag(nextTage) as UIResponder?
            
            if nextResponder != nil {
                
                nextResponder?.becomeFirstResponder()
            }
        }
        return true
    }
    
}
