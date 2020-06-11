//
//  DisasterTabBarController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 6/11/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import PromiseKit

class DisasterTabBarController: FABTabBarController {
    var site: Site?
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        self.setViewControllers([LoadingViewController()], animated: true)
        loadViews()
        
        
    }
    

    func loadViews() {
        fetchSite {
            guard let site = self.site else {
                return
                
            }
            let homeController = ArticleController.init(endpoint: Endpoints.links(), dataJSONType: "links", title: "Latest News", cellType: NewsCell.self, seperators: false, site: site)
            homeController.title = "Disaster Consult | \(site.title)"
            let newsNav: CNavigationController = CNavigationController.init(rootViewController: homeController)
            newsNav.navigationBar.barStyle = .black
            newsNav.navigationBar.tintColor = .white
            newsNav.title = "Home"
            
            let litController = ArticleController.init(endpoint: Endpoints.literature(), dataJSONType: "literature", title: "Latest Literature", cellType: LitCell.self, seperators: true, site: site)
            litController.title = "Disaster Consult | \(site.title)"
            let litNav: CNavigationController = CNavigationController.init(rootViewController: litController)
            litNav.navigationBar.barStyle = .black
            litNav.navigationBar.tintColor = .white
            litNav.title = "Literature"
            
            
            
            let resourcesNav: CNavigationController = CNavigationController.init(rootViewController: ResourcesController(site: site))
            resourcesNav.navigationBar.barStyle = .black
            resourcesNav.navigationBar.tintColor = .white
            resourcesNav.title = "Disaster Consult | \(site.title)"
            resourcesNav.title = "Resources"
            
            let aboutNav: CNavigationController = CNavigationController.init(rootViewController: AboutController(site: site))
            aboutNav.navigationBar.barStyle = .black
            aboutNav.navigationBar.tintColor = .white
            aboutNav.title = "About"
            
            
            
            
            self.setViewControllers([resourcesNav, newsNav, litNav, aboutNav], animated: true)
            
            if let tab = self.tabBar.items?[0]{
                tab.image = #imageLiteral(resourceName: "icons8-opened-folder-30")
            }
            if let tab = self.tabBar.items?[1]{
                tab.image = #imageLiteral(resourceName: "icons8-news-30")
            }
            if let tab = self.tabBar.items?[2]{
                tab.image = #imageLiteral(resourceName: "icons8-literature-30")
            }
        }
    }
    
    
    func choose() {
        UserDefaults.standard.removeObject(forKey: "slug")
        loadViews()

    }
    
    
    func fetchSite(completion: @escaping () -> Void) {
        guard let slug = UserDefaults.standard.string(forKey: "slug") else {
            let chooseDisasterController = ChooseDisasterController { site in
                UserDefaults.standard.set(site.slug, forKey: "slug")
                self.site = site
                completion()
            }

            let navigationController = CNavigationController(rootViewController: chooseDisasterController)
            navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.1468381584, green: 0.2079161704, blue: 0.2486139238, alpha: 1)
            navigationController.navigationBar.barStyle = .black
            navigationController.navigationBar.tintColor = .white
            
            self.setViewControllers([navigationController], animated: true)

            return
            
        }
        
        
        
        guard let request: URLRequest = Session.makeUrlRequest(endpoint: "", method: .GET, site: slug) else {
            return
            
        }
        
        firstly {
            URLSession.shared.dataTask(.promise, with: request).validate()
        }.map {
            try JSON.init(data: $0.data)
        }.done { json in
            let data: JSON = json["site"]
            self.site = Site(json: data)
            completion()
        
        }
        .catch { error in
            print(error)
        }
        
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}
