//
//  AboutPubCell.swift
//  PlacePoint
//
//  Created by Mac on 05/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation
import GooglePlaces
import GoogleMaps

protocol BusinessBtnAction: class {
    
    func callMe(index: Int)
    
    func openMapNavigation(index: Int)
    
    func openTaxiDetail(index: Int)
}

class AboutPubCell: UITableViewCell {
    
    @IBOutlet var vwDescription: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var collectionImages: UICollectionView!
    
    @IBOutlet weak var lblAbout: UILabel!
    
    @IBOutlet weak var lblOpenNoW: UILabel!
    
    @IBOutlet weak var lblDetails: UILabel!
  
    @IBOutlet var lblOpensAt: UILabel!
    
    @IBOutlet var vwOpenNow: UIView!
    
    @IBOutlet var btnCall: UIButton!
    
    @IBOutlet var btnTaxi: UIButton!
    
    @IBOutlet var btnNavigation: UIButton!
    
    @IBOutlet var lblDistance: UILabel!
    
    var coverImgUrl = ""
    
    weak var delegate: BusinessBtnAction?
    
    var locationManager = CLLocationManager()
    
    var locationStart = CLLocation()
    
    var endLocation = CLLocation()
    
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        vwOpenNow.layer.cornerRadius = 10
        
        let nib = UINib(nibName: "ImagesCollectionViewCell", bundle: nil)
        
        self.collectionImages.register(nib, forCellWithReuseIdentifier: "ImagesCollectionViewCell")
        
        collectionImages.delegate = self
        
        collectionImages.dataSource = self
        
        self.lblDetails.text = "Dummy text is text that is used in the publishing industry or by web designers to occupy the space which will later be filled with 'real' content. This is required when, for example, the final text is not yet available. Dummy text"
        
