//
//  DisasterNavigationController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 6/8/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit

class DisasterPageViewController: CTableViewController {
    
    let titleLabel: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.isUserInteractionEnabled = true
        lbl.numberOfLines = 1
        lbl.font = Fonts.smallTitle
        return lbl
    }()
    
    init(style: UITableView.Style = .plain) {
        super.init(tableView: BTableView.init(style: style))
        if DownloadsManager.shared.isOffline {
            titleLabel.text = "Offline | \(Session.shared.site?.title ?? "") 🔽"
        } else {
            titleLabel.text = "\(Session.shared.site?.title ?? "") 🔽"
        }
        titleLabel.accessibilityLabel = "Switch Disaster"
        titleLabel.accessibilityValue = Session.shared.site?.title
        self.navigationItem.titleView = titleLabel
        
        
        let tap = UITapGestureRecognizer(target:self,action:#selector(self.changeDisaster))
        titleLabel.addGestureRecognizer(tap)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    
    
    @objc func changeDisaster(sender:UITapGestureRecognizer) {
        if let tabBar = self.tabBarController as? DisasterTabBarController {
            tabBar.selectDisaster()
        }
    }

    
}

class NavigationBarNoAnimation: UINavigationBar {
    override func popItem(animated: Bool) -> UINavigationItem? {
        return super.popItem(animated: false)
    }
}
