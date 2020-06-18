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
        button.accessibilityLabel = "Leave Feedback"
        return button
    }()
    
    var site: Site?
    static let buttonWidth: CGFloat = 55
    var firstOpen: Bool = true

    override init() {
        super.init()
        self.setViewControllers([LoadingViewController()], animated: true)
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateOffline),
            name: Notification.Name(rawValue: "DC_OfflineStatusUpdate"),
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateOffline() {
        if DownloadsManager.shared.isOffline {
            self.site = DownloadsManager.shared.currentDownload?.site ?? Site.init(json: JSON())
            Session.shared.site = DownloadsManager.shared.currentDownload?.site ?? Site.init(json: JSON())
        }
        
        loadViews()
    }
    
    @objc func loadViews() {
        
        guard let site = self.site else {
            self.selectDisaster()
            return
        }
        
        let homeController = ArticleController.init(endpoint: Endpoints.links(), dataJSONType: "links", title: "Latest News", cellType: NewsCell.self, seperators: false)
        
        homeController.title = "Disaster Consult | \(site.title)"
        let newsNav: CNavigationController = CNavigationController.init(rootViewController: homeController)
        newsNav.navigationBar.barStyle = .black
        newsNav.navigationBar.tintColor = .white
        newsNav.title = "News"
        
        let litController = ArticleController.init(endpoint: Endpoints.literature(), dataJSONType: "literature", title: "Latest Literature", cellType: LitCell.self, seperators: true)
        litController.title = "Disaster Consult | \(site.title)"
        let litNav: CNavigationController = CNavigationController.init(rootViewController: litController)
        litNav.navigationBar.barStyle = .black
        litNav.navigationBar.tintColor = .white
        litNav.title = "Literature"
        
        
        
        let resourcesNav: CNavigationController = CNavigationController.init(rootViewController: ResourcesController())
        resourcesNav.navigationBar.barStyle = .black
        resourcesNav.navigationBar.tintColor = .white
        resourcesNav.title = "Disaster Consult | \(site.title)"
        resourcesNav.title = "Resources"
        
        let downloadNav: CNavigationController = CNavigationController.init(rootViewController: DownloadsController())
        downloadNav.navigationBar.barStyle = .black
        downloadNav.navigationBar.tintColor = .white
        downloadNav.title = "Downloads"
        
        
        let aboutNav: CNavigationController = CNavigationController.init(rootViewController: AboutController())
        aboutNav.navigationBar.barStyle = .black
        aboutNav.navigationBar.tintColor = .white
        aboutNav.title = "About"
        
        self.floatingButton.isHidden = DownloadsManager.shared.isOffline
        
        if DownloadsManager.shared.isOffline {
            self.setViewControllers([resourcesNav, downloadNav, aboutNav], animated: true)
        } else {
            if(site.hasLiterature) {
                self.setViewControllers([resourcesNav, newsNav, litNav, downloadNav, aboutNav], animated: true)
            }
            else {
                self.setViewControllers([resourcesNav, newsNav, downloadNav, aboutNav], animated: true)

            }
            
            if let tab = self.tabBar.items?[1]{
                tab.image = #imageLiteral(resourceName: "icons8-news-30")
            }
            if let tab = self.tabBar.items?[2]{
                tab.image = #imageLiteral(resourceName: "icons8-literature-30")
            }
        }
        
        if let tab = self.tabBar.items?[0]{
            tab.image = #imageLiteral(resourceName: "icons8-opened-folder-30")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstOpen {
            firstOpen = false
            selectDisaster()
        }
    }
    
    @objc func selectDisaster() {
        
        let select: ChooseDisasterController = ChooseDisasterController.init(completionHandler: { (site) in
            self.site = site
            Session.shared.site = self.site
            DownloadsManager.shared.currentDownload = nil
            self.loadViews()
        })
        select.navigationItem.title = "Disaster Consult"
        
        let nav: CNavigationController = CNavigationController.init(rootViewController: select)
        
        nav.isModalInPopover = site == nil
        if site != nil {
            select.showClose()
        }
        
        self.present(nav, animated: true, completion: nil)
    }
    
    
    
    
    /*
     func choose() {
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
        
    }*/
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
