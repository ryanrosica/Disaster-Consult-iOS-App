//
//  ChooseDisasterViewController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 6/8/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import PromiseKit

class ChooseDisasterController: CTableViewController {
    var completionHandler: ((Site) -> Void)?
    
    init(completionHandler: ((Site) -> Void)? = nil) {
        self.completionHandler = completionHandler
        super.init(tableView: BTableView.init(style: .plain))
        tableView.setDelegate(self)
        tableView.separatorStyle = .none
        
        tableView.data.append(Array())
        tableView.data.append(Array())

        fetch()
        fetchDownloads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
 
        deselectAll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isTranslucent = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fetch() {

        guard let request: URLRequest = Session.makeUrlRequest(endpoint: Endpoints.sites(), method: .GET) else { return }
        
        firstly {
            URLSession.shared.dataTask(.promise, with: request).validate()
        }.map {
            try JSON.init(data: $0.data)
        }.done { json in
            
            var sites: [CCellObject] = [CCellObject]()

            if let data: [JSON] = json["sites"].array {
                for js in data {
                    let siteObject = SiteObject.init(site: Site.init(json: js))
                    sites.append(siteObject)
                }
            }

            sites.insert(TitleObject(title: "Choose a Disaster"), at: 0)
            
            
            self.tableView.data[0] = sites
            self.tableView.reloadData()
            
        }.catch { error in
            print(error)
        }
    }
    
    func fetchDownloads() {
        DownloadsManager.shared.fetchDownloads { (downloads) in
            var downloadsObjs: [CCellObject] = [CCellObject]()
            downloadsObjs.insert(TitleObject(title: "Offline Downloads"), at: 0)
            
            var oldDownload = false
            
            for download in downloads ?? [ManagedDownload]() {
                if let created = download.created {
                    if let difference = Calendar.current.dateComponents([.day], from: created, to: Date()).day {
                        if difference > 29 {
                            oldDownload = true
                        }
                    }
                }

                downloadsObjs.append(OfflineDownload.init(managed: download))
            }
            
            if oldDownload {
                downloadsObjs.insert(OldDownloadObject(), at: 1)
            }

            if downloads?.count ?? 0 > 0 {
                self.tableView.data[1] = downloadsObjs
                self.tableView.reloadData()
            }
        }
        
       
    }
}


extension ChooseDisasterController: CTableViewDelegate {
    
    func cellTypes() -> [AnyClass] {
        return [TitleCell.self, CategoryCell.self, DownloadCell.self, OldDownloadCell.self]
    }
    
    func cell(indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let object: OfflineDownload = self.tableView.data.item(indexPath: indexPath) as? OfflineDownload {
            self.dismiss(animated: true) {
                DownloadsManager.shared.setOffline(download: object)
            }
            return
        }
         
        if let cell = tableView.cellForRow(at: indexPath) as? OldDownloadCell {
            self.navigationController?.pushViewController(DownloadsController(), animated: true)
            return
        }
        
        
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryCell {
            cell.titleLbl.backgroundColor = #colorLiteral(red: 0.1468381584, green: 0.2079161704, blue: 0.2486139238, alpha: 1)
            cell.titleLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        if let site = self.tableView.data[indexPath.section][indexPath.row] as? SiteObject {

            if let completion = self.completionHandler {
               completion(site.site)
           }
            self.dismiss(animated: true, completion: nil)

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

