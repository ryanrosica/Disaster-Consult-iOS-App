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
    let tabBarController: CTabBarController = FABTabBarController.init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
        
        let homeController = ArticleController.init(endpoint: Endpoints.links(), dataJSONType: "links", title: "Latest News", cellType: NewsCell.self, seperators: false)
        homeController.title = "Disaster Consult | COVID- 19"
        let homeNav: CNavigationController = CNavigationController.init(rootViewController: homeController)
        homeNav.navigationBar.barStyle = .black
        homeNav.navigationBar.tintColor = .white
        homeNav.title = "Home"
        
        let litController = ArticleController.init(endpoint: Endpoints.literature(), dataJSONType: "literature", title: "Latest Literature", cellType: LitCell.self, seperators: true)
        litController.title = "Disaster Consult | COVID- 19"
        let litNav: CNavigationController = CNavigationController.init(rootViewController: litController)
        litNav.navigationBar.barStyle = .black
        litNav.navigationBar.tintColor = .white
        litNav.title = "Literature"
        
        
        
        let resourcesNav: CNavigationController = CNavigationController.init(rootViewController: ResourcesController())
        resourcesNav.navigationBar.barStyle = .black
        resourcesNav.navigationBar.tintColor = .white
        resourcesNav.title = "Resources"
        
        let aboutNav: CNavigationController = CNavigationController.init(rootViewController: AboutController())
        aboutNav.navigationBar.barStyle = .black
        aboutNav.navigationBar.tintColor = .white
        aboutNav.title = "About"
        
        


        tabBarController.setViewControllers([homeNav, litNav, resourcesNav, aboutNav], animated: true)
        if let tab = tabBarController.tabBar.items?[0]{
            tab.image = #imageLiteral(resourceName: "icons8-home-30")
        }
        if let tab = tabBarController.tabBar.items?[1]{
            tab.image = #imageLiteral(resourceName: "icons8-literature-30")
        }
        if let tab = tabBarController.tabBar.items?[2]{
            tab.image = #imageLiteral(resourceName: "icons8-opened-folder-30")
        }
        window?.rootViewController = tabBarController
        
        return true
    }
    

}

