//
//  BusinessPaymentVC.swift
//  PlacePoint
//
//  Created by Mac on 06/08/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD
import  Stripe

class BusinessPaymentVC: UIViewController {
    
    @IBOutlet var txtFieldCardNumber: UITextField!
    
    @IBOutlet var txtFieldCardNameDetail: UITextField!
    
    @IBOutlet var txtFieldCvv: UITextField!
    
    @IBOutlet var txtFieldExpireDate: UITextField!
    
    @IBOutlet var toolBar: UIToolbar!
    
    @IBOutlet var lbl1: UILabel!
    
    @IBOutlet var lbl2: UILabel!
    
    @IBOutlet var lbl3: UILabel!
    
    @IBOutlet var lblAmount: UILabel!
    
    var email = String()
    
    var password = String()
    
    var businessName = String()
    
    var location = String()
    
    var category = String()
    
    var token: STPToken?
    
    var pickerView = UIPickerView()
    
    var amount = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setUpNavigation()
        
        txtFieldCardNumber.inputAccessoryView = toolBar
        
        txtFieldCvv.inputAccessoryView = toolBar
        
        let selectedUserType = UserDefaults.standard.getBusinessUserType()
        
        if selectedUserType == "Standard" {
            
            lbl1.text = "- No live feed"
            
            lbl2.text = "- No scheduled posts allowed "
            
            lbl3.text = "- Positioned in middle of listings"
            
            if isApplyCoupon == true {
                
                lblAmount.text = "Amount to be paid = \(price)"
            }
            else {
                
                lblAmount.text = "Amount to be paid = \(150)"
            }
            
        }
        else {
            
            lbl1.text = "- No Restrictions"
            
            lbl2.isHidden = true
            
            lbl3.isHidden = true
            
            if isApplyCoupon == true {
                
                lblAmount.text = "Amount to be paid = \(price)"
            }
            else {
                
                lblAmount.text = "Amount to be paid = \(300)"
            }
            
        }
        
        if self.amount != 0 {
            
            self.lblAmount.isHidden = false
            
            if isApplyCoupon == true {
                
                lblAmount.text = "Amount to be paid = \(price)"
            }
            else {
                self.lblAmount.text = "Amount to be paid = \(amount)"
            }
            
        }
        
