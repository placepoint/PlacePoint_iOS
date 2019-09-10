//
//  MultipleSelectionCategoryVC.swift
//  PlacePoint
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class MultipleSelectionCategoryVC: UIViewController {

    
    @IBOutlet weak var tblCategories: UITableView!
    
    var arrCategories = [AnyObject]()
    
    var arrSelectedCategories = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         let isKeyExistSavedCategories =
            CommonClass.sharedInstance.keyAlreadyExists(Key: "arrCategorySave")
        
        if isKeyExistSavedCategories == true {
            self.getDAtaa()
        } else {
            self.apiGetCategories()
        }
        
       

    }
    
    
    func getDAtaa()  {
        
        let arrCat = UserDefaults.standard.fetchArrCatFlashDeals()
        
        let arrParentCat = arrCat.filter{$0["parent_category"] as! String == "0"}
        
        let arrStrCatIds = arrCat.filter{$0["parent_category"] as! String == "0"}.map({ ($0["id"]!)}) as [AnyObject]
        
        let arrIntCatIds =  arrStrCatIds.compactMap { Int($0 as! String) }
        
        let isKeyExist = CommonClass.sharedInstance.keyAlreadyExists(Key: "FCategories")
        
        if isKeyExist == true {
            
            
            let arrFCategory = UserDefaults.standard.getMultipleCatForFlashDeal()
            
            if arrFCategory.count > 0 {
                
                self.arrSelectedCategories = arrFCategory as! [Int]
                
            } else {
                
                self.arrSelectedCategories = arrIntCatIds
                
            }
            
        } else {
            
            self.arrSelectedCategories = arrIntCatIds
        }
        
        
        
        self.arrCategories = arrParentCat
        
        DispatchQueue.main.async {
             SVProgressHUD.dismiss()
            self.tblCategories.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            self.tblCategories.tableFooterView = UIView()
            
            self.tblCategories.dataSource = self
            
           self.tblCategories.delegate = self
        }
        
      
    }
    
    
    // MARK: - Api Get Towns
    func apiGetCategories() {
        
        SVProgressHUD.show()
        
        self.view.isUserInteractionEnabled = false
        
        AppDataManager.sharedInstance.getAppData(completionHandler: { (dictResponse) in
            
            if AppDataManager.sharedInstance.arrTowns.count != 0 {
                
                
                let arrCities = AppDataManager.sharedInstance.arrTowns as [AnyObject]
                
                UserDefaults.standard.setArrTown(value: arrCities)
                
                let arrCat = AppDataManager.sharedInstance.arrCategories as [AnyObject]
                
                UserDefaults.standard.saveArrCatFlashDeals(value: arrCat)
                
                self.getDAtaa()
                
       
            }
            else {
                
                print("No Data")
            }
            
        }, failure: { (errorCode) in
            
            return
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setUpNavigation()
        
    }
    
    // MARK: - Set Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBarForFDeal(titleName: "")
        
        self.navigationItem.navTitle(title: "Choose Categories For Flash Deals")
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"backArrow"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
    }
    
    // backButton Tapped
    @objc func doneButtonTapped() {
        
        if arrSelectedCategories.count > 0 {
            
            UserDefaults.standard.setMultipleCatForFlashDeal(value: self.arrSelectedCategories as [AnyObject])
            
            UserDefaults.standard.synchronize()
            
            self.ApiUpdateOneSignalId()
            
           

        } else {
            self.showAlert(withTitle: "", message: "Please select catgeory")

        }
        
    }
    
    
    func ApiUpdateOneSignalId() {
        
   

        let arrFTown = UserDefaults.standard.getMultipleTownsForFlashDeal()
        
        let stringFTown =    arrFTown.compactMap { String($0 as! Int) }.joined(separator: ",")
        
        let arrFCategory = UserDefaults.standard.getMultipleCatForFlashDeal()
        
        let stringFCategory =    arrFCategory.compactMap { String($0 as! Int) }.joined(separator: ",")
    
        
        var dictParams = [String: Any]()
        
        dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
        
        dictParams["town_id"] = stringFTown
        
         dictParams["category_id"] = stringFCategory
        
        dictParams["onesignal_id"] = UserDefaults.standard.getkDeviceId()
        
        
        SVProgressHUD.show()
        
        HomeVCManager.sharedInstance.dictParams = dictParams
        
        HomeVCManager.sharedInstance.updateOnesignalid(completionHandler: { (response) in
            DispatchQueue.main.async {
                print(response)
                
                self.view.isUserInteractionEnabled = true
                UserDefaults.standard.setMultipleCatForFlashDeal(value: self.arrSelectedCategories as [AnyObject])
                
                UserDefaults.standard.synchronize()
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                appDelegate?.setUpTabVC()
                SVProgressHUD.dismiss()
            }
            
        }, failure: { (strError :String) in
            
            self.view.isUserInteractionEnabled = true
            
            SVProgressHUD.dismiss()
            
            print(strError)
        })
        
    }
    
    // backButton Tapped
    @objc func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

//MARK: UITableView DataSource and Delegate
extension MultipleSelectionCategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrCategories.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
        
        cell.textLabel?.font = UIFont(name: CustomFont.ubuntuRegular.rawValue, size: 15)
        
        cell.selectionStyle = .none
        
        let dictTown = arrCategories[indexPath.row] as? [String:AnyObject]
        
        cell.textLabel?.text = (dictTown?["name"] as! String)
        
        let strTownId = dictTown?["id"] as! String
        
        let idTown:Int? = Int(strTownId)
        
        if arrSelectedCategories.contains(idTown!) {
            
            cell.accessoryType = .checkmark
            
        } else {
            
            cell.accessoryType = .none
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let dictTown = arrCategories[indexPath.row] as? [String:AnyObject]
        
        let strTownId = dictTown?["id"] as! String
        
        let idTown:Int? = Int(strTownId)
        
        if arrSelectedCategories.count > 0 {
            
            if arrSelectedCategories.contains(idTown!) {
                
                let index =   arrSelectedCategories.index(where: { $0 == idTown })
                
                arrSelectedCategories.remove(at: index!)
                cell?.accessoryType = .none
                
            } else {
                
                cell?.accessoryType = .checkmark
                arrSelectedCategories.append(idTown!)
            }
        } else {
            
            cell?.accessoryType = .checkmark
            arrSelectedCategories.append(idTown!)
        }
        
    }
}



