//
//  RegisterVC.swift
//  PlacePoint
//
//  Created by Mac on 28/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

//var selectedBusinessType = "Free"

class RegisterVC: UIViewController, SelectedSubPlan {
    
    @IBOutlet var viewHeader: UIView!
    
    @IBOutlet var viewFooter: UIView!
    
    @IBOutlet var tableViewRegister: UITableView!
    
    @IBOutlet var lblsubType: UILabel!
    
    @IBOutlet weak var vwApplyCoupon: UIView!
    
    @IBOutlet weak var txtFieldCoupon: UITextField!
    
    @IBOutlet weak var vwLineCoupon: UIView!
    
    var arrTitle = ["EMAIL ID", "PASSWORD", "BUSINESS NAME", "BUSINESS LOCATION", "BUSINESS CATEGORY"]
    
    var arrTitleDes = ["name@domain.com", "********", "Enter Business Name", "Select Town", "Select Category"]
    
    var arrTowns = [AnyObject]()
    
    var arrCategories = [AnyObject]()
    
    var index: IndexPath? = nil
    
    var strSelectedLocation: String?
    
    var strSelectedCategory: String?
    
    var dictRegisterDetails = [String: String]()
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let picker = UIPickerView()
    
    var textField: UITextField!
    
    var strEmail = String()
    
    var strPwd = String()
    
    var strBusName = String()
    
    var strBusLoc = String()
    
    var strBusCat = String()
    
    var arrSelectedCategory = [String]()
    
    var popUpSubscPlan = PopUpSubScriptionPlan()
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        isBusinessVc = false
        
