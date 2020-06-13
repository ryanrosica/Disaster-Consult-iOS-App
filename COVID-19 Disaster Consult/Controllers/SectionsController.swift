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

    init(category: Category) {
        self.category = category
        super.init()
        tableView.setDelegate(self)
        tableView.separatorStyle = .none
        fetch()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
 

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fetch() {
        if DownloadsManager.shared.isOffline {
            var js: JSON = JSON.init(parseJSON: "{\"sections\":[]}")
            var array: [JSON] = [JSON]()
            for (key, subJson):(String, JSON) in (DownloadsManager.shared.currentDownload?.categoriesJS[category.id]["sections"] ?? JSON()) {
                array.append(subJson)
            }
            
            js["sections"].arrayObject = array
            process(json: js)
            return
        }
        
        guard let request: URLRequest = Session.makeUrlRequest(endpoint: Endpoints.category(id: category.id ), method: .GET) else { return }
        
        firstly {
            URLSession.shared.dataTask(.promise, with: request).validate()
        }.map {
            try JSON.init(data: $0.data)
        }.done { json in
            self.process(json: json)
        }.catch { error in
            print(error)
        }
    }
    
    func process(json: JSON) {
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
            let contentController = SectionController(section: section.section, category: self.category.id)
            navigationController?.pushViewController(contentController, animated: true)
        }
    }
    

}
