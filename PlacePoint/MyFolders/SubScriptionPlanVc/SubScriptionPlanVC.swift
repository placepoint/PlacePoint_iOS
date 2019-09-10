//
//  SubScriptionPlanVC.swift
//  PlacePoint
//
//  Created by Mac on 08/08/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class SubScriptionPlanVC: UIViewController {

    @IBOutlet var vwForShadow: UIView!
    
    @IBOutlet var collectionPlan: UICollectionView!
    
    @IBOutlet var pageControl: UIPageControl!
    
    var currentPage = 0
    
    var arrTitle = [String]()
    
    var arrImages = [String]()
    
    var arrPrice = [String]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setUpNavigation()
        
        vwForShadow.layer.borderColor = UIColor.lightGray.cgColor
        
        vwForShadow.layer.borderWidth = 2.0
        
        let nib = UINib(nibName: "SubscriptionCollectionCell", bundle: nil) 
        
        self.collectionPlan.register(nib, forCellWithReuseIdentifier: "SubscriptionCollectionCell")
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free" {
            
            self.arrTitle = ["STANDARD PACKAGE","PREMIUM PACKAGE"]
            
            self.arrImages = ["Standard","Premium"]
            
            self.arrPrice = ["€ 150","€ 300"]
        }
        else if selectedBusinessType == "Standard" {
            
            self.arrTitle = ["PREMIUM PACKAGE"]
            
            self.arrImages = ["Premium"]
            
            self.arrPrice = ["€ 300"]
            
        }
        
    }

    
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        self.navigationItem.navTitle(title: "Subscription Plans")
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    
    @objc func backButtonTapped() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getPackageDetails() {
        
        SVProgressHUD.show()
        
        self.view.isUserInteractionEnabled = false
        
        var dictParams = [String: Any]()
        
        var currentType = String()
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
    
        if selectedBusinessType == "Free" {
            
            currentType = "3"
        }
        else if selectedBusinessType == "Standard" {
            
            currentType = "2"
        }
        else {
            
            currentType = "1"
        }
        
        dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
        
        dictParams["currenttype"] = currentType
            
        dictParams["upgrade_type"] = upgardeType
        
        FeedManager.sharedInstance.dictParams = dictParams
        
        FeedManager.sharedInstance.getPackageDetails(completionHandler: { (dictResponse) in
            
            let strStatus = dictResponse["status"] as? String
            
            if strStatus == "true" {
                
                DispatchQueue.main.async {
                
                    SVProgressHUD.dismiss()
                    
                    self.view.isUserInteractionEnabled = true
                    
                    if upgardeType == "2" {
                        
                        UserDefaults.standard.setUpdateBusUserType(userType: "Standard")
                      
                        UserDefaults.standard.setBusinessUserType(userType: "Standard")
                    }
                    else {
                        
                        UserDefaults.standard.setUpdateBusUserType(userType: "Premium")
                        
                        UserDefaults.standard.setBusinessUserType(userType: "Premium")
                    }
                    
                    let amount = dictResponse["amount_payable"] as? Int
                    
                    let paymentVc = BusinessPaymentVC(nibName: "BusinessPaymentVC", bundle: nil)
                    
                    paymentVc.amount = amount!
                    
                    let nav = UINavigationController(rootViewController: paymentVc)
                    
                    nav.modalPresentationStyle = .custom
                    
                    self.present(nav, animated: true, completion: nil)
                    
                }
                
            }
            
        }, failure: { (error) in
            
            return
        })
    }
    
}


//MARK: UICollectionView DataSource and Delegate
extension SubScriptionPlanVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func  collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.size.width) , height:collectionView.frame.size.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return arrTitle.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCollectionCell", for: indexPath as IndexPath) as! SubscriptionCollectionCell
        
        pageControl.numberOfPages = arrTitle.count
        
        cell.btnUpgrade.tag = indexPath.row
        
        cell.delegate = self
        
        cell.imgVwSubPlan.image = UIImage(named: "\(arrImages[indexPath.row])")
        
        cell.lblAmount.text = "\(arrPrice[indexPath.row])"
        
        cell.lblPackage.text = "\(arrTitle[indexPath.row])"
        
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageWidth = scrollView.frame.width
        
        self.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        
        pageControl.currentPage = self.currentPage
    }
}


//MARK: Adopt Protocol
extension SubScriptionPlanVC: SubDetails {
    
    func getSubDetails(index: Int) {
        
        let upgradePackage = arrTitle[index] as? String
        
        if upgradePackage == "STANDARD PACKAGE" {
            
            upgardeType = "2"
            
            UserDefaults.standard.setUpdateBusUserType(userType: "Standard")
        }
        else {
            
            upgardeType = "1"
            
            UserDefaults.standard.setUpdateBusUserType(userType: "Premium")
        }
        
        DispatchQueue.main.async {
            
            self.getPackageDetails()
        }
        
    }
}
