//
//  AllBusinessVC.swift
//  PlacePoint
//
//  Created by Mac on 19/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import CoreLocation

class AllBusinessVC: UIViewController {
    
    @IBOutlet var tableViewSelectedCategories: UITableView!
    
    @IBOutlet var lblNoPost: UILabel!
    
    @IBOutlet var vwLoading: UIView!
    
    var arrBusiness = [AnyObject]()
    
    var arrFreeBusiness = [AnyObject]()
    
    var arrSortedByLocation = [AnyObject]()
    
    var arrFiltered = [AnyObject]()
    
    var lat = CLLocationDegrees()
    
    var long = CLLocationDegrees()
    
    var locationManager = CLLocationManager()
    
    var locationStart = CLLocation()
    
    var businessListingTutorialView = BusinessListingTutorialView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.registerTableView()
        
        SVProgressHUD.show()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        SVProgressHUD.show()
        
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        
        self.arrBusiness.removeAll()
        
        self.arrFreeBusiness.removeAll()
        
        var strLoc = String()
        
        if isTaxiCat == true {
            
            let arrFiltered = AppDataManager.sharedInstance.arrCategories.filter({$0["name"] as! String == "Taxis"})
            
            if arrFiltered.count > 0 {
                
                let dictTaxi = arrFiltered.first as! [String:Any]
                
                let strIds = dictTaxi["id"] as! String
                
                let myTowName = UserDefaults.standard.getTown()
                
                let townId = CommonClass.sharedInstance.getLocationId(strLocation: myTowName, array: AppDataManager.sharedInstance.arrTowns)
                
                arrBusiness.removeAll()
                
                UserDefaults.standard.setSelectedCat(value: "Taxis")
                
                self.apiCategories(strLoc: townId, strCategory: strIds)
                
            }
            else {
                
                isTaxiCat = false
                
                AppDataManager.sharedInstance.arrAllFeeds.removeAll()
                
                self.vwLoading.isHidden = true
                
                self.tableViewSelectedCategories.isHidden = true
                
                self.lblNoPost.isHidden = false
                
            }
        }
        else {
            if isBusinessDetail == true  {
                
                if UserDefaults.standard.getSelectedTown() == "" {
                    
                    strLoc = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getTown(), array: AppDataManager.sharedInstance.arrTowns as [AnyObject])
                    
                }
                else {
                    
                    strLoc = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getSelectedTown(), array: AppDataManager.sharedInstance.arrTowns as [AnyObject])
                    
                }
                
            }
            else {
                
                strLoc = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getTown(), array: AppDataManager.sharedInstance.arrTowns as [AnyObject])
                
            }
            var strCategory = String()
            
            if isCatSel == true {
                
                strCategory = UserDefaults.standard.getSelectedCat()
            }
            else {
                
                let isKeyExists = CommonClass.sharedInstance.keyAlreadyExists(Key: "catSelected")
                if isKeyExists ==  true {
                    
                    strCategory = UserDefaults.standard.getCatSelect()
                }
                else {
                    
                    strCategory = UserDefaults.standard.getSelectedCategory()
                }
//                strCategory = UserDefaults.standard.getCatSelect()
            }
            
            var strCategoryID = String()
            
            if isAllCategories == true {
                
                let arrSelectedCategory = strCategory.components(separatedBy: ",")
                
                var allCategoryId = [String]()
                
                for i in 0..<arrSelectedCategory.count {
                    
                    let arrCategoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
                        [arrSelectedCategory[i]], array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                    
                    let stringArr =  arrCategoryID.joined(separator: ",")
                    
                    allCategoryId.append(stringArr)
                    
                }
                
                strCategoryID = allCategoryId.joined(separator: ",")
                
            }
            else {
                
                let arrSelectedCategory = strCategory.components(separatedBy: ",")
                
                let arrCategoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
                    [arrSelectedCategory[0]], array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                
                strCategoryID = arrCategoryID.joined(separator: ",")
            }
            
            self.apiCategories(strLoc: strLoc, strCategory: strCategoryID)
            //
            //            self.arrTitle = CommonClass.sharedInstance.arrCategories(array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch? = touches.first
        
        if touch?.view == businessListingTutorialView {
            
            self.businessListingTutorialView.isHidden = true
            
        }
    }
    
    
    func showTutorialView() {
        
        let checkFirstLaunch = UserDefaults.standard.getFirstTutorialBusiness()
        
        if checkFirstLaunch == true {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let window = appDelegate.window
            
            businessListingTutorialView = Bundle.main.loadNibNamed("BusinessListingTutorialView", owner: nil, options: nil)?[0] as! BusinessListingTutorialView
            
            businessListingTutorialView.frame = CGRect(x: 0, y: 0, width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight)
            
            window?.addSubview(businessListingTutorialView)
            
        }
    }
    
    
    // MARK: - Register TableView nib
    func registerTableView() {
        
        tableViewSelectedCategories.tableFooterView = UIView()
        
        let  cellNib1 = UINib(nibName: "AllBusinessViewCell", bundle: nil)
        
        tableViewSelectedCategories.register(cellNib1, forCellReuseIdentifier: "AllBusinessViewCell")
        
        let  cellNib2 = UINib(nibName: "FreeBusinessTableCell", bundle: nil)
        
        tableViewSelectedCategories.register(cellNib2, forCellReuseIdentifier: "FreeBusinessTableCell")
        
        tableViewSelectedCategories.estimatedRowHeight = 100
        
        tableViewSelectedCategories.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    //MARK: - Setup Navigation
    func setUpNavigation() {
        
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.barTintColor = UIColor.themeColor()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        if isChooseCategoryVc == false || isLogout == true {
            
            var strLoc = String()
            
            if UserDefaults.standard.getSelectedTown() == "" {
                
                strLoc = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getTown(), array: AppDataManager.sharedInstance.arrTowns as [AnyObject])
                
            }
            else {
                
                strLoc = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getSelectedTown(), array: AppDataManager.sharedInstance.arrTowns as [AnyObject])
                
            }
            
            let strCategory = UserDefaults.standard.getSelectedCat()
            
            var strCategoryID = String()
            
            if isAllCategories == true {
                
                let arrSelectedCategory = strCategory.components(separatedBy: ",")
                
                var allCategoryId = [String]()
                
                for i in 0..<arrSelectedCategory.count {
                    
                    let arrCategoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
                        [arrSelectedCategory[i]], array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                    
                    let stringArr =  arrCategoryID.joined(separator: ",")
                    
                    allCategoryId.append(stringArr)
                    
                }
                
                strCategoryID = allCategoryId.joined(separator: ",")
                
                self.apiCategories(strLoc: strLoc, strCategory: strCategoryID)
                
            }
            else {
                
                let arrSelectedCategory = strCategory.components(separatedBy: ",")
                
                let arrCategoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
                    [arrSelectedCategory[0]], array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                
                strCategoryID = arrCategoryID.joined(separator: ",")
                
                self.apiCategories(strLoc: strLoc, strCategory: strCategoryID)
            }
            
            if isTaxiCat == false {
                
                self.apiCategories(strLoc: strLoc, strCategory: strCategoryID)
            }
            
            let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(backButtonTapped))
            
            self.navigationItem.leftBarButtonItem = leftBarButtonItem
            
        }
        
    }
    
    
    // backButton Tapped
    @objc func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    //MARK: - Api to get all Business Categories
    func apiCategories(strLoc: String, strCategory: String) {
        
        SVProgressHUD.show()
        
        self.tableViewSelectedCategories.isHidden = true
        
        self.view.isUserInteractionEnabled = false
        
        var params = [String: String]()
        
        params["auth_code"] = UserDefaults.standard.getAuthCode()
        
        params["town_id"] = strLoc
        
        params["limit"] = "100"
        
        params["page"] = "0"
        
        params["category_id"] = strCategory
        
        FeedManager.sharedInstance.dictParams = params  as! [String : Any]
        
        FeedManager.sharedInstance.getBusinessDetails(completionHandler: { (dictResponse) in
            
            let strStatus = dictResponse["status"] as? String
            
            if strStatus == "true" {
                
                DispatchQueue.main.async {
                    
                    self.view.isUserInteractionEnabled = true
                    
                    var array = [AnyObject]()
                    
                    var arrayAll = (FeedManager.sharedInstance.arrSelectedBusiness
                        as? [AnyObject])!
                    
                    var strLat = String()
                    
                    var strLong = String()
                    
                    for k in 0..<arrayAll.count {
                        
                        var dict = arrayAll[k] as? [String: Any]
                        
                        strLat = (dict!["lat"] as? String)!
                        
                        strLong = (dict!["long"] as? String)!
                        
                        if strLat == "" {
                            
                            strLat = "\(self.locationStart.coordinate.latitude)"
                            
                            dict!["lat"] = strLat
                        }
                        
                        if strLong == "" {
                            
                            strLong = "\(self.locationStart.coordinate.longitude)"
                            
                            dict!["long"] = strLong
                        }
                        
                        let strEndLatitude = dict!["lat"] as? String
                        
                        let strEndLongitude = dict!["long"] as? String
                        
                        let endLat = (strEndLatitude as! NSString).doubleValue
                        
                        let endLong = (strEndLongitude as! NSString).doubleValue
                        
                        let endLocation = CLLocation(latitude: endLat, longitude: endLong)
                        
                        let distance = self.calculateDistane(locationEnd: endLocation)
                        
                        print(distance)
                        
                        dict!["distance"] = distance as Double
                        
                        arrayAll.remove(at: k)
                        
                        arrayAll.insert(dict as AnyObject, at: k)
                        
                    }
                    
                    for item in 0..<arrayAll.count {
                        
                        let dict = arrayAll[item] as? [String: Any]
                        
                        array.append(dict as AnyObject)
                    }
                    
                    if array.count == 0 {
                        
                        SVProgressHUD.dismiss()
                        
                        self.vwLoading.isHidden = true
                        
                        self.tableViewSelectedCategories.isHidden = true
                        
                        self.lblNoPost.isHidden = false
                        
                    }
                    else {
                        
                        for i in 0..<array.count {
                            
                            let businessUserId =  array[i]["business_user_id"] as? String
                            
                            let userType = array[i]["user_type"] as? String
                            
                            if businessUserId == "0" || userType == "3" {
                                
                                self.arrFreeBusiness.append(array[i])
                            }
                            else {
                                
                                self.arrBusiness.append(array[i])
                            }
                        }
                    }
                    if isTaxiCat == true {
                        
                        let index = IndexPath(row: 0, section: 0)
                        
                        let cell = self.tableViewSelectedCategories.cellForRow(at: index) as? AllBusinessViewCell
                        
                        cell?.btnNavigation.isHidden = true
                        
                        cell?.btnTaxi.isHidden = true
                        
                    }
                    else if isFilterBusiness == false{
                        
                        self.arrSortedByLocation = [self.arrBusiness, self.arrFreeBusiness].flatMap({ (element: [AnyObject]) -> [AnyObject] in
                            return element
                        })
                    }
                    else if isFilterBusiness == true {
                        
                        self.arrBusiness.removeAll()
                        
                        self.arrFiltered.removeAll()
                        self.arrSortedByLocation = (array as NSArray).sortedArray(using: [NSSortDescriptor(key: "distance", ascending: true)]) as [AnyObject]
                        
                    }
                    
                    SVProgressHUD.dismiss()
                    
                    self.vwLoading.isHidden = true
                    
                    self.tableViewSelectedCategories.isHidden = false
                    
                    self.lblNoPost.isHidden = true
                    
                    self.tableViewSelectedCategories.dataSource = self
                    
                    self.tableViewSelectedCategories.delegate = self
                    
                    self.tableViewSelectedCategories.reloadData()
                    
                    self.showTutorialView()
                    
                }
                
            }
            else {
                
                DispatchQueue.main.async {
                    
                    SVProgressHUD.dismiss()
                    
                    self.view.isUserInteractionEnabled = true
                    
                    self.vwLoading.isHidden = true
                    
                    self.tableViewSelectedCategories.isHidden = true
                    
                    self.lblNoPost.isHidden = false
                    
                }
            }
            
        }, failure: { (error) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
            }
            
        })
    }
    
    //MARK: calculate Distance
    func calculateDistane(locationEnd: CLLocation) -> Double{
        
        var arrDistance = [AnyObject]()
        
        let originCoordinate = CLLocation(latitude: locationStart.coordinate.latitude, longitude: locationStart.coordinate.longitude)
        
        let destCoordinate = CLLocation(latitude: locationEnd.coordinate.latitude, longitude: locationEnd.coordinate.longitude)
        
        let distanceInMeters = originCoordinate.distance(from: destCoordinate)
        
        let distanceInKm = (distanceInMeters * 0.001)
        
        let dist = Double(round(100*distanceInKm)/100)
        
        return dist
        
    }
}


