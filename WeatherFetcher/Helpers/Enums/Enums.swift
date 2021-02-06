//
//  Enums.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

enum WeatherRequestType: String {
    case DailyForecast = "forecast/daily"
    case CurrentWeather = "weather"
}

enum DestCity: String, CaseIterable {
    case sydney
    case perth
    case hobart
}


enum DataRequestType{
    case city
    case coord
    case unknown
}

