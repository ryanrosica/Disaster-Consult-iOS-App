//
//  SectionsController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/22/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import PromiseKit

class SectionsController: DisasterPageViewController {
    var category: Category
    var site: Site
    init(category: Category, site: Site) {
        self.site = site
        self.category = category
        super.init(tableView: BTableView.init(style: .plain))
        tableView.setDelegate(self)
        tableView.separatorStyle = .none
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Disaster Consult | \(site.title)"
        fetch()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
 

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1468381584, green: 0.2079161704, blue: 0.2486139238, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fetch() {
        guard let request: URLRequest = Session.makeUrlRequest(endpoint: Endpoints.category(id: category.id ), method: .GET, site: site.slug) else { return }
        
        firstly {
            URLSession.shared.dataTask(.promise, with: request).validate()
        }.map {
            try JSON.init(data: $0.data)
        }.done { json in
            
            var sections: [CCellObject] = [CCellObject]()

            if let data: [JSON] = json["sections"].array {
                for js in data {
                    let sectionObject = SectionObject.init(section: Section.init(json: js))
                    if (sectionObject.section.is_public) {
                        sections.append(sectionObject)
                    }
                }
            }
            
            sections.insert(TitleObject(title: self.category.title), at: 0)
            self.tableView.data = [sections]
            self.tableView.reloadData()
            
        }.catch { error in
            print(error)
        }
    }
}


extension SectionsController: CTableViewDelegate {
    
    func cellTypes() -> [AnyClass] {
        return [TitleCell.self, SectionCell.self]
    }
    
    func cell(indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let section = self.tableView.data[0][indexPath.row] as? SectionObject {
            let contentController = SectionController(section: section.section, site: site)
            navigationController?.pushViewController(contentController, animated: true)
        }
    }
    

}
