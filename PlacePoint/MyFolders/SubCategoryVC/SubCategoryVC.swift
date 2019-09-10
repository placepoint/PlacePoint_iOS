//
//  SubCategoryVC.swift
//  PlacePoint
//
//  Created by Mac on 25/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class SubCategoryVC: UIViewController {
    
    @IBOutlet var collectionSubCategory: UICollectionView!
    
    @IBOutlet var VwNoSubCategory: UIView!
    
    @IBOutlet var lblNoSubCategory: UILabel!
    
    var arrSubCategories = [AnyObject]()
    
    var arrAllSubCatName = [String]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if arrSubCategories.count == 0 {
            
            self.VwNoSubCategory.isHidden = false
            
            self.lblNoSubCategory.isHidden = false
        }
        else {
            
            for i in 0..<arrSubCategories.count {
                
                let dict = arrSubCategories[i] as? [String: Any]
                
                let catName = dict!["subCat"] as? String
                
                arrAllSubCatName.append(catName!)
                
            }
            if parentCategory != "Taxis" {
                
                let dictSubCategory = [String: Any]()
                
                arrSubCategories.insert(dictSubCategory as AnyObject, at: 0)
                
            }
            
            self.registerTableView()
        }
        
        self.setUpNavigation()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        self.setUpNavigation()
        
    }
    
    
    // MARK: - APi App Auth
    func apiAppAuth() {
        
        AppDataManager.sharedInstance.getAppAuth(completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                if isFirstCome == false {
                    
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    
                    appDelegate?.setUpRootVC()
                }
                else {
                    
                    goToShowFeed = true
                    
                    let feedDetailsVC = BuisnessShowFeedVc(nibName: "BuisnessShowFeedVc", bundle: nil)
                    
                    self.navigationController?.pushViewController(feedDetailsVC, animated: true)
                    
                }
                
            }
        }, failure: { (errorCode) in
            
            return
            
        })
    }
    
    
    // MARK: - Register TableView nib
    func registerTableView() {
        
        let  cellNib1 = UINib(nibName: "CategoryCollectionCell", bundle: nil)
        
        collectionSubCategory.register(cellNib1, forCellWithReuseIdentifier: "CategoryCollectionCell")
        
        collectionSubCategory.delegate = self
        
        collectionSubCategory.dataSource = self
        
    }
    
    
    //MARK: - SetUp Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        let strTown = selectedTown
        
        self.navigationItem.navTitle(title: "\(parentCategory) in \(strTown)")
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
    }
    
    
    // backButton Tapped
    @objc func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}


//MARK: CollectionView DataSource and Delegate
extension SubCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSubCategories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as? CategoryCollectionCell else {
            
            fatalError()
        }
        
        cell.setSubCategoryData(arr: arrSubCategories, index: indexPath.row)
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.size.width - 15)/2 , height: 120)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        isCatSel = true
        
        isFilterBusiness = false
        
        selectedFilterType = ""
        
        openBusinessess = true
        
//        let checkAppAuthFirst = UserDefaults.standard.getisAppAuthFirst()
//
//        if checkAppAuthFirst == false {
//
//            //Raj
//            self.apiAppAuth()
//        }
        
//        UserDefaults.standard.setSelectedTownAndCategories(value: true)
        
        //        UserDefaults.standard.setSelectedTown(value: selectedTown as! String)
        
        
        selectedTown = UserDefaults.standard.getTown()
        
        UserDefaults.standard.setTown(value: selectedTown)
        
        if indexPath.row == 0 {
            
            isAllCategories = true
            
            isAllCat = true
            
            isTaxiCat = false
            
            let strCategory = arrAllSubCatName.joined(separator: ",")
            
            UserDefaults.standard.setSelectedCat(value: strCategory)
            
            UserDefaults.standard.setCatSelect(value: strCategory)
            
            UserDefaults.standard.setAllCatName(value: "All \(parentCategory)")
            
            Analytics.logEvent("category_in_\(selectedTown)", parameters: [
                "title": "All_\(parentCategory)"])
        }
        else {
            
            isAllCat = false
            
            isAllCategories = false
            
            let strCategory = (arrSubCategories[indexPath.row]["subCat"] as? String)
            
            UserDefaults.standard.setSelectedCat(value: strCategory!)
            
            //let strCat = arrAllSubCatName.joined(separator: ",")
            
            let strCat = arrAllSubCatName[indexPath.row-1]
            
            UserDefaults.standard.setCatSelect(value: strCat)
            
            Analytics.logEvent("category_in_\(selectedTown)", parameters: [
                "title": String(format: "%@_%@", arrSubCategories[indexPath.row]["subCat"] as! String, parentCategory)])
        }
        
        let checkAppAuthFirst = UserDefaults.standard.getisAppAuthFirst()
        
        if checkAppAuthFirst == true {

            if leftMenuView == true {

                self.dismiss(animated: true, completion: nil)
            }
            else {

                goToShowFeed = true

                let feedDetailsVC = BuisnessShowFeedVc(nibName: "BuisnessShowFeedVc", bundle: nil)

                self.navigationController?.pushViewController(feedDetailsVC, animated: true)

            }
        }
        
    }
}
