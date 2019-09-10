//
//  AllBusinessViewCell.swift
//  PlacePoint
//
//  Created by Mac on 19/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation
import GooglePlaces
import GoogleMaps

protocol BusinessAction: class {
    
    func callMe(index: Int)
    
    func openMapNavigation(index: Int)
    
    func openTaxiDetail(index: Int)
}

class AllBusinessViewCell: UITableViewCell {
    
    @IBOutlet var imgVwCategory: UIImageView!
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblOpenAt: UILabel!
    
    @IBOutlet var lblShowAddress: UILabel!
    
    @IBOutlet weak var lblOpenNow: UILabel!
    
    @IBOutlet var vwOpenNow: UIView!
    
    @IBOutlet var btnCall: UIButton!
    
    @IBOutlet var btnTaxi: UIButton!
    
    @IBOutlet var btnNavigation: UIButton!
    
    @IBOutlet var lblDistance: UILabel!
    
    
    var lat = CLLocationDegrees()
    
    var long = CLLocationDegrees()
    
    var contactNumber = String()
    
    var address = String()
    
    weak var delegate: BusinessAction?
    
    var locationManager = CLLocationManager()
    
    var locationStart = CLLocation()
    
    var endLocation = CLLocation()
    
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        imgVwCategory.layer.cornerRadius = 5
        
        vwOpenNow.layer.cornerRadius = 10
        
        imgVwCategory.clipsToBounds = true
        
