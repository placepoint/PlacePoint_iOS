//
//  LoginVC.swift
//  PlacePoint
//
//  Created by Mac on 28/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol CheckUserLogin: class {
    
    func checkUserLogin(isLogin: Bool)
    
}

class LoginVC: UIViewController {
    
    @IBOutlet var tableViewLogin: UITableView!
    
    @IBOutlet var viewFooter: UIView!
    
    var index: IndexPath? = nil
    
    var arrTitle = ["EMAIL ID", "PASSWORD"]
    
    var arrTitleDes = ["name@domain.com","********"]
    
    var dictLoginDetails = [String: String]()
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var strEmail = String()
    
    var strPwd = String()
    
    weak var delegate: CheckUserLogin?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        isBusinessVc = false
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        dictLoginDetails["email"] = ""
        
        dictLoginDetails["password"] = ""
        
        self.registerTableView()
        
        self.keyBoardNotify()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    //MARK: - UIActions
    @IBAction func btnLoginAction(_ sender: UIButton) {
        
        delegate?.checkUserLogin(isLogin: true)
        
        UserDefaults.standard.setBusinessLogin(value: true)
        
        self.view.frame.origin.y = 0
        
        self.apiLogin()
    }
    
    @IBAction func backButonAction(_ sender: UIButton) {
        
        isBusinessVc = false
        
        UserDefaults.standard.setBusinessLogin(value: false)
        
        self.dismiss(animated: true, completion: nil)
        
        delegate?.checkUserLogin(isLogin: false)
        
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        
        let regsiterVC = RegisterVC(nibName: "RegisterVC", bundle: nil)
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController

        while((topVC!.presentedViewController) != nil) {

            topVC = topVC!.presentedViewController
        }
        
        topVC?.modalPresentationStyle = .custom
        
        topVC?.present(regsiterVC, animated: true, completion: nil)
     
    }
    
    
    // MARK: - Register TableView nib
    func registerTableView() {
        
        tableViewLogin.tableFooterView = UIView()
        
        let  cellNib1 = UINib(nibName: "RegisterCell", bundle: nil)
        
        tableViewLogin.register(cellNib1, forCellReuseIdentifier: "cell")
        
        tableViewLogin.tableFooterView = viewFooter
    }
    
    
    //MARK: Api Login
    func apiLogin()  {
        
        if dictLoginDetails["password"]  == "" {
            
            let cell = tableViewLogin.cellForRow(at: IndexPath(row: 1, section: 0)) as! RegisterCell
            
            dictLoginDetails["password"] = cell.txtFldRegister.text?.trim()
        }
        
        
        if dictLoginDetails["email"] != "" && dictLoginDetails["password"] != "" {
            
            strEmail = dictLoginDetails["email"]!
            
            strPwd = dictLoginDetails["password"]!
        }
        
        guard !((strEmail.isEmpty)) && !((strPwd.isEmpty))
            
            else {
                
                let alert = UIAlertController(title: ValidAlertTitle.FieldMandatory,message: ValidAlertMsg.FieldMandatory,preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    
                }))
                
                 self.present(alert, animated: true, completion: nil)
                
