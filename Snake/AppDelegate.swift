//
//  AppDelegate.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.02.2022..
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()
        let initialController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }
        initialController.setRootWireframe(HomeWireframe())
        window.rootViewController = initialController
        window.makeKeyAndVisible()
        return true
    }
}

