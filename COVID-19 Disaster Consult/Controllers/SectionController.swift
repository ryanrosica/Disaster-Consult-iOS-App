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
class SectionController: DisasterPageViewController {
    var section: Section
    var category: String
    
    init(section: Section, category: String) {
        self.section = section
        self.category = category
        super.init()
        tableView.setDelegate(self)
        tableView.separatorStyle = .none
        fetch()
        
    }

        

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    func fetch() {
        
        if DownloadsManager.shared.isOffline {
            var js: JSON = JSON.init(parseJSON: "{\"posts\":[]}")
            var array: [JSON] = [JSON]()
            for (key, subJson):(String, JSON) in (DownloadsManager.shared.currentDownload?.categoriesJS[self.category]["sections"][section.id]["posts"] ?? JSON()) {
                array.append(subJson)
            }
            
            js["posts"].arrayObject = array
            process(json: js)
            return
        }
        
        guard let request: URLRequest = Session.makeUrlRequest(endpoint: Endpoints.section(id: section.id), method: .GET) else { return }
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)


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
                webView.id = section.id
                webView.url = "https://www.disasterconsult.org/section/\(section.id)"
                webView.tableOfContentsVisible = true
                navigationController?.pushViewController(webView, animated: true)
        }
    }
    
    
}