                return
        }
        
        let dictParams = ["email":strEmail, "password":strPwd, "auth_code":UserDefaults.standard.getAuthCode()]
        
        UserDefaults.standard.setPassword(value: strPwd)
        
        UserDefaults.standard.setEmail(value: strEmail)
        
        AppDataManager.sharedInstance.dictParams = dictParams
        
        SVProgressHUD.show()
        
        self.view.isUserInteractionEnabled = false
        
        AppDataManager.sharedInstance.apiLogin(completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
                let strStatus = dictResponse["status"] as! String
                
                if strStatus == "true" {
                    
                    let data = dictResponse["data"] as? [AnyObject]
                
                    let userType = data![0]["user_type"] as? String
                    
                    if userType == "1" {
                        
                        UserDefaults.standard.setBusinessUserType(userType: "Premium")
                    }
                    else if userType == "2"{
                        
                        UserDefaults.standard.setBusinessUserType(userType: "Standard")
                    }
                    else if userType == "3" {
                        
                        UserDefaults.standard.setBusinessUserType(userType: "Free")
                    }
                    else {
                        
                         UserDefaults.standard.setBusinessUserType(userType: "Admin")
                    }
                    
                    UserDefaults.standard.setBusinessLogin(value: true)
                    
                    UserDefaults.standard.setBusinessName(value: (dictResponse["business_name"] as? String)!)
                    
                    UserDefaults.standard.setBusinessStatus(value: "true")
                    
                    UserDefaults.standard.setBusinessId(value: (dictResponse["business_id"] as? String)!)
                 
                    let arr = dictResponse["data"] as? [AnyObject]
                    
                    let strBuisnessName = arr![0]["business_name"] as? String
                    
                    let townId = arr![0]["location"] as? String
                    
                    let town = CommonClass.sharedInstance.getTownName(strTown: townId!, array: AppDataManager.sharedInstance.arrTowns )
                    
                    UserDefaults.standard.setSelectedTown(value: town)
                    
                    let strCatID = arr![0]["category"] as? String
                    
                    let categoriesArray = AppDataManager.sharedInstance.arrCategories
                        
                     UserDefaults.standard.setArrCategories(value: categoriesArray)
                    
                    let townArray = AppDataManager.sharedInstance.arrTowns
                    
                    UserDefaults.standard.setArrTown(value: townArray)
                    
                    
                    
                    let arrCatId = strCatID?.components(separatedBy: ",")
                    
                    var arrStrCategory = [String]()
                    
                    for i in 0..<(arrCatId?.count)!{
                        
                        let strCat = CommonClass.sharedInstance.getCategoryName(strCategory: arrCatId![i], array: (AppDataManager.sharedInstance.arrCategories as? [AnyObject])!)
                        
                        arrStrCategory.append(strCat)
                        
                    }
                    
                    let category = arrStrCategory.joined(separator: ",")
                    
                    UserDefaults.standard.selectedCategory(value: category)
                    
                    checkMyTimeLine = "My Posts"
                    
                    isBusinessVc = true
                    
                    UserDefaults.standard.setBusinessName(value: strBuisnessName!)
                    
                    self.dismiss(animated: true, completion: nil)
              
                    let imageDataDict:[String: UIImage] = ["image": #imageLiteral(resourceName: "placeholder")]
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setProfileData"), object: nil, userInfo: imageDataDict)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setMoreMenuData"), object: nil, userInfo: imageDataDict)
                    
                }
                else {
                    
                    let strMsg = dictResponse["msg"] as! String
 
                    let alert = UIAlertController(title: "",message: strMsg,preferredStyle: UIAlertControllerStyle.alert)
                    
                    UserDefaults.standard.setBusinessLogin(value: false)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                
                    let cell = self.tableViewLogin.cellForRow(at: IndexPath(row: 1, section: 0)) as! RegisterCell
                    
                    cell.txtFldRegister.text = ""
                    
                    self.dictLoginDetails["password"] = cell.txtFldRegister.text 
                    
                }
            }
            
        }, failure: { (errorCode) in
            
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            
        })
    }
}


// MARK: - TableView Delegate and DataSource
extension LoginVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? RegisterCell
        
        cell?.lblTitle.text = arrTitle[indexPath.row]
        
        cell?.btnDropDown.isHidden = true
        
        cell?.delegate = self
        
        if indexPath.row == 0 {
            
            cell?.txtFldRegister.keyboardType = .emailAddress
            
            cell?.btnForgotPass.isHidden = true
            
        }
        else {
            
            cell?.btnForgotPass.isHidden = false
        }
        
        cell?.txtFldRegister.attributedPlaceholder = NSAttributedString(string: arrTitleDes[indexPath.row], attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeHolderTextColor()])
        
        cell?.txtFldRegister.tag = indexPath.row
        
        cell?.imgLogo.image = UIImage(named: arrTitle[indexPath.row])
        
        cell?.txtFldRegister.delegate = self
        
        cell?.selectionStyle = .none
        
        if indexPath.row == 1 {
            
            cell?.txtFldRegister.returnKeyType = .done
            
            cell?.txtFldRegister.isSecureTextEntry = true
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
}


//MARK: - Adopt Protocol
extension LoginVC: OpenForgotScreen {
    
    func openForgotVc() {
        
        let forgotVc = ForgotPasswordVc(nibName: "ForgotPasswordVc", bundle: nil)
        
        self.present(forgotVc, animated: true, completion: nil)
        
    }
    
}
