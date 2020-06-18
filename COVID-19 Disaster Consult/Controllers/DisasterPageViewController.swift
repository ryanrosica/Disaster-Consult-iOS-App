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
        lbl.font = Fonts.title
        return lbl
    }()
    
    
    let downArrowLabel: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.isUserInteractionEnabled = true
        lbl.numberOfLines = 1
        lbl.font = Fonts.title
        lbl.text = " \u{25BE}"

        return lbl
    }()

    let background = UIView()
    let stackView: UIStackView
    
    init(style: UITableView.Style = .plain) {
        
        background.clipsToBounds = true
        background.layer.cornerRadius = 10
        background.layer.borderWidth = 2
        background.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        stackView = UIStackView.init(arrangedSubviews: [titleLabel, downArrowLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 3
        
        
        super.init(tableView: BTableView.init(style: style))
        if DownloadsManager.shared.isOffline {
            titleLabel.text = "Offline | \(Session.shared.site?.title ?? "")"
        } else {
            titleLabel.text = "\(Session.shared.site?.title ?? "")"
        }
        titleLabel.accessibilityLabel = "Switch Disaster"
        titleLabel.accessibilityValue = Session.shared.site?.title
        background.addSubview(stackView)
        self.navigationItem.titleView = background
        
        updateViewConstraints()
        
        let tap = UITapGestureRecognizer(target:self,action:#selector(self.changeDisaster))
        titleLabel.addGestureRecognizer(tap)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        stackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(background).inset(6)
            maker.top.equalTo(background).inset(2)
            maker.right.equalTo(background).inset(6)
            maker.bottom.equalTo(background).inset(2)
        }
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
