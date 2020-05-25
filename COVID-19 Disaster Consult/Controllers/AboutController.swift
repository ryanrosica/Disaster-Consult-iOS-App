//
//  ResourcesController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/14/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import PromiseKit

class AboutController: CTableViewController {
    init() {
        super.init(tableView: BTableView.init(style: .grouped))
        tableView.setDelegate(self)
        tableView.separatorStyle = .singleLine
        self.title = "About Us"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Disaster Consult | COVID- 19"
        self.tabBarItem.title = "About"
        self.tabBarItem.image = UIImage.init(named: "about") ?? UIImage()
        loadData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1468381584, green: 0.2079161704, blue: 0.2486139238, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadData() {
        
        var data: [[CCellObject]] = [[CCellObject]]()
        
        data.append(Array())
        data[0].append(TitleObject(title: "About Us"))
        data[0].append(TitleObject(title: "We are a group of Physicians, Disaster Medicine, Computer Science/IT specialists, and students working to provide easy to use clinical resources for front line healthcare workers. We do our best to review current literature, best practices, and guidelines in order to give you the most relevant and important information. We welcome feedback and constructive criticism.", cellType: HeaderCell.self))
        
        data.append(Array())
        data[1].append(TitleObject(title: "Our Website", description: "Vist Our Main Page.", cellType: TextCell.self))
        
        data[1].append(TitleObject(title: "Our Team", description: "Meet our team of Physicians, Disaster Medicine, Computer Science/IT specialists, and students.", cellType: TextCell.self))
        data[1].append(TitleObject(title: "Contact Us", description: "Send your feedback and suggestions.", cellType: TextCell.self))
        
        self.tableView.data = data
        self.tableView.reloadData()
    }
}


extension AboutController: CTableViewDelegate {
    
    func cellTypes() -> [AnyClass] {
        return [TitleCell.self, CategoryCell.self, HeaderCell.self, TextCell.self]
    }
    
    func cell(indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let object: CCellObject = self.tableView.data.item(indexPath: indexPath) else { return }
        
        if let textObj: TitleObject = object as? TitleObject {
            
            if textObj.title == "Our Website" {
                if let url: URL = URL.init(string: "https://www.disasterconsult.org/home") {
                    UIApplication.shared.open(url)
                }
            }
            if textObj.title == "Our Team" {
                if let url: URL = URL.init(string: "https://www.disasterconsult.org/aboutus") {
                    present(Presenter.openSVC(url: url), animated: true)
                }
            }
            if textObj.title == "Contact Us" {
                if let url: URL = URL.init(string: "https://www.disasterconsult.org/contact") {
                    present(Presenter.openSVC(url: url), animated: true)
                }
            }

        }
        
    }
    
    
}

