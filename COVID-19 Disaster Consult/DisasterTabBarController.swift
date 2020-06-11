//
//  DisasterTabBarController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 6/11/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import PromiseKit

class DisasterTabBarController: CTabBarController {
    var site: Site?
    static let buttonWidth: CGFloat = 55

    override init() {
        super.init()
        self.setViewControllers([LoadingViewController()], animated: true)
        loadViews()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            newsNav.title = "News"
            
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

extension DisasterTabBarController {
    
    @objc func buttonPressed() {
        guard let site = site else { return }
        let safariController = Presenter.openSVC(url: URL(string: "https://www.disasterconsult.org/\(site.slug)/contact")!)
        safariController.providesPresentationContextTransitionStyle = true
        safariController.modalPresentationStyle = .pageSheet
        self.present(safariController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        let floatingButton: UIButton = {
               let button = UIButton(type: .custom)
               button.layer.cornerRadius = 0.5 * DisasterTabBarController.buttonWidth
               button.clipsToBounds = true
               button.layer.shadowColor = UIColor.black.cgColor
               button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
               button.layer.shadowRadius = 3
               button.layer.shadowOpacity = 0.2
               button.layer.masksToBounds = false
               button.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
               button.tintColor = .white
               button.titleLabel?.font = Fonts.smallCaption
               button.setImage(#imageLiteral(resourceName: "icons8-feedback-30"), for: .normal)
               button.setTitleColor(.white, for: .normal)
               button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
               return button
           }()
        
        super.viewDidLoad()
        self.view.insertSubview(floatingButton, belowSubview: self.tabBar)
        
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.snp.makeConstraints { maker in
            maker.height.equalTo(DisasterTabBarController.buttonWidth)
            maker.width.equalTo(DisasterTabBarController.buttonWidth)
            maker.right.equalTo(self.view).inset(16)
            maker.bottom.equalTo(self.tabBar.snp.top).inset(-10)
        }
    }

}
