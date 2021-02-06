//
//  CustomError.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import Foundation

public class CustomError: LocalizedError {
    public let errorDescription: String?

    public init(errorDescription: String? = nil) {
        self.errorDescription = errorDescription
    }
}
