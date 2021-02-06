//
//  WeatherCurrentDataModel.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import Foundation

struct WeatherCurrentDataModel: Decodable{
    let city: String
    let weather: [GeneralCondition]
    let currentTemp: CurrentTemp
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case weather = "weather"
        case currentTemp = "main"
      }
}

struct CurrentTemp: Decodable{
    let temp: Double
    let minTemp: Double
    let maxTemp: Double

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
      }
}