        lblDetails.sizeToFit()
        
    }
    
    
    //MARK: calculate Distance
    func calculateDistane(locationEnd: CLLocation) {
        
        let originCoordinate = CLLocation(latitude: locationStart.coordinate.latitude, longitude: locationStart.coordinate.longitude)
        
        let destCoordinate = CLLocation(latitude: locationEnd.coordinate.latitude, longitude: locationEnd.coordinate.longitude)
        
        let distanceInMeters = originCoordinate.distance(from: destCoordinate)
        
        let distanceInKm = (distanceInMeters * 0.001)
        
        let dist = Double(round(100*distanceInKm)/100)
        
        self.lblDistance.text = "\(dist) km away"
        
    }
    
    
    func setData(dict: [String: Any], arr: [AnyObject]) {
    
        if dict.isEmpty && arr.isEmpty {
            return
        }
        
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        
        let arrFiltered = AppDataManager.sharedInstance.arrCategories.filter({$0["name"] as! String == "Taxis"})
        
        if arrFiltered.count > 0 {
            
            let dictTaxi = arrFiltered.first as! [String:Any]
            
            let strIds = dictTaxi["town_id"] as! String
            
            let arrIds = strIds.components(separatedBy: ",")
            
            let townId = dict["town_id"] as? String
        
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
        
        var arrCategories = AppDataManager.sharedInstance.arrCategories
        
        let indexOfArr = arrCategories.index(where: ({$0["name"] as! String == "Taxis" }))
        
        if isTaxiCat == true {
            
            self.btnNavigation.setImage(#imageLiteral(resourceName: "img_Phone"), for: .normal)
            
            self.btnNavigation.tag = 300
            
            btnTaxi.isHidden = true
            btnCall.isHidden = true
            
        }
        
        if indexOfArr == nil {
            
            self.btnTaxi.setImage(#imageLiteral(resourceName: "img_Phone"), for: .normal)
            
            self.btnTaxi.tag = 200
            
            btnCall.isHidden = true
            
        }
        else {
            
            self.btnTaxi.tag = 201
            
            self.btnNavigation.tag = 301
        }
        
        if isDealFeatureBuisness == true {
            
            self.btnTaxi.setImage(#imageLiteral(resourceName: "img_Phone"), for: .normal)
            
            self.btnTaxi.tag = 200
            
            btnCall.isHidden = true
        }
        
        
        
        if dict["description"] as? String == "" {
            
            self.vwDescription.isHidden = true
            self.lblDetails.isHidden = true
            
        }
        else {
            self.vwDescription.isHidden = false
            self.lblDetails.text = dict["description"] as? String
            
        }
    
        if dict["contact_no"] as? String == "" {
            
            self.btnCall.isHidden = true
            
        }
        
        self.coverImgUrl = (dict["cover_image"] as? String)!
        
        let strEndLatitude = dict["lat"] as? String
        
        let strEndLongitude = dict["long"] as? String
        
        let endLat = (strEndLatitude! as NSString).doubleValue
        
        let endLong = (strEndLongitude! as NSString).doubleValue
        
        endLocation = CLLocation(latitude: endLat, longitude: endLong)
        
        let date = NSDate()
        
        let week = date.dayOfTheWeek()
        
        let dayIndex = DayClass.sharedInstance.getDayIndex(day: week!)
        
        if arr.count > 0 {
            
            let dictCheckDay = arr[dayIndex] as! [String: Any]
            
            if dictCheckDay["startFrom"] as! String == "12:00 AM" {
                
                self.lblOpenNoW.text = "CLOSED"
                
                var timeandDay = String()
                
                timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arr)
                
                self.lblOpensAt.isHidden = true
                
//                self.lblOpensAt.text = "Open \(timeandDay)"
                
                   self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 38)
                
                self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                
            }
            else {
                
                let now = Date()
                
                let outputFormatter = DateFormatter()
                
                outputFormatter.dateFormat = "h:mm a"
                
                outputFormatter.amSymbol = "AM"
                
                outputFormatter.pmSymbol = "PM"
                
                //current time
                let currentTimeString = outputFormatter.string(from: now)
                
                let dateCurrent: Date? = outputFormatter.date(from: currentTimeString)
                
                let formatter = DateFormatter()
                
                formatter.dateFormat = "h:mm a"
                
                formatter.amSymbol = "AM"
                
                formatter.pmSymbol = "PM"
                
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "YYYY-MM-dd"
                
                var getCloseFrom = dictCheckDay["closeFrom"] as! String
                
                if dictCheckDay["closeFrom"] as! String == "12:00 AM"
                {
                    getCloseFrom = "closed"
                    
                }
                
                var getCloseTo = dictCheckDay["closeTo"] as! String
                
                if dictCheckDay["closeTo"] as! String == "12:00 AM"
                {
                    getCloseTo = "closed"
                    
                }
                
                dateFormatter.dateFormat = "YYYY-MM-dd"
                
                let getTodayDate = dateFormatter.string(from: now)
                
                if getCloseFrom == "closed" || getCloseTo == "closed" {
                    
                    var getStartFrom = dictCheckDay["startFrom"] as! String
                    
                    if getStartFrom == "12:00 AM" {
                        
                        getStartFrom = "closed"
                        
                    }
                    
                    var getStartTo = dictCheckDay["startTo"] as! String
                    
                    if getStartTo == "12:00 AM" {
                        
                        getStartTo = "closed"
                        
                    }
                    else if getStartFrom != "closed" || getStartTo != "closed" {
                        
                        dateFormatter.dateFormat = "YYYY-MM-dd"
                        
                        let getTodayDate = dateFormatter.string(from: now)
                        
                        var startFrom = "\(getTodayDate) \(getStartFrom)"
                        
                        var startTo = "\(getTodayDate) \(getStartTo)"
                        
                        let resultCheckStartFrom: ComparisonResult!

                        let resultCheckStarTo: ComparisonResult!

                        let resultCheckFromAndTo: ComparisonResult!
                        
                        let locale = NSLocale.current
                        
                        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
                        
                        if formatter.contains("a") || formatter.contains("p"){
                            
                            dateFormatter.dateFormat = "YYYY-MM-dd hh:mm a"
                            
                            let getTimeValue = CommonClass.sharedInstance.checkIrelandTimeZone(startFrom: startFrom, startTo: startTo)
                            
                            
                            if getTimeValue.0 {
 
                               let getDateCompareObj = CommonClass.sharedInstance.compareTime(startFrom: getTimeValue.1, startTo: getTimeValue.2, dateFormatter: dateFormatter)
                                
                                resultCheckStartFrom = getDateCompareObj.0
                                
                                resultCheckStarTo = getDateCompareObj.1
                                
                                resultCheckFromAndTo = getDateCompareObj.2
                            }
                            else {
                                
                                let getDateCompareObj = CommonClass.sharedInstance.compareTime(startFrom: startFrom, startTo: startTo, dateFormatter: dateFormatter)
                                
                                resultCheckStartFrom = getDateCompareObj.0
                                
                                resultCheckStarTo = getDateCompareObj.1
                                
                                resultCheckFromAndTo = getDateCompareObj.2
                            }
                            
                        } else {
                            
                            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
                            
                            if startFrom.contains("A") {
                                
                                startFrom = startFrom.replacingOccurrences(of: "AM", with: "", options: NSString.CompareOptions.literal, range: nil)
                                
                            }
                            else if startFrom.contains("P") {
                                
                                startFrom = startFrom.replacingOccurrences(of: "PM", with: "", options: NSString.CompareOptions.literal, range: nil)
                                
                            }
                            
                            if startTo.contains("A") {
                                
                                startTo = startTo.replacingOccurrences(of: "AM", with: "", options: NSString.CompareOptions.literal, range: nil)
                                
                            }
                            else if startTo.contains("P") {
                                
                                startTo = startTo.replacingOccurrences(of: "PM", with: "", options: NSString.CompareOptions.literal, range: nil)
                                
                            }
                            
                            let getDateCompareObj = CommonClass.sharedInstance.compareTime(startFrom: startFrom, startTo: startTo, dateFormatter: dateFormatter)
                            
                            resultCheckStartFrom = getDateCompareObj.0
                            
                            resultCheckStarTo = getDateCompareObj.1
                            
                            resultCheckFromAndTo = getDateCompareObj.2
                            
                        }
                        
                        if (resultCheckStartFrom == .orderedAscending && resultCheckStartFrom == .orderedSame) {
                            
                            if resultCheckFromAndTo == .orderedDescending {
                                
                                self.lblOpenNoW.text = "OPEN NOW"
                                
                                self.lblOpensAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                                
//                                self.lblOpensAt.text = "Closes at 9 PM"
                            }
                            else if resultCheckStarTo == .orderedDescending {
                                
                                self.lblOpenNoW.text = "OPEN NOW"
                                
                                self.lblOpensAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                                
//                                self.lblOpensAt.text = "Closes at 9 PM"
                            }
                        }
                        else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedAscending {
                            
                            self.lblOpenNoW.text = "CLOSED"
                            
                            var timeandDay = String()
                            
                            timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arr)
                            
                            self.lblOpensAt.isHidden = false
                            
                            self.lblOpensAt.text = "Open \(timeandDay)"
                            
                              self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 38)
                            
                            self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                        }
                            
                        else if resultCheckStartFrom == .orderedDescending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedAscending {
                            
                            self.lblOpenNoW.text = "OPEN NOW"
                            
                            self.lblOpensAt.isHidden = true
                            
                            self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                            
//                            self.lblOpensAt.text = "Closes at 9 PM"
                        }
                        else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedDescending && resultCheckFromAndTo == .orderedAscending {
                            
                            self.lblOpenNoW.text = "OPEN NOW"
                            
                            self.lblOpensAt.isHidden = true
                            
                            self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                            
//                            self.lblOpensAt.text = "Closes at 9 PM"
                        }
                        else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedDescending {
                            
                            self.lblOpenNoW.text = "OPEN NOW"
                            
                            self.lblOpensAt.isHidden = true
                            
                            self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                            
//                            self.lblOpensAt.text = "Closes at 9 PM"
                        }
                        else {
                            
                            self.lblOpenNoW.text = "CLOSED"
                            
                            var timeandDay = String()
                            
                            timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arr)
                            
                            self.lblOpensAt.isHidden = false
                            
                            self.lblOpensAt.text = "Open \(timeandDay)"
                            
                              self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 38)
                            
                            self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                        }
                    }
                    else {
                        
                        self.lblOpenNoW.text = "CLOSED"
                        
                        var timeandDay = String()
                        
                        timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arr)
                        
                        self.lblOpensAt.isHidden = false
                        
                        self.lblOpensAt.text = "Open \(timeandDay)"
                        
                          self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 38)
                        
                        self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)

                    }
                }
                else {
                    
                    let closeFrom = "\(getTodayDate) \(getCloseFrom)"
                    
                    let closeTo = "\(getTodayDate) \(getCloseTo)"
                    
                    dateFormatter.dateFormat = "YYYY-MM-dd h:mm a"
                    
                    let closeFromDate = dateFormatter.date(from: closeFrom)
                    
                    let closeToDate = dateFormatter.date(from: closeTo)
                    
                    let resultCheckStartFrom: ComparisonResult = (closeFromDate?.compare(now))!
                    
                    let resultCheckStarTo: ComparisonResult = (closeToDate?.compare(now))!
                    
                    let resultCheckFromAndTo: ComparisonResult = (closeFromDate?.compare(closeToDate!))!
                    
                    if (resultCheckStartFrom == .orderedAscending && resultCheckStartFrom == .orderedSame) {
                        
                        if resultCheckFromAndTo == .orderedDescending {
                            
                            self.lblOpenNoW.text = "OPEN NOW"
                            
                            self.lblOpensAt.isHidden = true
                            
                            self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                            
//                            self.lblOpensAt.text = "Closes at 9 PM"
                        }
                        else if resultCheckStarTo == .orderedDescending {
                            
                            self.lblOpenNoW.text = "OPEN NOW"
                            
                            self.lblOpensAt.isHidden = true
                            
                            self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                            
//                            self.lblOpensAt.text = "Closes at 9 PM"
                        }
                    }
                    else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedDescending && resultCheckFromAndTo == .orderedAscending {
                        
                        self.lblOpenNoW.text = "CLOSED"
                        
                        var timeandDay = String()
                        
                        timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arr)
                        
                        self.lblOpensAt.isHidden = false
                        
                        self.lblOpensAt.text = "Open \(timeandDay)"
                        
                          self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 38)
                        self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)

                    }
                    else if resultCheckStartFrom == .orderedDescending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedDescending {
                        
                        self.lblOpenNoW.text = "OPEN NOW"
                        
                        self.lblOpensAt.isHidden = true
                        
                        self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                        
//                        self.lblOpensAt.text = "Closes at 9 PM"
                    }
                    else if resultCheckStartFrom == .orderedDescending && resultCheckStarTo == .orderedDescending && resultCheckFromAndTo == .orderedDescending {
                        
                        var timeandDay = String()
                        
                        timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arr)
                        
                        self.lblOpensAt.isHidden = false
                        
                        self.lblOpensAt.text = "Open \(timeandDay)"
                        
                          self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 38)
                        
                        self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                    }
                    else {
                        
                        var getStartFrom = dictCheckDay["startFrom"] as! String
                        
                        if getStartFrom == "12:00 AM" {
                            
                            getStartFrom = "closed"
                            
                        }
                        var getStartTo = dictCheckDay["startTo"] as! String
                        
                        if getStartTo == "12:00 AM" {
                            
                            getStartTo = "closed"
                            
                        }
                        
                        dateFormatter.dateFormat = "YYYY-MM-dd"
                        
                        let getTodayDate = dateFormatter.string(from: now)
                        
                        if getStartFrom == "closed" || getStartTo == "closed" {
                            
                            print("closed")
                        }
                        else {
                            
                            let startFrom = "\(getTodayDate) \(getStartFrom)"
                            
                            let startTo = "\(getTodayDate) \(getStartTo)"
                            
                            dateFormatter.dateFormat = "YYYY-MM-dd h:mm a"
                            
                            let startFromDate = dateFormatter.date(from: startFrom)
                            
                            let startToDate = dateFormatter.date(from: startTo)
                            
                            let resultCheckStartFrom: ComparisonResult = (startFromDate?.compare(now))!
                            
                            let resultCheckStarTo: ComparisonResult = (startToDate?.compare(now))!
                            
                            let resultCheckFromAndTo: ComparisonResult = (startFromDate?.compare(startToDate!))!
                            
                            if (resultCheckStartFrom == .orderedAscending && resultCheckStartFrom == .orderedSame) {
                                
                                if resultCheckFromAndTo == .orderedDescending {
                                    
                                    self.lblOpenNoW.text = "OPEN NOW"
                                    
                                    self.lblOpensAt.isHidden = true
                                    
                                    self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                                    
//                                    self.lblOpensAt.text = "Closes at 9 PM"
                                }
                                else if resultCheckStarTo == .orderedDescending {
                                    
                                    self.lblOpenNoW.text = "OPEN NOW"
                                    
                                    self.lblOpensAt.isHidden = true
                                    
                                    self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                                    
//                                    self.lblOpensAt.text = "Closes at 9 PM"
                                }
                            }
                            else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedAscending {
                                
                                self.lblOpenNoW.text = "CLOSED"
                                
                                var timeandDay = String()
                                
                                timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arr)
                                
                                self.lblOpensAt.isHidden = false
                                
                                self.lblOpensAt.text = "Open \(timeandDay)"
                                
                                  self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 38)
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)

                            }
                                
                            else if resultCheckStartFrom == .orderedDescending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedAscending {
                                
                                self.lblOpenNoW.text = "OPEN NOW"
                                
                                self.lblOpensAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                                
//                                self.lblOpensAt.text = "Closes at 9 PM"
                            }
                            else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedDescending && resultCheckFromAndTo == .orderedAscending {
                                
                                self.lblOpenNoW.text = "OPEN NOW"
                                
                                self.lblOpensAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                                
//                                self.lblOpensAt.text = "Closes at 9 PM"
                            }
                            else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedDescending {

                                self.lblOpenNoW.text = "OPEN NOW"
                                
                                self.lblOpensAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 25)
                                
