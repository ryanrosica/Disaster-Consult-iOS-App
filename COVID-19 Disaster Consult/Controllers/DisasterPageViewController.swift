//
//  DisasterNavigationController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 6/8/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit

class DisasterPageViewController: CTableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = "\(self.title ?? "") 🔽" 
        self.navigationItem.titleView = titleLabel
        let tap = UITapGestureRecognizer(target:self,action:#selector(self.changeDisaster))
        titleLabel.addGestureRecognizer(tap)
    }
    
    let titleLabel: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.isUserInteractionEnabled = true
        lbl.numberOfLines = 1
        return lbl
    }()
    
    
    @objc func changeDisaster(sender:UITapGestureRecognizer) {
        if let tabBar = self.tabBarController as? DisasterTabBarController {
            tabBar.choose()
        }
    }

    
}
