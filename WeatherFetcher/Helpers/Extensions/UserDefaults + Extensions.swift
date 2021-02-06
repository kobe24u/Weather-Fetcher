//
//  UserDefaults + Extensions.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import Foundation
import MapKit

extension UserDefaults {
    private struct Key {
        static var gpsLat = "App.Location.Coordinate.Lat"
        static var gpsLon = "App.Location.Coordinate.Lon"
        static var gpsLastUpdatedTime = "App.Location.Record.Time"
    }
    
    var gpsLat: Double? {
        get {
            return object(forKey: UserDefaults.Key.gpsLat) as? Double
        }
        set {
            set(newValue, forKey: UserDefaults.Key.gpsLat)
        }
    }
    
    var gpsLon: Double? {
        get {
            return object(forKey: UserDefaults.Key.gpsLon) as? Double
        }
        set {
            set(newValue, forKey: UserDefaults.Key.gpsLon)
        }
    }
    
    var gpsLastUpdatedTime: Date? {
        get {
            return object(forKey: UserDefaults.Key.gpsLastUpdatedTime) as? Date
        }
        set {
            set(newValue, forKey: UserDefaults.Key.gpsLastUpdatedTime)
        }
    }
}
