//
//  DealsVC.swift
//  PlacePoint
//
//  Created by Apple on 08/03/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import CoreLocation
import Kingfisher
import SVProgressHUD


class DealsVC: UIViewController {

    @IBOutlet weak var vwFDealsBg: UIView!
    @IBOutlet weak var vwLievFeedBg: UIView!
    @IBOutlet weak var vwLoader: UIView!
    @IBOutlet weak var vwBsnsDetails: UIView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnTaxi: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var businessname: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgBusiness: UIImageView!
    @IBOutlet weak var lblSelectedTown: UILabel!
    
    @IBOutlet var vwOpenNow: UIView!

    
    @IBOutlet var lblOpenAt: UILabel!
    
    @IBOutlet weak var lblOpenNow: UILabel!
    
    var locationManager = CLLocationManager()
    
    var locationStart = CLLocation()
    
    var dictBsns = [String:Any]()
    
     var endLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwBsnsDetails.cornerRadius(usingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
        
        vwLievFeedBg.cornerRadius(usingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
        
        vwFDealsBg.cornerRadius(usingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10, height: 10))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isNotificationClicked == true {
            
            self.tabBarController?.selectedIndex = 1
            
            isNotificationClicked = false
            
        }
        
        self.setUpNavigation()
        
         self.apiGetFeaturedBusiness()
        
        isMoreVc = false
        
        lblSelectedTown.text = UserDefaults.standard.getTown()
    }
    
