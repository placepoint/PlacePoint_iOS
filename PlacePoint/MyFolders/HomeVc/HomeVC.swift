//
//  HomeVC.swift
//  PlacePoint
//
//  Created by MRoot on 06/10/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher
import AVKit
import YouTubePlayer
import MediaPlayer
import AppsFlyerLib


class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, OpenLink, ExpandableLabelDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var viewWelcome: UIView!
    
    var homeTutorialView = HomeTutorialView()
    
    @IBOutlet weak var txtFldName: UITextField!
    
    @IBOutlet weak var txtFldEmail: UITextField!
    
    @IBOutlet weak var txtFldPhone: UITextField!
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    @IBOutlet weak var tblViewFlashposts: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var arrFlashPosts = [AnyObject]()
    
    var states = [Bool]()
    
//    var strMsg = "firstTime"
    
    var intClaimedPerEmailId = Int()
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var viewConatinedContent: UIView!
    
    @IBOutlet weak var viewClaimOffer: UIView!
    
    var intTag = Int()
    
    let timeFormatter = TTTTimeIntervalFormatter()

    
    var boolPullToRefresh = false
    
    var arrIndexPath = [Int]()
    
    var arrStatus1 = [String]()
    
    var tagVideo = Int()
    
    var checkPlayPause = String()
    
    var playPauseTag = Int()
    
    var tagYouTubeVideo = Int()
    
    var isYouTubePlayerPlaying = Bool()
    
    var boolarrReady = false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        AppsFlyerTracker.shared().trackEvent(AFEventPurchase,
//                                             withValues: [
//                                                AFEventParamRevenue: "1200",
//                                                AFEventParamContent: "shoes",
//                                                AFEventParamContentId: "123"
//            ]);
        
        
        tblViewFlashposts.tableFooterView = UIView()
        
        lblNoDataFound.isHidden = false

        tblViewFlashposts.isHidden = false
        
        UpdateOneSignalToAPi()
        
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: Notification.Name("UpdateOneSignalIdToApi"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOneSignal), name: Notification.Name("UpdateOneSignal_multipleSelection"), object: nil)


        
//        let checkFirstLaunch = UserDefaults.standard.getisFirstlaunch()
//
//        if checkFirstLaunch == true {
//
//            let window = appDelegate.window
//
//            homeTutorialView = Bundle.main.loadNibNamed("HomeTutorialView", owner: nil, options: nil)?[0] as! HomeTutorialView
//
//            homeTutorialView.frame = CGRect(x: 0, y: 0, width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight)
//
//            window?.addSubview(homeTutorialView)
//        }
        
        setUpTableView()
        
        
        
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        
        refreshControl.tintColor = UIColor.themeColor()
    }
    
    func showAlert(){
        
        let alert = UIAlertController.init(title: "Alert", message: "PlacePoint is launching in Athlone on the 1st of February. Please note the current data being shown is only test data. Make sure you keep the app installed to ensure you get notifications of new special offers as we have over €1,000 in giveaways and promotions from February the 1st.", preferredStyle: .alert)
        
        let actionOk = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            
            showAthlonePopUp = false
        }
        
        alert.addAction(actionOk)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func UpdateOneSignalToAPi() {
        
        print("asdas")
        
        let strValue = UserDefaults.standard.getkDeviceId()
        
        if strValue != "1" {
            
            let boolIDSentToApi = UserDefaults.standard.GetoneSignalSentToAPi()
            
            if !boolIDSentToApi {
                
                ApiUpdateOneSignalId()
            }
        }
    }
    
    @objc func recieveNotification(sender: NSNotification) {
        
        UpdateOneSignalToAPi()
    }
    
    
    @objc func updateOneSignal(sender: NSNotification) {
        
        ApiUpdateOneSignalId()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtFldName {
            
            txtFldEmail.becomeFirstResponder()
            
            return false
        }
        else if textField == txtFldEmail {
            
            txtFldPhone.becomeFirstResponder()
            
            return false
        }
        else {
            
            txtFldName.resignFirstResponder()
            
            return true
        }
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
       
        boolPullToRefresh = true
        
        CallApiFlashPost()
    }
    
    func firstLogin(){
        
          UserDefaults.standard.setfirstTimeLoginPopUp(value: true)
        
        let alert = UIAlertController.init(title: "Alert", message: "Thanks for Downloading PlacePoint. Deals are limited to a specific number so they can sometimes sell out in hours. We usually have 1-3 deals per week so keep the app installed if the current deals are expired to get an instant notification when the next deal is available.", preferredStyle: .alert)
        
        let actionOk = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            
          
        }
        
        alert.addAction(actionOk)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let isKeyExists = CommonClass.sharedInstance.keyAlreadyExists(Key: "first_login")
        
        if isKeyExists == false {
            self.firstLogin()
        }
        
        
