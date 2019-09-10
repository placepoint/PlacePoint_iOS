//
//  Extension+NSDate.swift
//  PlacePoint
//
//  Created by Mac on 22/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    
    func dayOfTheWeek() -> String? {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        let components: NSDateComponents = calendar.components(.weekday, from: self as Date) as NSDateComponents
        return weekdays[components.weekday - 1]
    }
    
}


