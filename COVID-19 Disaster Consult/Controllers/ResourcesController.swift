//
//  ResourcesController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/14/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import PromiseKit

class ResourcesController: DisasterPageViewController {
    init() {
        super.init()
        tableView.setDelegate(self)
        tableView.separatorStyle = .none
        self.title = "Resources"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
        deselectAll()
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    func fetch() {
        if DownloadsManager.shared.isOffline {
            var js: JSON = JSON.init(parseJSON: "{\"categories\":[]}")
            var array: [JSON] = [JSON]()
            for (key, subJson):(String, JSON) in (DownloadsManager.shared.currentDownload?.categoriesJS ?? JSON()) {
                array.append(subJson)
            }
            
            js["categories"].arrayObject = array
            process(json: js)
            return
        }
        
        guard let request: URLRequest = Session.makeUrlRequest(endpoint: Endpoints.categories(), method: .GET) else { return }
        
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
        var categories: [CCellObject] = [CCellObject]()
        
        if let data: [JSON] = json["categories"].array {
            for js in data {
                let categoryObject = CategoryObject.init(category: Category.init(json: js))
                if (categoryObject.category.is_public) {
                    categories.append(categoryObject)
                }
            }
        }
        categories.insert(TitleObject(title: "This clinical resource is under constant development. Please check back frequently for updates and help us improve by providing feedback.", cellType: HeaderCell.self), at: 0)
        categories.insert(TitleObject(title: "Clinical and Operational Resources"), at: 0)
        
        self.tableView.data = [categories]
        self.tableView.reloadData()
    }
}


extension ResourcesController: CTableViewDelegate {
    
    func cellTypes() -> [AnyClass] {
        return [TitleCell.self, CategoryCell.self, HeaderCell.self]
    }
    
    func cell(indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryCell {
            cell.titleLbl.backgroundColor = #colorLiteral(red: 0.1468381584, green: 0.2079161704, blue: 0.2486139238, alpha: 1)
            cell.titleLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        if let category = self.tableView.data[0][indexPath.row] as? CategoryObject {
            let sectionsController = SectionsController(category: category.category)
            navigationController?.pushViewController(sectionsController, animated: true)
        }
    }
    
    func deselectAll() {
        for cell in tableView.visibleCells {
            if let categoryCell = cell as? CategoryCell {
                categoryCell.titleLbl.backgroundColor = #colorLiteral(red: 0.7521713376, green: 0.8826304078, blue: 0.9193754196, alpha: 1)
                categoryCell.titleLbl.textColor = .black
            }
        }
    }
    
}

