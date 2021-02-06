//
//  ServiceManager.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import Alamofire
import UIKit
import PromiseKit

struct ServiceManager {
    static let shared = ServiceManager()
        
    func forcastWithCoordinates(_ lat: Double, _ lon: Double) -> Promise<WeatherDailyForeCastDataModel>{
        return Promise { seal in
            let requesURL = "\(Constants.baseUrlString)/\(WeatherRequestType.DailyForecast.rawValue)?lat=\(lat)&lon=\(lon)&\(Constants.tempType)&cnt=\(Constants.forecastDays)&appid=\(Constants.appID)"
            AF.request(requesURL).responseDecodable(of: WeatherDailyForeCastDataModel.self) { (response) in
                if let err = response.error{
                    seal.reject(err)
                }else{
                    guard let dataModel = response.value else {
                        seal.reject(CustomError(errorDescription: "Failed to fetch forecase weather with lat \(lat) and lon \(lon),  error is nil"))
                        return
                    }
                    seal.fulfill(dataModel)
                }
              }
        }
    }
    
    func forcastWithCityName(_ cityName: String) -> Promise<WeatherDailyForeCastDataModel>{
        return Promise { seal in
            let requesURL = "\(Constants.baseUrlString)/\(WeatherRequestType.DailyForecast.rawValue)?q=\(cityName)&\(Constants.tempType)&cnt=\(Constants.forecastDays)&appid=\(Constants.appID)"
            AF.request(requesURL).responseDecodable(of: WeatherDailyForeCastDataModel.self) { (response) in
                    if let err = response.error{
                        seal.reject(err)
                    }else{
                        guard let dataModel = response.value else {
                            seal.reject(CustomError(errorDescription: "Failed to fetch forecase weather with cityname \(cityName),  error is nil"))
                            return
                        }
                        seal.fulfill(dataModel)
                    }
            }
        }
    }
    
    func getCurrentWeatherWithCityName(_ cityName: String) -> Promise<WeatherCurrentDataModel>{
        return Promise { seal in
            let requesURL = "\(Constants.baseUrlString)/\(WeatherRequestType.CurrentWeather.rawValue)?q=\(cityName)&\(Constants.tempType)&appid=\(Constants.appID)"
            AF.request(requesURL).responseDecodable(of: WeatherCurrentDataModel.self) { (response) in
                    if let err = response.error{
                        seal.reject(err)
                    }else{
                        guard let dataModel = response.value else {
                            seal.reject(CustomError(errorDescription: "Failed to get current weather with cityname \(cityName),  error is nil"))
                            return
                        }
                        seal.fulfill(dataModel)
                    }
              }
        }
    }
    
    func getCurrentWeatherWithCoordinates(_ lat: Double, _ lon: Double) -> Promise<WeatherCurrentDataModel>{
        return Promise { seal in
            let requesURL = "\(Constants.baseUrlString)/\(WeatherRequestType.CurrentWeather.rawValue)?lat=\(lat)&lon=\(lon)&\(Constants.tempType)&appid=\(Constants.appID)"
            AF.request(requesURL).responseDecodable(of: WeatherCurrentDataModel.self) { (response) in
                    if let err = response.error{
                        seal.reject(err)
                    }else{
                        guard let dataModel = response.value else {
                            seal.reject(CustomError(errorDescription: "Failed to get current weather with lat \(lat) and lon \(lon),  error is nil"))
                            return
                        }
                        seal.fulfill(dataModel)
                    }
            }
        }
    }
}