        self.showDatePicker()
    }
    
    
    //MARK: - SetUp Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        self.navigationItem.navTitle(title: "Payment Details")
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
    }
    
    
    // backButton Tapped
    @objc func backButtonTapped() {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK: - UIActions
    @IBAction func btnToolBarDone(_ sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        
    }
    
    
    func showDatePicker() {
        
        //Formate Date
        let expiryDatePicker = MonthYearPickerView()
        
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            
            self.txtFieldExpireDate.text = string
        }
        
        expiryDatePicker.backgroundColor = UIColor.white
        
        pickerView = expiryDatePicker
        
        //ToolBar
        
        let toolbar = UIToolbar()
        
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        toolbar.backgroundColor = UIColor.darkGray
        
        txtFieldExpireDate.inputAccessoryView = toolbar
        
        txtFieldExpireDate.inputView = pickerView
        
    }
    
    
    @objc func donedatePicker() {
        
        self.view.endEditing(true)
    }
    
    
    @objc func cancelDatePicker() {
        
        self.view.endEditing(true)
        
    }
    
    
    //MARK: Api Register
    func apiRegister(strCardToken: String) {
        
        var strToken = String()
        
        if let token = strCardToken as? String {
            
            strToken = token
        }
        
        let dictParams = ["email":self.email, "password":self.password, "business_name":self.businessName, "location":self.location,"coupon": couponCode,"token": strToken,"type":strUserType, "category":self.category, "auth_code":UserDefaults.standard.getAuthCode()] as [String : Any]
        
        UserDefaults.standard.setPassword(value: self.password)
        
        UserDefaults.standard.setEmail(value: self.email)
        
        AppDataManager.sharedInstance.dictParams = dictParams as! [String : String]
        
        SVProgressHUD.show()
        
        self.view.isUserInteractionEnabled = false
        
        AppDataManager.sharedInstance.apiRegister(completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
                let strStatus = dictResponse["status"] as? String
                
                if strStatus == "true" {
                    
                    UserDefaults.standard.setBusinessLogin(value: true)
                    
                    let arrData = dictResponse["data"] as? [AnyObject]
                    
                    UserDefaults.standard.setBusinessName(value: (arrData![0]["business_name"] as? String)!)
                    
                    UserDefaults.standard.setBusinessStatus(value: "true")
                    
                    checkMyTimeLine = "My Posts"
                    
                    UserDefaults.standard.setBusinessId(value: (arrData![0]["business_id"] as? String)!)
                    
                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                        
                    });
                    
                    let imageDataDict:[String: UIImage] = ["image": #imageLiteral(resourceName: "placeholder")]
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setProfileData"), object: nil, userInfo: imageDataDict)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setMoreMenuData"), object: nil, userInfo: imageDataDict)
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                else {
                    
                    let strMsg = dictResponse["msg"] as! String
                    
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
    @IBAction func btnBuyNow(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if txtFieldExpireDate.text == "" || txtFieldCvv.text == "" || txtFieldCardNumber.text == "" || txtFieldCardNameDetail.text == "" {
            
            
            let alert = UIAlertController(title: "",message: "All Fields are mandatory ",preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                
            }))
            
            alert.modalPresentationStyle = .custom
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            
            self.getStripeToken(strBuyOrSave: "Buy")
            
        }
    }
    
    
    //MARK: - Upgrade Package
    func upgradePackage(strCardToken: String) {
        
        SVProgressHUD.show()
        
        var dictParams = [String: Any]()
        
        var currentType = String()
        
        var strToken = String()
        
        if let token = strCardToken as? String {
            
            strToken = token
        }
        
        dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
        
        dictParams["currenttype"] = strUserType
        
        dictParams["upgrade_type"] = upgardeType
        
        dictParams["token"] = strToken
        
        dictParams["amount"] = amount
        
        FeedManager.sharedInstance.dictParams = dictParams
        
        SVProgressHUD.show()
        
        self.view.isUserInteractionEnabled = false
        
        FeedManager.sharedInstance.upgardePackage(completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
                let strStatus = dictResponse["status"] as? String
                
                if strStatus == "true" {
                    
                    let data = dictResponse["data"] as? [AnyObject]
                    
                    let userType = data![0]["user_type"] as? String
                    
                    if userType == "1" {
                        
                        UserDefaults.standard.setBusinessUserType(userType: "Premium")
                        
                    }else if userType == "2" {
                        
                        UserDefaults.standard.setBusinessUserType(userType: "Standard")
                    }
                    else {
                        
                        UserDefaults.standard.setBusinessUserType(userType: "Free")
                    }
                    
                    let strMsg = dictResponse["msg"] as! String
                    
                    let alert = UIAlertController(title: "",message: strMsg,preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                        
                    });
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "afterUpgarde"), object: nil)
                    
                    self.tabBarController?.selectedIndex = 0
                    
                }
                else {
                    
                    let strMsg = dictResponse["msg"] as! String
                    
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
    
    
    //MARK: - Get Stripe Token
    func getStripeToken(strBuyOrSave:String)   {
        
        SVProgressHUD.show()
        
        let cardParams = STPCardParams()
        
        cardParams.number = txtFieldCardNumber.text
        
        let expirationDateSplit = txtFieldExpireDate.text?.components(separatedBy: "/")
        
        let expMonth = UInt(Int(expirationDateSplit![0])!)
        
        let expYear = UInt(Int(expirationDateSplit![1])!)
        
        cardParams.expMonth = expMonth
        
        cardParams.expYear = expYear
        
        cardParams.cvc = txtFieldCvv.text
        
        //        let cardParams = STPCardParams()
        //        cardParams.number = "4242424242424242"
        //        cardParams.expMonth = 10
        //        cardParams.expYear = 2018
        //        cardParams.cvc = "123"
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            
            guard let token = token, error == nil else {
                
                self.handleError(error: error! as NSError)
                
                SVProgressHUD.dismiss()
                
                return
            }
            self.token = token
            
            if isBusinessVc == false && isShowFeed == false && isScheduleVc == false && isAddPost == false {
                
                self.apiRegister(strCardToken: token.tokenId)
            }
            else {
                
                self.upgradePackage(strCardToken: token.tokenId)
            }
        }
        
    }
    
    
    func handleError(error: NSError) {
        
        UIAlertView(title: "Please Try Again", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "ok").show()
        
    }
}


//MARK: - UITextField Delegate
extension BusinessPaymentVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtFieldCvv {
            
            guard let text = textField.text else { return true }
            
            let newLength = text.count + string.count - range.length
            
            return newLength <= 3
            
        }
        else if textField == txtFieldCardNumber {
            
            guard let text = textField.text else { return true }
            
            let newLength = text.count + string.count - range.length
            
            return newLength <= 16
            
        }
        else {
            
            return true
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}
