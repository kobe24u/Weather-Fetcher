//
//  WeatherViewModel.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import Foundation
import PromiseKit
import CoreLocation

class WeatherViewModel: AnimationDelegate {
    
    var animationStarts: VoidClosure?
    var animationSucceeds: VoidClosure?
    var animationFails: Closure<Error>?
    
    var destCity: DestCity?
    var coord: (Double, Double)? {
        didSet{
            self.requestWeatherData()
        }
    }
    
    var reloadClosure: VoidClosure?
    
    var localModel: Bool {
        guard coord != nil else {
            return false
        }
        
        return true
    }
    
    private var dailyList: [WeatherDaily]? {
        didSet{
            reloadClosure?()
        }
    }
    
    private var currentModel: WeatherCurrentDataModel?{
        didSet {
            guard let model = currentModel, let weather = model.weather.first else {
                return
            }
            self.currentCellModel = CurrentCellModel(cityName: model.city, temperature: "\(Int(model.currentTemp.temp))\u{00B0}", minTemp: "\(Int(model.currentTemp.minTemp))\u{00B0}", maxTemp: "\(Int(model.currentTemp.maxTemp))\u{00B0}", weatherCondition: weather.condition)
        }
    }
    
    var currentCellModel: CurrentCellModel?
    

    init(destCity: DestCity) {
        self.destCity = destCity
    }
    
    init(coord: (Double, Double)) {
        self.coord = coord
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLocation), name: .DidUpdateLocation, object: nil)
    }
    
    @objc private func refreshLocation() {
        guard let lat = UserDefaults.standard.gpsLat, let lon = UserDefaults.standard.gpsLon else {
            return
        }
        self.coord = (lat, lon)
    }

    func requestWeatherData() {
        if let coord = self.coord{
            if self.dailyList == nil { self.animationStarts?() }
            fetchDataWithCoords(coord)
        }else if let city = self.destCity {
            if self.dailyList == nil { self.animationStarts?() }
            fetchDataWithCity(city)
        }
    }
    
    private func fetchDataWithCity(_ city: DestCity){
        firstly {
            ServiceManager.shared.getCurrentWeatherWithCityName(city.rawValue)
        }.then{ currentModel in
            ServiceManager.shared.forcastWithCityName(city.rawValue).map{ ($0, currentModel) }
        }.done{ [weak self] forecastModel, currentModel in
            self?.currentModel = currentModel
            self?.dailyList = Array(forecastModel.dailyList.dropFirst())
            self?.animationSucceeds?()
        }.catch{ [weak self] err in
            self?.animationFails?(err)
        }
    }
    
    
    private func fetchDataWithCoords(_ coord: (Double, Double)){
        firstly {
            ServiceManager.shared.getCurrentWeatherWithCoordinates(coord.0, coord.1)
        }.then{ currentModel in
            ServiceManager.shared.forcastWithCoordinates(coord.0, coord.1).map{ ($0, currentModel) }
        }.done{ [weak self] forecastModel, currentModel in
            self?.currentModel = currentModel
            self?.dailyList = Array(forecastModel.dailyList.dropFirst())
            self?.animationSucceeds?()
        }.catch{ [weak self] err in
            self?.animationFails?(err)
        }
    }
    
    
    func numberOfDailyRecords() -> Int {
        return dailyList?.count ?? 0
    }

    func cellModel(for index: Int) -> DailyForeCastCellModel? {
        guard let records = dailyList else {
            return nil
        }
        
        let dailyRecord = records[index]
        let iconID: String = dailyRecord.weather.first?.icon ?? Constants.defaultWeatherIcon
        let iconURL = "\(Constants.iconURLHeader)/\(iconID).png"
        let dateString = index == 0 ? "Tomorrow, " + DateManager.getPartialDate(timeInterval: dailyRecord.dayTime) : DateManager.getFullDate(timeInterval: dailyRecord.dayTime)
        let richMinTempString = "\(Int(dailyRecord.temp.minTemp))\u{00B0}"
        let richMaxTempString = "\(Int(dailyRecord.temp.maxTemp))\u{00B0}"
        
        let cellModel = DailyForeCastCellModel(dateString: dateString, iconURL: iconURL, minTemp: richMinTempString, maxTemp: richMaxTempString)
        return cellModel
    }
}
