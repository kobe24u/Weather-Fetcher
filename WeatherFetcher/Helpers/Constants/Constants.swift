//
//  Constants.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import UIKit
import Foundation

typealias VoidClosure = () -> Void
typealias Closure<T> = (T) -> Void

struct Constants {
    static let baseUrlString = "http://api.openweathermap.org/data/2.5"
    static let iconURLHeader = "http://openweathermap.org/img/w"
    static let tempType = "units=metric"
    static let forecastDays = 15
    static let appID = "82ef835998d0498e54fdcc3caeb2a5c3"
    
    static let dailyForeCastCellID = "dailyCellID"
    
    static let melbLat: Double =  -37.8136
    static let melbLon: Double =  144.9631
    
    static let defaultWeatherIcon = "03d"
    
    static let indexPage = 0
    
    static let intervalForUpdatingLocation: TimeInterval = TimeInterval.minute * 1
}
