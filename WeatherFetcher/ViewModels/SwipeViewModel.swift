//
//  SwipeViewModel.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import Foundation
import MapKit

class SwipeViewModel: NSObject, CLLocationManagerDelegate {
    
    var addWeatherPagesClosure: Closure<[UIViewController]>?
    var permissionDeniedClosure:  VoidClosure?
    
    fileprivate var locManager: CLLocationManager!
    var coord = CLLocationCoordinate2D()
    
    override init() {
        super.init()
        self.locManager = CLLocationManager()
        self.locManager.startUpdatingLocation()
        self.locManager.delegate = self
        self.coord = requestLocation()
    }
    
    fileprivate func setWeatherData() {
        var viewControllers = [UIViewController]()
        
        let viewModel = WeatherViewModel(coord: (coord.latitude, coord.longitude))
        let weatherController = WeatherViewController(viewModel: viewModel)
        
        viewControllers.append(weatherController)
        let cityList = DestCity.allCases
        
        for city in cityList {
            let viewModel = WeatherViewModel(destCity: city)
            let weatherController = WeatherViewController(viewModel: viewModel)
            viewControllers.append(weatherController)
        }
        
        self.addWeatherPagesClosure?(viewControllers)
    }
    
    fileprivate func requestLocation() -> CLLocationCoordinate2D {
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            coord.latitude = (locManager.location?.coordinate.latitude)!
            coord.longitude = (locManager.location?.coordinate.longitude)!
        }else {
            print("Permission not authorised, will give a default Melbourne Location, location data will be updated when user has given permission")
            coord.latitude = CLLocationDegrees(exactly: Constants.melbLat)!
            coord.longitude = CLLocationDegrees(exactly: Constants.melbLon)!
        }
        return coord
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.setWeatherData()
        } else if status == .notDetermined {
            self.coord = requestLocation()
        } else {
            self.permissionDeniedClosure?()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        func emitUpdateLocSignal(_ lat: Double, _ lon: Double){
            UserDefaults.standard.gpsLastUpdatedTime = Date()
            UserDefaults.standard.gpsLat = lat
            UserDefaults.standard.gpsLon = lon
            NotificationCenter.default.post(name: .DidUpdateLocation, object: nil)
        }
        
        if let lat = locations.first?.coordinate.latitude, let lon = locations.first?.coordinate.longitude{
            if let lastUpdatedTime = UserDefaults.standard.gpsLastUpdatedTime{
                //Compare if it has past some time, if yes, we emit the signal to update coord and refresh view
                let elapsedTime = Date().timeIntervalSince(lastUpdatedTime)
                if elapsedTime > Constants.intervalForUpdatingLocation{
                    emitUpdateLocSignal(lat, lon)
                }
            }else{
                //First time login, haven't logged time before, immediately log one
                emitUpdateLocSignal(lat, lon)
            }
        }
    }
}