//        if isKeyExists == true {
//
//            let isFirstTimeLogin = UserDefaults.standard.getfirstTimeLoginPopUp()
//
//            if isFirstTimeLogin == false {
//
//            }
//        }
        
       
        super.viewWillAppear(animated)
        
        txtFldName.text = ""
        
        txtFldEmail.text = ""
        
        self.setUpNavigation()
        
        CallApiFlashPost()
        
        viewClaimOffer.isHidden = true
        
        if heightOfTabbar != 0 {
            
            tblViewFlashposts.frame.size.height = (DeviceInfo.TheCurrentDeviceHeight - heightOfTabbar) - tblViewFlashposts.frame.origin.y
        }
        
    }
    
    // MARK:- SetUp tableView
    func setUpTableView() {
        
        let nib = UINib(nibName: "FieldTableViewCell", bundle: nil)
        
        self.tblViewFlashposts.register(nib, forCellReuseIdentifier: "FieldTableViewCell")
        
        self.tblViewFlashposts.dataSource = self
        
        self.tblViewFlashposts.delegate = self
        
        tblViewFlashposts.estimatedRowHeight = 200
        
        tblViewFlashposts.rowHeight = UITableViewAutomaticDimension
        
        tblViewFlashposts.refreshControl = refreshControl

        tblViewFlashposts.addSubview(refreshControl)
    }
    
    
    @IBAction func btnDoneClaimActiom(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        let strName = txtFldName.text?.replacingOccurrences(of: " ", with: "")
        
        let strEmail = txtFldEmail.text?.replacingOccurrences(of: " ", with: "")
        
        let strPhone = txtFldPhone.text?.replacingOccurrences(of: " ", with: "")
        
        guard !(strName?.isEmpty)! && !(strEmail?.isEmpty)! && !(strPhone?.isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "Please Enter Details", vc: self)
            
            return
        }
        
        guard (strEmail?.isValidEmail())! else {
            UIAlertController.Alert(title: "", msg: "Please Enter Valid Email id", vc: self)
            
            return
        }
       
        callApiClaimDeal(strEmail: strEmail!, strName: strName!, strPhone: strPhone!, index: intTag)
    }
    
    
    @IBAction func btnCancelClaimAction(_ sender: UIButton) {
        
        self.view.endEditing(true)

        viewClaimOffer.isHidden = true
    }
    
    
    // MARK: - Set Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        self.navigationItem.navTitle(title: "Flash Sales")
    }
   
    
    func CallApiFlashPost() {
        
        if boolPullToRefresh == false {
            
            arrFlashPosts.removeAll()
        }
        
//        arrFlashPosts.removeAll()
        
        let townName = UserDefaults.standard.getTown()
        let arrTown = UserDefaults.standard.getArrTown()
        let strTownId = CommonClass.sharedInstance.getLocationId(strLocation: townName, array: arrTown)

        //Priya
      
        let arrFTown = UserDefaults.standard.getMultipleTownsForFlashDeal()
        
        let stringFTown =    arrFTown.compactMap { String($0 as! Int) }.joined(separator: ",")
        
        let arrFCategory = UserDefaults.standard.getMultipleCatForFlashDeal()
        
        let stringFCategory =    arrFCategory.compactMap { String($0 as! Int) }.joined(separator: ",")
        
            SVProgressHUD.show()
            
            self.view.isUserInteractionEnabled = false
            
            self.view.endEditing(true)
            
            var dictParams = [String: Any]()
            
            dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
            
            dictParams["town_id"] = stringFTown
            
            dictParams["category_id"] = stringFCategory
        
            dictParams["limit"] = "100"
            
            dictParams["page"] = "0"
            
            print(dictParams)
            
            HomeVCManager.sharedInstance.dictParams = dictParams
        
            HomeVCManager.sharedInstance.getHomeFlashPost(completionHandler: { (response) in
                
                DispatchQueue.main.async {
                
                print(response)
                
                let strStatus = response["status"] as? String
                
                if strStatus == "true" {

                    let arrPostsData = response["data"] as? [AnyObject]
                    
                    if (arrPostsData?.count)! > 0 {
                        
                        self.arrFlashPosts = arrPostsData!
                        
                        if !self.boolarrReady {
                        
                        self.arrStatus1 = [String](repeating: "1", count: self.arrFlashPosts.count)
                        
//                         self.arrStatus2 = [String](repeating: "1", count: self.arrFlashPosts.count)
                            
                            self.boolarrReady = true
                        }
                        print(arrPostsData!)
                        
                        self.states = [Bool](repeating: true, count: self.arrFlashPosts.count)
                        
                        self.refreshControl.endRefreshing()
                        
                        self.tblViewFlashposts.reloadData()
                       
                        self.view.isUserInteractionEnabled = true
                }
                    
                    self.refreshControl.endRefreshing()
                    
                    SVProgressHUD.dismiss()
                    
                    self.view.isUserInteractionEnabled = true
                    
//                    let arrCategory = response["category"] as? [AnyObject]
                    
                    let arrCategory = (response["category"] as? NSArray)!
                    
                    let descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                    
                    let sortedResults: NSArray = arrCategory.sortedArray(using: [descriptor]) as NSArray
                    
                    
                    
                    UserDefaults.standard.setArrCategories(value: sortedResults as [AnyObject])
                    
                    AppDataManager.sharedInstance.arrCategories = sortedResults as [AnyObject]
                    
                    let arrLocation = response["location"] as? [AnyObject]
                    
                    UserDefaults.standard.setArrTown(value: arrLocation!)
                    
                    AppDataManager.sharedInstance.arrTowns = arrLocation!
           }
                else if strStatus == "false" {
                    
                    self.refreshControl.endRefreshing()
                    
                    SVProgressHUD.dismiss()
                    
                    self.view.isUserInteractionEnabled = true
                    
                    self.viewWelcome.isHidden = true
                    
                    self.lblNoDataFound.isHidden = false
                    
                    self.tblViewFlashposts.isHidden = true
                }
                
                    /*if showAthlonePopUp {
                        
                        self.showAlert()
                    }*/
                }
            }, failure: { (strError :String) in
                
                self.viewWelcome.isHidden = true
                
                self.lblNoDataFound.isHidden = false
                
                self.tblViewFlashposts.isHidden = true
                
                self.refreshControl.endRefreshing()
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true

                UIAlertController.Alert(title: "", msg: strError, vc: self)
                
                /*if showAthlonePopUp {
                    
                    self.showAlert()
                }*/
                
//                print(strError)
            })
            
//
//        }
//

       
    }
    
    
    func callApiClaimDeal(strEmail :String, strName: String, strPhone: String, index: Int) {
        
        SVProgressHUD.show()
        
        self.view.isUserInteractionEnabled = false
        
        self.view.endEditing(true)
        
        var dictParams = [String: Any]()
        
        dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
        
        let strId = arrFlashPosts[index].value(forKey: "id") as! String
        
        dictParams["post_id"] = strId
        
        dictParams["email"] = strEmail
        
        dictParams["name"] = strName
        
        dictParams["phone_no"] = strPhone
        
        print(dictParams)
        
        HomeVCManager.sharedInstance.dictParams = dictParams
        
        HomeVCManager.sharedInstance.getClaimFlashPost(completionHandler: { (response) in
            
            DispatchQueue.main.async {
                
                self.txtFldName.text = ""
                
                self.txtFldEmail.text = ""
                
            print(response)
                
                if !self.arrIndexPath.contains(index) {
                
                self.arrIndexPath.append(index)
                }
                
            let strStatus = response["status"] as? String
            
            if strStatus == "true" {

                 SVProgressHUD.dismiss()
                
                let strMsgForAlert = response["msg"] as! String
                
                self.intClaimedPerEmailId = response["claimed"] as! Int
                
                self.arrStatus1[index] = " "
                
                    self.moveAfterAlert(strMsg: strMsgForAlert)
                    
                    self.viewClaimOffer.isHidden = true

                    self.view.isUserInteractionEnabled = true
                        
                    }
                
                else {
                
                     SVProgressHUD.dismiss()
                
                let strMsg = response["msg"] as! String
                
                self.arrStatus1[index] = "ios"
                
               self.moveAfterAlert(strMsg: strMsg)
                
                self.viewClaimOffer.isHidden = true
                
                self.view.isUserInteractionEnabled = true
            }
            }
        }, failure: { (strError :String) in
            
           
            
//            self.strMsg = "firstTime"
              DispatchQueue.main.async {
                
                 SVProgressHUD.dismiss()
            
            self.txtFldName.text = ""
            
            self.txtFldEmail.text = ""
            
            self.view.isUserInteractionEnabled = true
                
                
            
            UIAlertController.Alert(title: "", msg: strError, vc: self)
                
            }
        })
    }
    
    
    
    func ApiUpdateOneSignalId() {
        
        let arrFTown = UserDefaults.standard.getMultipleTownsForFlashDeal()
        
        let stringFTown =    arrFTown.compactMap { String($0 as! Int) }.joined(separator: ",")
        
        let arrFCategory = UserDefaults.standard.getMultipleCatForFlashDeal()

         let stringFCategory =    arrFCategory.compactMap { String($0 as! Int) }.joined(separator: ",")
        
            var dictParams = [String: Any]()
        
            dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
        
            dictParams["town_id"] = stringFTown
        
            dictParams["onesignal_id"] = UserDefaults.standard.getkDeviceId()
        
          dictParams["category_id"] = stringFCategory
        
            print(dictParams)
        
            HomeVCManager.sharedInstance.dictParams = dictParams
        
            HomeVCManager.sharedInstance.updateOnesignalid(completionHandler: { (response) in
                   DispatchQueue.main.async {
                print(response)
                
                let strStatus = response["status"] as? String
                
                if strStatus == "true" {
                    
                    UserDefaults.standard.SetoneSignalSentToAPi(kDeviceIdSentToApi: true)
                        
                    
                        }
                    
                    self.view.isUserInteractionEnabled = true
                    SVProgressHUD.dismiss()
                }
        
            }, failure: { (strError :String) in
                
                self.view.isUserInteractionEnabled = true
                
                SVProgressHUD.dismiss()
                
                print(strError)
            })
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrFlashPosts.count
    }
    
   
    
    


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentSource = preparedSources(index: indexPath)[0]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FieldTableViewCell") as? FieldTableViewCell
        
