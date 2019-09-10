//
//  ChooseCategoryVC.swift
//  PlacePoint
//
//  Created by Mac on 29/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import MMDrawerController
import Kingfisher

class ChooseCategoryVC: UIViewController {
    
    @IBOutlet weak var collectionViewCategories: UICollectionView!
    
    var arrAllCategories = [AnyObject]()
    
    var selectedCat = String()
    
     let checkAppAuthFirst = UserDefaults.standard.getisAppAuthFirst()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        isFilterBusiness = false
        
         selectedFilterType = ""
        
        isBusinessDetail = false
        
        self.registerTableView()
        
        self.setUpNavigation()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        self.setUpNavigation()
        
    }
    
    
    @objc func setView() {
        
        isBusinessDetail = false
        
        self.registerTableView()
        
        self.setUpNavigation()
        
    }
    
    
    // MARK: - Register TableView nib
    func registerTableView() {
        
//        let checkBusinessProfile = UserDefaults.standard.getBusinessProfile()
        
        let keyExist = CommonClass.sharedInstance.keyAlreadyExists(Key: "arrCat")
        
//        let arrCateory = UserDefaults.standard.getArrCategories()
        
        if keyExist == false {

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
        
        
        let arrFiltered = AppDataManager.sharedInstance.arrCategories.filter({$0["name"] as! String == "Taxis"})
        
        if arrFiltered.count > 0 {
            
            let dictTaxi = arrFiltered.first as! [String:Any]
            
            let strIds = dictTaxi["town_id"] as! String
            
            let arrIds = strIds.components(separatedBy: ",")
            
            var townId = String()
            
            let myTowName = selectedTown
            
            print(UserDefaults.standard.getTown())
            
            print(AppDataManager.sharedInstance.arrTowns)
            
            if selectedTown == "" {
                
                townId = CommonClass.sharedInstance.getLocationId(strLocation: UserDefaults.standard.getTown(), array: AppDataManager.sharedInstance.arrTowns)
                
                
                selectedTown = UserDefaults.standard.getTown()
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
        
        let arrCategories = AppDataManager.sharedInstance.arrCategories as [AnyObject]
        
        for i in 0..<arrCategories.count {
            
            var dictCatData = [String: Any]()
            
            var catName = String()
            
            var subCatName = String()
            
            if arrCategories[i]["parent_category"] as? String == "0" {
                
                let catId = arrCategories[i]["id"] as? String
                
                catName = CommonClass.sharedInstance.getCategoryName(strCategory: catId!, array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                
                let strImg = arrCategories[i]["image_url"] as! String
                
                dictCatData["img_url"] = strImg
                
                dictCatData["child"] = []
                
                var arrChild = [AnyObject]()
                
                for a in 0..<arrCategories.count {
                    
                    if arrCategories[a]["parent_category"] as? String == catId {
                        
                        subCatName = (arrCategories[a]["name"] as? String)!
                        
                        let strImg = arrCategories[a]["image_url"] as! String
                        
                        var dictSubCat = [String: Any]()
                        
                        dictSubCat["subCat"] = subCatName
                        
                        dictSubCat["img_url"] = strImg
                        
                        arrChild.append(dictSubCat as AnyObject)
                        
                        dictCatData["child"] = arrChild
                        
                    }
                    
                    dictCatData["parentCat"] = catName
                }
                
                self.arrAllCategories.append(dictCatData as AnyObject)
                
            }
        }
        
        let  cellNib1 = UINib(nibName: "CategoryCollectionCell", bundle: nil)
        
        collectionViewCategories.register(cellNib1, forCellWithReuseIdentifier: "CategoryCollectionCell")
        
        collectionViewCategories.delegate = self
        
        collectionViewCategories.dataSource = self
    }
    
    
    //MARK: - SetUp Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        var strTown = String()
        
        if checkAppAuthFirst == true {
           
            let town = UserDefaults.standard.getTown()
            
            strTown = town
            
        }
        else {
            
           strTown = selectedTown
        }
        
        
        self.navigationItem.navTitle(title: "Category in \(strTown)")
        
//        let checkAppAuthFirst = UserDefaults.standard.getisAppAuthFirst()
        
        if checkAppAuthFirst == false || isMoreVc == true || leftMenuView == true{
            
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
    
}


//MARK: UICollectionView DataSource and Delegate
extension ChooseCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrAllCategories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as? CategoryCollectionCell else {
            
            fatalError()
        }
        
        cell.setData(arr: arrAllCategories, index: indexPath.row)
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.size.width - 15)/2 , height: 120)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let subCategory = SubCategoryVC(nibName: "SubCategoryVC", bundle: nil)
        
        let childArray = arrAllCategories[indexPath.row]["child"] as? AnyObject
        
        parentCategory = (arrAllCategories[indexPath.row]["parentCat"] as? String)!
        
        if childArray?.count == 0 {
            
            subCategory.arrSubCategories = [] as [AnyObject]
        }
        else {
            
            subCategory.arrSubCategories = arrAllCategories[indexPath.row]["child"] as! [AnyObject]
        }
        
        self.navigationController?.pushViewController(subCategory, animated: true)
        
    }
}
