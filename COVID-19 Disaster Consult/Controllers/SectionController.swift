//
//  ContentController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/27/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import PromiseKit
import WebKit
class SectionController: CTableViewController {

    var section: Section
    init(section: Section) {
        self.section = section
        super.init(tableView: BTableView.init(style: .plain))
        tableView.setDelegate(self)
        tableView.separatorStyle = .none
        fetch()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Disaster Consult | COVID- 19"
    }

        

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    func fetch() {
        guard let request: URLRequest = Session.makeUrlRequest(endpoint: Endpoints.section(id: section.id ), method: .GET) else { return }
        
        firstly {
            URLSession.shared.dataTask(.promise, with: request).validate()
        }.map {
            try JSON.init(data: $0.data)
        }.done { json in
            
            var sections: [CCellObject] = [CCellObject]()
            if let data: [JSON] = json["posts"].array {
                for js in data {
                    let linkObject = LinkObject.init(link: Link.init(json: js), cellType: SectionCell.self)
                    if(linkObject.link.is_public) {
                        sections.append(linkObject)
                    }
                }
            }
            sections.insert(TitleObject(title: self.section.title), at: 0)
            self.tableView.data = [sections]
            self.tableView.reloadData()
            
        }.catch { error in
            print(error)
        }
    }
}


extension SectionController: CTableViewDelegate {
    
    func cellTypes() -> [AnyClass] {
        return [TitleCell.self, SectionCell.self]
    }
    
    func cell(indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        if let link = self.tableView.data[0][indexPath.row] as? LinkObject {
            let webView = WebView()
                webView.html = link.link.content
                webView.pageTitle = link.link.title
                navigationController?.pushViewController(webView, animated: true)
        }
    }
    
    
}

