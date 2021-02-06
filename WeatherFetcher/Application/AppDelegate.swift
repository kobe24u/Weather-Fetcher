//
//  AppDelegate.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let viewModel = SwipeViewModel()
        let swipeVC = SwipeViewController(viewModel: viewModel)
        window?.rootViewController = swipeVC
        
        return true
    }
}

