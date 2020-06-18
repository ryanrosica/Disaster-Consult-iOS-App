//
//  TableOfContentsController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 5/27/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import PromiseKit

class TableOfContentsController: CTableViewController {
    var completion: ([UIViewController]) -> Void
    var selectedID: String
    
    init(selectedID: String, completion: @escaping ([UIViewController]) -> Void) {
        self.completion = completion
        self.selectedID = selectedID
        super.init(tableView: BTableView.init(style: .plain))

        tableView.setDelegate(self)
        self.showClose()
        //tableView.separatorStyle = .none

        self.title = ""
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        

        
        fetch()
        
    }
    
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

      }
      
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetch() {
        
        if DownloadsManager.shared.isOffline {
            var js: JSON = JSON.init(parseJSON: "{\"table_of_contents\":[]}")
            var array: [JSON] = [JSON]()
            for (key, subJson):(String, JSON) in (DownloadsManager.shared.currentDownload?.categoriesJS ?? JSON()) {
                array.append(subJson)
                
                var sectionarray: [JSON] = [JSON]()
                for (subkey, subsubJson):(String, JSON) in (subJson["sections"] ?? JSON()) {
                    sectionarray.append(subsubJson)
                }
                array[array.count - 1]["sections"].arrayObject = sectionarray
            }
            
            js["table_of_contents"].arrayObject = array
            process(json: js)
            return
        }
        
        guard let request: URLRequest = Session.makeUrlRequest(endpoint: Endpoints.tableOfContents(), method: .GET) else { return }
        
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
        var cellObjects: [CCellObject] = [CCellObject]()

        if let data: [JSON] = json["table_of_contents"].array {
            for js in data {
                
                let categoryObject = CategoryObject.init(category: Category.init(json: js))
                cellObjects.append(categoryObject)
                
                if let sectionsData: [JSON] = js["sections"].array {
                    for sectionData in sectionsData {
                        let sectionObject = SectionObject.init(section: Section.init(json: sectionData), cellType: SectionCellSmall.self)
                        sectionObject.section.category = categoryObject.category
                        if sectionObject.section.id == self.selectedID {
                            //sectionObject.bold = true
                        }
                        
                        cellObjects.append(sectionObject)
                    }
                }
                
            }
        }
        
        cellObjects.insert(TitleObject(title: "Table of Contents"), at: 0)
        self.tableView.data = [cellObjects]
        self.tableView.reloadData()
    }

}


extension TableOfContentsController: CTableViewDelegate {
    
    func cellTypes() -> [AnyClass] {
        return [TitleCell.self, CategoryCell.self, SectionCell.self, SectionCellSmall.self]
    }
    
    func cell(indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let section = self.tableView.data[0][indexPath.row] as? SectionObject {
            let sectionController = SectionController(section: section.section, category: section.section.category?.id ?? "")
            guard let category = section.section.category else { return }
            let sectionsController = SectionsController(category: category)
            self.completion([ResourcesController(), sectionsController, sectionController])
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    
}