    // MARK: - Set Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        self.navigationItem.navTitle(title: "Welcome to")
    }
    
    
    @IBAction func btnLocClick(_ sender: UIButton) {
        
        let longitude = (dictBsns["long"] as? String)!
        
        let long = ((longitude as? NSString)?.doubleValue)!
        
        let latitude = (dictBsns["lat"] as? String)!
        
        let lat = ((latitude as? NSString)?.doubleValue)!
        
        let mapVC = MapNavigationVC(nibName: "MapNavigationVC", bundle: nil)
        
        mapVC.latitude = lat
        
        mapVC.longitude = long
        
        self.navigationController?.pushViewController(mapVC, animated: true)
        
        
    }
    
    @IBAction func btnBsnsDetailsClick(_ sender: UIButton) {
        
        let feedDetailsVC = BuisnessShowFeedVc(nibName: "BuisnessShowFeedVc", bundle: nil)
            
        isBusinessDetail = true
            
        isShowBusinessDetail = true
            
        checkBusinessDetailVc = true
        
        isDealFeatureBuisness = true
            
             let dict = dictBsns
        
            let strBusId = dict["id"] as! String
            
            let userType = dict["user_type"] as? String
            
            strBusinessUserType = userType!
            
            let strBusinessName = dict["business_name"] as? String
            
            businessName = strBusinessName!
            
            let userId = dict["business_user_id"] as? String
            
            strBusinessUserId = userId!
            
            if isChooseCategoryVc == true {
                
                checkMyTimeLine = ""
                
                let category = dict["category_id"] as? String
                
                let arrCat = category?.components(separatedBy: ",")
                
                var arrStrCategory = [String]()
                
                for i in 0..<(arrCat?.count)! {
                    
                    let strCat = CommonClass.sharedInstance.getCategoryName(strCategory: arrCat![i], array: AppDataManager.sharedInstance.arrCategories)
                    
                    arrStrCategory.append(strCat)
                    
                }
                
                let strCategory = arrStrCategory.joined(separator: ",")
                
                UserDefaults.standard.setSelectedCat(value: strCategory)
                
                selectedCategory = category!
            }
            
            strBusinessId = strBusId
            
            self.navigationController?.pushViewController(feedDetailsVC, animated: true)
        
        
        
        
        
    }
    @IBAction func btnTaxiClick(_ sender: UIButton) {
        
        let arrFiltered = AppDataManager.sharedInstance.arrCategories.filter({$0["name"] as! String == "Taxis"})
        
        if arrFiltered.count > 0 {
            
            let dictTaxi = arrFiltered.first as! [String:Any]
            
            let strIds = dictTaxi["id"] as! String
            
            let myTowName = UserDefaults.standard.getTown()
            
            let townId = CommonClass.sharedInstance.getLocationId(strLocation: myTowName, array: AppDataManager.sharedInstance.arrTowns)
            
            UserDefaults.standard.setSelectedCat(value: "Taxis")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "afterUpgarde"), object: nil)
            
        }
      
        
        
        
    }
    

    @IBAction func btnCallClcik(_ sender: UIButton) {
        
        let contactNo = (dictBsns["contact_no"] as? String)!
        
        
        if contactNo == "" {
            
            self.showAlert(withTitle: "Alert!", message: "Contact No. is not available.")
            
            
        } else {
            
            if let url = URL(string: "tel://\(contactNo)"), UIApplication.shared.canOpenURL(url) {
                
                if #available(iOS 10, *) {
                    
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
                } else {
                    
                    UIApplication.shared.openURL(url)
                }
            }
            
        }
        
        
        
    }
    
    
    @IBAction func btnUpdateNowClick(_ sender: UIButton) {
        
        guard let url = URL(string: "https://www.placepoint.ie/download.php") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    
    
    @IBAction func btnAllCategoriesClick(_ sender: UIButton) {
        
           self.tabBarController?.selectedIndex = 2
        
    }
    

    @IBAction func btnFlashDealClick(_ sender: UIButton) {
        
         self.tabBarController?.selectedIndex = 1
        
    }
    
    
    //MARK: - Api to get all Business Categories
    func apiGetFeaturedBusiness() {
        
        SVProgressHUD.show()

       
        vwLoader.isHidden = false
        var params = [String: String]()
        
        params["auth_code"] = UserDefaults.standard.getAuthCode()
        
        params["town_id"] = "9"
        
        params["limit"] = "100"
        
        params["page"] = "0"
        
        params["category_id"] = "29,30,42"
        
        FeedManager.sharedInstance.dictParams = params  as! [String : Any]
        
        FeedManager.sharedInstance.getBusinessDetails(completionHandler: { (dictResponse) in
            
            let strStatus = dictResponse["status"] as? String
            
         if strStatus == "true" {
            
            
//            let
            
            let arrayAll = dictResponse["featured_business"] as? [AnyObject]
            
            let dictFiltered = arrayAll![0]
            
            
                self.dictBsns = dictFiltered as! [String:AnyObject]
            
            
            if self.dictBsns.count > 0 {
                var strLat = String()
                
                var strLong = String()
                
                strLat = (self.dictBsns["lat"] as? String)!
                
                strLong = (self.dictBsns["long"] as? String)!
                
                if strLat == "" {
                    
                    strLat = "\(self.locationStart.coordinate.latitude)"
                    
                    self.dictBsns["lat"] = strLat as AnyObject
                }
                
                if strLong == "" {
                    
                    strLong = "\(self.locationStart.coordinate.longitude)"
                    
                    self.dictBsns["long"] = strLong as AnyObject
                }
                
                let strEndLatitude = self.dictBsns["lat"] as? String
                
                let strEndLongitude = self.dictBsns["long"] as? String
                
                let endLat = (strEndLatitude! as NSString).doubleValue
                
                let endLong = (strEndLongitude! as NSString).doubleValue
                
                self.endLocation = CLLocation(latitude: endLat, longitude: endLong)
                
                self.locationManager.delegate = self
                
                self.locationManager.startUpdatingLocation()
 
                DispatchQueue.main.async {
                    
                    SVProgressHUD.dismiss()
                    self.vwLoader.isHidden = true
                    self.setData(dict: self.dictBsns)
                    
                }
            }
    
        }


    }, failure: { (error) in
            
            DispatchQueue.main.async {
            self.vwLoader.isHidden = true
               SVProgressHUD.dismiss()
                
            }
            
        })
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
    
    
    func setData(dict:[String:Any])  {
        
          lblSelectedTown.text = UserDefaults.standard.getTown()
        
 
            if dict["contact_no"] as? String == "" {
                
                self.btnCall.isHidden = true
                
            }
        
            let coverImgUrl: String = (dict["cover_image"] as? String)!
            
            if coverImgUrl != "" {
                
                let url = URL(string:coverImgUrl)!
                
                self.imgBusiness.kf.indicatorType = .activity
                
                (self.imgBusiness.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
                
                self.imgBusiness.kf.setImage(with: url,
                                               placeholder: #imageLiteral(resourceName: "placeholder"),
                                               options: [.transition(ImageTransition.fade(1))],
                                               progressBlock: { receivedSize, totalSize in
                },
                                               completionHandler: { image, error, cacheType, imageURL in
                })
            }
     
            
            
            businessname.text = dict["business_name"] as? String
        
            self.lblAddress.text = dict["address"] as? String
            
            let strOpeningHours = dict["opening_time"] as? String
            
            if strOpeningHours != "" && strOpeningHours != "null"{
                
                let arryOpeningHours = self.convertToDictionary(text: strOpeningHours!)!
                
                let date = NSDate()
                
             
                let week = date.dayOfTheWeek()
                
                if week == nil || week == "" {
                   return
                }
                
                let dayIndex = DayClass.sharedInstance.getDayIndex(day: week!)
                
                let dictCheckDay = arryOpeningHours[dayIndex] as? NSDictionary
                
                
                if dictCheckDay == nil || dictCheckDay?.count == 0 {
                    return
                }
                
                if dictCheckDay!["startFrom"] as! String == "12:00 AM" {
                    
                    self.lblOpenNow.text = "CLOSED"
                    
                    var timeandDay = String()
                    
                    timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                    
                    self.lblOpenAt.isHidden = false
                    
                    self.lblOpenAt.text = "Open \(timeandDay)"
                    
                    self.vwOpenNow.frame = CGRect(x: 260.0, y: 12, width: 92, height: 38)
                    
                    self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                }
                else {
                    
                    let now = Date()
                    
                    let outputFormatter = DateFormatter()
                    
                    outputFormatter.dateFormat = "h:mm a"
                    
                    outputFormatter.amSymbol = "AM"
                    
                    outputFormatter.pmSymbol = "PM"
                    
                    //current time
                    let currentTimeString = outputFormatter.string(from: now)
                    
                    let dateCurrent: Date? = outputFormatter.date(from: currentTimeString)
                    
                    let formatter = DateFormatter()
                    
                    formatter.dateFormat = "h:mm a"
                    
                    formatter.amSymbol = "AM"
                    
                    formatter.pmSymbol = "PM"
                    
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    
                    var getCloseFrom = dictCheckDay!["closeFrom"] as! String
                    
                    if dictCheckDay!["closeFrom"] as! String == "12:00 AM"
                    {
                        getCloseFrom = "closed"
                        
                    }
                    
                    var getCloseTo = dictCheckDay!["closeTo"] as! String
                    
                    if dictCheckDay!["closeTo"] as! String == "12:00 AM"
                    {
                        getCloseTo = "closed"
                        
                    }
                    
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    
                    let getTodayDate = dateFormatter.string(from: now)
                    
                    if getCloseFrom == "closed" || getCloseTo == "closed" {
                        
                        var getStartFrom = dictCheckDay!["startFrom"] as! String
                        
                        if getStartFrom == "12:00 AM" {
                            
                            getStartFrom = "closed"
                            
                        }
                        var getStartTo = dictCheckDay!["startTo"] as! String
                        
                        if getStartTo == "12:00 AM" {
                            
                            getStartTo = "closed"
                            
                        }
                        else if getStartFrom != "closed" || getStartTo != "closed" {
                            
                            dateFormatter.dateFormat = "YYYY-MM-dd"
                            
                            let getTodayDate = dateFormatter.string(from: now)
                            
                            var startFrom = "\(getTodayDate) \(getStartFrom)"
                            
                            var startTo = "\(getTodayDate) \(getStartTo)"
                            
                            let resultCheckStartFrom: ComparisonResult!
                            
                            let resultCheckStarTo: ComparisonResult!
                            
                            let resultCheckFromAndTo: ComparisonResult!
                            
                            let locale = NSLocale.current
                            
                            let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
                            
                            if formatter.contains("a") || formatter.contains("p"){
                                
                                dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
                                
                                let getTimeValue = CommonClass.sharedInstance.checkIrelandTimeZone(startFrom: startFrom, startTo: startTo)
                                
                                if getTimeValue.0 {
                                    
                                    let getDateCompareObj = CommonClass.sharedInstance.compareTime(startFrom: getTimeValue.1, startTo: getTimeValue.2, dateFormatter: dateFormatter)
                                    
                                    resultCheckStartFrom = getDateCompareObj.0
                                    
                                    resultCheckStarTo = getDateCompareObj.1
                                    
                                    resultCheckFromAndTo = getDateCompareObj.2
                                    
                                }
                                else {
                                    
                                    dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
                                    
                                    let getDateCompareObj = CommonClass.sharedInstance.compareTime(startFrom: startFrom, startTo: startTo, dateFormatter: dateFormatter)
                                    
                                    resultCheckStartFrom = getDateCompareObj.0
                                    
                                    resultCheckStarTo = getDateCompareObj.1
                                    
                                    resultCheckFromAndTo = getDateCompareObj.2
                                }
                            }
                            else {
                                
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                
                                if startFrom.contains("A") {
                                    
                                    startFrom = startFrom.replacingOccurrences(of: "AM", with: "", options: NSString.CompareOptions.literal, range: nil)
                                    
                                }
                                else if startFrom.contains("P") {
                                    
                                    startFrom = startFrom.replacingOccurrences(of: "PM", with: "", options: NSString.CompareOptions.literal, range: nil)
                                    
                                }
                                
                                if startTo.contains("A") {
                                    
                                    startTo = startTo.replacingOccurrences(of: "AM", with: "", options: NSString.CompareOptions.literal, range: nil)
                                    
                                }
                                else if startTo.contains("P") {
                                    
                                    startTo = startTo.replacingOccurrences(of: "PM", with: "", options: NSString.CompareOptions.literal, range: nil)
                                    
                                }
                                
                                let getDateCompareObj = CommonClass.sharedInstance.compareTime(startFrom: startFrom, startTo: startTo, dateFormatter: dateFormatter)
                                
                                resultCheckStartFrom = getDateCompareObj.0
                                
                                resultCheckStarTo = getDateCompareObj.1
                                
                                resultCheckFromAndTo = getDateCompareObj.2
                                
                            }
                            
                            if (resultCheckStartFrom == .orderedAscending && resultCheckStartFrom == .orderedSame) {
                                
                                if resultCheckFromAndTo == .orderedDescending {
                                    
                                    self.lblOpenNow.text = "OPEN NOW"
                                    
                                    self.lblOpenAt.isHidden = true
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                    
                                }
                                else if resultCheckStarTo == .orderedDescending {
                                    
                                    self.lblOpenNow.text = "OPEN NOW"
                                    
                                    self.lblOpenAt.isHidden = true
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                }
                                
                            }
                                
                            else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedAscending {
                                
                                self.lblOpenNow.text = "CLOSED"
                                
                                var timeandDay = String()
                                
                                timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                                
                                self.lblOpenAt.isHidden = false
                                
                                self.lblOpenAt.text = "Open \(timeandDay)"
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                                
                            }
                            else if resultCheckStartFrom == .orderedDescending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedAscending {
                                
                                self.lblOpenNow.text = "OPEN NOW"
                                
                                self.lblOpenAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                
                                //                            self.lblOpenAt.text = "Closes at 9 PM"
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                
                            }
                            else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedDescending && resultCheckFromAndTo == .orderedAscending {
                                
                                self.lblOpenNow.text = "OPEN NOW"
                                
                                self.lblOpenAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                
                                //                            self.lblOpenAt.text = "Closes at 9 PM"
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                
                            }
                            else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedDescending {
                                
                                self.lblOpenNow.text = "OPEN NOW"
                                
                                self.lblOpenAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                
                                //                            self.lblOpenAt.text = "Closes at 9 PM"
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                
                            }
                            else {
                                
                                self.lblOpenNow.text = "CLOSED"
                                
                                var timeandDay = String()
                                
                                timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                                
                                self.lblOpenAt.isHidden = false
                                
                                self.lblOpenAt.text = "Open \(timeandDay)"
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                                
                            }
                        }
                        else {
                            
                            self.lblOpenNow.text = "CLOSED"
                            
                            var timeandDay = String()
                            
                            timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                            
                            self.lblOpenAt.isHidden = false
                            
                            self.lblOpenAt.text = "Open \(timeandDay)"
                            
                            self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                            
                            self.vwOpenNow.backgroundColor = UIColor(red: 211.0/255.0, green: 21.0/255.0, blue: 15.0/255.0, alpha: 1.0)
                            
                        }
                        
                    }
                    else {
                        
                        let closeFrom = "\(getTodayDate) \(getCloseFrom)"
                        
                        let closeTo = "\(getTodayDate) \(getCloseTo)"
                        
                        dateFormatter.dateFormat = "YYYY-MM-dd h:mm a"
                        
                        let closeFromDate = dateFormatter.date(from: closeFrom)
                        
                        let closeToDate = dateFormatter.date(from: closeTo)
                        
                        let resultCheckStartFrom: ComparisonResult = (closeFromDate?.compare(now))!
                        
                        let resultCheckStarTo: ComparisonResult = (closeToDate?.compare(now))!
                        
                        let resultCheckFromAndTo: ComparisonResult = (closeFromDate?.compare(closeToDate!))!
                        
                        if (resultCheckStartFrom == .orderedAscending && resultCheckStartFrom == .orderedSame) {
                            
                            if resultCheckFromAndTo == .orderedDescending {
                                
                                self.lblOpenNow.text = "OPEN NOW"
                                
                                self.lblOpenAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                
                                //                            self.lblOpenAt.text = "Closes at 9 PM"
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                
                            }
                            else if resultCheckStarTo == .orderedDescending {
                                
                                self.lblOpenNow.text = "OPEN NOW"
                                
                                self.lblOpenAt.isHidden = true
                                
                                //                            self.lblOpenAt.text = "Closes at 9 PM"
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                
                            }
                        }
                        else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedDescending && resultCheckFromAndTo == .orderedAscending {
                            
                            self.lblOpenNow.text = "CLOSED"
                            
                            var timeandDay = String()
                            
                            timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                            
                            self.lblOpenAt.isHidden = false
                            
                            self.lblOpenAt.text = "Open \(timeandDay)"
                            
                            self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                            
                            self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                            
                        }
                        else if resultCheckStartFrom == .orderedDescending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedDescending {
                            
                            self.lblOpenNow.text = "OPEN NOW"
                            
                            self.lblOpenAt.isHidden = true
                            
                            //                        self.lblOpenAt.text = "Closes at 9 PM"
                            
                            self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                            
                            self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                            
                        }
                        else if resultCheckStartFrom == .orderedDescending && resultCheckStarTo == .orderedDescending && resultCheckFromAndTo == .orderedDescending {
                            
                            self.lblOpenNow.text = "CLOSED"
                            
                            var timeandDay = String()
                            
                            timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                            
                            self.lblOpenAt.isHidden = false
                            
                            self.lblOpenAt.text = "Open \(timeandDay)"
                            
                            
                            self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                            
                            self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                            
                        }
                        else {
                            
                            var getStartFrom = dictCheckDay!["startFrom"] as! String
                            
                            if getStartFrom == "12:00 AM" {
                                
                                getStartFrom = "closed"
                                
                            }
                            var getStartTo = dictCheckDay!["startTo"] as! String
                            
                            if getStartTo == "12:00 AM" {
                                
                                getStartTo = "closed"
                                
                            }
                            
                            dateFormatter.dateFormat = "YYYY-MM-dd"
                            
                            let getTodayDate = dateFormatter.string(from: now)
                            
                            if getStartFrom == "closed" || getStartTo == "closed" {
                                
                                print("closed")
                            }
                            else {
                                
                                let startFrom = "\(getTodayDate) \(getStartFrom)"
                                
                                let startTo = "\(getTodayDate) \(getStartTo)"
                                
                                dateFormatter.dateFormat = "YYYY-MM-dd h:mm a"
                                
                                let startFromDate = dateFormatter.date(from: startFrom)
                                
                                let startToDate = dateFormatter.date(from: startTo)
                                
                                let resultCheckStartFrom: ComparisonResult = (startFromDate?.compare(now))!
                                
                                let resultCheckStarTo: ComparisonResult = (startToDate?.compare(now))!
                                
                                let resultCheckFromAndTo: ComparisonResult = (startFromDate?.compare(startToDate!))!
                                
                                if (resultCheckStartFrom == .orderedAscending && resultCheckStartFrom == .orderedSame) {
                                    
                                    if resultCheckFromAndTo == .orderedDescending {
                                        
                                        self.lblOpenNow.text = "OPEN NOW"
                                        
                                        self.lblOpenAt.isHidden = true
                                        
                                        self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                        
                                        //                                    self.lblOpenAt.text = "Closes at 9 PM"
                                        
                                        self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                        
                                    }
                                    else if resultCheckStarTo == .orderedDescending {
                                        
                                        self.lblOpenNow.text = "OPEN NOW"
                                        
                                        self.lblOpenAt.isHidden = true
                                        
                                        //                                    self.lblOpenAt.text = "Closes at 9 PM"
                                        
                                        self.vwOpenNow.frame = CGRect(x: 260.0, y: 12, width: 85, height: 25)
                                        
                                        self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                        
                                    }
                                }
                                else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedAscending {
                                    
                                    self.lblOpenNow.text = "CLOSED"
                                    
                                    var timeandDay = String()
                                    
                                    timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                                    
                                    self.lblOpenAt.isHidden = false
                                    
                                    self.lblOpenAt.text = "Open \(timeandDay)"
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                                    
                                }
                                    
                                else if resultCheckStartFrom == .orderedDescending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedAscending {
                                    
                                    self.lblOpenNow.text = "OPEN NOW"
                                    
                                    self.lblOpenAt.isHidden = true
                                    
                                    //                                self.lblOpenAt.text = "Closes at 9 PM"
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                    
                                }
                                else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedDescending && resultCheckFromAndTo == .orderedAscending {
                                    
                                    self.lblOpenNow.text = "OPEN NOW"
                                    
                                    self.lblOpenAt.isHidden = true
                                    
                                    //                                self.lblOpenAt.text = "Closes at 9 PM"
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                    
                                }
                                else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedDescending {
                                    
                                    self.lblOpenNow.text = "OPEN NOW"
                                    
                                    self.lblOpenAt.isHidden = true
                                    
                                    //                                self.lblOpenAt.text = "Closes at 9 PM"
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                }
                                else {
                                    
                                    self.lblOpenNow.text = "CLOSED"
                                    
                                    var timeandDay = String()
                                    
                                    timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                                    
                                    self.lblOpenAt.isHidden = false
                                    
                                    self.lblOpenAt.text = "Open \(timeandDay)"
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                                    
                                }
                            }
                        }
                    }
                }
            }
        
        
}
        
  
    
    
    //MARK: calculate Distance
    
    func calculateDistane(locationEnd: CLLocation) {
        
        let originCoordinate = CLLocation(latitude: locationStart.coordinate.latitude, longitude: locationStart.coordinate.longitude)
        
        let destCoordinate = CLLocation(latitude: locationEnd.coordinate.latitude, longitude: locationEnd.coordinate.longitude)
        
        let distanceInMeters = originCoordinate.distance(from: destCoordinate)
        
        let distanceInKm = (distanceInMeters * 0.001)
        
        let dist = Double(round(100*distanceInKm)/100)
        
        self.lblDistance.text = "\(dist) km away"
        
    }
    
//    func calculateDistane(locationEnd: CLLocation) -> Double{
//
//        var arrDistance = [AnyObject]()
//
//        let originCoordinate = CLLocation(latitude: locationStart.coordinate.latitude, longitude: locationStart.coordinate.longitude)
//
//        let destCoordinate = CLLocation(latitude: locationEnd.coordinate.latitude, longitude: locationEnd.coordinate.longitude)
//
//        let distanceInMeters = originCoordinate.distance(from: destCoordinate)
//
//        let distanceInKm = (distanceInMeters * 0.001)
//
//        let dist = Double(round(100*distanceInKm)/100)
//
//        return dist
//
//
//  }
}
extension UIView
{
    func cornerRadius(usingCorners corners: UIRectCorner, cornerRadii: CGSize)
    {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: cornerRadii)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
}
extension DealsVC: CLLocationManagerDelegate {
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation = locations.last else {
            return
        }
        
        locationManager.stopUpdatingLocation()
        
        self.locationStart = userLocation
        
        self.calculateDistane(locationEnd: endLocation)
        
    }
}
