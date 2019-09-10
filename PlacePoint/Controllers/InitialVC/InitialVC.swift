//
//  InitialVC.swift
//  PlacePoint
//
//  Created by Mac on 28/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD
import MMDrawerController

class InitialVC: UIViewController {
    
    @IBOutlet var tableViewCities: UITableView!
    
    var isLeftVC: Bool = false
    
    var arrCities = [AnyObject]()
    
    var arrSearchData = [AnyObject]()
    
    var isLeftDrawSelected: Bool = false
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.apiGetTowns()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
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
    
    
    // MARK: - Set Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        self.navigationItem.navTitle(title: "Choose a town")
        
        if isLeftDrawSelected == true {
            
            let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(backButtonTapped))
            
            self.navigationItem.leftBarButtonItem = leftBarButtonItem
            
        }
    }
    
    
    // backButton Tapped
    @objc func backButtonTapped() {
        
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Api Get Towns
    func apiGetTowns() {
        
        SVProgressHUD.show()
        
        self.view.isUserInteractionEnabled = false
        
        AppDataManager.sharedInstance.getAppData(completionHandler: { (dictResponse) in
            
            if AppDataManager.sharedInstance.arrTowns.count != 0 {
                
                self.arrCities = AppDataManager.sharedInstance.arrTowns as [AnyObject]
                
                  UserDefaults.standard.setArrTown(value: self.arrCities)
                
                let strTown = self.arrCities.map({ ($0["townname"]!)}) as [AnyObject]
                
                self.arrSearchData = strTown as [AnyObject]
                
                self.registerTableView()
            }
            else {
                
                print("No Data")
            }
            
        }, failure: { (errorCode) in
            
             return
        })
    }
    
  
    // MARK: - Register tableView nib
    func registerTableView() {
        
        DispatchQueue.main.async {
            
            self.tableViewCities.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            self.tableViewCities.delegate = self
            
            self.tableViewCities.dataSource = self
            
            self.tableViewCities.tableFooterView = UIView()
            
            self.tableViewCities.reloadData()
            
            SVProgressHUD.dismiss()
            
            self.view.isUserInteractionEnabled = true
        }
    }
}


//MARK: UITableView DataSource and Delegate
extension InitialVC: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrCities.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
        
        cell.textLabel?.font = UIFont(name: CustomFont.ubuntuRegular.rawValue, size: 15)
        
        cell.accessoryType = .disclosureIndicator
        
        cell.selectionStyle = .none
        
        cell.textLabel?.text = (arrSearchData[indexPath.row] as! String)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let strTown = (arrSearchData[indexPath.row])
        
        selectedTown = strTown as! String
        
        UserDefaults.standard.setTown(value: selectedTown as! String)
        
        let checkAppAuthFirst = UserDefaults.standard.getisAppAuthFirst()
        
        if checkAppAuthFirst == false {
            
            self.apiAppAuth()
            
        }
        
        let checkFirstLaunch = UserDefaults.standard.getisFirstlaunch()
        
        if checkFirstLaunch == false {
            
            let chooseCategoryVC = ChooseCategoryVC(nibName: "ChooseCategoryVC", bundle: nil)
            
            self.navigationController?.pushViewController(chooseCategoryVC, animated: true)
            
        }
        
    }
}