        self.txtFieldCoupon.attributedPlaceholder = NSAttributedString(string: "Enter Coupon", attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeHolderTextColor()])
        
        if isSubSelectPlane == false {
            
            selectedPlan = "1"
            
            self.txtFieldCoupon.delegate = self
        }
        
        if selectedPlan == "3" {
            
            self.lblsubType.text = "Free € 0/year"
            
            self.vwApplyCoupon.isHidden = true
            
            self.txtFieldCoupon.isHidden = true
            
            self.vwLineCoupon.isHidden = true
        }
        else if selectedPlan == "1" {
            
            self.lblsubType.text = "Premium € 300/year"
            
            self.vwApplyCoupon.isHidden = false
            
            self.txtFieldCoupon.isHidden = false
            
            self.vwLineCoupon.isHidden = false
            
            
        }
        else if selectedPlan == "2"{
            
            self.lblsubType.text = "Standard € 150/year"
            
            self.vwApplyCoupon.isHidden = false
            
            self.txtFieldCoupon.isHidden = false
            
            self.vwLineCoupon.isHidden = false
            
        }
        else if selectedPlan == "4"{
            
            self.lblsubType.text = "Admin"
            
            self.vwApplyCoupon.isHidden = true
            
            self.txtFieldCoupon.isHidden = true
            
            self.vwLineCoupon.isHidden = true
            
        }
        else {
            
            self.lblsubType.text = ""
            
            self.vwApplyCoupon.isHidden = true
            
            self.txtFieldCoupon.isHidden = true
            
            self.vwLineCoupon.isHidden = true
            
        }
        self.setUpView()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        dictRegisterDetails["buisneessLoc"] = ""
        
        dictRegisterDetails["buisneessCategory"] = ""
        
        dictRegisterDetails["email"] = ""
        
        dictRegisterDetails["password"] = ""
        
        dictRegisterDetails["buisneessName"] = ""
        
        dictRegisterDetails["buisneessLoc"] = ""
        
        dictRegisterDetails["buisneessCategory"] = ""
        
        self.registerTableView()
        
        self.setUpNavigation()
        
        self.keyBoardNotify()
        
        self.apiGetTowns()
        
        self.setUpPicker()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        if selectedPlan == "3" {
            
            self.lblsubType.text = "Free € 0/year"
            
            self.vwApplyCoupon.isHidden = true
            
            self.txtFieldCoupon.isHidden = true
            
            self.vwLineCoupon.isHidden = true
            
        }
        else if selectedPlan == "1" {
            
            self.lblsubType.text = "Premium € 300/year"
            
            self.vwApplyCoupon.isHidden = false
            
            self.txtFieldCoupon.isHidden = false
            
            self.vwLineCoupon.isHidden = false
        }
        else if selectedPlan == "2"{
            
            self.lblsubType.text = "Standard € 150/year"
            
            self.vwApplyCoupon.isHidden = false
            
            self.txtFieldCoupon.isHidden = false
            
            self.vwLineCoupon.isHidden = false
            
        }
        else if selectedPlan == "4"{
            
            self.lblsubType.text = "Admin"
            
            self.vwApplyCoupon.isHidden = true
            
            self.txtFieldCoupon.isHidden = true
            
            self.vwLineCoupon.isHidden = true
            
        }
        else {
            
            self.lblsubType.text = ""
            
            self.vwApplyCoupon.isHidden = true
            
            self.txtFieldCoupon.isHidden = true
            
            self.vwLineCoupon.isHidden = true
            
        }
        
        if !(arrSelectedCategory.isEmpty) {
            
            let indexPath = IndexPath(row: 4, section: 0)
            
            let cell = tableViewRegister.cellForRow(at: indexPath) as!RegisterCell
            
            strSelectedCategory = (arrSelectedCategory.map{String($0)}).joined(separator: ",")
            
            cell.btnPicker.setTitle(strSelectedCategory, for: .normal)
            
        }
        
    }
    
    
    func setUpView() {
        
        let arrCategories = AppDataManager.sharedInstance.arrCategories as [AnyObject]
        
        for i in 0..<arrCategories.count {
            
            var dict = [String: Any]()
            
            var dictCatData = [String: Any]()
            
            var catName = String()
            
            var subCatName = String()
            
            if arrCategories[i]["parent_category"] as? String == "0" {
                
                let catId = arrCategories[i]["id"] as? String
                
                catName = CommonClass.sharedInstance.getCategoryName(strCategory: catId!, array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                
                dictCatData["status"] = "0"
                
                dictCatData["child"] = []
                
                var arrChild = [AnyObject]()
                
                for a in 0..<arrCategories.count {
                    
                    if arrCategories[a]["parent_category"] as? String == catId {
                        
                        subCatName = (arrCategories[a]["name"] as? String)!
                        
                        let strImg = arrCategories[a]["image_url"] as! String
                        
                        var dictSubCat = [String: Any]()
                        
                        dictSubCat["subCat"] = subCatName
                        
                        dictSubCat["img_url"] = strImg
                        
                        dictSubCat["status"] = "0"
                        
                        arrChild.append(dictSubCat as AnyObject)
                        
                        dictCatData["child"] = arrChild
                        
                    }
                }
                
                dict[catName] = dictCatData
                
                dict.forEach { (k,v) in dictAllCategories[k] = v }
                
                arrAllCategories = [String] (dictAllCategories.keys) as [AnyObject]
            }
        }
        
    }
    
    
    func apiGetTowns() {
        
        self.arrTowns = arrTowns  as [AnyObject]
        
        self.arrCategories = AppDataManager.sharedInstance.arrCategories  as [AnyObject]
    }
    
    
    //MARK: Api Apply Coupon
    func apiApplyCoupon() {
        
        var dict = [String: String]()
        
        dict["auth_code"] = UserDefaults.standard.getAuthCode()
        
        dict["type"] = selectedPlan
        
        dict["coupon"] = self.txtFieldCoupon.text
        
        AppDataManager.sharedInstance.dictParams = dict as! [String : String]
        
        SVProgressHUD.show()
        
        self.view.isUserInteractionEnabled = false
        
        AppDataManager.sharedInstance.apiApplyCoupon(completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
                let strStatus = dictResponse["status"] as? String
                
                if strStatus == "true" {
                    
                    isApplyCoupon = true
                    
                    couponCode = self.txtFieldCoupon.text!
                    
                    price = (dictResponse["price"] as? Int)!
                    
                }
                else {
                    
                    let strMsg = dictResponse["msg"] as! String
                    
                    couponCode = self.txtFieldCoupon.text!
                    
                    isApplyCoupon = false
                    
                    let alert = UIAlertController(title: "",message: strMsg,preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                        
                        
                    }))
                    
                    alert.modalPresentationStyle = .custom
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        }, failure: { (errorCode) in
            
            SVProgressHUD.dismiss()
            
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
            }
            
        })
    }
    
    
    //MARK: - Api Register
    func apiRegsiter()  {
        
        dictRegisterDetails["buisneessLoc"] = strSelectedLocation
        
        if let selectedLocation = strSelectedLocation {
            
            UserDefaults.standard.setTown(value: selectedLocation)
        }
        
        dictRegisterDetails["buisneessCategory"] = strSelectedCategory
        
        if let selectedCat = strSelectedCategory {
            
            UserDefaults.standard.selectedCategory(value: selectedCat)
        }
        
        if dictRegisterDetails["buisneessLoc"] != nil &&
            dictRegisterDetails["buisneessCategory"] != nil && dictRegisterDetails["email"] != nil && dictRegisterDetails["password"] != nil && dictRegisterDetails["buisneessName"] != nil {
            
            if dictRegisterDetails["email"] != "" {
                
                strEmail = dictRegisterDetails["email"]!
            }
            else {
                
                strEmail = ""
            }
            
            if dictRegisterDetails["password"] != "" {
                
                strPwd = dictRegisterDetails["password"]!
            }
            else {
                
                strPwd = ""
            }
            
            if dictRegisterDetails["buisneessName"] != "" {
                
                strBusName = dictRegisterDetails["buisneessName"]!
            }
            else {
                
                strBusName = ""
            }
            
            if dictRegisterDetails["buisneessLoc"] != "" {
                
                strBusLoc = dictRegisterDetails["buisneessLoc"]!
            }
            else {
                
                strBusLoc = ""
            }
        }
        
        var strCategoryID = String()
        
        if strSelectedCategory != nil {
            
            let arrSelectedCategory = strSelectedCategory?.components(separatedBy: ",")
            
            let arrCategoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
                arrSelectedCategory as! [String], array: arrCategories)
            
            strCategoryID = arrCategoryID.joined(separator: ",")
            
        }
        
        guard !((strEmail.isEmpty)) && !((strPwd.isEmpty)) && !((strBusName.isEmpty)) && !((strBusLoc.isEmpty)) && !((strCategoryID.isEmpty))
            
            else {
                
                let alert = UIAlertController(title: ValidAlertTitle.FieldMandatory,message: ValidAlertMsg.FieldMandatory,preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    
                }))
                
                alert.modalPresentationStyle = .custom
                
                self.present(alert, animated: true, completion: nil)
                
                return
        }
        
        let strLocationId = CommonClass.sharedInstance.getLocationId(strLocation: strBusLoc, array: arrTowns)
        
        if strPwd.characters.count < 5 {
            
            let alert = UIAlertController(title: "Alert",message: "Password must be greater than 4 character",preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                
                
            }))
            
            alert.modalPresentationStyle = .custom
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let selectedUserType = UserDefaults.standard.getBusinessUserType()
        
        if selectedUserType == "Free" || selectedUserType == "Admin" {
            
            self.FreeSubscriptionUserApi()
        }
        else {
            
            let paymentVc = BusinessPaymentVC(nibName: "BusinessPaymentVC", bundle: nil)
            
            paymentVc.email = strEmail
            
            paymentVc.password = strPwd
            
            paymentVc.businessName = strBusName
            
            paymentVc.location = strLocationId
            
            strUserType = selectedPlan
            
            paymentVc.category = strCategoryID
            
            let nav = UINavigationController(rootViewController: paymentVc)
            
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    
    func FreeSubscriptionUserApi() {
        
        var strCategoryID = String()
        
        if strSelectedCategory != "" {
            
            let arrSelectedCategory = strSelectedCategory?.components(separatedBy: ",")
            
            let arrCategoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
                arrSelectedCategory as! [String], array: arrCategories)
            
            strCategoryID = arrCategoryID.joined(separator: ",")
            
        }
        
        let strLocationId = CommonClass.sharedInstance.getLocationId(strLocation: strBusLoc, array: arrTowns)
        
        let dictParams = ["email":strEmail, "password":strPwd, "business_name":strBusName, "location":strLocationId,"token": "","type":selectedPlan, "category":strCategoryID, "auth_code":UserDefaults.standard.getAuthCode(),"coupon": ""] as [String : Any]
        
        UserDefaults.standard.setPassword(value: strPwd)
        
        UserDefaults.standard.setEmail(value: strEmail)
        
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
                    
                    UserDefaults.standard.setBusinessId(value: (arrData![0]["business_id"] as? String)!)
                    
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                        
                    });
                    
                    let imageDataDict:[String: UIImage] = ["image": #imageLiteral(resourceName: "placeholder")]
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setProfileData"), object: nil, userInfo: imageDataDict)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setMoreMenuData"), object: nil, userInfo: imageDataDict)
                    
                }
                else {
                    
                    let strMsg = dictResponse["msg"] as! String
                    
                    let alert = UIAlertController(title: "",message: strMsg,preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                        
                    }))
                    
                    alert.modalPresentationStyle = .custom
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        }, failure: { (errorCode) in
            
            SVProgressHUD.dismiss()
            
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
            }
            
        })
        
    }
    
    
    //MARK: - UIActions
    @IBAction func btnRegister(_ sender: UIButton) {
        
        self.apiRegsiter()
    }
    
    
    @IBAction func backButtonClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnChooseSubPlan(_ sender: UIButton) {
        
        popUpSubscPlan = Bundle.main.loadNibNamed("PopUpSubScriptionPlan", owner: nil, options: nil)?[0] as! PopUpSubScriptionPlan
        
        popUpSubscPlan.frame = self.view.frame
        
        popUpSubscPlan.delegate = self
        
        self.view.addSubview(popUpSubscPlan)
        
    }
    
    
    func setSubPlan(name: String) {
        
        popUpSubscPlan.removeFromSuperview()
        
        switch name {
            
        case "3":
            
            popUpSubscPlan.imgFree.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            popUpSubscPlan.imgPrem.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgStd.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgAdmin.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            self.lblsubType.text = "Free € 0/year"
            
            self.vwApplyCoupon.isHidden = true
            
            self.txtFieldCoupon.isHidden = true
            
            self.vwLineCoupon.isHidden = true
            
            selectedPlan = "3"
            
            UserDefaults.standard.setBusinessUserType(userType: "Free")
            
            let indexPath = IndexPath(row: 4, section: 0)
            
            let cell = tableViewRegister.cellForRow(at: indexPath) as!RegisterCell
            
            cell.btnPicker.setTitle("Select Category", for: .normal)
            
            arrSelectedCategory.removeAll()
            
            if strSelectedCategory != nil {
                
                let arrStrSelected = strSelectedCategory?.components(separatedBy: ",")
                
                for a in 0..<arrAllCategories.count {
                    
                    let catName = arrAllCategories[a] as? String
                    
                    var dictCat = [String: Any]()
                    
                    var dict = dictAllCategories as? [String: Any]
                    
                    var dictChild = dict![catName!] as? [String: Any]
                    
                    dictChild!["status"] = "0"
                    
                    var arrChild: [AnyObject] = (dictChild!["child"] as? [AnyObject])!
                    
                    if arrChild.count > 0 {
                        
                        for k in 0..<arrChild.count{
                            
                            var dictSubCat = arrChild[k] as? [String: Any]
                            
                            let subCatName = dictSubCat!["subCat"] as? String
                            
                            let strImg = dictSubCat!["image_url"] as? String
                            
                            for i in 0..<(arrStrSelected?.count)!{
                                
                                if subCatName == arrStrSelected![i] &&  dictSubCat!["status"] as? String == "1" {
                                    
                                    dictSubCat!["status"] = "0"
                                    
                                    arrChild[k] = dictSubCat! as AnyObject
                                    
                                    dictChild!["child"] = arrChild
                                }
                                
                            }
                            
                            dictCat[catName!] = dictChild
                            
                            dictCat.forEach { (k,v) in dictAllCategories[k] = v }
                            
                            arrAllCategories = [String] (dictAllCategories.keys) as [AnyObject]
                            
                        }
                    }
                    
                }
                
            }
            
            strSelectedCategory = ""
            
            selectedcategories.removeAll()
            
            self.setUpView()
            
            
        case "1":
            
            popUpSubscPlan.imgPrem.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            popUpSubscPlan.imgFree.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgStd.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgAdmin.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            self.lblsubType.text = "Premium € 300/year"
            
            self.vwApplyCoupon.isHidden = false
            
            self.txtFieldCoupon.isHidden = false
            
            self.vwLineCoupon.isHidden = false
            
            txtFieldCoupon.delegate = self
            
            selectedPlan = "1"
            
            UserDefaults.standard.setBusinessUserType(userType: "Premium")
            
        case "2":
            
            popUpSubscPlan.imgStd.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            popUpSubscPlan.imgFree.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgPrem.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgAdmin.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            self.lblsubType.text = "Standard € 150/year"
            
            selectedPlan = "2"
            
            self.vwApplyCoupon.isHidden = false
            
            self.txtFieldCoupon.isHidden = false
            
            self.vwLineCoupon.isHidden = false
            
            txtFieldCoupon.delegate = self
            
            UserDefaults.standard.setBusinessUserType(userType: "Standard")
            
        case "4":
            
            popUpSubscPlan.imgAdmin.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            popUpSubscPlan.imgFree.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgPrem.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgStd.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            self.lblsubType.text = "Admin"
            
            self.vwApplyCoupon.isHidden = true
            
            self.txtFieldCoupon.isHidden = true
            
            self.vwLineCoupon.isHidden = true
            
            selectedPlan = "4"
            
            UserDefaults.standard.setBusinessUserType(userType: "Admin")
            
            
        default:
            break
        }
        
    }
    
    
    // MARK: - Register TableView nib
    func registerTableView() {
        
        tableViewRegister.tableFooterView = UIView()
        
        let  cellNib1 = UINib(nibName: "RegisterCell", bundle: nil)
        
        tableViewRegister.register(cellNib1, forCellReuseIdentifier: "cell")
        
        tableViewRegister.tableHeaderView = viewHeader
        
        tableViewRegister.tableFooterView = viewFooter
        
    }
    
    
    func setUpNavigation() {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
}


