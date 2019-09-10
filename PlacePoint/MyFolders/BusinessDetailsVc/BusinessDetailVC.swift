//
//  BusinessDetailVC.swift
//  PlacePoint
//
//  Created by Mac on 19/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//
import UIKit
import SVProgressHUD
import MMDrawerController
import CoreLocation

class BusinessDetailVC: UIViewController {
    
    @IBOutlet var vwLoading: UIView!
    
    @IBOutlet var lblNoPost: UILabel!
    
    @IBOutlet weak var tblPubDetail: UITableView!
    
    
    var footerView = LocationView()
    
    var businessId = String()
    
    var checkBusinessCreated = String()
    
    var dictBusinessDetails = [String:Any]()
    
    var arrOpeningHrs = [AnyObject]()
    
    var arrFilteredIndex = [Int]()
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.businessId = strBusinessId
        
        SVProgressHUD.show()
        
        checkBusinessDetailVc = true
        
        tblPubDetail.estimatedRowHeight = 300
        
        tblPubDetail.rowHeight = UITableViewAutomaticDimension
        
        self.apiGetDetails(strBusinessId: businessId)
        
    }
    
    
    //MARK: - getDay
    func getDayOfWeek(_ today:String) -> Int? {
        
        let formatter  = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let todayDate = formatter.date(from: today) else { return nil }
        
        let myCalendar = Calendar(identifier: .gregorian)
        
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        
        return weekDay
    }
    
    
    //MARK: Api Get Business Details
    func apiGetDetails(strBusinessId: String)  {
        
        var params = [String: String]()
        
        params["auth_code"] = UserDefaults.standard.getAuthCode()
        
        params["business_id"] = strBusinessId
        
        let checkBusinessLogin = UserDefaults.standard.getBusinessLogin()
        
        if checkBusinessLogin == true {
            
            params["mydetail"] = "true"
        }
        else {
            
            params["mydetail"] = "false"
        }
        
        isBusinessDetail  = false
        
        FeedManager.sharedInstance.dictParams = params as [String : Any]
        
        FeedManager.sharedInstance.getSingleBusinessDetails(completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                let strStatus = dictResponse["status"] as? String
                
                if strStatus == "false" {
                    
                    DispatchQueue.main.async {
                        
                        let action = dictResponse["action"] as? String
                        
                        let msg = dictResponse["msg"] as? String
                        
                        self.vwLoading.isHidden = false
                        
                        self.tblPubDetail.isHidden = true
                        
                        self.lblNoPost.isHidden = true
                        
                        let strAuthCOde = UserDefaults.standard.getAuthCode()
                        
                        let strTown = UserDefaults.standard.getTown()
                        
                        var strCategory = String()
                        
                        var strAllCat = String()
                        
                        var strSelectCat = String()
                        
                        if isAllCategories == true {
                            
                            strAllCat = UserDefaults.standard.getAllCatName()
                        }
                        else {
                            
                            strCategory = UserDefaults.standard.getSelectedCat()
                            
                            strSelectCat = UserDefaults.standard.getSelectedCategory()
                        }
                        
                        let strSelectedTown = UserDefaults.standard.getSelectedTown()
                        
                        let userType = UserDefaults.standard.getBusinessUserType()
                        
                        if action == "logout" {
                            
                            let alert = UIAlertController(title: "",message:"msg",preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                                
                                LogoutUser.sharedLogout.resetDefaults()
                                
                                goToShowFeed = false
                                
                                UserDefaults.standard.setBusinessUserType(userType: userType)
                                
                                UserDefaults.standard.setIsLoggedIn(value: false)
                                
                                UserDefaults.standard.setupAuthCode(auth: strAuthCOde)
                                
                                UserDefaults.standard.setTown(value: strTown)
                                
                                UserDefaults.standard.setisAppAuthFirst(isFirst: true)
                                
                                UserDefaults.standard.setSelectedCat(value: strCategory)
                                
                                UserDefaults.standard.setAllCatName(value: strAllCat)
                                
                                UserDefaults.standard.selectedCategory(value: strSelectCat)
                                
                                UserDefaults.standard.setSelectedTown(value: strSelectedTown)
                                
                                
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                
                                appDelegate.setUpRootVC()
                                
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
                else if strStatus == "true" {
                    
                    DispatchQueue.main.async {
                        
                        let type = dictResponse["user_type"] as? String
                        
                        strBusinessUserType = type!
                        
                        let arrData = dictResponse["data"] as? [AnyObject]
                        
                        self.dictBusinessDetails = arrData![0] as! [String: Any]
                        
                        self.vwLoading.isHidden = true
                        
                        self.tblPubDetail.isHidden = false
                        
                        self.lblNoPost.isHidden = true
                        
                        let strOpeningTime = self.dictBusinessDetails["opening_time"] as? String
                        
                        let strCategory = self.dictBusinessDetails["category_id"] as? String
                        
                        UserDefaults.standard.setCatOfBusiness(value: strCategory!)
                        
                        isBusinessDetail  = true
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setview"), object: nil)
                        
                        
                        let str = strOpeningTime
                        
                        if str != "" && str != "null"{
                            
                            self.arrOpeningHrs = self.convertToDictionary(text: str!)!
                        }
                        
                        self.setUpTableView()
                        
                        SVProgressHUD.dismiss()
                        
                        self.view.isUserInteractionEnabled = true
                    }
                }
                else {
                    
                    DispatchQueue.main.async {
                        
                        SVProgressHUD.dismiss()
                        
                        self.vwLoading.isHidden = true
                        
                        self.tblPubDetail.isHidden = true
                        
                        self.lblNoPost.isHidden = false
                        
                        self.view.isUserInteractionEnabled = true
                        
                    }
                }
            }
            
        }, failure: { (error) in
            
            return
        })
    }
    
    
    //MARK: Set Up TableView
    func setUpTableView()  {
        
        let nib = UINib(nibName: "OpeningDetailsCell", bundle: nil)
        
        self.tblPubDetail.register(nib, forCellReuseIdentifier: "OpeningDetailsCell")
        
        let nibPhotos = UINib(nibName: "BusinessPhotoTableCell", bundle: nil)
        
        self.tblPubDetail.register(nibPhotos, forCellReuseIdentifier: "BusinessPhotoTableCell")
        
        
        let nibDetails = UINib(nibName: "AboutPubCell", bundle: nil)
        
        self.tblPubDetail.register(nibDetails, forCellReuseIdentifier: "AboutPubCell")
        
        footerView = (Bundle.main.loadNibNamed("LocationView", owner: nil, options: nil)?[0] as? LocationView)!
        
        footerView.frame = CGRect(x: self.footerView.frame.origin.x, y: self.footerView.frame.origin.y, width: self.footerView.frame.size.width, height: self.footerView.frame.size.height + 80)
        
        footerView.setData(dict: dictBusinessDetails)
        
        footerView.delegate = self
        
        self.tblPubDetail.tableFooterView = footerView
        
        tblPubDetail.delegate = self
        
        tblPubDetail.dataSource = self
    }
    
    
    // backButton Tapped
    @objc func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func convertToDictionary(text: String) -> [AnyObject]? {
        
        if let data = text.data(using: .utf8) {
            
            do {
                
                return try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
                
            }
            catch {
                
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    func setCell(tableCell: OpeningDetailsCell) {
        
        arrFilterTime.removeAll()
        
        if  arrOpeningHrs.count > 0 {
            
            if arrFilterTime.isEmpty {
                
                self.filterDaysTime(arrDay: arrOpeningHrs as! [[String : AnyObject]])
                
            }
            
            if arrFilterTime.count > 0 {
                
                tableCell.setUpView()
                
            }
        }
        else {
            
             tableCell.setUpView()
        }
    }
    
    
    func filterDaysTime(arrDay: [[String: AnyObject]]) -> Void {
        
        var getArr = arrDay
        
        var startTo = String()
        
        var startFrom = String()
        
        var arrFilteredData = [[String: String]]()
        
        var strDays = String()
        
        var strTime = String()
        
        var isMatched = Bool()
        
        var dayName = String()
        
        var lastIndex = -1
        
        for (index, item) in getArr.enumerated() {
            
            if !arrFilteredIndex.isEmpty {
                
                if arrFilteredIndex.count == getArr.count {
                    
                    break
                }
                
                if arrFilteredIndex.contains(index) {
                    
                    continue
                }
                else {
                    
                    if startTo.isEmpty && startFrom.isEmpty {
                        
                        startTo = arrDay[index]["startTo"] as! String
                        
                        startFrom = arrDay[index]["startFrom"] as! String
                        
                        dayName = DayClass.sharedInstance.getDayFirstLetter(index: index)
                    }
                }
            }
            else {
                
                if startTo.isEmpty && startFrom.isEmpty {
                    
                    dayName = DayClass.sharedInstance.getDayFirstLetter(index: index)
                    
                    startTo = arrDay[index]["startTo"] as! String
                    
                    startFrom = arrDay[index]["startFrom"] as! String
                }
            }
            
            if startTo == item["startTo"] as! String && startFrom == item["startFrom"] as! String {
                
                dayName = DayClass.sharedInstance.getDayFirstLetter(index: index)
                
                if !isMatched {
                    
                    if strDays.isEmpty {
                        
                        strDays = dayName
                    }
                    else {
                        
                        strDays = "\(strDays),\(dayName)"
                    }
                }
                
                if !isMatched && strTime.isEmpty {
                    
                    strTime = "\(startFrom)-\(startTo)"
                }
                
                arrFilteredIndex.append(index)
                
                isMatched = true
                
                if index == getArr.count - 1 {
                    
                    dayName = DayClass.sharedInstance.getDayFirstLetter(index: index)
                    
                    if !strDays.hasSuffix(dayName) {
                        
                        strDays = "\(strDays)-\(dayName)"
                    }
                }
                
                lastIndex = index
            }
            else {
                
                if lastIndex >= 0 {
                    
                    dayName = DayClass.sharedInstance.getDayFirstLetter(index: lastIndex)
                    
                    if strDays.contains(dayName) {
                        
                        print("No change")
                        
                    }
                    else {
                        
                        strDays = "\(strDays)-\(dayName)"
                    }
                    
                }
                
                isMatched = false
            }
            
        }
        
        var dict = [String: String]()
        
        dict["dayName"] = strDays
        
        if strTime == "12:00 AM-12:00 AM" {
            
            strTime = "closed"
        }
        
        dict["dayTime"] = strTime
        
        arrFilterTime.append(dict)
        
        if arrFilteredIndex.count == getArr.count {
            
            arrFilteredIndex.removeAll()
            
            return
        }
        else {
            
            self.filterDaysTime(arrDay: arrOpeningHrs as! [[String : AnyObject]])
        }
    }
}
