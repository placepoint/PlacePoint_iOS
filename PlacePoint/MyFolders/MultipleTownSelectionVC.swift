//
//  MultipleTownSelectionVC.swift
//  PlacePoint
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class MultipleTownSelectionVC: UIViewController {

    @IBOutlet weak var tblTowns: UITableView!
    
     var arrCities = [AnyObject]()
    var arrSelectedTowns = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.apiGetTowns()
        
      

   
    }
    
   
    // MARK: - Api Get Towns
    func apiGetTowns() {
        
        SVProgressHUD.show()
        
        self.view.isUserInteractionEnabled = false
        
        AppDataManager.sharedInstance.getAppData(completionHandler: { (dictResponse) in
            
         
            self.arrCities = AppDataManager.sharedInstance.arrTowns as [AnyObject]
            let isKeyExist = CommonClass.sharedInstance.keyAlreadyExists(Key: "FTowns")
            
            if isKeyExist == true {
                
                let arrFTown = UserDefaults.standard.getMultipleTownsForFlashDeal()
                
                if arrFTown.count > 0 {
                    
                    self.arrSelectedTowns = arrFTown as! [Int]
                    
                }
            } else {
                let arrFiltered =  self.arrCities.filter({$0["id"] as! String == "9"})
                
                let dictTown = arrFiltered[0] as? [String:AnyObject]
                
                let strTownId = dictTown?["id"] as! String
                
                let idTown:Int? = Int(strTownId)
                
                self.arrSelectedTowns.append(idTown!)
            }
            
            DispatchQueue.main.async {
                 SVProgressHUD.dismiss()
                self.tblTowns.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                
                self.tblTowns.tableFooterView = UIView()
                
                self.tblTowns.dataSource = self
                
                self.tblTowns.delegate = self
                self.view.isUserInteractionEnabled = true
                
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
        
        self.navigationItem.navTitle(title: "Choose Towns For Flash Deals")
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:""),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(backButtonTapped))

        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
    }
    
    // backButton Tapped
    @objc func doneButtonTapped() {
        
        if arrSelectedTowns.count > 0 {
          
            UserDefaults.standard.setMultipleTownsForFlashDeal(value: arrSelectedTowns as [AnyObject])
            UserDefaults.standard.synchronize()
            let vc = MultipleSelectionCategoryVC(nibName:"MultipleSelectionCategoryVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.showAlert(withTitle: "", message: "Please select town")
        }
  
    }
    
    // backButton Tapped
    @objc func backButtonTapped() {
        
       
    }
    
}

//MARK: UITableView DataSource and Delegate
extension MultipleTownSelectionVC: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrCities.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
        
        cell.textLabel?.font = UIFont(name: CustomFont.ubuntuRegular.rawValue, size: 15)
        
//        cell.accessoryType = .disclosureIndicator
        
        cell.selectionStyle = .none
        
        let dictTown = arrCities[indexPath.row] as? [String:AnyObject]
        
        cell.textLabel?.text = (dictTown?["townname"] as! String)
        
        let strTownId = dictTown?["id"] as! String
        
        let idTown:Int? = Int(strTownId)
        
        if arrSelectedTowns.contains(idTown!) {
            
            cell.accessoryType = .checkmark
            
        } else {
            
           cell.accessoryType = .none
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let dictTown = arrCities[indexPath.row] as? [String:AnyObject]
        
        let strTownId = dictTown?["id"] as! String
        
        let idTown:Int? = Int(strTownId)
        
        if arrSelectedTowns.count > 0 {
            if arrSelectedTowns.contains(idTown!) {
                
            let index =   arrSelectedTowns.index(where: { $0 == idTown })
                
            arrSelectedTowns.remove(at: index!)
            cell?.accessoryType = .none
                
            } else {
                
                cell?.accessoryType = .checkmark
                arrSelectedTowns.append(idTown!)
            }
        } else {
            
            cell?.accessoryType = .checkmark
            arrSelectedTowns.append(idTown!)
        }
    
    }
}
