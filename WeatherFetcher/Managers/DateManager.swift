//
//  VersatileManager.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import Foundation
import UIKit

class DateManager {
    
    static func getFullDate(timeInterval: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat  = "E, d MMM"
        return dateFormatter.string(from: date as Date)
    }
    
    static func getPartialDate(timeInterval: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat  = "d MMM"
        return dateFormatter.string(from: date as Date)
    }
}
