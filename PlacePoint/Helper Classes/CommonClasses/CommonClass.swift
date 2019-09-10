//
//  CommonClass.swift
//  PlacePoint
//
//  Created by Mac on 11/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class CommonClass: NSObject {
    
    static let sharedInstance : CommonClass = {
        
        let instance = CommonClass()
        
        return instance
    }()
    
    var arrStringCategories = [String]()
    
    
    func checkIrelandTimeZone(startFrom: String = "", startTo: String = "") -> (Bool, String, String) {
        
        var getStartFrom = String()
        
        var getStartTo = String()
        
        if (TimeZone.current.identifier == "Europe/Dublin" ) {
            
            if (!startFrom.isEmpty) {
                
                if startFrom.hasSuffix("AM") {
                    
                    getStartFrom = startFrom.replacingOccurrences(of: "AM", with: "a.m.", options: NSString.CompareOptions.literal, range: nil)
                }
                else {
                    
                    getStartFrom = startFrom.replacingOccurrences(of: "PM", with: "p.m.", options: NSString.CompareOptions.literal, range: nil)
                    
                }
                
                if startTo.hasSuffix("AM") {
                    
                    getStartTo = startTo.replacingOccurrences(of: "AM", with: "a.m.", options: NSString.CompareOptions.literal, range: nil)
                }
                else {
                    
                    getStartTo = startTo.replacingOccurrences(of: "PM", with: "p.m", options: NSString.CompareOptions.literal, range: nil)
                }
            }
            
            return (true, getStartFrom, getStartTo)
        }
        return (false, getStartFrom, getStartTo)
    }
    
    
    func compareTime(startFrom: String, startTo: String, dateFormatter: DateFormatter) -> (ComparisonResult, ComparisonResult, ComparisonResult){
        
        let now = Date()
        
        var startFromDate: Date!
        
        var startToDate: Date!
        
        if startFrom.contains("am") || startFrom.contains("AM") || startFrom.contains("pm") || startFrom.contains("PM") {
            
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        }
        else {
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm"
        }
        
        startFromDate = dateFormatter.date(from: startFrom)
        
        if startTo.contains("am") || startTo.contains("AM") || startTo.contains("pm") || startTo.contains("PM") {
            
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        }
        else {
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm"
            print("priya")
        }
        
        startToDate = dateFormatter.date(from: startTo)
        
        print("SWDSDSD --- \(startToDate)")
        
        if startToDate == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd H:mm"
              print("IOS")
        }
        
        
        startToDate = dateFormatter.date(from: startTo)
        
        
         print("startTo == \(startTo)")
        
         print("startToDate == \(startToDate)")
        
        if startFromDate != nil &&  startToDate != nil  {
            
            let resultCheckStartFrom: ComparisonResult = (startFromDate?.compare(now))!
            
            let resultCheckStarTo: ComparisonResult = (startToDate?.compare(now))!
            
            let resultCheckFromAndTo: ComparisonResult = (startFromDate?.compare(startToDate!))!
            
            return (resultCheckStartFrom,resultCheckStarTo,resultCheckFromAndTo)
            
        } else {
            
            let resultCheckStartFrom: ComparisonResult = (now.compare(now))
            
            let resultCheckStarTo: ComparisonResult = (now.compare(now))
            
            let resultCheckFromAndTo: ComparisonResult = (now.compare(now))
            
            return (resultCheckStartFrom,resultCheckStarTo,resultCheckFromAndTo)
         
        }
