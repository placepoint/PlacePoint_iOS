//
//  DayClass.swift
//  PlacePoint
//
//  Created by Mac on 22/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

class DayClass: NSObject {
    
    static let sharedInstance : DayClass = {
        
        let instance = DayClass()
        
        return instance
    }()
    
    private override init() { }
    
    func getDayIndex(day: String) -> Int {
        
        switch day {
            
        case "Monday":
            return 1
        case "Tuesday":
            return 2
        case "Wednesday":
            return 3
        case "Thursday":
            return 4
        case "Friday":
            return 5
        case "Saturday":
            return 6
        case "Sunday":
            return 7
            
        default:
            print("no day")
        }
        
        return 0
    }
    
    func getDay(index: String) -> String {
        
        switch index {
        case "1":
            return "Monday"
        case "2":
            return "Tuesday"
        case "3":
            return "Wednesday"
        case "4":
            return "Thursday"
        case "5":
            return "Friday"
        case "6":
            return "Saturday"
        case "7":
            return "Sunday"
            
        default:
            print("no day")
        }
        
        return "no day"
    }
    
    func getDayFirstLetter(index: Int) -> String {
        
        switch index {
        case 0:
            return "Mon"
        case 1:
            return "Tue"
        case 2:
            return "Wed"
        case 3:
            return "Thu"
        case 4:
            return "Fri"
        case 5:
            return "Sat"
        case 6:
            return "Sun"
            
        default:
            print("no day")
        }
        
        return "no day"
    }
    
    func getTimeAndDay(arrHour: [AnyObject]) -> String {
        
        var startTime = String()
        
        for i in 0..<arrHour.count {
            
            let dict = arrHour[i] as? [String: Any]
            
            if dict!["startFrom"] as? String != "12:00 AM" && dict!["startTo"] as? String != "12:00 AM" {
                
                let dayStartTime = dict!["startFrom"] as! String
                
                var day = String()
                
                day  = self.getDayFirstLetter(index: i)
                
                startTime = "\(dayStartTime) \(day)"
                
                break
            }
    
        }
       
        return startTime
    }
    
}

struct TimeStatus {
    
    static func isTimeFormatIn24Hours() -> Bool {
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale.current
        
        formatter.dateStyle = .none
        
        formatter.timeStyle = .short
        
        let dateString = formatter.string(from: Date())
        
        let amRange = dateString.range(of: formatter.amSymbol)
        
        let pmRange = dateString.range(of: formatter.pmSymbol)
        
        return (pmRange == nil && amRange == nil)
    }
    
    
    static func getTime(is24H: Bool, strDate: String) -> String {
        
        let dFormat = DateFormatter()
        
        let timeZine = TimeZone(identifier: "UTC")
        
        dFormat.timeZone = timeZine
        
        if is24H == true {
            
            dFormat.locale = Locale(identifier: "en_GB")
        }
        else {
            
            dFormat.locale = Locale(identifier: "en_US_POSIX")
        }
        
        dFormat.dateFormat = "dd MMM yyyy - hh:mm a"
        
        let date = dFormat.date(from: strDate)
        
        let edtDf = DateFormatter()
        
        let timeZome = UserDefaults.standard.object(forKey: "kTimeZone") as? String
        
        edtDf.timeZone = TimeZone(identifier: timeZome!)
        
        if is24H == true {
            
            edtDf.dateFormat = "dd MMM yyyy - HH:mm"
        }
        else {
            
            edtDf.dateFormat = "dd MMM yyyy - hh:mm a"
        }
        
        let st = edtDf.string(from: date!)
        
        return st
    }
    
    
    static func getTimeOnly(is24H: Bool, strServerTime: String) -> String {
        
        var updateTimeOld = strServerTime.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
        
        let dateFormatter1 = DateFormatter()
        
        let isTimeIn24H = TimeStatus.isTimeFormatIn24Hours()
        
        if isTimeIn24H {
            
            var newUpdateTimeOld = String()
            
            if updateTimeOld.hasSuffix("PM") {
                
                newUpdateTimeOld = updateTimeOld.replacingOccurrences(of: " PM", with: "", options: .literal, range: nil)
                
                var arrTime = newUpdateTimeOld.split(separator: ":")
                
                var hrs = Int(arrTime[0])!
                
                if Int(arrTime[0])! != 12 {
                    
                    hrs = Int(arrTime[0])! + 12
                }
                //                let hrs = Int(arrTime[0])! + 12
                
                newUpdateTimeOld = String(format: "%d:%@", hrs, arrTime[1] as CVarArg )
            }
            else  {
                
                newUpdateTimeOld = updateTimeOld.replacingOccurrences(of: " AM", with: "", options: .literal, range: nil)
            }
            
            updateTimeOld = newUpdateTimeOld
            
            dateFormatter1.dateFormat = "H:mm"
        }
        else {
            
            dateFormatter1.dateFormat = "h:mm a"
        }
        
        //                    dateFormatter1.dateFormat = "h:mm a"
        
        let serverTime = dateFormatter1.date(from: updateTimeOld)
        
        //CONVERT FROM NSDate to String
        let date1 = serverTime
        
        let dateFormatter3 = DateFormatter()
        
        dateFormatter3.dateFormat = "HH:mm"
        
        let dateString = dateFormatter3.string(from: date1!)
        
        return dateString
    }
    
    
    static func getTimeOnlyIn12Hr(is24H: Bool, strServerTime: String) -> String {
        
        var updateTimeOld = strServerTime.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
        
        let dateFormatter1 = DateFormatter()
        
        let isTimeIn24H = TimeStatus.isTimeFormatIn24Hours()
        
        if isTimeIn24H {
            
            var newUpdateTimeOld = String()
            
            if updateTimeOld.hasSuffix("PM") {
                
                newUpdateTimeOld = updateTimeOld.replacingOccurrences(of: " PM", with: "", options: .literal, range: nil)
                
                var arrTime = newUpdateTimeOld.split(separator: ":")
                
                var hrs = Int(arrTime[0])!
                
                if Int(arrTime[0])! != 12 {
                    
                    hrs = Int(arrTime[0])! + 12
                }
                //                let hrs = Int(arrTime[0])! + 12
                
                newUpdateTimeOld = String(format: "%d:%@", hrs, arrTime[1] as CVarArg )
            }
            else  {
                
                newUpdateTimeOld = updateTimeOld.replacingOccurrences(of: " AM", with: "", options: .literal, range: nil)
            }
            
            updateTimeOld = newUpdateTimeOld
            
            dateFormatter1.dateFormat = "H:mm"
        }
        else {
            
            dateFormatter1.dateFormat = "h:mm a"
        }
        
        //                    dateFormatter1.dateFormat = "h:mm a"
        
        let serverTime = dateFormatter1.date(from: updateTimeOld)
        
        //CONVERT FROM NSDate to String
        let date1 = serverTime
        
        let dateFormatter3 = DateFormatter()
        
        dateFormatter3.dateFormat = "HH:mm"
        
        let dateString = dateFormatter3.string(from: date1!)
        
        return dateString
    }
    
}
