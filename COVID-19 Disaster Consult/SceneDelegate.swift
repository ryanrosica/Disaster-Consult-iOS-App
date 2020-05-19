//
//  SceneDelegate.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let tabBarController: CTabBarController = CTabBarController.init()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
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
            tabBarController.tabBar.tintColor = #colorLiteral(red: 0.1468381584, green: 0.2079161704, blue: 0.2486139238, alpha: 1)
            if let tab = tabBarController.tabBar.items?[0]{
                tab.image = #imageLiteral(resourceName: "icons8-home-30")
            }
            if let tab = tabBarController.tabBar.items?[1]{
                tab.image = #imageLiteral(resourceName: "icons8-literature-30")
            }
            if let tab = tabBarController.tabBar.items?[2]{
                tab.image = #imageLiteral(resourceName: "icons8-opened-folder-30")
            }
            window.rootViewController = tabBarController
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

