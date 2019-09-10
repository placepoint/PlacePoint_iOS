//
//  BuisnessShowFeedVc.swift
//  PlacePoint
//
//  Created by Mac on 12/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SlidingContainerViewController
import SVProgressHUD
import FirebaseAnalytics

class BuisnessShowFeedVc: UIViewController, SlidingContainerViewControllerDelegate,FilterActions {
    
    @IBOutlet var vwloading: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var liveFeedTutorialView = LiveFeedTutorialView()
    
    var popFilterView = PopUpFilterView()
    
    var strCat = String()
    
    var rightBarButtonItem = UIBarButtonItem()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let checkAppAuthFirst = UserDefaults.standard.getisAppAuthFirst()
        
        if  isLogout == true || checkAppAuthFirst == true {
            
            self.getAppData()
        }
        else {
            
            self.getAppData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        rightBarButtonItem = UIBarButtonItem.init(title: "Claim", style: .done, target: self, action: #selector(claimButtonRight))
        
       // let rightBarButton = UIBarButtonItem.init(image: UIImage.init(named: "claimBusiness"), style: .done, target: self, action: #selector(claimButtonRight))
        
         var user_email = ""
        
        let isKeyExists = CommonClass.sharedInstance.keyAlreadyExists(Key: "email")
        if isKeyExists ==  true {
            user_email = UserDefaults.standard.getEmail()
        } else {
            user_email = ""
        }
        
        if !user_email.contains("placepoint.ie") {
            
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
            
            
        }
        
       
        
        isMoreVc = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setView(notification:)), name: Notification.Name("afterUpgarde"), object: nil)
        
        if isBusinessVc == true && isBusinessDetail == true {
            
            self.tabBarController?.tabBar.isHidden = true
        }
        
        isBusinessVc = false
        
