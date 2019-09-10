//
//  Extension+BusinessDetailVC.swift
//  PlacePoint
//
//  Created by Mac on 19/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

//MARK: TableView DataSource and Delegate
extension BusinessDetailVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let array =  dictBusinessDetails["image_url"] as! [AnyObject]
        
        if array.count != 0 {
            
            return 3
        }
        
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AboutPubCell", for: indexPath) as? AboutPubCell else {
                fatalError()
            }
            let arrFiltered = AppDataManager.sharedInstance.arrCategories.filter({$0["name"] as! String == "Taxis"})
            
            if arrFiltered.count > 0 {
                
                let dictTaxi = arrFiltered.first as! [String:Any]
                
                let strIds = dictTaxi["town_id"] as! String
                
                let arrIds = strIds.components(separatedBy: ",")
                
                let townId = dictBusinessDetails["town_id"] as? String
                
                if arrIds.contains(townId!) {
                    
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
            
            cell.selectionStyle = .none
            
            cell.delegate = self
            
//            cell.btnCall.tag = indexPath.row
            
            cell.btnTaxi.tag = indexPath.row
            
            cell.btnNavigation.tag = indexPath.row
            
            cell.setData(dict: dictBusinessDetails, arr: arrOpeningHrs)
            
            return cell
        }
        else if indexPath.row == 1 {
            
            let array =  dictBusinessDetails["image_url"] as! [AnyObject]
            
            if array.count != 0 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessPhotoTableCell", for: indexPath) as? BusinessPhotoTableCell else {
                    fatalError()
                }
                
                cell.selectionStyle = .none
                
                arrBusinessImages = array
                
                cell.delegate = self
                
                return cell
            }
            else {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpeningDetailsCell", for: indexPath) as? OpeningDetailsCell else{
                    fatalError()
                }
                
                cell.selectionStyle = .none
                
                if arrOpeningHrs.count == 0 {
                    
                     arrFilterTime.removeAll()
                    
                    cell.setUpView()
                }
                else{
                    
                     self.setCell(tableCell: (cell as? OpeningDetailsCell)!)
                }
               
                
                return cell
            }
        }
        else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpeningDetailsCell", for: indexPath) as? OpeningDetailsCell else{
                fatalError()
            }
            
            cell.selectionStyle = .none
            
            self.setCell(tableCell: (cell as? OpeningDetailsCell)!)
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return UITableViewAutomaticDimension
        }
        else if indexPath.row == 1 {
            
            let array =  dictBusinessDetails["image_url"] as! [AnyObject]
            
            if array.count != 0 {
                
                return 100
            }
            if arrOpeningHrs.count > 0 {
                return 250
            }
            else {
                return 150
            }
        }
        else if indexPath.row == 2 {
            
            if arrOpeningHrs.count > 0 {
                  return 250
            }
            else {
                return 150
            }
        }
        
        return UITableViewAutomaticDimension
    }
}


//MARK: Adopt Protocol
extension BusinessDetailVC: OpenPreviewImages {
    
    func openImagePreview(index: Int) {
        
        let previewVc = PreviewImagesVC(nibName: "PreviewImagesVC", bundle: nil)
        
        previewVc.cellIndex = index
        
        self.navigationController?.pushViewController(previewVc, animated: true)
    }
}


extension BusinessDetailVC: mapDelegate {
    
    func showMapView() {
        
        let mapVC = MapVC(nibName: "MapVC", bundle: nil)
        
        mapVC.lat = (dictBusinessDetails["lat"] as? NSString)!
        
        mapVC.long = (dictBusinessDetails["long"] as? NSString)!
        
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
}


extension BusinessDetailVC: BusinessBtnAction {
    
    func callMe(index: Int) {
        
        let contactNo = (dictBusinessDetails["use_contact_no"] as? String)!
        
        
        if contactNo == "" {
            
            self.showAlert(withTitle: "Alert!", message: "Contact No. is not available.")
            
            
        } else {
            
            if let url = URL(string: "tel://\(contactNo)"), UIApplication.shared.canOpenURL(url) {
                
                if #available(iOS 10, *) {
                    
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
                } else {
                    
                    UIApplication.shared.openURL(url)
                }
            }
            
        }
        
     
        
    }
    
    func openMapNavigation(index: Int) {
        
        let longitude = (dictBusinessDetails["long"] as? String)!
        
        let long = ((longitude as? NSString)?.doubleValue)!
        
        let latitude = (dictBusinessDetails["lat"] as? String)!
        
        let lat = ((latitude as? NSString)?.doubleValue)!
        
        let mapVC = MapNavigationVC(nibName: "MapNavigationVC", bundle: nil)
        
        mapVC.latitude = lat
        
        mapVC.longitude = long
        
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    
    func openTaxiDetail(index: Int) {
        
        isBusinessDetail = false
        
        isShowFeed = false
        
        isTaxiCat = true
        
//        isCatSel = true
        
        checkBusinessDetailVc = false
        
        let arrFiltered = AppDataManager.sharedInstance.arrCategories.filter({$0["name"] as! String == "Taxis"})
        
        if arrFiltered.count > 0 {
            
            let dictTaxi = arrFiltered.first as! [String:Any]
            
            let strIds = dictTaxi["id"] as! String
            
            let myTowName = UserDefaults.standard.getTown()
            
            let townId = CommonClass.sharedInstance.getLocationId(strLocation: myTowName, array: AppDataManager.sharedInstance.arrTowns)
            
            UserDefaults.standard.setSelectedCat(value: "Taxis")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "afterUpgarde"), object: nil)
            
        }
        else {
            
            isTaxiCat = false
            
            AppDataManager.sharedInstance.arrAllFeeds.removeAll()
            
            self.vwLoading.isHidden = true
            
            self.tblPubDetail.isHidden = true
            
            self.lblNoPost.isHidden = false
            
        }
        
    }
    
}
