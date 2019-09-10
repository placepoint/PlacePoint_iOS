//
//  TabBarVC.swift
//  PlacePoint
//
//  Created by Mac on 29/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController ,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        isFirstCome = true
        
        heightOfTabbar = self.tabBar.frame.height
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.navigationItem.hidesBackButton = true
    
        self.navigationController?.navigationBar.barTintColor =  UIColor.gray
        
        let tabOne = DealsVC()
        
        let navOne = UINavigationController(rootViewController: tabOne)
        
        let tabOneBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "img_Home"), selectedImage:#imageLiteral(resourceName: "img_Home"))
        
        tabOneBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        
        tabBar.tag = 1
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        let tabTwo = ChooseCategoryVC()
        
        let navTwo = UINavigationController(rootViewController: tabTwo)
        
        let tabTwoBarItem2 = UITabBarItem(title: "Categories", image: #imageLiteral(resourceName: "img_category"), selectedImage: #imageLiteral(resourceName: "img_category"))
        
        tabTwoBarItem2.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
        
        tabBar.tag = 2
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        
        
        let tabThree = HomeVC()

        let navThree = UINavigationController(rootViewController: tabThree)

        let tabThreeBarItem3 =  UITabBarItem(title: "Deals", image: UIImage(named: "deals"), selectedImage: UIImage(named: "deals"))

        tabThreeBarItem3.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);

        tabBar.tag = 3

        tabThree.tabBarItem = tabThreeBarItem3
        
        
        
        
        let tabFour = BusinessProfileInfoVC()
        
        let navFour = UINavigationController(rootViewController: tabFour)
        
        let tabFourBarItem =  UITabBarItem(title: "Business", image: #imageLiteral(resourceName: "img_business"), selectedImage: #imageLiteral(resourceName: "img_business"))
        
        tabFourBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
        
        tabBar.tag = 3
        
        tabFour.tabBarItem = tabFourBarItem
        
        
        let tabFive = MoreMenuVC()
        
        let navFive = UINavigationController(rootViewController: tabFive)
        
        let tabFiveBarItem =  UITabBarItem(title: "More", image: #imageLiteral(resourceName: "img_More"), selectedImage: #imageLiteral(resourceName: "img_More"))
        
        tabFiveBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
        
        tabBar.tag = 4
        
        tabFive.tabBarItem = tabFiveBarItem
        
        tabBar.barTintColor = UIColor.themeColor()
        
        tabBar.unselectedItemTintColor = UIColor.white
        
        UITabBar.appearance().tintColor = UIColor.tabBarSelectedColor()
        
//        let controllers = [tabOne,tabTwo,tabFour,tabFive]
        
        
        let controllers = [tabOne,tabThree,tabTwo,tabFive]
        
        tabBarController?.viewControllers = controllers
        
        self.tabBarController?.selectedIndex = 2
        
        tabBarController?.selectedViewController = tabFour
        
        self.viewControllers = [navOne, navThree, navTwo,navFive]
//        self.viewControllers = [navOne, navTwo, navFour,navFive]
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
       if item.title == "Categories"{
        
            selectedFilterType = ""
        
            isFilterBusiness = false
        
            isCatgoryTabSelected = true
        
            leftMenuView = false
        
//            UserDefaults.standard.setisFirstlaunch(isFirst: true)
        
            let rootView = self.viewControllers![1] as! UINavigationController
            
            rootView.popToRootViewController(animated: false)
            
            goToShowFeed = true
            
            isEditPost = false
            
            isScheduleVc = false
            
            isAddPost = false
        
//            isBusinessProfile = false
        
            checkMyTimeLine = ""
            
            if isTaxiCat == true {
                
                isTaxiCat = false
            }
            
        }
        else if item.title == "Business"{
        
            selectedFilterType = ""
        
            isFilterBusiness = false
        
            isCatgoryTabSelected = false
        
            checkMyTimeLine = "My Posts"
            
            goToShowFeed = false
            
            isBusinessVc = true
            
            leftMenuView = false
            
        }
        else {
        
            selectedFilterType = ""
        
            isFilterBusiness = false
        
//            isBusinessProfile = false
        
            isCatgoryTabSelected = false
        
            leftMenuView = false
            
            goToShowFeed = true
            
            checkMyTimeLine = ""
            
            if isTaxiCat == true {
                
                isTaxiCat = false
            }
        }
        
    }
}
