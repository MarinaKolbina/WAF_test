//
//  AppDelegate.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 13/09/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Create a new window for the window property that comes with AppDelegate
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Create a view controller instance to be the root view controller
        let viewController = MainTabBarController() // replace with your initial view controller
        
        // Set the root view controller of the window with your view controller
        window?.rootViewController = viewController
        
        // Make the window visible
        window?.makeKeyAndVisible()
        
        return true
    }
}