//                                self.lblOpensAt.text = "Closes at 9 PM"
                            }
                            else {
                                
                                self.lblOpenNoW.text = "CLOSED"
                                
                                var timeandDay = String()
                                
                                timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arr)
                                
                                self.lblOpensAt.isHidden = false
                                
                                self.lblOpensAt.text = "Open \(timeandDay)"
                                
                                  self.vwOpenNow.frame = CGRect(x: 267.0, y: 6, width: 92, height: 38)
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                            }
                        }
                    }
                }
            }
        }
        else {
         
            self.vwOpenNow.isHidden = true
        }
    }
    
    //MARK: - UIActions
    
    @IBAction func btnNavigation(_ sender: UIButton) {
        
        if isTaxiCat == true {
            
            delegate?.callMe(index: sender.tag)
        }
        else {
            
            delegate?.openMapNavigation(index: sender.tag)
        }
        
    }
    
    @IBAction func btnCallMe(_ sender: UIButton) {
        
        delegate?.callMe(index: sender.tag)
    }
    
    @IBAction func btnTaxi(_ sender: UIButton) {
        
        if sender.tag == 200 {
            
            delegate?.callMe(index: sender.tag)
        }
        else {
            
            delegate?.openTaxiDetail(index: sender.tag)
        
        }
        
    }
    
}


//MARK: CollectionView DataSource, Delegate and FlowLayoutDelegate
extension AboutPubCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as? ImagesCollectionViewCell else{
            fatalError()
        }
        
        pageControl.numberOfPages = 1
        
        cell.imagesCollections.image = #imageLiteral(resourceName: "placeholder")
   
            if coverImgUrl != "" {

                let url = URL(string:coverImgUrl)!

                cell.imagesCollections.kf.indicatorType = .activity

                (cell.imagesCollections.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray

                cell.imagesCollections.kf.setImage(with: url,
                                                   placeholder: #imageLiteral(resourceName: "placeholder"),
                                                   options: [.transition(ImageTransition.fade(1))],
                                                   progressBlock: { receivedSize, totalSize in
                },
                                                   completionHandler: { image, error, cacheType, imageURL in
                })
        }

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        
        return CGSize(width:self.frame.size.width, height: collectionView.frame.size.height)
    }
   
}

extension AboutPubCell: CLLocationManagerDelegate {
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation = locations.last else {
            return
        }
        
        locationManager.stopUpdatingLocation()
        
        self.locationStart = userLocation
        
        self.calculateDistane(locationEnd: endLocation)
        
    }
}
