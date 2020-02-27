//
//  Dates.swift
//  IGetHappy
//
//  Created by Gagan on 11/28/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
extension Date {
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: self)
    }
        
    func startOf(_ dateComponent : Calendar.Component, date:Date) -> Date {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
            var startOfComponent = self
            var timeInterval : TimeInterval = 0.0
            calendar.dateInterval(of: dateComponent, start: &startOfComponent, interval: &timeInterval, for: date)
            return startOfComponent
        }
 
    
}
