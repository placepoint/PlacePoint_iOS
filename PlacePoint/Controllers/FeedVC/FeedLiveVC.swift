//
//  FeedLiveVC.swift
//  PlacePoint
//
//  Created by Mac on 04/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import MMDrawerController
import SVProgressHUD
import AVKit

class FeedLiveVC: UIViewController {
    
    @IBOutlet weak var viewTopSegment: UIView!
    
    @IBOutlet var tblFields: UITableView!
    
    @IBOutlet var vwLoading: UIView!
    
    @IBOutlet var lblNoPosts: UILabel!
    
    @IBOutlet weak var viewBottomMyPosts: UIView!
    
    @IBOutlet weak var viewBottomFlashPosts: UIView!
    
    var states = [Bool]()
    
    var videoLink: String?
    
    var arrTitle = [String]()
    
    var arrDetails = [AnyObject]()
    
    var arrDataForTableView = [AnyObject]()
    
    var selectedCatId = String()
    
    var popUpPremiumView = PopUpPremium()
    
     var offsetCount:Int = 0
    
    var totalCount:Int = 0
    
    let refreshControl = UIRefreshControl()
    
    var isPullToRefresh = false
    
    //Abhi
    var arrDataFtype = [[String:AnyObject]]()
    //Abhi
    var isFlashPostsShow = Bool()
    //Abhi
    var boolComingFromSubCategory = false
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBottomFlashPosts.isHidden = true
        
        viewBottomMyPosts.isHidden = false
        
        SVProgressHUD.show()
        
        if boolComingFromSubCategory {
            
            viewTopSegment.isHidden = true
        }
        else {
            
            viewTopSegment.isHidden = false
        }
        isPullToRefresh = false
        
        if isBusinessVc == true {
            
            checkMyTimeLine = "My Posts"
        }
        
        self.callAppear()
        
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        
        refreshControl.tintColor = UIColor.themeColor()
    }
 
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        isPullToRefresh = true
        
//        offsetCount += 1
        
        self.setViewData()
        