// MARK: - TableView Delegate and DataSource
extension RegisterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? RegisterCell
        
        cell?.btnForgotPass.isHidden = true
        
        cell?.lblTitle.text = arrTitle[indexPath.row]
        
        cell?.imgLogo.image = UIImage(named: arrTitle[indexPath.row])
        
        cell?.txtFldRegister.attributedPlaceholder = NSAttributedString(string: arrTitleDes[indexPath.row], attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeHolderTextColor()])
          
        cell?.txtFldRegister.delegate = self
        
        cell?.txtFldRegister.tag = indexPath.row
        
        if cell?.txtFldRegister.tag == 0 || cell?.txtFldRegister.tag == 1 || cell?.txtFldRegister.tag == 2 {
            
            cell?.btnDropDown.isHidden = true
            
        }
        
        cell?.btnPicker.tag = indexPath.row
        
        cell?.btnPicker.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        
        cell?.selectionStyle = .none
        
        if indexPath.row == 0 {
            
            cell?.txtFldRegister.keyboardType = .emailAddress
        }
        else if indexPath.row == 1 {
            
            cell?.txtFldRegister.isSecureTextEntry = true
        }
        else if indexPath.row == 2 {
            
            cell?.txtFldRegister.autocapitalizationType = .sentences
            
            cell?.txtFldRegister.returnKeyType = .done
        }
        else if indexPath.row == 3 || indexPath.row == 4 {
            
            cell?.btnDropDown.isHidden = false
            
            cell?.btnPicker.setTitle(arrTitleDes[indexPath.row], for: .normal)
            
            cell?.txtFldRegister.isHidden = true
            
            cell?.btnDropDown.tag = indexPath.row
            
            cell?.btnPicker.isHidden = false
        }
        else {
            
            cell?.btnDropDown.isHidden = true
        }
        if indexPath.row == 4 {
            
            cell?.txtFldRegister.returnKeyType = .done
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if UIScreen.main.bounds.size.height == 736{
            
            return 100
        }
        else if UIScreen.main.bounds.size.height == 812{
            
            return 100
        }
        return 90
    }
}


//MARK: - Adopt Protocol
extension RegisterVC: SelectedCategories {
    
    func category(selectedCat: [String]) {
        
        self.arrSelectedCategory = selectedCat
        
    }
}

