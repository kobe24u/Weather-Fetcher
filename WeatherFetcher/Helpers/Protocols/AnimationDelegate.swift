//
//  AnimationDelegate.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import Foundation

protocol AnimationDelegate {
    //Animation closures
    var animationStarts: VoidClosure? { get set }
    var animationSucceeds: VoidClosure? { get set }
    var animationFails: Closure<Error>? { get set }
}
