//
//  BusinessProfileInfoVC.swift
//  PlacePoint
//
//  Created by Mac on 19/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SlidingContainerViewController

class BusinessProfileInfoVC: UIViewController, SlidingContainerViewControllerDelegate, SlidingContainerSliderViewDelegate {
    
    var index = Int()
    
    var editPostDict = [String: Any]()
    
    var slidingContainerViewController: SlidingContainerViewController!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var addPostTutorial = AddPostTutorial()
    
//AddPostTutorial
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        let checkBusinessProfile = UserDefaults.standard.getBusinessProfile()
//        
////        if checkBusinessProfile == false {
////
////            UserDefaults.standard.setBusinessProfile(value: true)
////        }
////        else {
//        
            UserDefaults.standard.setBusinessProfile(value: true)
//        }
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        isBusinessDetail = false
        
        isEditPost = false
        
        isScheduleVc = false
        
        isAddPost = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setData), name: NSNotification.Name(rawValue: "setProfileData"), object: nil)
        
        let checkBusinessLogin = UserDefaults.standard.getBusinessLogin()
        
        if checkBusinessLogin == false {
            
            isBusinessVc = false
            
            let loginVc = LoginVC(nibName: "LoginVC", bundle: nil)
            
            self.setUpNavigation()
            
            loginVc.delegate = self
            
            loginVc.modalPresentationStyle = .custom
            
            self.navigationController?.present(loginVc, animated: false, completion: nil)
        }
        else {
            
            isBusinessVc = true
            
            self.setUpNavigation()
            
            self.setUpView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeTabBarIndex(_:)), name: NSNotification.Name(rawValue: "changeTabBarIndex"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.setUpNavigation()
        
        self.setUpView()
    }
    
    
    @objc func setData() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.setUpNavigation()
        
        self.setUpView()
        
    }
    
    
    //MARK: - SetUp Navigation
    func setUpNavigation() {
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.themeColor()
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
    
    
    @objc func changeTabBarIndex(_ notification: NSNotification) {
        
        if isEditPost == true {
            
            if let dict = notification.userInfo as NSDictionary? {
                
                self.editPostDict = (dict as? [String: Any])!
                
                self.setUpView()
            }
        }
        else {
            self.setUpView()
        }
        
    }
    
    
    //MARK: - Set Up View
    func setUpView() {
        
        let vc1 = BusinessVC()
        
        let vc2 = AddPostVC()
        
        let vc3 = SchedulePostVC()
        
        let vc4 = FeedLiveVC()
        
        let checkBusinessLogin = UserDefaults.standard.getBusinessLogin()
        
        if checkBusinessLogin == true {
            
            slidingContainerViewController = SlidingContainerViewController (
                parent: self,
                contentViewControllers: [vc1, vc2, vc3, vc4],
                titles: ["Profile","Add post","Scheduled","My posts"])
            
            navigationItem.navTitle(title: slidingContainerViewController.titles[index])
            
            view.addSubview(slidingContainerViewController.view)
            
            slidingContainerViewController.sliderView.appearance.outerPadding = 0
            slidingContainerViewController.sliderView.appearance.innerPadding = 50
            slidingContainerViewController.sliderView.appearance.fixedWidth = true
            
            slidingContainerViewController.sliderView.sliderDelegate = self
            
            if isScheduleVc == false && isAddPost == true {
                
                slidingContainerViewController.setCurrentViewControllerAtIndex(3)
                
            }
            else if isEditPost == true {
                
                slidingContainerViewController.setCurrentViewControllerAtIndex(1)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editPostInfo"), object: nil, userInfo: self.editPostDict)
            }
                
            else if isScheduleVc == true && isAddPost == true {
                
                slidingContainerViewController.setCurrentViewControllerAtIndex(2)
                
            }
            else if isAddPost == true{
                
                slidingContainerViewController.setCurrentViewControllerAtIndex(1)
            }
            else {
                
                slidingContainerViewController.setCurrentViewControllerAtIndex(0)
            }
            
            slidingContainerViewController.delegate = self
        }
        
    }
    
    
    func slidingContainerViewControllerDidMoveToViewController(_ slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int) {
        
        self.index = atIndex
        
        navigationItem.navTitle(title: slidingContainerViewController.titles[index])
        
//        if atIndex == 1 {
//
//            let checkFirstLaunch = UserDefaults.standard.getFirstTutorialPost()
//
//            if checkFirstLaunch == true {
//
//                let window = appDelegate.window
//
//                addPostTutorial = Bundle.main.loadNibNamed("AddPostTutorial", owner: nil, options: nil)?[0] as! AddPostTutorial
//
//                addPostTutorial.frame = CGRect(x: 0, y: 0, width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight)
//
//                window?.addSubview(addPostTutorial)
//            }
//
//        }
        
    }
    
    
    func slidingContainerViewControllerDidHideSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    
    func slidingContainerViewControllerDidShowSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    
    func slidingContainerSliderViewDidPressed(_ slidingtContainerSliderView: SlidingContainerSliderView, atIndex: Int) {
        
        if atIndex == 1 {
            
            let addPostVC = slidingContainerViewController.contentViewControllers[1] as! AddPostVC
            
            addPostVC.clearAllData()
            
            addPostVC.chooseCat = false
            
            addPostVC.setUpView()
            
            slidingContainerViewController.setCurrentViewControllerAtIndex(1)
            
            let checkFirstLaunch = UserDefaults.standard.getFirstTutorialPost()
            
            if checkFirstLaunch == true {
                
                let window = appDelegate.window
                
                addPostTutorial = Bundle.main.loadNibNamed("AddPostTutorial", owner: nil, options: nil)?[0] as! AddPostTutorial
                
                addPostTutorial.frame = CGRect(x: 0, y: 0, width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight)
                
                window?.addSubview(addPostTutorial)
            }
            
        }
        else if atIndex == 0 {
            
            isAddPost = false
            
            isEditPost = false
            
            isScheduleVc = false
            
            slidingContainerViewController.setCurrentViewControllerAtIndex(0)
            
        }
        else {
            
            slidingContainerViewController.setCurrentViewControllerAtIndex(atIndex)
        }
    }
}


//MARK: - Adopt Protocol
extension BusinessProfileInfoVC: CheckUserLogin {
    
    func checkUserLogin(isLogin: Bool) {
        
        if isLogin == false {
            
            let appDel = UIApplication.shared.delegate as? AppDelegate
            
            appDel?.setUpRootVC()
            
        }
        
    }
}
