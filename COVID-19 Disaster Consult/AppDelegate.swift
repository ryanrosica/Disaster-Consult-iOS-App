//
//  AppDelegate.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let tabBarController: CTabBarController = DisasterTabBarController.init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window?.rootViewController = tabBarController
        
        return true
    }
    

}

