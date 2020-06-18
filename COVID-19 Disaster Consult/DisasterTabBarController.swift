//
//  DisasterTabBarController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 6/11/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import PromiseKit

class SelectDisasterButton: UIControl {
    
    let titleLabel: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.font = Fonts.provideFont(size: 18, style: "ExtraBold")
        lbl.textColor = UIColor.white
        lbl.text = "----"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    let subtitleLabel: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.font = Fonts.provideFont(size: 14, style: "Regular")
        lbl.textColor = UIColor.white
        lbl.text = "Tap to change"
        return lbl
    }()
    
    var stackView: UIStackView!
    
    init() {
        super.init(frame: CGRect.zero)
        
        isUserInteractionEnabled = true
        backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        stackView = UIStackView.init(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        addSubview(stackView)
        
        layer.cornerRadius = 8.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.5
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1.0
        }
        if self.bounds.contains((touches.first?.location(in: self))!) {
            sendActions(for: .touchUpInside)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1.0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.frame = CGRect.init(x: 16, y: 8, width: bounds.width - 32, height: bounds.height - 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

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
    
    let selectDisasterButton: SelectDisasterButton = {
        let select: SelectDisasterButton = SelectDisasterButton.init()
        return select
    }()
    
    var site: Site?
    static let buttonWidth: CGFloat = 55
    var firstOpen: Bool = true
    
    override init() {
        super.init()
        self.setViewControllers([LoadingViewController()], animated: true)
        
        selectDisasterButton.addTarget(self, action: #selector(selectDisaster), for: .touchUpInside)
        
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
        
        selectDisasterButton.titleLabel.text = self.site?.title ?? ""
        
        let homeController = ArticleController.init(endpoint: Endpoints.links(), dataJSONType: "links", title: "Latest News", cellType: NewsCell.self, seperators: false, tabTitle: "News")
        
        let newsNav: CNavigationController = CNavigationController.init(rootViewController: homeController)
        newsNav.navigationBar.barStyle = .black
        newsNav.navigationBar.tintColor = .white
        newsNav.title = "News"
        
        let litController = ArticleController.init(endpoint: Endpoints.literature(), dataJSONType: "literature", title: "Latest Literature", cellType: LitCell.self, seperators: true, tabTitle: "Literature")
        let litNav: CNavigationController = CNavigationController.init(rootViewController: litController)
        litNav.navigationBar.barStyle = .black
        litNav.navigationBar.tintColor = .white
        litNav.title = "Literature"
        
        
        
        let resourcesNav: CNavigationController = CNavigationController.init(rootViewController: ResourcesController())
        resourcesNav.navigationBar.barStyle = .black
        resourcesNav.navigationBar.tintColor = .white
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        selectDisasterButton.frame = CGRect.init(x: 16, y: self.view.frame.height - self.tabBar.frame.height - 16 - DisasterTabBarController.buttonWidth, width: self.view.frame.width * 0.4, height: DisasterTabBarController.buttonWidth)
        floatingButton.frame = CGRect.init(x: self.view.frame.width - DisasterTabBarController.buttonWidth - 16, y: self.view.frame.height - self.tabBar.frame.height - 16 - DisasterTabBarController.buttonWidth, width: DisasterTabBarController.buttonWidth, height: DisasterTabBarController.buttonWidth)
        
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
        
        
        super.viewDidLoad()
        self.view.insertSubview(floatingButton, belowSubview: self.tabBar)
        self.view.insertSubview(selectDisasterButton, belowSubview: self.tabBar)
        
        
        /*floatingButton.translatesAutoresizingMaskIntoConstraints = false
         floatingButton.snp.makeConstraints { maker in
         maker.height.equalTo(DisasterTabBarController.buttonWidth)
         maker.width.equalTo(DisasterTabBarController.buttonWidth)
         maker.right.equalTo(self.view).inset(16)
         maker.bottom.equalTo(self.tabBar.snp.top).inset(-10)
         }*/
    }
    
}
