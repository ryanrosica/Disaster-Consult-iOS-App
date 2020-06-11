//
//  DisasterNavigationController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 6/8/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit

class DisasterPageViewController: CTableViewController {
    init(title: String, style: UITableView.Style = .plain) {
        super.init(tableView: BTableView.init(style: style))
        titleLabel.text = "\(title) 🔽"
        self.navigationItem.titleView = titleLabel
        let tap = UITapGestureRecognizer(target:self,action:#selector(self.changeDisaster))
        titleLabel.addGestureRecognizer(tap)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1468381584, green: 0.2079161704, blue: 0.2486139238, alpha: 1)
    }
    
    let titleLabel: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.isUserInteractionEnabled = true
        lbl.numberOfLines = 1
        lbl.font = Fonts.smallTitle
        return lbl
    }()
    
    
    @objc func changeDisaster(sender:UITapGestureRecognizer) {
        if let tabBar = self.tabBarController as? DisasterTabBarController {
            tabBar.choose()
        }
    }

    
}

class NavigationBarNoAnimation: UINavigationBar {
    override func popItem(animated: Bool) -> UINavigationItem? {
        return super.popItem(animated: false)
    }
}
