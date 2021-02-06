//
//  TimeInterval + Extensions.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import Foundation

extension TimeInterval {
    static public let second: TimeInterval = 1
    static public let minute: TimeInterval = TimeInterval.second * 60
    static public let hour: TimeInterval = TimeInterval.minute * 60
    static public let day: TimeInterval = TimeInterval.hour * 24
}