//        cell?.lblTown.text = ""
        
        cell?.iconBump.isHidden = true
        
        cell?.btnBumpPost.isHidden = true
        
        cell?.btnOpenUrl.isHidden = true
        
        print(arrFlashPosts.count)
        
        if  checkMyTimeLine == "My Posts" {
            
            cell?.iconBump.isHidden = false
            
            cell?.btnBumpPost.isHidden = false
            
        } else {
            
            cell?.iconBump.isHidden = true
            
            cell?.btnBumpPost.isHidden = true
        }
        
        cell?.btnBumpPost.tag = indexPath.row
        
        cell?.viewConatinedLblRedemtionLeft.isHidden = true
        
//        image == #imageLiteral(resourceName: "share")
//        cell?.btnMore.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        
        cell?.btnClaimoffer.addTarget(self, action: #selector(btnClaimOfferAction), for: .touchUpInside)
        
        cell?.btnClaimoffer.tag = indexPath.row
        
        cell?.viewClaimButton.isHidden = false
        
        cell?.viewTopFlashOffer.isHidden = false
        
        cell?.imgViewShare.image = #imageLiteral(resourceName: "share")
        
        print(indexPath.row)
        
        if arrFlashPosts.count > 0 {
        
            let strExpiryStatus = arrFlashPosts[indexPath.row].value(forKey: "expired") as! Int
            
            print(arrFlashPosts[indexPath.row])
        
            let strValidity = arrFlashPosts[indexPath.row].value(forKey: "validity_date") as! String
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateValidity = dateFormatter.date(from: strValidity)
            
            let currentDate = Date()
            
            timeFormatter.usesAbbreviatedCalendarUnits = true
            
            let  strLastSeen = timeFormatter .stringForTimeInterval(from: currentDate, to: dateValidity)
        
           if strExpiryStatus == 1 {
            
            let strRedeemed = arrFlashPosts[indexPath.row].value(forKey: "redeemed") as! String
            
            if strRedeemed == "0" {
                
//                cell?.lblAlertSale.text = String(format:"***Expired %@ ***",strLastSeen! )
                cell?.lblAlertSale.text = "***Expired***"
            } else {
                
                cell?.lblAlertSale.text = String(format:"*Expired \(strRedeemed) offer(s) claimed* %@ ",strLastSeen! )
                
//                "***Expired \(strLastSeen) offer(s) claimed***"
                
//                cell?.lblAlertSale.text = ""
            }
            
            
            cell?.lblAlertSale.backgroundColor = UIColor.LblExpired()
            
            cell?.viewClaimButton.isHidden = true
        }
        else {
            
            let expiryDate = arrFlashPosts[indexPath.row].value(forKey: "validity_date") as! String
            
            let strCalculatedDifference = calCulateDate(strDate: expiryDate)
            
            let strMax_redemption = arrFlashPosts[indexPath.row].value(forKey: "max_redemption") as! String
            
            let strRedeemed = arrFlashPosts[indexPath.row].value(forKey: "redeemed") as! String
            
            let intMax_redemption = Int(strMax_redemption)
            
            let intRedeemed = Int(strRedeemed)
            
            var result = Int()
            
            if arrIndexPath.contains(indexPath.row) {
                
                if arrStatus1[indexPath.row] == " " {
                    
                    if intRedeemed != 0 {
                        
                        cell?.lblRedemptionLeft.layer.cornerRadius = 8
                        
                        let strintClaimedPerEmailId = String(intClaimedPerEmailId)
                        
                        if intClaimedPerEmailId == 1 {
                            
                            cell?.lblRedemptionLeft.text = "\(strintClaimedPerEmailId) Offer successfully Claimed. To redeem visit the business and mention your name and email address."
                        }
                        else {
                            
                            cell?.lblRedemptionLeft.text = "\(strintClaimedPerEmailId) Offers successfully Claimed. To redeem visit the business and mention your name and email address."
                        }
                        
                        cell?.viewConatinedLblRedemtionLeft.isHidden = false
                    }
                }
                else if arrStatus1[indexPath.row] == "ios" {
                    
                    cell?.lblRedemptionLeft.layer.cornerRadius = 8
                    
                    if intRedeemed == 1 {
                        
                        cell?.lblRedemptionLeft.text = "\(strRedeemed) Offer successfully Claimed. To redeem visit the business and mention your name and email address."
                    }
                    else {
                        
                        cell?.lblRedemptionLeft.text = "\(strRedeemed) Offers successfully Claimed. To redeem visit the business and mention your name and email address."
                    }
                    
//                    if !arrIndexPath.contains(indexPath.row) {
//
//                        arrIndexPath.append(indexPath.row)
//                    }
                    
                    cell?.viewConatinedLblRedemtionLeft.isHidden = false
                }
            }
            else {
                
                cell?.viewConatinedLblRedemtionLeft.isHidden = true
            }
            
            
           
            
            if intRedeemed! < intMax_redemption! {
                
                 result = intMax_redemption! - intRedeemed!
                
                cell?.lblExpiry.text = "Hurry Expires in \(strCalculatedDifference) - Only \(String(result)) left"
                
                cell?.lblAlertSale.text = "***Flash Alert Sale***"
                
//                cell?.lblAlertSale.backgroundColor = UIColor.LblALertSale()
                
                 cell?.lblAlertSale.backgroundColor = UIColor.clear
                
                cell?.viewClaimButton.isHidden = false
                
                cell?.btnClaimoffer.isHidden = false
                
//                cell?.heightConstraintBottomView.constant = 90
            }
            else if intRedeemed! == intMax_redemption! {
                
                cell?.viewClaimButton.isHidden = true
                
                cell?.lblAlertSale.backgroundColor = UIColor.LblExpired()
                
                cell?.lblAlertSale.text = String(format:"*Expired \(strMax_redemption) offer(s) claimed* %@ ",strLastSeen! )
                
//                cell?.lblAlertSale.text = String(format:"***Expired %@ ***",strLastSeen! )
                
//                cell?.lblAlertSale.text = "***Expired \(strMax_redemption) offer(s) claimed***"
                
                cell?.viewConatinedLblRedemtionLeft.isHidden = true
                
//                cell?.lblExpiry.text = "0Left"
                
//                cell?.btnClaimoffer.isHidden = true
                
//                cell?.heightConstraintBottomView.constant = 50
                
//                cell?.layoutIfNeeded()
            }
            
//            if arrIndexPath.contains(indexPath.row) {
//
//                cell?.lblRedemptionLeft.layer.cornerRadius = 8
//
//                if intRedeemed == 1 {
//
//                    cell?.lblRedemptionLeft.text = "\(strRedeemed) Offer successfully Claimed. To redeem visit the business and mention your name and email address."
//                }
//                else {
//
//                    cell?.lblRedemptionLeft.text = "\(strRedeemed) Offers successfully Claimed. To redeem visit the business and mention your name and email address."
//                }
//
//                cell?.viewConatinedLblRedemtionLeft.isHidden = false
//
//        }
        }
        
//        self.strMsg = "firstTime"
        
        
             cell?.viewYoutube.backgroundColor = UIColor.black
            let strVideoLink = arrFlashPosts[indexPath.row].value(forKey: "video_link") as? String
            
            cell?.imgYouTubeThumb.isHidden = true
            
            if strVideoLink != "" {
                
                cell?.viewYoutube.isHidden = false
                
                if (strVideoLink?.contains("youtu"))! {
                    
                    tagYouTubeVideo = indexPath.row
                    
                    cell?.playButtonFbPlayer.isHidden = true
                    
                    cell?.imgPlayPause.isHidden = true
                    
                    cell?.viewFbPlayer.isHidden = true
                    cell?.viewYouTubePlayer.delegate = self
                    cell?.viewYouTubePlayer.isHidden = false
                    
                    cell?.imgYouTubeThumNail.isHidden = false
                    
                    cell?.btnOpenUrl.tag = indexPath.row
                    
                    let strvideoURL = URL(string:strVideoLink!)
                    
                    cell?.viewYouTubePlayer.loadVideoURL(strvideoURL!)
                    
                    
                } else if ((strVideoLink?.contains("flv"))!
                    || ((strVideoLink?.contains("facebook"))!)) {
                    
                    cell?.viewYoutube.backgroundColor = UIColor.white
                    cell?.viewYoutube.isHidden = true
                   
                    cell?.viewFbPlayer.isHidden = true
 //                 cell?.imgYouTubeThumb.isHidden = false
                      cell?.imgPlayPause.isHidden = true
                    
                    cell?.playButtonFbPlayer.isHidden = true
                    
                    cell?.imgYouTubeThumNail.isHidden = true
                    
                    cell?.btnOpenUrl.tag = indexPath.row
                    
//                     cell?.vwTextUrl.isHidden = false
                    
                     cell?.btnOpenUrl.isHidden = false
                     cell?.btnOpenUrl.setTitle(strVideoLink, for: .normal)
                   //  cell?.lblFbLink.isHidden = false
                    
                   // cell?.lblFbLink.text = strVideoLink
                    
//                    let url = self.createThumbnailUrlVideoFromFileURL(videoURL: strVideoLink!)
//
//                    cell?.imgYouTubeThumNail.kf.indicatorType = .activity
//
//                    (cell?.imgYouTubeThumNail.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
//
//                    cell?.imgYouTubeThumNail.kf.setImage(with: url,
//                                                         placeholder:#imageLiteral(resourceName: "placeholder"),
//                                                         options: [.transition(ImageTransition.fade(1))],
//                                                         progressBlock: { receivedSize, totalSize in
//                    },
//                                                         completionHandler: { image, error, cacheType, imageURL in
//                    })
                }
                
                
                
                
                
                
                else {
                    
                    let strvideoURL = URL(string:strVideoLink!)
                    
                   let player = AVPlayer(url: strvideoURL!)
                    
//                    if (strVideoLink?.contains("flv"))!{
//
//                        cell?.playButtonFbPlayer.isHidden = true
//                        cell?.imgPlayPause.isHidden = false
//                        cell?.btnOpenUrl.isHidden = false
//                        cell?.btnOpenUrl.tag = indexPath.row
//
//
//                    } else {
                    
                         cell?.btnOpenUrl.isHidden = true
                        cell?.playButtonFbPlayer.isHidden = false
                        cell?.imgPlayPause.isHidden = false
//                    }
                    
                
                    
                    cell?.viewFbPlayer.playerLayer.frame = (cell?.viewYoutube.bounds)!
                    

                    cell?.playButtonFbPlayer.tag = indexPath.row
                    
                    cell?.playButtonFbPlayer.addTarget(self, action: #selector(playerClick(_:)), for: .touchUpInside)
                    
                    cell?.viewYouTubePlayer.pause()
                    
                    cell?.viewYouTubePlayer.isHidden = true
                    
                    cell?.viewFbPlayer.isHidden = false
                    
                    cell?.viewFbPlayer.playerLayer.player = player
                    
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object:  cell?.viewFbPlayer.player!.currentItem, queue: nil) { (_) in
                        cell?.viewFbPlayer.player?.seek(to: kCMTimeZero)
                        
                        cell?.viewFbPlayer.player?.play()
                        cell?.viewFbPlayer.player?.playImmediately(atRate: 1.0)
                        
                    }
                    
                }
                
                
            }
            else {
                
                cell?.viewYoutube.isHidden = true
                
                cell?.imgYouTubeThumNail.isHidden = true
            }
            
            cell?.btnMore.isHidden = false
            
            cell?.delegate = self
            
            cell?.btnMore.tag = indexPath.row
            
           // cell?.lblDescription.setLessLinkWith(lessLink: " ...less", attributes: [.foregroundColor: UIColor.themeColor()], position: currentSource.textAlignment)
            
            cell?.layoutIfNeeded()
            
           // cell?.lblDescription.delegate = self
            
          //  cell?.lblDescription.shouldCollapse = true
            
          //  cell?.lblDescription.textReplacementType = currentSource.textReplacementType
            
          //  cell?.lblDescription.numberOfLines = currentSource.numberOfLines
            
           // cell?.lblDescription.collapsed = states[indexPath.row]
            
          //  cell?.lblDescription.text = currentSource.text
          
            let strHttp = currentSource.text.components(separatedBy: " ")
            
            var strLink = String()
            
            if let strValue = strHttp.first(where: { (($0 as String).hasPrefix("(http")) || (($0 as String).hasPrefix("http")) || (($0 as String).hasPrefix("www"))}) {
                
                strLink = strValue
            }
            
            let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                              NSAttributedStringKey.font: UIFont(name: CustomFont.ubuntuRegular.rawValue, size: 15)]
            
           // let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font:fontCutom]

            cell?.lblDescription.attributedText = NSAttributedString(string: currentSource.text, attributes: attributes as [NSAttributedStringKey : Any])
            
            //Step 2: Define a selection handler block
            let handler = {
                (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
                
                guard let url = URL(string: substring!) else {
                    return
                }
                
                if #available(iOS 10.0, *) {
                    
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                else {
                    
                    UIApplication.shared.openURL(url)
                }
            }
            
            //Step 3: Add link substrings
            cell?.lblDescription.setLinksForSubstrings([strLink], withLinkHandler: handler)
            
            cell?.setData(arr: arrFlashPosts, index: indexPath.row)
            
            cell?.selectionStyle = .none
            
            if arrFlashPosts.count > 0 {
                cell?.showFPostTown(dict: (arrFlashPosts[indexPath.row] as! NSDictionary))
                cell?.reloadCollectionView(dict: (arrFlashPosts[indexPath.row] as! NSDictionary))
            }
        }
        
        return (cell)!
    }
    
    
    @objc func btnClaimOfferAction(sender: UIButton) {

        viewConatinedContent.shadow()
        
        viewClaimOffer.isHidden = false
        
        intTag = sender.tag
        
    }
    
    func calCulateDate(strDate: String) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        var date = dateFormatter.date(from: strDate)
        
        if date == nil {
            
            dateFormatter.dateFormat = "YYYY-dd-MM"
            
             date = dateFormatter.date(from: strDate)
        }
        
        let calCulatedString = offsetFrom(date: date!)
        
        return calCulatedString
    }
    
    
    func offsetFrom(date : Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: Date(), to: date);
        
