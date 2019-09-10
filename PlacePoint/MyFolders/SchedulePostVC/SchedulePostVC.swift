//
//  SchedulePostVC.swift
//  PlacePoint
//
//  Created by Mac on 24/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

class SchedulePostVC: UIViewController {
    
    @IBOutlet var lblNoSchedule: UILabel!
    
    @IBOutlet var vwLoading: UIView!
    
    @IBOutlet var tblSchedulePost: UITableView!
    
    var type = String()
    
    var arraySchedulePost = [AnyObject]()
    
    var rowIndex = Int()
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setView), name: Notification.Name("afterUpgarde"), object: nil)
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free" || selectedBusinessType == "Standard" {
            
            let nib = Bundle.main.loadNibNamed("PopUpPremium", owner: nil, options: nil)?[0] as! PopUpPremium
            
            nib.frame = self.tblSchedulePost.frame
            
            self.tblSchedulePost.isHidden = true
            
            nib.delegate = self
            
            self.view.addSubview(nib)
        }
        else {
            
            let schedulePostCell = UINib(nibName: "SchedulePostCell", bundle: nil)
            
            tblSchedulePost.register(schedulePostCell, forCellReuseIdentifier: "SchedulePostCell")
            
            tblSchedulePost.dataSource = self
            
            tblSchedulePost.delegate = self
            
            self.getScheduledPost()
            
        }
    }
    
    
    //MARK: get Scheduled post
    func getScheduledPost() {
        
        var dict = [String: Any]()
        
        dict["auth_code"] = UserDefaults.standard.getAuthCode()
        
        SVProgressHUD.show()
        
        FeedManager.sharedInstance.dictParams = dict
        
        FeedManager.sharedInstance.getScheduledPost(completionHandler: { (dictResponse) in
            
            SVProgressHUD.dismiss()
            
            let strStatus = dictResponse["status"] as? String
            
            if strStatus == "true" {
                
                DispatchQueue.main.async {
                    
                    SVProgressHUD.dismiss()
                    
                    let arrData = dictResponse["data"] as? [AnyObject]
                    
                    self.arraySchedulePost = arrData!
                    
                    self.tblSchedulePost.isHidden = false
                    
                    self.vwLoading.isHidden = true
                    
                    self.lblNoSchedule.isHidden = true
                    
                    self.tblSchedulePost.reloadData()
                    
                }
            }
            else {
                
                DispatchQueue.main.async {
                    
                    SVProgressHUD.dismiss()
                    
                    self.view.isUserInteractionEnabled = true
                    
                    self.vwLoading.isHidden = true
                    
                    self.lblNoSchedule.isHidden = false
                    
                    self.tblSchedulePost.isHidden = true
                }
                
            }
            
        }, failure: { (error) in
            
             return
        })
        
    }
    
    
    func openActionSheet() {
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Edit", style: .default) { action -> Void in
            
            self.editPost()
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Delete", style: .default) { action -> Void in
            
            self.deletePost()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
        
    }
    
    
    func editPost() {
        
        let dict = arraySchedulePost[rowIndex] as? [String: Any]
        
        isEditPost = true
        
        isAddPost = false
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTabBarIndex"), object: nil, userInfo: dict)
        
    }
    
    
    @objc func setView() {
        
        self.tblSchedulePost.isHidden = false
        
        self.tblSchedulePost.dataSource = self
        
        self.tblSchedulePost.delegate = self
        
        self.tblSchedulePost.reloadData()
        
    }
    
    
    func deletePost() {
        
        SVProgressHUD.show()
        
        let dict = arraySchedulePost[rowIndex] as? [String: Any]
        
        self.view.isUserInteractionEnabled = false
        
        self.view.endEditing(true)
        
        var dictParams = [String: Any]()
        
        dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
        
        dictParams["post_id"] = dict?["id"]
        
        FeedManager.sharedInstance.dictParams = dictParams
        
        SVProgressHUD.show()
        
        FeedManager.sharedInstance.deleteSchedulePost(completionHandler: { (dictResponse) in
            
            SVProgressHUD.dismiss()
            
            let strStatus = dictResponse["status"] as? String
            
            if strStatus == "true" {
                
                DispatchQueue.main.async {
                    
                    SVProgressHUD.dismiss()
                    
                    self.view.isUserInteractionEnabled = true
                    
                    self.arraySchedulePost.remove(at: self.rowIndex)
                    
                    if self.arraySchedulePost.count == 0 {
                        
                        self.tblSchedulePost.isHidden = true
                        
                        self.lblNoSchedule.isHidden = false
                        
                    }
                    else {
                        
                        self.tblSchedulePost.reloadData()
                    }
                    
                }
            }
            
        }, failure: { (error) in
            
              return
            
        })
        
    }
}