// MARK: - TableView Delegate and DataSource
extension AllBusinessVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrSortedByLocation.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let arrFiltered = AppDataManager.sharedInstance.arrCategories.filter({$0["name"] as! String == "Taxis"})
        
        if arrFiltered.count > 0 {
            
            let dictTaxi = arrFiltered.first as! [String:Any]
            
            let strIds = dictTaxi["town_id"] as! String
            
            let arrIds = strIds.components(separatedBy: ",")
            
            let myTowName = selectedTown
            
            var townId = String()
            
            print(UserDefaults.standard.getTown())
            
            print(AppDataManager.sharedInstance.arrTowns)
            
            if selectedTown == "" {
                
                townId = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getTown(), array: AppDataManager.sharedInstance.arrTowns)
                
            }
            else {
                
                townId = CommonClass.sharedInstance.getLocationId(strLocation: myTowName, array: AppDataManager.sharedInstance.arrTowns)
                
            }
            
            if arrIds.contains(townId) {
                
                print("no change")
            }
                
            else {
                
                var arrCategories = AppDataManager.sharedInstance.arrCategories as [AnyObject]
                
                let index = arrCategories.index(where: ({$0["name"] as! String == "Taxis"}))
                
                if index != nil {
                    
                }
                
                arrCategories.remove(at: index!)
                
                AppDataManager.sharedInstance.arrCategories = arrCategories
                
            }
            
        }
        else {
            
            print("count not exist")
            
        }
        
        let dict = arrSortedByLocation[indexPath.row]
        
        let businessUserId = dict["business_user_id"] as? String
        
        let userType = dict["user_type"] as? String
        
        if businessUserId != "0" && userType != "3"{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllBusinessViewCell", for: indexPath as IndexPath) as? AllBusinessViewCell
            
            cell?.btnTaxi.tag = indexPath.row
            
            cell?.btnNavigation.tag = indexPath.row
            
            cell?.delegate = self
            
            cell?.selectionStyle = .none
            
            print(arrSortedByLocation)
            
            if arrSortedByLocation.count > 0 {
                
                cell?.setData(arr: arrSortedByLocation, index: indexPath.row)
                
            }
            
            return cell!
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBusinessTableCell", for: indexPath as IndexPath) as? FreeBusinessTableCell
            
            cell?.selectionStyle = .none
            
            cell?.delegate = self
            
            cell?.setFreeCellData(arr: arrSortedByLocation, index: indexPath.row)
            
            return cell!
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dict = arrSortedByLocation[indexPath.row]
        
        let businessUserId = dict["business_user_id"] as? String
        
        let userType = dict["user_type"] as? String
        
        if businessUserId != "0" && userType != "3" {
            
            return 210.0
        }
        else {
            
            return 130.0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = arrSortedByLocation[indexPath.row]
        
        let businessUserId = dict["business_user_id"] as? String
        
        let userType = dict["user_type"] as? String
        
        if businessUserId != "0" && userType != "3" {
            
            let feedDetailsVC = BuisnessShowFeedVc(nibName: "BuisnessShowFeedVc", bundle: nil)
            
            isBusinessDetail = true
            
            isShowBusinessDetail = true
            
            let dict = arrSortedByLocation[indexPath.row] as? NSDictionary
            
            let strBusId = dict!["id"] as! String
            
            let userType = dict!["user_type"] as? String
            
            strBusinessUserType = userType!
            
            let strBusinessName = dict!["business_name"] as? String
            
            businessName = strBusinessName!
            
            let userId = dict!["business_user_id"] as? String
            
            strBusinessUserId = userId!
            
            if isChooseCategoryVc == true {
                
                checkMyTimeLine = ""
                
                let category = dict!["category_id"] as? String
                
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
        else {
            
            let feedDetailsVC = BuisnessShowFeedVc(nibName: "BuisnessShowFeedVc", bundle: nil)
            
            isBusinessDetail = true
            
            isShowBusinessDetail = true
            
            checkBusinessDetailVc = true
            
            let dict = arrSortedByLocation[indexPath.row] as? NSDictionary
            
            let strBusId = dict!["id"] as! String
            
            let userType = dict!["user_type"] as? String
            
            strBusinessUserType = userType!
            
            let strBusinessName = dict!["business_name"] as? String
            
            businessName = strBusinessName!
            
            let userId = dict!["business_user_id"] as? String
            
            strBusinessUserId = userId!
            
            if isChooseCategoryVc == true {
                
                checkMyTimeLine = ""
                
                let category = dict!["category_id"] as? String
                
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
        
    }
}

//MARK: Adopt Protocol
extension AllBusinessVC: BusinessAction {
    
    func openTaxiDetail(index: Int) {
        
        arrBusiness.removeAll()
        
        isTaxiCat = true
        
        isCatSel = false
        
        UserDefaults.standard.setSelectedCat(value: "Taxis")
        
        let feedDetailsVC = BuisnessShowFeedVc(nibName: "BuisnessShowFeedVc", bundle: nil)
        
        self.navigationController?.pushViewController(feedDetailsVC, animated: true)
    }
    
    
    func callMe(index: Int) {
        
        let dict = arrBusiness[index] as? [String: Any]
        
        let contactNo = (dict!["use_contact_no"] as? String)!
        
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
    
    
    func openMapNavigation(index: Int) {
        
        print(arrFreeBusiness)
        
        
        if arrFreeBusiness.count > 0 {
            let dict = arrBusiness[index] as? [String: Any]
            
            if !((dict?.isEmpty)!) {
                
                let longitude = (dict!["long"] as? String)!
                
                let long = ((longitude as? NSString)?.doubleValue)!
                
                let latitude = (dict!["lat"] as? String)!
                
                let lat = ((latitude as? NSString)?.doubleValue)!
                
                let mapVC = MapNavigationVC(nibName: "MapNavigationVC", bundle: nil)
                
                mapVC.latitude = lat
                
                mapVC.longitude = long
                
                self.navigationController?.pushViewController(mapVC, animated: true)
            }
            
           
        }
        
        
        
    }
    
}

extension AllBusinessVC: ActionCall {
    
    func toCallUser(index: Int) {
        
        let dict = arrFreeBusiness[index] as? [String: Any]
        
        let contactNo = (dict!["use_contact_no"] as? String)!
        
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
    
    
    func toOpenMapNavigation(index: Int) {
        
        print(arrFreeBusiness)
        
        let dict = arrFreeBusiness[index] as? [String: Any]
        
        let longitude = (dict!["long"] as? String)!
        
        let long = ((longitude as? NSString)?.doubleValue)!
        
        let latitude = (dict!["lat"] as? String)!
        
        let lat = ((latitude as? NSString)?.doubleValue)!
        
        let mapVC = MapNavigationVC(nibName: "MapNavigationVC", bundle: nil)
        
        mapVC.latitude = lat
        
        mapVC.longitude = long
        
        self.navigationController?.pushViewController(mapVC, animated: true)
        
    }
    
    func toOpenTaxiDetail(index: Int) {
        
        arrFreeBusiness.removeAll()
        
        isTaxiCat = true
        
        isCatSel = false
        
        UserDefaults.standard.setSelectedCat(value: "Taxis")
        
        let feedDetailsVC = BuisnessShowFeedVc(nibName: "BuisnessShowFeedVc", bundle: nil)
        
        self.navigationController?.pushViewController(feedDetailsVC, animated: true)
    }
    
}
//MARK: CLLocationManager Delegate
extension AllBusinessVC: CLLocationManagerDelegate {
    
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
        
    }
}

