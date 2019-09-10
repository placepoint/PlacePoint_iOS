
//
//  RedeemVC.swift
//  PlacePoint
//
//  "" on 28/11/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class RedeemVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tblViewRedem: UITableView!
    
    @IBOutlet weak var searchBarRedeemed: UISearchBar!
    
    @IBOutlet weak var lblNoPostFound: UILabel!
    
    
    var arrSelectedIndex = [Int]()
    
    var strIdFromFlashpost = String()
    
    var arrDetailsClaim = [AnyObject]()
    
    var arrDetailsRedeem = [AnyObject]()
    
    var arrFilterDetailsClaim = [AnyObject]()
    
    var arrFilterDetailsRedeem = [AnyObject]()

    
    override func viewDidLoad() {
       
        super.viewDidLoad()

        searchBarRedeemed.delegate = self
        
        tblViewRedem.isHidden = false
        
        lblNoPostFound.isHidden = true
        
        tblViewRedem.register(UINib(nibName: "RedemeedTVcell", bundle: nil), forCellReuseIdentifier: "redemeedTVcell")
        
        tblViewRedem.delegate = self

        tblViewRedem.dataSource = self
        
        self.tblViewRedem.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0);

        callClaimedFlashPostList()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        
        arrFilterDetailsClaim = arrDetailsClaim
        
        arrFilterDetailsRedeem = arrDetailsRedeem
        
        arrDetailsClaim.removeAll()
        
        arrDetailsRedeem.removeAll()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let strSearchText = searchText.replacingOccurrences(of: " ", with: "").localizedLowercase
        
        if strSearchText != "" {
        
            for i in 0..<arrFilterDetailsClaim.count {

                let strValue = arrFilterDetailsClaim[i].value(forKey: "email") as! String
                
                if strValue.contains(strSearchText) {
                    
                    arrDetailsClaim.append(arrFilterDetailsClaim[i])
                }
            }
            
            for i in 0..<arrFilterDetailsRedeem.count {
                
                let strValue = arrFilterDetailsRedeem[i].value(forKey: "email") as! String
                
                if strValue.contains(strSearchText) {
                    
                    arrDetailsRedeem.append(arrFilterDetailsRedeem[i])
                }
            }
        }
        else {
          
            arrDetailsClaim = arrFilterDetailsClaim
            
            arrDetailsRedeem = arrFilterDetailsRedeem
        }
        
        if arrDetailsClaim.count != 0 || arrDetailsRedeem.count != 0 {
            
            tblViewRedem.reloadData()
        }
        else {
            
            tblViewRedem.isHidden = true
            
            lblNoPostFound.isHidden = false
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        searchBar.setShowsCancelButton(false, animated: true)
        
        tblViewRedem.isHidden = false
        
        lblNoPostFound.isHidden = true

        arrDetailsClaim = arrFilterDetailsClaim
        
        arrDetailsRedeem = arrFilterDetailsRedeem
        
        searchBar.text = ""
        
        tblViewRedem.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setUpNavigation()
    }

    
    //MARK: - SetUp Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        self.navigationItem.navTitle(title: "Redeem")
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
         let btnMailBox = UIBarButtonItem(image: UIImage(named: "mailBox"), style: .plain, target: self, action: #selector(btnMailBoxAction))
        
         self.navigationItem.rightBarButtonItems = [btnMailBox]
    }
    
    @objc func btnMailBoxAction(sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "You can send a list of redeemed and unredeemed offers to your registered email to print out. Click send to send the email now.", preferredStyle: .alert)
        
        let sendAction = UIAlertAction(title: "Send", style: .default) { (action) in
            
            self.CallApiUpdateEmail()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        alert.addAction(sendAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // backButton Tapped
    @objc func backButtonTapped() {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
//        boolComingFromRedeem = true
//
//         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTabBarIndex"), object: nil)
    }
    
    
    @IBAction func btnRedeemedAction(_ sender: UIButton) {
        
        callRedeemedFlashPostApi()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            
            return arrDetailsClaim.count
        }
    
        return arrDetailsRedeem.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewSectionHeader = UIView()
        
        viewSectionHeader.frame = tableView.bounds
        
        viewSectionHeader.backgroundColor = UIColor.clear
        
        let lblHeading = UILabel()
        
        lblHeading.frame = CGRect(x: 15, y:0, width: tableView.frame.size.width-30, height: 40)
        
        if section == 0 {
           
            lblHeading.text = "Claimed"
        }
        else {
            
            if arrDetailsRedeem.count > 0{
                
                 lblHeading.text = "Redeemed"
                
            } else {
                
                 lblHeading.text = ""
                
            }
            
           
        }
        
        lblHeading.font = UIFont(name: CustomFont.ubuntuBold.rawValue, size: 17)
        
        lblHeading.textColor = UIColor.black
        
        viewSectionHeader.addSubview(lblHeading)
        
        return viewSectionHeader
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            if !arrDetailsClaim.isEmpty {
                
                return 40
            }
        }
        else {
            
            if !arrDetailsRedeem.isEmpty {
                
                return 40
            }
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tblViewRedem.dequeueReusableCell(withIdentifier: "redemeedTVcell") as! RedemeedTVcell
        
        cell.btnSelect.setImage(#imageLiteral(resourceName: "UncheckBoxBlue"), for: .normal)
        
        cell.btnPhone.addTarget(self, action: #selector(btnPhoneAction), for: .touchUpInside)
        
        cell.btnPhone.isHidden = true
        
        if indexPath.section == 0 {
            
            cell.btnSelect.isHidden = false
            
            cell.btnSelect.addTarget(self, action: #selector(btnSelectAction), for: .touchUpInside)
            
            let strEmail = arrDetailsClaim[indexPath.row].value(forKey: "email") as! String
            
            let strName = arrDetailsClaim[indexPath.row].value(forKey: "name") as! String
            
            let strDate = arrDetailsClaim[indexPath.row].value(forKey: "created_at") as! String
            
            if let strPhone = arrDetailsClaim[indexPath.row].value(forKey: "phone_no") as? String, !strPhone.isEmpty {
                
                cell.btnPhone.setTitle(strPhone, for: .normal)
                
                cell.btnPhone.isHidden = false
            }
           
            cell.lblEmail.text = strEmail
            
            cell.lblName.text = strName
            
            cell.lblDateDescription.text = getDateFormatter(strDate: strDate)
            
            cell.btnSelect.tag = indexPath.row
        }
        else {
            
            cell.btnSelect.isHidden = true
            
           // cell.btnSelect.addTarget(self, action: #selector(btnSelectAction), for: .touchUpInside)
            
            let strEmail = arrDetailsRedeem[indexPath.row].value(forKey: "email") as! String
            
            let strName = arrDetailsRedeem[indexPath.row].value(forKey: "name") as! String
            
            let strDate = arrDetailsRedeem[indexPath.row].value(forKey: "created_at") as! String
            
            if let strPhone = arrDetailsRedeem[indexPath.row].value(forKey: "phone_no") as? String, !strPhone.isEmpty {
                
                cell.btnPhone.setTitle(strPhone, for: .normal)
                
                cell.btnPhone.isHidden = false
            }
            
            cell.lblEmail.text = strEmail
            
            cell.lblName.text = strName
            
            cell.lblDateDescription.text = getDateFormatter(strDate: strDate)
            
           // cell.btnSelect.tag = indexPath.row
        }
     
        return cell
    }

    
    func getDateFormatter(strDate: String) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:s"
        
        let date = dateFormatter.date(from: strDate)
        
        let dateFormatterForDayOnly = DateFormatter()
        
        dateFormatterForDayOnly.dateFormat = "YYYY-MM-dd"
        
        return dateFormatterForDayOnly.string(from: date!)
    }
    
    
    @objc func btnPhoneAction(sender: UIButton) {
        
        let strPhone = sender.titleLabel?.text
        
        if let phoneCallURL = URL(string: "telprompt://\(strPhone ?? "")") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    @objc func btnSelectAction(sender: UIButton) {
        
        let intTag = sender.tag
        
        if sender.imageView?.image == #imageLiteral(resourceName: "checkBoxBlue") {
            
            sender.setImage(#imageLiteral(resourceName: "UncheckBoxBlue"), for: .normal)
            
            if arrSelectedIndex.contains(intTag) {
                
                arrSelectedIndex.remove(at: arrSelectedIndex.index(of: intTag)!)
            }
            
        }
        else {
                        
            if !arrSelectedIndex.contains(intTag) {
            
            arrSelectedIndex.append(intTag)
            }
            
            sender.setImage(#imageLiteral(resourceName: "checkBoxBlue"), for: .normal)
        }
    }
    
    
    func callRedeemedFlashPostApi() {
        
        SVProgressHUD.show()
        
        self.view.isUserInteractionEnabled = false
        
        self.view.endEditing(true)
        
        var dictParams = [String: Any]()
        
        dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
        
        dictParams["post_id"] = strIdFromFlashpost
        
        var strIds = ""
        
        for i in 0..<arrSelectedIndex.count {
           
            var firtselement = String()
            
            var index = Int()
           
            if i == arrSelectedIndex.count - 1 {
            
                index = arrSelectedIndex[i]
                
                let strElement = arrDetailsClaim[index].value(forKey: "id") as! String
                
                firtselement = "\(strElement)"
            }
            else {
                let strElement = arrDetailsClaim[index].value(forKey: "id") as! String
                
                firtselement = "\(strElement),"
            }
            
            strIds.append(firtselement)
        }
        
        dictParams["ids"] = strIds
        
        print(strIds)
        
        RedeemVCManager.sharedInstance.dictParams = dictParams
        
        RedeemVCManager.sharedInstance.RedeemedFlashPost(completionHandler: { (response) in
            
            DispatchQueue.main.async {
                
            print(response)
            
            let strStatus = response["status"] as? String
            
            if strStatus == "true" {
                
                self.arrSelectedIndex.removeAll()
                
                self.view.isUserInteractionEnabled = true

                let strMsg = response["msg"] as? String
                    
                self.moveAfterAlert(strMsg: strMsg!)
            }
            else {
                
                self.view.isUserInteractionEnabled = true
                
                let strMsg = response["msg"] as? String
                
                UIAlertController.Alert(title: "", msg: strMsg!, vc: self)
                
                }
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
               
        }
            
        }, failure: { (strError :String) in
            
            self.view.isUserInteractionEnabled = true
            
            SVProgressHUD.dismiss()
          
            UIAlertController.Alert(title: "", msg: strError, vc: self)
            
        })
    }
    
    
    
    func CallApiUpdateEmail() {
            
            SVProgressHUD.show()
            
            self.view.isUserInteractionEnabled = false
            
            self.view.endEditing(true)
            
            var dictParams = [String: Any]()
            
            dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
            
            dictParams["post_id"] = strIdFromFlashpost
        
            RedeemVCManager.sharedInstance.dictParams = dictParams
            
            RedeemVCManager.sharedInstance.sendEmail(completionHandler: { (response) in
                DispatchQueue.main.async {
                    
                print(response)
                
                    SVProgressHUD.dismiss()
                    
                    self.view.isUserInteractionEnabled = true
                    
                let strStatus = response["status"] as? String
                
                if strStatus == "true" {
                    
                    SVProgressHUD.dismiss()
                        
                        let strMsg = response["msg"] as? String
                        
                        UIAlertController.Alert(title: "", msg: strMsg!, vc: self)
                }
                else {
                    
                    let strMsg = response["msg"] as? String
                    
                    UIAlertController.Alert(title: "", msg: strMsg!, vc: self)
                }
                    
                    self.view.isUserInteractionEnabled = true
                    
                    SVProgressHUD.dismiss()
                }
                
            }, failure: { (strError :String) in
                
                self.view.isUserInteractionEnabled = true
                
                
                SVProgressHUD.dismiss()
                
                UIAlertController.Alert(title: "", msg: strError, vc: self)
                
                print(strError)
            })
            
            //
            //        }
            //
        
    }
    
    func callClaimedFlashPostList() {
        
            SVProgressHUD.show()
            
            self.view.isUserInteractionEnabled = false
            
            self.view.endEditing(true)
            
            var dictParams = [String: Any]()
            
            dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
        
            dictParams["post_id"] = strIdFromFlashpost

            RedeemVCManager.sharedInstance.dictParams = dictParams
            
             RedeemVCManager.sharedInstance.getClaimedFlashPost(completionHandler: { (response) in
              
                DispatchQueue.main.async {
                    
                print(response)
                
                let strStatus = response["status"] as? String
                
                if strStatus == "true" {
                        
                        if let arrPostsData = response["data"] as? [AnyObject] {
//
                        self.arrDetailsClaim.removeAll()
                        
//                        self.arrDetails = arrPostsData
                        
                        for i in 0..<arrPostsData.count {
                            
                            let strStatus = arrPostsData[i].value(forKey: "status") as! String
                            
                            if strStatus == "0" {
                                
                                self.arrDetailsClaim.append(arrPostsData[i])
                            }
                            else if strStatus == "1" {
                                
                                self.arrDetailsRedeem.append(arrPostsData[i])
                            }
                        }
                        
                           self.tblViewRedem.reloadData()
                        }
                    
                    else {
                        
                            self.lblNoPostFound.isHidden = false
                        
                            self.tblViewRedem.isHidden = true
                    }
                            self.view.isUserInteractionEnabled = true
                    
                        
                    self.view.isUserInteractionEnabled = true
                    
                    
                    SVProgressHUD.dismiss()
                    
                    }
                }
            }, failure: { (strError :String) in
                
                self.view.isUserInteractionEnabled = true
                
                SVProgressHUD.dismiss()
                
                UIAlertController.Alert(title: "", msg: strError, vc: self)
                
                print(strError)
            })
        
}
    
    func moveAfterAlert(strMsg: String) {
        
        let Alert = UIAlertController(title: "", message: strMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { (result : UIAlertAction) -> Void in
            
            self.view.endEditing(true)
            
            self.callClaimedFlashPostList()
        }
        
        Alert.addAction(okAction)
        
        self.present(Alert, animated: true, completion: nil)
    }
    
    
}