//MARK: TableView DataSource and delegate
extension SchedulePostVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arraySchedulePost.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulePostCell", for: indexPath) as? SchedulePostCell else {
            
            fatalError()
        }
        
        cell.selectionStyle = .none
        
        cell.btnEdit.tag = indexPath.row
        
        let dictCreatedPost = arraySchedulePost[indexPath.row] as? [String: Any]
        
        var day = String()
        
        var time = String()
        
        var strUrl = String()
        
        if dictCreatedPost!["type"] as? String == "1" {
            
            if let daySelected = dictCreatedPost!["day"] as? String {
                
                let strDay = DayClass.sharedInstance.getDay(index: daySelected)
                
                day = strDay
            }
            
            if let timeSelected = dictCreatedPost!["time"] as? String {
                
                time = timeSelected
            }
            
            if let imgUrl = dictCreatedPost!["image_url"] as? String {
                
                strUrl = imgUrl
            }
            
            cell.lblSchedule.text = "Scheduled on every \(day) at @\(time)"
            
            if strUrl != "" {
                
                let url = URL(string:strUrl)!
                
                cell.imgView.kf.indicatorType = .activity
                
                (cell.imgView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
                
                cell.imgView.kf.setImage(with: url,
                                         placeholder: #imageLiteral(resourceName: "placeholder"),
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in
                },
                                         completionHandler: { image, error, cacheType, imageURL in
                })
            }
            
        }
        else if dictCreatedPost!["type"] as? String == "2" {
            
            if let daySelected = dictCreatedPost!["day"] as? String {
                
                day = daySelected
            }
            
            if let timeSelected = dictCreatedPost!["time"] as? String {
                time = timeSelected
            }
            
            if let imgUrl = dictCreatedPost!["image_url"] as? String {
                
                strUrl = imgUrl
            }
            
            cell.lblSchedule.text = "Scheduled on every \(day) of the month @\(time)"
            
            if strUrl != "" {
                
                let url = URL(string:strUrl as! String)!
                
                cell.imgView.kf.indicatorType = .activity
                
                (cell.imgView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
                
                cell.imgView.kf.setImage(with: url,
                                         placeholder: #imageLiteral(resourceName: "placeholder"),
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in
                },
                                         completionHandler: { image, error, cacheType, imageURL in
                })
            }
            
        }
        else {
            
            if let daySelected = dictCreatedPost!["day"] as? String {
                
                day = daySelected
            }
            
            if let timeSelected = dictCreatedPost!["time"] as? String {
                
                time = timeSelected
            }
            
            if let imgUrl = dictCreatedPost!["image_url"] as? String {
                
                strUrl = imgUrl
            }
            
            cell.lblSchedule.text = "Scheduled on \(day) @\(time)"
            
            if strUrl != "" {
                
                let url = URL(string:strUrl as! String)!
                
                cell.imgView.kf.indicatorType = .activity
                
                (cell.imgView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
                
                cell.imgView.kf.setImage(with: url,
                                         placeholder: #imageLiteral(resourceName: "placeholder"),
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in
                },
                                         completionHandler: { image, error, cacheType, imageURL in
                })
            }
        }
        
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
}


//MARK: Adopt Protocol
extension SchedulePostVC: OpenPicker {
    
    func openPicker(cellIndex: Int) {
        
        self.rowIndex = cellIndex
        
        self.openActionSheet()
    }
}

extension SchedulePostVC: UpgradePlan {
    
    func upgradeSubPlan() {
        
        isScheduleVc = true
        
        let strSelectedType = UserDefaults.standard.getBusinessUserType()
        
        if strSelectedType == "Free" {
            
            strUserType = "3"
        }
        else if strSelectedType == "Standard" {
            
            strUserType = "2"
        }
        else if strSelectedType == "Premium" {
            
            strUserType = "1"
        }
        else {
            
            strUserType = "4"
        }
        
        let subPlanVc = SubScriptionPlanVC(nibName: "SubScriptionPlanVC", bundle: nil)
        
        let nav = UINavigationController(rootViewController: subPlanVc)
        
        nav.modalPresentationStyle = .custom
        
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
}