        self.setUpNavigation()
    }
    
    
    @objc func claimButtonRight() {
        
        let alert = UIAlertController.init(title: "Alert", message: "To Claim this business, click the Claim button below and you will be taken to the PlacePoint Facebook page where you can PM us to request ownership. Please specify the email account you want to Claim ownership with.", preferredStyle: .alert)
        
        let actionOk = UIAlertAction.init(title: "Claim", style: .default) { (action) in
            
            self.openUrl()
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(cancelAction)

        alert.addAction(actionOk)

        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openUrl() {
        
        guard let url = URL(string: "https://www.facebook.com/placepoint.ireland") else {
            
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    // MARK: Set navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        let checkBusinessLogin = UserDefaults.standard.getBusinessLogin()
        
        let strTown = UserDefaults.standard.getTown()
        
        if isLogout == true {
            
            if isBusinessDetail == true {
                
                self.navigationItem.navTitle(title: "\(businessName)")
                
                let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(self.backButtonTapped))
                
                self.navigationItem.leftBarButtonItem = leftBarButtonItem
                
            }
            else {
                
                self.navigationItem.navTitle(title: "All \(parentCategoryName) in \(strTown)")
            }
            
        }
        else if isTaxiCat == true {
            
            if checkBusinessDetailVc == false {
                
                self.navigationItem.navTitle(title: "Taxis in \(strTown)")
                
                self.navigationItem.setLeftBarButton(nil, animated: true)
                
                let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(self.backButtonTapped))
                
                self.navigationItem.leftBarButtonItem = leftBarButtonItem
            }
            else {
                
                self.navigationItem.navTitle(title: "\(businessName) in \(strTown)")
                
                let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(self.backButtonTapped))
                
                self.navigationItem.leftBarButtonItem = leftBarButtonItem
                
            }
        }
        else {
            
            if isBusinessDetail == true {
                
                self.navigationItem.navTitle(title: "\(businessName)")
                
                let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(self.backButtonTapped))
                
                self.navigationItem.leftBarButtonItem = leftBarButtonItem
            }
            else {
                
                if isAllCat == true {
                    
                    let catName = UserDefaults.standard.getAllCatName()
                    
                    self.navigationItem.navTitle(title: "\(catName) in \(strTown)")
                    
                    if goToShowFeed == true || isMoreVc == true {
                        
                        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(self.backButtonTapped))
                        
                        self.navigationItem.leftBarButtonItem = leftBarButtonItem
                        
                        self.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Filter"),
                                                                  style: .plain,
                                                                  target: self,
                                                                  action: #selector(self.rightMenu))
                        
                        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem
                        
                        
                    }
                    else {
                        
                        self.navigationItem.leftBarButtonItem = nil
                    }
                    
                }
                else {
                    
                    self.navigationItem.navTitle(title: "\(strCat) in \(strTown)")
                    
                    if goToShowFeed == true || isMoreVc == true {
                        
                        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(self.backButtonTapped))
                        
                        self.navigationItem.leftBarButtonItem = leftBarButtonItem
                        
                        
                        self.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Filter"),
                                                                  style: .plain,
                                                                  target: self,
                                                                  action: #selector(self.rightMenu))
                        
                        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem
                        
                        
                    }
                    else {
                        
                        self.navigationItem.leftBarButtonItem = nil
                    }
                }
                
            }
        }
    }
    
    
    // MARK: - API Get App Data
    func getAppData()  {
        
        self.view.isUserInteractionEnabled = false
        
        SVProgressHUD.show()
        
        strCat = ""
        
        AppDataManager.sharedInstance.getAppData(completionHandler: { (dict) in
            
            DispatchQueue.main.async {
                print(dict)
                var strLocationId = String()
                
                print(UserDefaults.standard.getTown())
                
                print(AppDataManager.sharedInstance.arrTowns)
                
                strLocationId = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getTown(), array: AppDataManager.sharedInstance.arrTowns as [AnyObject])
                
                var catId = String()
                
                if isCatSel == true {
                    
                    catId = UserDefaults.standard.getSelectedCat()
                }
                else {
                  let isKeyExists = CommonClass.sharedInstance.keyAlreadyExists(Key: "catSelected")
                    if isKeyExists ==  true {
                        catId = UserDefaults.standard.getCatSelect()
                    } else {
                        catId = UserDefaults.standard.getSelectedCategory()
                    }
                    
                    
                }
              
                var strCategoryID = String()
                
                var catName = String()
                
                if isAllCategories == true {
                    
                    let arrSelectedCategory = catId.components(separatedBy: ",")
                    
                    var allCategoryId = [AnyObject]()
                    
                    for i in 0..<arrSelectedCategory.count {
                        
                        let arrCategoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
                            [arrSelectedCategory[i]], array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                        
                        allCategoryId.append(arrCategoryID as AnyObject)
                        
                    }
                    
                    isShowFeed = false
                    
                    catName = ""
                    
                    catName = UserDefaults.standard.getAllCatName()
                    
                    allCategoryId.removeAll()
                    
                    self.strCat = catName
                    
                }
                else {
                    
                    let arrSelectedCategory = catId.components(separatedBy: ",")
                    
                    let arrCategoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory:
                        [arrSelectedCategory[0]], array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                    
                    strCategoryID = arrCategoryID.joined(separator: ",")
                    
                    catName = CommonClass.sharedInstance.getCategoryName(strCategory: strCategoryID, array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                    
                    let showFeed = CommonClass.sharedInstance.getShowOnLiveValue(strCategory: "\(strCategoryID)", array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                    
                    if showFeed == "0" {
                        
                        isShowFeed = true
                        
                    }
                    else {
                        
                        isShowFeed = false
                    }
                    
                    self.strCat = catName
                }
                
                let checkBusinessLogin = UserDefaults.standard.getBusinessLogin()
                
                if checkBusinessLogin == true {
                    
                    let strTown = UserDefaults.standard.getTown()
                    
                    if isTaxiCat == true {
                        
                        if checkBusinessDetailVc == false {
                            
                            let strTown = UserDefaults.standard.getTown()
                            
                            self.navigationItem.navTitle(title: "Taxis in \(strTown)")
                            
                        }
                        else {
                            
                            self.navigationItem.navTitle(title: "\(businessName)")
                            
                            let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                                    style: .plain,
                                                                    target: self,
                                                                    action: #selector(self.backButtonTapped))
                            
                            self.navigationItem.leftBarButtonItem = leftBarButtonItem
                            
                        }
                        
                    }
                    else if isBusinessDetail == false  {
                        
                        self.navigationItem.navTitle(title: "\(catName) in \(strTown)")
                        
                        if goToShowFeed == true || isMoreVc == true {
                            
                            //kirtitt
                            let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                                    style: .plain,
                                                                    target: self,
                                                                    action: #selector(self.backButtonTapped))
                            
                            self.navigationItem.leftBarButtonItem = leftBarButtonItem
                            
                            self.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Filter"),
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(self.rightMenu))
                            
                            self.navigationItem.rightBarButtonItem = self.rightBarButtonItem
                            
                        }
                        else {
                            
                            self.navigationItem.leftBarButtonItem = nil
                        }
                        
                    }
                    else {
                        
                        self.navigationItem.navTitle(title: "\(businessName)")
                        
                        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(self.backButtonTapped))
                        
                        self.navigationItem.leftBarButtonItem = leftBarButtonItem
                        
                    }
                    
                }
                else {
                    
                    if isTaxiCat == true {
                        
                        if checkBusinessDetailVc == false {
                            
                            let strTown = UserDefaults.standard.getTown()
                            
                            self.navigationItem.navTitle(title: "Taxis in \(strTown)")
                            
                        }
                        else {
                            
                            self.navigationItem.navTitle(title: "\(businessName)")
                            
                            let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                                    style: .plain,
                                                                    target: self,
                                                                    action: #selector(self.backButtonTapped))
                            
                            self.navigationItem.leftBarButtonItem = leftBarButtonItem
                            
                        }
                        
                    }
                    else if isBusinessDetail == false  {
                        
                        let strTown = UserDefaults.standard.getTown()
                        
                        self.navigationItem.navTitle(title: "\(catName) in \(strTown)")
                        
                        if goToShowFeed == true || isMoreVc == true {
                            
                            let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                                    style: .plain,
                                                                    target: self,
                                                                    action: #selector(self.backButtonTapped))
                            
                            self.navigationItem.leftBarButtonItem = leftBarButtonItem
                            
                        }
                        else {
                            
                            self.navigationItem.leftBarButtonItem = nil
                            
                        }
                        
                    }
                    else {
                        
                        self.navigationItem.navTitle(title: "\(businessName)")
                        
                        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(self.backButtonTapped))
                        
                        self.navigationItem.leftBarButtonItem = leftBarButtonItem
                        
                    }
                    
                }
                DispatchQueue.main.async {
                    
                    self.setUpView()
                    
                    strBusinessUserId = ""
                    
                }
                
            }
            
        }, failure: { (erroe) in
            print(erroe)
        })
    }
    
    
    @objc func leftMenu() {
        
        let initialVC = InitialVC(nibName:"InitialVC", bundle: nil)
        
        initialVC.isLeftDrawSelected = true
        
        leftMenuView = true
        
        let nav = UINavigationController(rootViewController: initialVC)
        
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    
    @objc func rightMenu() {
        
        popFilterView =  Bundle.main.loadNibNamed("PopUpFilterView", owner: nil, options: nil)?[0] as! PopUpFilterView
        
        popFilterView.frame.size.width = DeviceInfo.TheCurrentDeviceWidth
        
        popFilterView.frame.size.height = DeviceInfo.TheCurrentDeviceHeight
        
        popFilterView.delegate = self
        
        self.view.addSubview(popFilterView)
        
    }
    
    
    func selectedFilter(name: String) {
        
        popFilterView.removeFromSuperview()
        
        switch name {
            
        case "Near me":
            
            popFilterView.imgListing.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            selectedFilterType = "Near me"
            
            isFilterBusiness = true
            
            self.setUpView()
            
        case "Paid to free":
            
            popFilterView.imgPaidToFree.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            selectedFilterType = "Paid to free"
            
            isFilterBusiness = false
            
            self.setUpView()
            
        default:
            print("other")
        }
        
    }
    
    func dismissPopUp() {
        
        popFilterView.removeFromSuperview()
        
    }
    
    @objc func backButtonTapped() {
        
        isBusinessDetail = false
        
        isShowBusinessDetail = false
        
        checkBusinessDetailVc = false
        
        isFilterBusiness = false
        
        strBusinessUserId = ""
        
        if tabBarController?.selectedIndex == 1 || tabBarController?.selectedIndex == nil {
            
            isTaxiCat = false
            
            goToShowFeed = true
            
            isCatSel = false
        }
            
        else {
            
            isTaxiCat = false
            
            goToShowFeed = false
            
            isCatSel = false
        }
        
        openBusinessess = false
        
        self.navigationController?.popViewController(animated: true)
        
        if isBusinessDetail == false {
            
            self.tabBarController?.tabBar.isHidden = false
            
        }
        
        self.setUpView()
        
        strBusinessUserId = ""
        
    }
    
    
    @objc func setView(notification:Notification) {
        
        self.setUpNavigation()
        
        self.setUpView()
        
        strBusinessUserId = ""
        
    }
    
    
    func setUpView() {
        
        let vc1 = AllBusinessVC()
        
        let vc2 = FeedLiveVC()
        
        let vc3 = BusinessDetailVC()
        
        vc2.isFlashPostsShow = false
        
        vc2.boolComingFromSubCategory = true
        
        if isBusinessDetail == false {
            
            if isShowFeed == true {
                
                let slidingContainerViewController = SlidingContainerViewController (
                    parent: self,
                    contentViewControllers: [vc1],
                    titles: ["Business Listings"])
                
                view.addSubview(slidingContainerViewController.view)
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
                slidingContainerViewController.sliderView.appearance.outerPadding = 0
                slidingContainerViewController.sliderView.appearance.innerPadding = 50
                slidingContainerViewController.sliderView.appearance.fixedWidth = true
                slidingContainerViewController.setCurrentViewControllerAtIndex(0)
                slidingContainerViewController.delegate = self
            }
            else if strBusinessUserId == "0" {
                
                let slidingContainerViewController = SlidingContainerViewController (
                    parent: self,
                    contentViewControllers: [vc1],
                    titles: ["Business Listings"])
                
                view.addSubview(slidingContainerViewController.view)
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
                slidingContainerViewController.sliderView.appearance.outerPadding = 0
                slidingContainerViewController.sliderView.appearance.innerPadding = 50
                slidingContainerViewController.sliderView.appearance.fixedWidth = true
                slidingContainerViewController.setCurrentViewControllerAtIndex(0)
                slidingContainerViewController.delegate = self
            }
            else {
                
                let slidingContainerViewController = SlidingContainerViewController (
                    parent: self,
                    contentViewControllers: [vc1, vc2],
                    titles: ["Business Listings","Live feed"])
                view.addSubview(slidingContainerViewController.view)
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                slidingContainerViewController.sliderView.appearance.outerPadding = 0
                slidingContainerViewController.sliderView.appearance.innerPadding = 50
                slidingContainerViewController.sliderView.appearance.fixedWidth = true
                slidingContainerViewController.setCurrentViewControllerAtIndex(0)
                slidingContainerViewController.delegate = self
                
            }
            
        }
        else {
            
            if strBusinessUserId == "0" {
                
                let slidingContainerViewController = SlidingContainerViewController (
                    parent: self,
                    contentViewControllers: [vc3],
                    titles: ["Business details"])
                
                view.addSubview(slidingContainerViewController.view)
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
                slidingContainerViewController.sliderView.appearance.outerPadding = 0
                slidingContainerViewController.sliderView.appearance.innerPadding = 50
                slidingContainerViewController.sliderView.appearance.fixedWidth = true
                slidingContainerViewController.setCurrentViewControllerAtIndex(0)
                slidingContainerViewController.delegate = self
            }
            else {
                
                let slidingContainerViewController = SlidingContainerViewController (
                    parent: self,
                    contentViewControllers: [vc3, vc2],
                    titles: ["Business details","\(businessName)'s posts"])
                
                view.addSubview(slidingContainerViewController.view)
                
                SVProgressHUD.dismiss()
                
                self.view.isUserInteractionEnabled = true
                
                slidingContainerViewController.sliderView.appearance.outerPadding = 0
                slidingContainerViewController.sliderView.appearance.innerPadding = 50
                slidingContainerViewController.sliderView.appearance.fixedWidth = true
                slidingContainerViewController.setCurrentViewControllerAtIndex(0)
                slidingContainerViewController.delegate = self
            }
        }
    }
    
    
    func slidingContainerViewControllerDidMoveToViewController(_ slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int) {
        
        if atIndex == 1 {
            
            self.navigationItem.rightBarButtonItem = nil
           
            let strTown = UserDefaults.standard.getTown()
          
            Analytics.logEvent("category_in_\(strCat)", parameters: [
                "title": "Live_Feed_\(parentCategory)_in_\(strTown)"])
          
            if isLiveFeed == true {

                let checkFirstLaunch = UserDefaults.standard.getFirstTutorialLive()

                if checkFirstLaunch == true {

                    let window = appDelegate.window

                    liveFeedTutorialView = Bundle.main.loadNibNamed("LiveFeedTutorialView", owner: nil, options: nil)?[0] as! LiveFeedTutorialView

                    liveFeedTutorialView.frame = CGRect(x: 0, y: 0, width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight)

                    window?.addSubview(liveFeedTutorialView)
              }
           }
       }
       else {
            self.navigationItem.rightBarButtonItem = self.rightBarButtonItem
        }
        
    }
    
    func slidingContainerViewControllerDidHideSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    func slidingContainerViewControllerDidShowSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        
    }
}