        //        locationManager.delegate = self
        //
        //        locationManager.startUpdatingLocation()
        
    }
    
    
    func convertToDictionary(text: String) -> [AnyObject]? {
        
        if let data = text.data(using: .utf8) {
            
            do {
                
                return try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
            }
            catch {
                
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    
    func setData(arr: [AnyObject], index: Int) {
        
        print(arr)
        
        if arr.count > 0 {
            
            let arrCategories = AppDataManager.sharedInstance.arrCategories as [AnyObject]
            
            let indexOfArr = arrCategories.index(where: ({$0["name"] as! String == "Taxis" }))
            
            if arr[index]["contact_no"] as? String == "" {
                
                self.btnCall.isHidden = true
                
            }
            
            if indexOfArr == nil {
                
                self.btnTaxi.setImage(#imageLiteral(resourceName: "img_Phone"), for: .normal)
                
                self.btnTaxi.tag = index
                
                btnCall.isHidden = true
            }
            else {
                
                self.btnTaxi.tag = 201
            }
            
            if let dist = arr[index]["distance"] as? Double {
                
                self.lblDistance.text = "\(dist) kms away"
            }
            
            let strOpeningHours = arr[index]["opening_time"] as? String
            
            if strOpeningHours != "" && strOpeningHours != "null"{
                
                let arryOpeningHours = self.convertToDictionary(text: strOpeningHours!)!
                
                let date = NSDate()
                
                let week = date.dayOfTheWeek()
                
                let dayIndex = DayClass.sharedInstance.getDayIndex(day: week!)
                
                let dictCheckDay = arryOpeningHours[dayIndex] as! NSDictionary
                
                if dictCheckDay["startFrom"] as! String == "12:00 AM" {
                    
                    self.lblOpenNow.text = "CLOSED"
                    
                    var timeandDay = String()
                    
                    timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                    
                    self.lblOpenAt.isHidden = false
                    
                    self.lblOpenAt.text = "Open \(timeandDay)"
                    
                    self.vwOpenNow.frame = CGRect(x: 260.0, y: 12, width: 92, height: 38)
                    
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
                                
                                dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
                                
                                let getTimeValue = CommonClass.sharedInstance.checkIrelandTimeZone(startFrom: startFrom, startTo: startTo)
                                
                                if getTimeValue.0 {
                                    
                                    let getDateCompareObj = CommonClass.sharedInstance.compareTime(startFrom: getTimeValue.1, startTo: getTimeValue.2, dateFormatter: dateFormatter)
                                    
                                    resultCheckStartFrom = getDateCompareObj.0
                                    
                                    resultCheckStarTo = getDateCompareObj.1
                                    
                                    resultCheckFromAndTo = getDateCompareObj.2
                                    
                                }
                                else {
                                    
                                    dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
                                    
                                    let getDateCompareObj = CommonClass.sharedInstance.compareTime(startFrom: startFrom, startTo: startTo, dateFormatter: dateFormatter)
                                    
                                    resultCheckStartFrom = getDateCompareObj.0
                                    
                                    resultCheckStarTo = getDateCompareObj.1
                                    
                                    resultCheckFromAndTo = getDateCompareObj.2
                                }
                            }
                            else {
                                
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                
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
                                    
                                    self.lblOpenNow.text = "OPEN NOW"
                                    
                                    self.lblOpenAt.isHidden = true
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                    
                                    //                                self.lblOpenAt.text = "Closes at 9 PM"
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                    
                                }
                                else if resultCheckStarTo == .orderedDescending {
                                    
                                    self.lblOpenNow.text = "OPEN NOW"
                                    
                                    self.lblOpenAt.isHidden = true
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                    
                                    //                                self.lblOpenAt.text = "Closes at 9 PM"
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                }
                            }
                            else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedAscending {
                                
                                self.lblOpenNow.text = "CLOSED"
                                
                                var timeandDay = String()
                                
                                timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                                
                                self.lblOpenAt.isHidden = false
                                
                                self.lblOpenAt.text = "Open \(timeandDay)"
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                                
                            }
                            else if resultCheckStartFrom == .orderedDescending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedAscending {
                                
                                self.lblOpenNow.text = "OPEN NOW"
                                
                                self.lblOpenAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                
                                //                            self.lblOpenAt.text = "Closes at 9 PM"
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                
                            }
                            else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedDescending && resultCheckFromAndTo == .orderedAscending {
                                
                                self.lblOpenNow.text = "OPEN NOW"
                                
                                self.lblOpenAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                
                                //                            self.lblOpenAt.text = "Closes at 9 PM"
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                
                            }
                            else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedDescending {
                                
                                self.lblOpenNow.text = "OPEN NOW"
                                
                                self.lblOpenAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                
                                //                            self.lblOpenAt.text = "Closes at 9 PM"
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                
                            }
                            else {
                                
                                self.lblOpenNow.text = "CLOSED"
                                
                                var timeandDay = String()
                                
                                timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                                
                                self.lblOpenAt.isHidden = false
                                
                                self.lblOpenAt.text = "Open \(timeandDay)"
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                                
                            }
                        }
                        else {
                            
                            self.lblOpenNow.text = "CLOSED"
                            
                            var timeandDay = String()
                            
                            timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                            
                            self.lblOpenAt.isHidden = false
                            
                            self.lblOpenAt.text = "Open \(timeandDay)"
                            
                            self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                            
                            self.vwOpenNow.backgroundColor = UIColor(red: 211.0/255.0, green: 21.0/255.0, blue: 15.0/255.0, alpha: 1.0)
                            
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
                                
                                self.lblOpenNow.text = "OPEN NOW"
                                
                                self.lblOpenAt.isHidden = true
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                
                                //                            self.lblOpenAt.text = "Closes at 9 PM"
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                
                            }
                            else if resultCheckStarTo == .orderedDescending {
                                
                                self.lblOpenNow.text = "OPEN NOW"
                                
                                self.lblOpenAt.isHidden = true
                                
                                //                            self.lblOpenAt.text = "Closes at 9 PM"
                                
                                self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                
                                self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                
                            }
                        }
                        else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedDescending && resultCheckFromAndTo == .orderedAscending {
                            
                            self.lblOpenNow.text = "CLOSED"
                            
                            var timeandDay = String()
                            
                            timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                            
                            self.lblOpenAt.isHidden = false
                            
                            self.lblOpenAt.text = "Open \(timeandDay)"
                            
                            self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                            
                            self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                            
                        }
                        else if resultCheckStartFrom == .orderedDescending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedDescending {
                            
                            self.lblOpenNow.text = "OPEN NOW"
                            
                            self.lblOpenAt.isHidden = true
                            
                            //                        self.lblOpenAt.text = "Closes at 9 PM"
                            
                            self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                            
                            self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                            
                        }
                        else if resultCheckStartFrom == .orderedDescending && resultCheckStarTo == .orderedDescending && resultCheckFromAndTo == .orderedDescending {
                            
                            self.lblOpenNow.text = "CLOSED"
                            
                            var timeandDay = String()
                            
                            timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                            
                            self.lblOpenAt.isHidden = false
                            
                            self.lblOpenAt.text = "Open \(timeandDay)"
                            
                            
                            self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                            
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
                                        
                                        self.lblOpenNow.text = "OPEN NOW"
                                        
                                        self.lblOpenAt.isHidden = true
                                        
                                        self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                        
                                        //                                    self.lblOpenAt.text = "Closes at 9 PM"
                                        
                                        self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                        
                                    }
                                    else if resultCheckStarTo == .orderedDescending {
                                        
                                        self.lblOpenNow.text = "OPEN NOW"
                                        
                                        self.lblOpenAt.isHidden = true
                                        
                                        //                                    self.lblOpenAt.text = "Closes at 9 PM"
                                        
                                        self.vwOpenNow.frame = CGRect(x: 260.0, y: 12, width: 85, height: 25)
                                        
                                        self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                        
                                    }
                                }
                                else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedAscending {
                                    
                                    self.lblOpenNow.text = "CLOSED"
                                    
                                    var timeandDay = String()
                                    
                                    timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                                    
                                    self.lblOpenAt.isHidden = false
                                    
                                    self.lblOpenAt.text = "Open \(timeandDay)"
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                                    
                                }
                                    
                                else if resultCheckStartFrom == .orderedDescending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedAscending {
                                    
                                    self.lblOpenNow.text = "OPEN NOW"
                                    
                                    self.lblOpenAt.isHidden = true
                                    
                                    //                                self.lblOpenAt.text = "Closes at 9 PM"
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                    
                                }
                                else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedDescending && resultCheckFromAndTo == .orderedAscending {
                                    
                                    self.lblOpenNow.text = "OPEN NOW"
                                    
                                    self.lblOpenAt.isHidden = true
                                    
                                    //                                self.lblOpenAt.text = "Closes at 9 PM"
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                    
                                }
                                else if resultCheckStartFrom == .orderedAscending && resultCheckStarTo == .orderedAscending && resultCheckFromAndTo == .orderedDescending {
                                    
                                    self.lblOpenNow.text = "OPEN NOW"
                                    
                                    self.lblOpenAt.isHidden = true
                                    
                                    //                                self.lblOpenAt.text = "Closes at 9 PM"
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 85, height: 25)
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 85.0/255.0, green: 202.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                                }
                                else {
                                    
                                    self.lblOpenNow.text = "CLOSED"
                                    
                                    var timeandDay = String()
                                    
                                    timeandDay = DayClass.sharedInstance.getTimeAndDay(arrHour: arryOpeningHours)
                                    
                                    self.lblOpenAt.isHidden = false
                                    
                                    self.lblOpenAt.text = "Open \(timeandDay)"
                                    
                                    self.vwOpenNow.frame = CGRect(x: 260, y: 12, width: 92, height: 38)
                                    
                                    self.vwOpenNow.backgroundColor = UIColor(red: 234.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1.0)
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            self.lblTitle.text = arr[index]["business_name"] as? String
            
            self.lblShowAddress.text = arr[index]["address"] as? String
            
            //            let strEndLatitude = arr[index]["lat"] as? String
            //
            //            let strEndLongitude = arr[index]["long"] as? String
            //
            //            let endLat = (strEndLatitude as! NSString).doubleValue
            //
            //            let endLong = (strEndLongitude as! NSString).doubleValue
            //
            //            endLocation = CLLocation(latitude: endLat, longitude: endLong)
            
            let coverImgUrl: String = (arr[index]["cover_image"] as? String)!
            
            if coverImgUrl != "" {
                
                let url = URL(string:coverImgUrl)!
                
                self.imgVwCategory.kf.indicatorType = .activity
                
                (self.imgVwCategory.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
                
                self.imgVwCategory.kf.setImage(with: url,
                                               placeholder: #imageLiteral(resourceName: "placeholder"),
                                               options: [.transition(ImageTransition.fade(1))],
                                               progressBlock: { receivedSize, totalSize in
                },
                                               completionHandler: { image, error, cacheType, imageURL in
                })
            }
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
//        self.lblDistance.text = "\(dist) km away"
//
//    }
    
    
    //MARK: - UiActions
    @IBAction func btnNavigation(_ sender: UIButton) {
        
        
        delegate?.openMapNavigation(index: sender.tag)
        
    }
    
    
    @IBAction func btnCallMe(_ sender: UIButton) {
        
        delegate?.callMe(index: sender.tag)
    }
    
    
    @IBAction func btnTaxi(_ sender: UIButton) {
        
        if isTaxiCat == false && sender.currentImage != UIImage(named:"img_taxi") {
            
            delegate?.callMe(index: sender.tag)
        }
        else {
            
            delegate?.openTaxiDetail(index: sender.tag)
            
        }
        
    }
}


//MARK: CLLocationManager Delegate
//extension AllBusinessViewCell: CLLocationManagerDelegate {
//
//    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//
//        guard status == .authorizedWhenInUse else {
//            return
//        }
//
//        locationManager.startUpdatingLocation()
//
//    }
//
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        guard let userLocation = locations.last else {
//            return
//        }
//
//        locationManager.stopUpdatingLocation()
//
//        self.locationStart = userLocation
//
//        self.calculateDistane(locationEnd: endLocation)
//
//    }
//}
