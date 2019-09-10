//
//  FreeBusinessTableCell.swift
//  PlacePoint
//
//  Created by Mac on 30/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import CoreLocation
import Kingfisher

protocol ActionCall: class {
    
    func toCallUser(index: Int)
    
    func toOpenMapNavigation(index: Int)
    
    func toOpenTaxiDetail(index: Int)
}

class FreeBusinessTableCell: UITableViewCell {
    
    @IBOutlet var lblBusinessName: UILabel!
    
    @IBOutlet var viewFreeListing: UIView!
    
    @IBOutlet var lblAddress: UILabel!
    
    @IBOutlet var lblDistance: UILabel!
    
    @IBOutlet var btnCall: UIButton!
    
    @IBOutlet weak var btnTaxi: UIButton!
    
    @IBOutlet weak var btnNav: UIButton!
    
    @IBOutlet weak var vwImgCover: UIView!
    
    @IBOutlet weak var imgFreeCover: UIImageView!
    
    weak var delegate: ActionCall?
    
  
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewFreeListing.layer.cornerRadius = 5
        
        viewFreeListing.layer.borderWidth = 0.5
        
        viewFreeListing.layer.borderColor = UIColor.black.cgColor
        
        vwImgCover.layer.cornerRadius = 5
        
        vwImgCover.layer.borderWidth = 0.5
        
        vwImgCover.layer.borderColor = UIColor.black.cgColor
    }
    
    
    func setFreeCellData(arr: [AnyObject], index: Int) {
        
        print(arr)
        
        if arr.isEmpty {
            
            return
        }
        
        let arrCategories = AppDataManager.sharedInstance.arrCategories as [AnyObject]
        
        let indexOfArr = arrCategories.index(where: ({$0["name"] as! String == "Taxis" }))
        
        if isTaxiCat == true {
            
            self.btnNav.setImage(#imageLiteral(resourceName: "img_Phone"), for: .normal)
            
            self.btnNav.tag = index
            
            btnTaxi.isHidden = true
            btnCall.isHidden = true
            
        }
        else if indexOfArr == nil  {
            
            self.btnTaxi.setImage(#imageLiteral(resourceName: "img_Phone"), for: .normal)
            
            //            self.btnTaxi.tag = 200
            
            self.btnNav.tag = index
            
            btnCall.isHidden = true
        }
        else {
            
            //jan_26_19 crash
            self.btnTaxi.tag = 201
            self.btnNav.tag = index
            
            //            self.btnNav.tag = 301
        }
        
        self.lblBusinessName.text = arr[index]["business_name"] as? String
        
        self.lblAddress.text = arr[index]["address"] as? String
        
        if arr[index]["contact_no"] as? String == "" {
            
            self.btnCall.isHidden = true
            
        }
        
        if let dist = arr[index]["distance"] as? Double {
            
            self.lblDistance.text = "\(dist) kms away"
        }
        
        let coverImgUrl: String = (arr[index]["cover_image"] as? String)!
        
        if coverImgUrl != "" {
            
            let url = URL(string:coverImgUrl)!
            
            self.imgFreeCover.kf.indicatorType = .activity
            
            (self.imgFreeCover.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
            
            self.imgFreeCover.kf.setImage(with: url,
                                          placeholder: #imageLiteral(resourceName: "placeholder"),
                                          options: [.transition(ImageTransition.fade(1))],
                                          progressBlock: { receivedSize, totalSize in
            },
                                          completionHandler: { image, error, cacheType, imageURL in
            })
        }
    }
    
    //MARK: calculate Distance
//    func calculateDistane(locationEnd: CLLocation) {
//
//        let originCoordinate = CLLocation(latitude: locationStart.coordinate.latitude, longitude: locationStart.coordinate.longitude)
//
//        let destCoordinate = CLLocation(latitude: locationEnd.coordinate.latitude, longitude: locationEnd.coordinate.longitude)
//
//        let distanceInMeters = originCoordinate.distance(from: destCoordinate)
//
//        let distanceInKm = (distanceInMeters * 0.001)
//
//        let dist = Double(round(100*distanceInKm)/100)
//
//        self.lblDistance.text = "\(dist) kms away"
//
//    }
    
    //MARK: - UIActions
    @IBAction func btnCallAction(_ sender: UIButton) {
        
        delegate?.toCallUser(index: sender.tag)
        
    }
    
    
    @IBAction func btnNavigation(_ sender: UIButton) {
        
        if isTaxiCat == true {
            
            delegate?.toCallUser(index: sender.tag)
        }
            
        else {
            
            delegate?.toOpenMapNavigation(index: sender.tag)
        }
    }
    
    
    @IBAction func btnTaxi(_ sender: UIButton) {
        
        if sender.tag == 200 {
            
            delegate?.toCallUser(index: sender.tag)
        }
        else {
            
            delegate?.toOpenTaxiDetail(index: sender.tag)
            
        }
        
    }

}