//        self.apiGetFeed(strLocId: , strCatId: )
        
        
//        let newHotel = Hotels(name: "Montage Laguna Beach", place:
//            "California south")
//        hotels.append(newHotel)
//
//        hotels.sort() { $0.name < $0.place }
//
//        self.tableView.reloadData()
//        refreshControl.endRefreshing()
    }

    
    func callAppear() -> Void {
        
        SVProgressHUD.show()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setTaxiView), name: NSNotification.Name(rawValue: "setViewTaxi"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setView), name: Notification.Name("afterUpgarde"), object: nil)
        
        if isShowMyTimeLine == true && isTaxiCat == false { //My TimeLine = true
            
            self.setViewData()
        }
        else { //category = true
            
            self.setViewData()
        }
        
        self.setUpTableView()
        
        self.tblFields.dataSource = self
        
        self.tblFields.delegate = self
    }
    
    
    @objc func setTaxiView() {
        
        self.setViewData()
    }
    
    
    @objc func setview(_ notification: NSNotification) {
        
        self.setViewData()
        
    }
    
    
    @objc func setView() {
        
        DispatchQueue.main.async {
            
            self.setUpTableView()
            
            self.tblFields.isHidden = false
            
            self.tblFields.dataSource = self
            
            self.tblFields.delegate = self
            
            self.tblFields.reloadData()
            
        }
    }
    
    
    func setViewData() {
        
//        let checkFirstTutorialBusiness = UserDefaults.standard.getFirstTutorialBusiness()
        
//        let checkBusinessProfile = UserDefaults.standard.getBusinessProfile()
        
        let arrCateory = UserDefaults.standard.getArrCategories()
        
        if arrCateory.count == 0 {
            
            let categoriesArray = AppDataManager.sharedInstance.arrCategories
            
            UserDefaults.standard.setArrCategories(value: categoriesArray)
            
            let townArray = AppDataManager.sharedInstance.arrTowns
            
            UserDefaults.standard.setArrTown(value: townArray)
            
            
        }
        else {
            
            let arrCat = UserDefaults.standard.getArrCategories()
            
            AppDataManager.sharedInstance.arrCategories = arrCat
            
            let arrTown = UserDefaults.standard.getArrTown()
            
            AppDataManager.sharedInstance.arrTowns = arrTown
        }
        
        var strLocationId = String()
        
        var strLocation = String()
        
        var strCategory = String()
        
        var allCategoryId = [String]()
        
        
        if isShowMyTimeLine == true && isTaxiCat == false { //MyTimeLine = true
            
            print(UserDefaults.standard.getTown())
            
            print(AppDataManager.sharedInstance.arrTowns)
            
            strLocation = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getSelectedTown(), array: AppDataManager.sharedInstance.arrTowns as [AnyObject])
            
            let catIds = UserDefaults.standard.getSelectedCategory()
            
            let arrSelectedCategory = catIds.components(separatedBy: ",")
            
            for i in 0..<arrSelectedCategory.count {
                
                let arrCategoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
                    [arrSelectedCategory[i]], array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                
                let stringArr =  arrCategoryID.joined(separator: ",")
                
                allCategoryId.append(stringArr)
                
            }
            strCategory = allCategoryId.joined(separator: ",")
            
            self.apiGetFeed(strLocId: strLocation, strCatId: strCategory)
            
        }
        else  if isTaxiCat == true {
            
            strLocationId = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getTown(), array: AppDataManager.sharedInstance.arrTowns as [AnyObject])
            
            var catName = String()
            
            var strCategoryID = String()
            
            catName = UserDefaults.standard.getSelectedCat()
            
            let categoryID = CommonClass.sharedInstance.getCategoryId(strCategory: catName, array: (AppDataManager.sharedInstance.arrCategories as? [AnyObject])!)
            
            self.arrTitle.removeAll()
            
            self.arrTitle = CommonClass.sharedInstance.arrCategories(array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
            
            self.apiGetFeed(strLocId: strLocationId, strCatId: categoryID)
            
        }
        else { //category = true
            
            if isBusinessVc == true {
                
                if UserDefaults.standard.getSelectedTown() == "" {
                    
                    strLocationId = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getTown(), array: AppDataManager.sharedInstance.arrTowns as [AnyObject])
                    
                }
                else {
                    
                    strLocationId = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getSelectedTown(), array: AppDataManager.sharedInstance.arrTowns as [AnyObject])
                    
                    UserDefaults.standard.set(strLocationId, forKey: "locationid")
                    
                }
                
            }
            else {
                
                strLocationId = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getTown(), array: AppDataManager.sharedInstance.arrTowns as [AnyObject])
                
            }
            
            var catId = String()
            
            var strCategoryID = String()
            
            if isBusinessVc == true {
                
                catId = UserDefaults.standard.getSelectedCategory()
            }
            else {
                let isKeyExists = CommonClass.sharedInstance.keyAlreadyExists(Key: "catSelected")
                if isKeyExists ==  true {
                    catId = UserDefaults.standard.getCatSelect()
                } else {
                    catId = UserDefaults.standard.getSelectedCategory()
                }
//                catId = UserDefaults.standard.getCatSelect()
            }
            
            if isAllCategories == true {
                
                let arrSelectedCategory = catId.components(separatedBy: ",")
                
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
                
                let arrSelectedCategory = catId.components(separatedBy: ",")
                
                var arrCategoryID = [String]()
                
                for i in 0..<arrSelectedCategory.count {
                    
                    let strCatId = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
                        [arrSelectedCategory[i]], array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                    
                    let str = strCatId.joined(separator: ",")
                    
                    arrCategoryID.append(str)
                }
                
                strCategoryID = arrCategoryID.joined(separator: ",")
            }
            
            self.arrTitle.removeAll()
            
            self.arrTitle = CommonClass.sharedInstance.arrCategories(array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
            
            self.apiGetFeed(strLocId: strLocationId, strCatId: strCategoryID)
            
        }
        
    }
    
    
    // MARK:- SetUp tableView
    func setUpTableView() {
        
        let nib = UINib(nibName: "FieldTableViewCell", bundle: nil)
        
        self.tblFields.register(nib, forCellReuseIdentifier: "FieldTableViewCell")
        
        if isFlashPostsShow {
        
             states = [Bool](repeating: true, count: arrDataFtype.count)
        }
        else {
             states = [Bool](repeating: true, count: arrDetails.count)
        }
        
        tblFields.estimatedRowHeight = 200
        
        tblFields.rowHeight = UITableViewAutomaticDimension
        
        tblFields.refreshControl = refreshControl
        
        tblFields.addSubview(refreshControl)
    }
    
    
    //MARK: - Api Get Feed Details
    func apiGetFeed(strLocId: String, strCatId: String)  {
        
        self.view.isUserInteractionEnabled = false
        
        SVProgressHUD.show()
        
        //Kirti
        if isPullToRefresh == false {
            
            self.arrDetails.removeAll()
            
            self.arrDataFtype.removeAll()
        }
        
        var params = [String: String]()
        
        params["auth_code"] = UserDefaults.standard.getAuthCode()
        
        params["town_id"] = strLocId
        
        params["limit"] = "100"
        
//        if offsetCount == 0 {
//
//            params["page"] = "0"
//
//        }
//        else {
//
//            params["page"] = "\(offsetCount)"
//
//        }
        
//        params["ftype"] = ""
//
//        params["max_redemption"] = ""
//
//        params["validity_date"] = ""
//
//        params["validity_time"] = ""
//
//        params["per_person_redemption"] = ""
//
        params["page"] = "0"
        
        if isBusinessDetail == true && selectedCategory != "" {
            
            params["category_id"] = strCatId
            
            selectedCatId = strCatId
        }
        else {
            
            params["category_id"] = strCatId
            
            selectedCatId = strCatId
        }
        
        if checkMyTimeLine == "My Posts" {
            
            params["timeline"] = "false"
            
        }
        else {

            params["timeline"] = "true"
        }
    
        print(params)
        
        FeedManager.sharedInstance.dictParams = params  as! [String : String]
        
        FeedManager.sharedInstance.getFeedDetails(completionHandler: { (dictResponse) in
            
            let strStatus = dictResponse["status"] as? String
            
            print(dictResponse)
            
            if strStatus == "true" {
                
//                if self.isPullToRefresh == false {
                
                
//                FeedManager.sharedInstance.arrFeed = dictResponse["data"] as! [AnyObject]
                
                let arrData = dictResponse["data"] as! [[String:AnyObject]]
                
                
                self.arrDataFtype.removeAll()
                
                FeedManager.sharedInstance.arrFeed.removeAll()
                
                for i in 0..<arrData.count {
                    
                    let strFType = arrData[i]["ftype"] as! String
                    
                    if strFType == "1" {
                        
                        self.arrDataFtype.append(arrData[i])
                        
                    }
                    else {
                        
                        FeedManager.sharedInstance.arrFeed.append(arrData[i] as AnyObject)
                    }
                    
                }
               
                
                if isShowBusinessDetail == true {
                    
                    var allFeedArray = [AnyObject]()
                    
                    allFeedArray = FeedManager.sharedInstance.arrFeed
                    
                    print(allFeedArray)
                    
                    for i in 0..<allFeedArray.count {
                        
                        let dict = allFeedArray[i] as? [String: Any]
                        
                        let businessId = dict!["bussness_id"] as? String
                        
                        if businessId == strBusinessId {
                            
                            self.arrDetails.append(dict as AnyObject)
                            
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        if self.isFlashPostsShow {
                            
                            self.states = [Bool](repeating: true, count: self.arrDataFtype.count)
                        }
                        else {
                            self.states = [Bool](repeating: true, count: self.arrDetails.count)
                        }
                        
                        if self.arrDetails.count == 0 {
                            
                            SVProgressHUD.dismiss()
                            
                            self.refreshControl.endRefreshing()
                            
                            self.view.isUserInteractionEnabled = true
                            
                            self.view.backgroundColor = UIColor.white
                            
                            self.vwLoading.isHidden = true
                            
                            self.tblFields.isHidden = true
                            
                            self.lblNoPosts.isHidden = false
                            
                            isLiveFeed = false
                            
                        }
                        else {
                            
                            DispatchQueue.main.async {
                                
                                SVProgressHUD.dismiss()
                                
                                self.setUpTableView()
                                
                                self.refreshControl.endRefreshing()
                                
                                self.view.isUserInteractionEnabled = true
                                
                                self.vwLoading.isHidden = true
                                
                                self.tblFields.isHidden = false
                                
                                self.lblNoPosts.isHidden = true
                                
                                isLiveFeed = true
                                
                                self.tblFields.reloadData()
                                
                            }
                            
                        }
                    }
                    
                }
                else if isBusinessDetail == false {
                    
                    DispatchQueue.main.async {
                        
                        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
                        //Raj
                        //                    if selectedBusinessType == "Free" || selectedBusinessType == "Standard" {
                        if selectedBusinessType == "Standard" {
                            
                            self.popUpPremiumView = Bundle.main.loadNibNamed("PopUpPremium", owner: nil, options: nil)?[0] as! PopUpPremium
                            
                            self.popUpPremiumView.frame = self.tblFields.frame
                            
                            self.tblFields.isHidden = true
                            
                            self.popUpPremiumView.delegate = self as UpgradePlan
                            
                            self.view.addSubview(self.popUpPremiumView)
                            
                        }
                        else {
                            
                            if self.isFlashPostsShow == true {
                                
                                self.arrDataFtype.removeAll()
                                
                                FeedManager.sharedInstance.arrFeed.removeAll()
                                
                                for i in 0..<arrData.count {
                                    
                                    let strFType = arrData[i]["ftype"] as! String
                                    
                                    if strFType == "1" {
                                        
                                        self.arrDataFtype.append(arrData[i])
                                        
                                        self.arrDetails = self.arrDataFtype as [AnyObject]
                                        
                                    }
                                    else {
                                        
                                        FeedManager.sharedInstance.arrFeed.append(arrData[i] as AnyObject)
                                        
                                    }
                                    
                                    
                                }
                            } else {
                                 self.arrDetails = FeedManager.sharedInstance.arrFeed as [AnyObject]
                            }
               
                            DispatchQueue.main.async {
                                
                                self.setUpTableView()
                                
                                SVProgressHUD.dismiss()
                                
                                self.refreshControl.endRefreshing()
                                
                                self.view.isUserInteractionEnabled = true
                                
                                self.vwLoading.isHidden = true
                                
                                self.lblNoPosts.isHidden = true
                                
                                self.tblFields.isHidden = false
                                
                                isLiveFeed = true
                                
                                self.tblFields.reloadData()
                                
                            }
                        }
                    }
                }
                else {
                    
                    DispatchQueue.main.async {
                        
                        var allFeedArray = [AnyObject]()
                        
                        allFeedArray = FeedManager.sharedInstance.arrFeed
                        
                        for i in 0..<allFeedArray.count {
                            
                            let dict = allFeedArray[i] as? [String: Any]
                            
                            let businessId = dict!["bussness_id"] as? String
                            
                            if businessId == strBusinessId {
                                
                                self.arrDetails.append(dict as AnyObject)
                                
                            }
                        }
                        DispatchQueue.main.async {
                            
                            if self.isFlashPostsShow {
                                
                                self.states = [Bool](repeating: true, count: self.arrDataFtype.count)
                            }
                            else {
                                self.states = [Bool](repeating: true, count: self.arrDetails.count)
                            }
                            
                            if self.arrDetails.count == 0 {
                                
                                SVProgressHUD.dismiss()
                                
                                self.refreshControl.endRefreshing()
                                
                                self.view.isUserInteractionEnabled = true
                                
                                self.view.backgroundColor = UIColor.white
                                
                                self.vwLoading.isHidden = true
                                
                                self.tblFields.isHidden = true
                                
                                self.lblNoPosts.isHidden = false
                                
                                isLiveFeed = false
                                
                            }
                            else {
                                
                                DispatchQueue.main.async {
                                    
                                    self.refreshControl.endRefreshing()
                                    
                                    SVProgressHUD.dismiss()
                                    
                                    self.setUpTableView()
                                    
                                    self.view.isUserInteractionEnabled = true
                                    
                                    self.vwLoading.isHidden = true
                                    
                                    self.tblFields.isHidden = false
                                    
                                    self.lblNoPosts.isHidden = true
                                    
                                    self.tblFields.reloadData()
                                    
                                    isLiveFeed = true
                                }
                                
                            }
                        }
                    }
                }
                
            }
            else {
                DispatchQueue.main.async {
                    
                    SVProgressHUD.dismiss()
                    
                    self.refreshControl.endRefreshing()
                    
                    self.view.isUserInteractionEnabled = true
                    
                    self.vwLoading.isHidden = true
                    
                    self.tblFields.isHidden = true
                    
                    isLiveFeed = false
                    
                    let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
                    
                    if selectedBusinessType == "Free" || selectedBusinessType == "Standard" {
                        
                        let nib = Bundle.main.loadNibNamed("PopUpPremium", owner: nil, options: nil)?[0] as! PopUpPremium
                        
                        nib.frame = self.tblFields.frame
                        
                        self.tblFields.isHidden = true
                        
                        nib.delegate = self
                        
                        self.view.addSubview(nib)
                        
                    }
                    else {
                        if self.isPullToRefresh == true {
                        
                            self.refreshControl.endRefreshing()
                            
                            self.vwLoading.isHidden = true
                            
                            self.tblFields.isHidden = false
                            
                            self.lblNoPosts.isHidden = true
                            
                            isLiveFeed = true
                            
                            self.tblFields.reloadData()
                            
                            
                        }
                        else {
                            
                            self.view.backgroundColor = UIColor.white
                            
                            self.lblNoPosts.isHidden = false
                            
                            isLiveFeed = false
                        }
                       
                        
                    }
                    
                }
            }
            
        }, failure: { (error) in
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
                isLiveFeed = false
            }
            
            print(error)
        })
    }
    
    
    // MARK: - Exapndable Label
    func preparedSources(index: IndexPath) -> [(text: String, textReplacementType: ExpandableLabel.TextReplacementType, numberOfLines: Int, textAlignment: NSTextAlignment)] {
        
        return [(loremIpsumText(index: index), .word, 6, .right)]
    }
    
    
    func loremIpsumText(index: IndexPath) -> String {
        
        if index.row >= arrDetails.count {
            
            return ""
            
        }
        else {
            
            return (arrDetails[index.row]).value(forKey: "description") as! String
        }
    }
    
    
    // MARK: - Buttons Actions
    @objc func menuButtonTapped() {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        appDelegate?.centerContainer?.toggle(MMDrawerSide.left ,  animated: true, completion: nil)
    }
    
    
    @objc func rightCategoriesButtonTapped() {
        
        if checkMyTimeLine == "My Posts" {
            
            let addPostVC = AddPostVC(nibName: "AddPostVC", bundle: nil)
            
            self.navigationController?.pushViewController(addPostVC, animated: true)
        }
        else {
            
            let selectedCategoryVC = AllBusinessVC(nibName: "AllBusinessVC", bundle: nil)
            
            self.navigationController?.pushViewController(selectedCategoryVC, animated: true)
        }
    }
    
    //Abhi
    @IBAction func btnMyPostsAction(_ sender: UIButton) {
    
        isFlashPostsShow  = false
        
        viewBottomMyPosts.isHidden = false
        
        viewBottomFlashPosts.isHidden = true
        
        if arrDetails.count > 0 {
        
        arrDetails.removeAll()
            
        arrDetails = FeedManager.sharedInstance.arrFeed
            
        self.states = [Bool](repeating: true, count: self.arrDetails.count)
            
        tblFields.reloadData()
            
        }
    }
    
    
    @IBAction func btnFlashPostsAction(_ sender: UIButton) {
       
        isFlashPostsShow  = true
        
        viewBottomMyPosts.isHidden = true
        
        viewBottomFlashPosts.isHidden = false
        
        print(arrDataFtype)
        
        if arrDetails.count > 0 {
            
            arrDetails.removeAll()
            
            arrDetails = arrDataFtype as [AnyObject]
            
            self.states = [Bool](repeating: true, count: self.arrDetails.count)
            
             tblFields.reloadData()
            
        }
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
    
}


extension FeedLiveVC: UpgradePlan {
    
    func upgradeSubPlan() {
        
        isShowFeed = true
        
        let strSelectedType = UserDefaults.standard.getBusinessUserType()
        
        if strSelectedType == "Free" {
            
            strUserType = "3"
        }
        else if strSelectedType == "Standard" {
            
            strUserType = "2"
        }
        else if strSelectedType == "Premium" {
            
            strUserType = "1"
        }
        else {
            
            strUserType = "4"
        }
        
        let subPlanVc = SubScriptionPlanVC(nibName: "SubScriptionPlanVC", bundle: nil)
        
        let nav = UINavigationController(rootViewController: subPlanVc)
        
        nav.modalPresentationStyle = .custom
        
        self.navigationController?.present(nav, animated: true, completion: nil)
        
    }
}
