//
//  MoreMenuVC.swift
//  PlacePoint
//
//  Created by Mac on 11/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import  SVProgressHUD
import AVKit
import AVFoundation
class MoreMenuVC: UIViewController {
    
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var tblMoreMenu: UITableView!
    
    var arrMenu = [String]()
    

    
    var arrMenuAfterlogin = ["Change Town", "Reset Password", "Terms and Conditions", "Privacy Policy", "Business", "Logout", ]
    
    var arrMenuBeforeLogin = ["Change Town", "Terms and Conditions", "Privacy Policy", "Business"]
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
        
        isBusinessDetail = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkLogin), name: NSNotification.Name(rawValue: "setMoreMenuData"), object: nil)
        
        let checkBusinessLogin = UserDefaults.standard.getBusinessLogin()
        
        if checkBusinessLogin == true {
            
            arrMenu = arrMenuAfterlogin
        }
        else {
            
            arrMenu = arrMenuBeforeLogin
            
        }
        self.registerTableView()
        
        self.setUpNavigation()
    }
    
    
    @objc func checkLogin() {
        
        let checkBusinessLogin = UserDefaults.standard.getBusinessLogin()
        
        if checkBusinessLogin == true {
            
            arrMenu = arrMenuAfterlogin
        }
        else {
            
            arrMenu = arrMenuBeforeLogin
            
        }
        self.registerTableView()
        
        self.setUpNavigation()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         self.setUpNavigation()
//        UserDefaults.standard.removeObject(forKey: "FCategories")
        
    }
    
    // MARK: - Set Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        self.navigationItem.navTitle(title: "More")
    }
    
    
    // MARK: - Register tableView nib
    func registerTableView() {
        
        DispatchQueue.main.async {
            
            self.tblMoreMenu.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            self.tblMoreMenu.delegate = self
            
            self.tblMoreMenu.dataSource = self
            
            self.tblMoreMenu.tableFooterView = UIView()
            
            self.tblMoreMenu.reloadData()
            
            SVProgressHUD.dismiss()
            
            self.view.isUserInteractionEnabled = true
        }
    }
}


//MARK: UITableView DataSource and Delegate
extension MoreMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableVietw: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrMenu.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
        
        cell.textLabel?.font = UIFont(name: CustomFont.ubuntuRegular.rawValue, size: 17)
        
        cell.textLabel?.text = arrMenu[indexPath.row]
        
        let image = UIImage(named: "blue_arrow")
        
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!));
        
        checkmark.image = image
        
        cell.accessoryView = checkmark
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch arrMenu[indexPath.row] {
            
        case "Privacy Policy":
            
            let privacyVc = PrivacyPolicyVC(nibName: "PrivacyPolicyVC", bundle: nil)
            
            privacyVc.isTermsAndCondition = "no"
            
            let nav = UINavigationController(rootViewController: privacyVc)
            
            self.navigationController?.present(nav, animated: true, completion: nil)
            
            break
            
        case "Reset Password":
            
            let updateVc = UpdatePasswordVC(nibName: "UpdatePasswordVC", bundle: nil)
            
            let nav = UINavigationController(rootViewController: updateVc)
            
            self.navigationController?.present(nav, animated: true, completion: nil)
            
            break
            
        case "Terms and Conditions":
            
            
            let privacyVc = PrivacyPolicyVC(nibName: "PrivacyPolicyVC", bundle: nil)
            
            privacyVc.isTermsAndCondition = "yes"
            
            let nav = UINavigationController(rootViewController: privacyVc)
            
            self.navigationController?.present(nav, animated: true, completion: nil)
            
            break
            
        case "Logout":
            
            let alertView = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                
                isLogout = true
                
                LogoutUser.sharedLogout.apiLogout()
            })
            
            alertView.addAction(action)
            
            alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            self.present(alertView, animated: true, completion: nil)
            
            break
            
        case "Change Town":
            
            let initialVC = InitialVC(nibName:"InitialVC", bundle: nil)
            
            initialVC.isLeftDrawSelected = true
            
             UserDefaults.standard.setisFirstlaunch(isFirst: false)
            
            leftMenuView = false
            
            isMoreVc = true
            
//            let nav = UINavigationController(rootViewController: initialVC)
            
            
            self.navigationController?.pushViewController(initialVC, animated: true)
            
//            self.navigationController?.present(nav, animated: true, completion: nil)
            
        case "Business":
            
            let initialVC = BusinessProfileInfoVC(nibName:"BusinessProfileInfoVC", bundle: nil)
            

            
            self.navigationController!.pushViewController(initialVC, animated: true)
            
        default:
            break
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
}
