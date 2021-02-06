//
//  WeatherModel.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import Foundation

struct WeatherDailyForeCastDataModel: Decodable{
    let city: City
    let dailyList: [WeatherDaily]
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case dailyList = "list"
      }
}


struct City: Decodable{
    let name: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
      }
}

struct DailyTemp: Decodable{
    let minTemp: Double
    let maxTemp: Double

    enum CodingKeys: String, CodingKey {
        case minTemp = "min"
        case maxTemp = "max"
      }
}

struct GeneralCondition: Decodable{
    let condition: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case condition = "main"
        case icon = "icon"
      }
}


struct WeatherDaily: Decodable{
    let dayTime: Int
    let temp: DailyTemp
    let weather: [GeneralCondition]

    enum CodingKeys: String, CodingKey {
        case dayTime = "dt"
        case temp = "temp"
        case weather = "weather"
      }
}