//        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " "
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day = difference.day, day > 0 { return days }
        if let hour = difference.hour, hour > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
//        if let second = difference.second, second > 0 { return seconds }
        
        if let day = difference.day, day < 0 { return days }
        if let hour = difference.hour, hour < 0 { return hours }
        if let minute = difference.minute, minute < 0 { return minutes }
//        if let second = difference.second, second < 0 { return seconds }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isBusinessDetail == false {
            
            let feedDetailsVC = BuisnessShowFeedVc(nibName: "BuisnessShowFeedVc", bundle: nil)
            
            isBusinessDetail = true
            
            isShowBusinessDetail = true
            
            let dict = arrFlashPosts[indexPath.row] as? NSDictionary
            
            let strBusId =   dict!["bussness_id"] as! String
            
            let strBusinessName = dict!["business_name"] as? String
            
            businessName = strBusinessName!
            
            if isChooseCategoryVc == true {
                
                let category = UserDefaults.standard.getSelectedCat()
                
                selectedCategory = category
                
            }
            
            strBusinessId = strBusId
            
            self.navigationController?.pushViewController(feedDetailsVC, animated: true)
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func moveAfterAlert(strMsg: String) {
        
        let Alert = UIAlertController(title: "", message: strMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { (result : UIAlertAction) -> Void in
            
            self.view.endEditing(true)
            
//            if self.strMsg == "ios"{
//
//                self.tblViewFlashposts.reloadData()
//            }
//            else {
            
            self.CallApiFlashPost()
        
        }
        Alert.addAction(okAction)
        
        self.present(Alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Exapndable Label
    func preparedSources(index: IndexPath) -> [(text: String, textReplacementType: ExpandableLabel.TextReplacementType, numberOfLines: Int, textAlignment: NSTextAlignment)] {
        
        return [(loremIpsumText(index: index), .word, 6, .right)]
    }
    
    
    func loremIpsumText(index: IndexPath) -> String {
        
        if index.row >= arrFlashPosts.count {
            
            return ""
            
        }
        else {
            
            return (arrFlashPosts[index.row]).value(forKey: "description") as! String
        }
    }
    
    
    func btnMore(index: Int) {
        
        let alert = UIAlertController(title: "Alert",message: "You are about to share an image to Facebook. Facebook does not allow us to send the text from the image automatically. We have copied the text from the post to the clipboard for your convenience. If you would like to add the text to the image please paste it into the comment section on the next section when sharing the post.",preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
            
            let indexPath = IndexPath(row: index, section: 0)
            
            let cell = self.tblViewFlashposts.cellForRow(at: indexPath) as? FieldTableViewCell
            cell?.btnBumpPost.tag = indexPath.row
            let textToShare = cell?.lblDescription.text
            
            let dict = self.arrFlashPosts[indexPath.row] as? NSDictionary
            
            let imgUrl = dict!["image_url"] as? String
            
            if let myWebsite = NSURL(string: imgUrl!) {
                
                let objectsToShare = [textToShare, myWebsite] as [Any]
                
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                activityVC.popoverPresentationController?.sourceView = self.view
                
                self.present(activityVC, animated: true, completion: nil)
            }
            
            let text = dict!["description"] as? String
            
            UIPasteboard.general.string = text
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openUrlLink(videoUrl: String) {
        
        self.openUrl(strVideoUrl: videoUrl)
    }
    
    
    func btnFlash(index: Int) {
        
//        let vc = RedeemVC(nibName: "RedeemVC", bundle: nil)
//
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { ($0.name == "v") })?.value
    }
    
    
    func createThumbnailUrlVideoFromFileURL(videoURL: String) -> URL? {
        
        let videoId = self.getYoutubeId(youtubeUrl: videoURL)
        
        var youtubeLink = String()
        
        if let video_id = videoId {
            
            youtubeLink = "http://img.youtube.com/vi/\(video_id)/0.jpg"
        }
        
        let urlYoutube = URL(string: youtubeLink)
        
        return urlYoutube
        
    }
    
    
    func openUrl(strVideoUrl: String) {
        
        guard let url = URL(string: strVideoUrl) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
        else {
            
            UIApplication.shared.openURL(url)
        }
    }
    
    
    func willExpandLabel(_ label: ExpandableLabel) {
        
        tblViewFlashposts.beginUpdates()
    }
    
    
    func didExpandLabel(_ label: ExpandableLabel) {
        
        let point = label.convert(CGPoint.zero, to: tblViewFlashposts)
        
        if let indexPath = tblViewFlashposts.indexPathForRow(at: point) as IndexPath? {
            
            states[indexPath.row] = false
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tblViewFlashposts.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
        tblViewFlashposts.endUpdates()
    }
    
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        
        tblViewFlashposts.beginUpdates()
    }
    
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
        let point = label.convert(CGPoint.zero, to: tblViewFlashposts)
        
        if let indexPath = tblViewFlashposts.indexPathForRow(at: point) as IndexPath? {
            
            states[indexPath.row] = true
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tblViewFlashposts.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
        tblViewFlashposts.endUpdates()
    }
}
extension HomeVC: YouTubePlayerDelegate {
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        
        if playerState == .Playing {
            isYouTubePlayerPlaying = true
            let iP = IndexPath(row: tagVideo, section: 0)
            playPauseTag = tagVideo
            let fullyVisibleCell = tblViewFlashposts.cellForRow(at: iP) as! FieldTableViewCell
            
            //             fullyVisibleCell.playButtonFbPlayer.setTitle("Play", for: .normal)
            fullyVisibleCell.imgPlayPause.image = UIImage(named:"Play")
            fullyVisibleCell.viewFbPlayer.player?.pause()
            playPauseTag = tagVideo
            
        }
        
        
        print(playerState)
        
    }
    
    @objc private func playerClick(_ sender: UIButton?) {
        
        if playPauseTag != 987658 {
            
            
            let iP = IndexPath(row: sender!.tag, section: 0)
            
            let fullyVisibleCell = tblViewFlashposts.cellForRow(at: iP) as! FieldTableViewCell
            fullyVisibleCell.imgPlayPause.image = UIImage(named:"Pause")
            fullyVisibleCell.viewFbPlayer.player?.seek(to: kCMTimeZero)
            
            
            let iPYouTube = IndexPath(row: tagYouTubeVideo, section: 0)
            
            let YouTubeCell = tblViewFlashposts.cellForRow(at: iPYouTube) as? FieldTableViewCell
            
            if YouTubeCell != nil {
                
                YouTubeCell!.viewYouTubePlayer.pause()
                
            }
            
            fullyVisibleCell.viewFbPlayer.player?.play()
            
            fullyVisibleCell.viewFbPlayer.player?.playImmediately(atRate: 1.0)
            tagVideo = sender!.tag
            
            playPauseTag = 987658
            
            
        } else {
            
            
            let iP = IndexPath(row: sender!.tag, section: 0)
            
            let fullyVisibleCell = tblViewFlashposts.cellForRow(at: iP) as! FieldTableViewCell
            fullyVisibleCell.imgPlayPause.image = UIImage(named:"Play")
            
            fullyVisibleCell.viewFbPlayer.player?.pause()
            tagVideo = sender!.tag
            playPauseTag = sender!.tag
        }
        
        
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let iP = IndexPath(row: tagYouTubeVideo, section: 0)
        
        let YouTubeCell = tblViewFlashposts.cellForRow(at: iP) as? FieldTableViewCell
        
        if YouTubeCell != nil {
            
            YouTubeCell!.viewYouTubePlayer.pause()
            
        }
        
        let iPVideo = IndexPath(row: tagVideo, section: 0)
        
        let fullyVisibleCell = tblViewFlashposts.cellForRow(at: iPVideo) as? FieldTableViewCell
        
        if fullyVisibleCell != nil {
            
            fullyVisibleCell!.imgPlayPause.image = UIImage(named:"Play")
            fullyVisibleCell!.viewFbPlayer.player?.pause()
            playPauseTag = tagVideo
            
        }
    }
    
    
}