//        let resultCheckStartFrom: ComparisonResult = (startFromDate?.compare(now))!
//
//        let resultCheckStarTo: ComparisonResult = (startToDate?.compare(now))!
//
//        let resultCheckFromAndTo: ComparisonResult = (startFromDate?.compare(startToDate!))!
//
//        return (resultCheckStartFrom,resultCheckStarTo,resultCheckFromAndTo)
    }
    
    
    func getCategoryArrayId(strCategory: [String], array: [AnyObject]) -> [String] {
        
        var arrSelectedId = [String]()
        
        if !strCategory.isEmpty {
            
            for item in strCategory {
                
                let arrCat = array.filter({ ($0["name"] as! String == item)})
                
                if !arrCat.isEmpty {
                    
                    let getCatId = arrCat[0]["id"] as! String
                    
                    arrSelectedId.append(getCatId)
                }
            }
        }
        
        return arrSelectedId
    }
    
    
    func getCategoryId(strCategory: String, array: [AnyObject]) -> String {
        
        let indexLocation = array.index { (item) -> Bool in
            let it =  item["name"] as! String
            if it == strCategory{
                return true
            }
            return false
            
        }
        let intIndex:Int? = indexLocation
        
        if intIndex != nil {
        
            let strId = (array[intIndex!])["id"] as? String
            
            return strId!
        }
        
        return ""
    }
    
    
    func getParentCategory(strCategory: String, array: [AnyObject]) -> String {
        
        let indexLocation = array.index { (item) -> Bool in
            let it =  item["parent_category"] as! String
            if it == strCategory{
                return true
            }
            return false
            
        }
        let intIndex:Int? = indexLocation
        
        if intIndex != nil {
        
            let strId = (array[intIndex!])["name"] as? String
            
            return strId!
        }
        return ""
    }
    
    
    func getParentCategoryId(strCategory: String, array: [AnyObject]) -> String {
        
        let indexLocation = array.index { (item) -> Bool in
            
            let it =  item["id"] as! String
            if it == strCategory{
                return true
            }
            return false
        }
        let intIndex:Int? = indexLocation
        
        if intIndex != nil {
        
            let strId = (array[intIndex!])["parent_category"] as? String
            
            return strId!
        }
        return ""
    }
    
    
    func getShowOnLiveValue(strCategory: String, array: [AnyObject]) -> String {
        
        let indexLocation = array.index { (item) -> Bool in
            
            let it =  item["id"] as! String
            if it == strCategory{
                return true
            }
            return false
            
        }
        let intIndex:Int? = indexLocation

        if intIndex != nil {
        
            let strId = (array[intIndex!])["show_on_live"] as? String
            
            return strId!
        }
        
        return ""
    }
    
    
    func getLocationId(strLocation: String, array: [AnyObject]) -> String {
        
        let indexLocation = array.index { (item) -> Bool in
            let it =  item["townname"] as! String
            if it == strLocation{
                return true
            }
            return false
            
        }
        
        let intIndex:Int? = indexLocation
        
        if intIndex != nil {
        
            let strId = (array[intIndex!])["id"] as? String
            
            return strId!
        }
        
        return ""
    }
    
    
    func arrCategories(array:[AnyObject]) -> [String] {
        
        arrStringCategories.removeAll()
        
        for  index in 0..<array.count {
            
            arrStringCategories.append(array[index]["name"] as! String)
        }
        
        return arrStringCategories
        
    }
    
    func keyAlreadyExists(Key: String) -> Bool {
        
        return UserDefaults.standard.object(forKey: Key) != nil
        
    }
    
    func arrLocation(array:[AnyObject]) -> [String] {
        
        arrStringCategories.removeAll()
        
        for  index in 0..<array.count {
            
            arrStringCategories.append(array[index]["townname"] as! String)
        }
        
        return arrStringCategories
        
    }
    
    
    func compressImage (_ image: UIImage) -> UIImage {
        
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 1024.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
        
    }
    
    
    func getCategoryArrayName(strCategory: [String], array: [AnyObject]) -> [String] {
        
        var arrSelectedId = [String]()
        
        if !strCategory.isEmpty {
            
            for item in strCategory {
                
                let arrCat = array.filter({ ($0["id"] as! String == item)})
                
                if !arrCat.isEmpty {
                    
                    let getCatId = arrCat[0]["name"] as! String
                    
                    arrSelectedId.append(getCatId)
                }
            }
        }
        
        return arrSelectedId
    }
    
    
    func getCategoryName(strCategory: String, array: [AnyObject]) -> String {
        
        let indexLocation = array.index { (item) -> Bool in
            let it =  item["id"] as! String
            if it == strCategory {
                
                return true
            }
            return false
        }
        
        let intIndex:Int? = indexLocation
        
        if intIndex != nil {
        
            let strId = (array[intIndex!])["name"] as? String
            
            return strId!
        }
        
        return ""
    }
    
    
    func getSubCategoryName(strCategory: String, array: [AnyObject]) -> String {
        
        let indexLocation = array.index { (item) -> Bool in
            let it =  item["parent_category"] as! String
            if it == strCategory{
                return true
            }
            return false
            
        }
        let intIndex:Int? = indexLocation
        
        if intIndex != nil {
        
            let strId = (array[intIndex!])["name"] as? String
            
            return strId!
        }
        return ""
    }
    
    
    func getTownName(strTown: String, array: [AnyObject]) -> String {
        
        let indexLocation = array.index { (item) -> Bool in
            let it =  item["id"] as! String
            if it == strTown{
                return true
            }
            return false
            
        }
        let intIndex:Int? = indexLocation
        
        if intIndex != nil {
        
            let strId = (array[intIndex!])["townname"] as? String
            
            return strId!
        }
        
        return ""
    }
}
