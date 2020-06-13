//
//  DownloadsController.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 6/12/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit


class DownloadsController: CTableViewController {
    
    var footer: DownloadsFooter = DownloadsFooter()
    var downloadCount: Int = 0
    let downloadCap: Int = 100
    
    init() {
        super.init(tableView: BTableView.init(style: .plain))
        tableView.setDelegate(self)
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = footer
        tableView.dataSource = self
        self.title = "Downloads"
        self.tabBarItem.title = "Downloads"
        self.tabBarItem.image = UIImage.init(named: "download") ?? UIImage()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(add))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadData),
            name: Notification.Name(rawValue: "DC_DownloadsUpdated"),
            object: nil
        )
    }
    
    @objc func add() {
        
        if downloadCount >= downloadCap {
            showMaxDownloads()
            return
        }
        
        guard let request: URLRequest = Session.makeUrlRequest(endpoint: Endpoints.sites(), method: .GET) else { return }
        
        firstly {
            URLSession.shared.dataTask(.promise, with: request).validate()
        }.map {
            try JSON.init(data: $0.data)
        }.done { json in
            
            let alert = UIAlertController.init(title: "Download Disaster", message: "Select a disaster to download for offline viewing.", preferredStyle: .actionSheet)
            
            if let data: [JSON] = json["sites"].array {
                for js in data {
                    let site: Site = Site.init(json: js)
                    alert.addAction(UIAlertAction.init(title: site.title, style: .default, handler: { (action) in
                        DownloadsManager.shared.download(site: site.slug)
                    }))
                }
            }
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }.catch { error in
            print(error)
        }
    }
    
    func showMaxDownloads() {
        let alert = UIAlertController.init(title: "Too Many Downloads", message: "You have exceded the maximum amount of downloads 100. Please delete some of your downloads before continuing. You can do this by swiping towards the left on a download.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func loadData() {
        self.tableView.setEditing(false, animated: false)
        DownloadsManager.shared.fetchDownloads { (downloads) in
            var links: [OfflineDownload] = [OfflineDownload]()
            for download in downloads ?? [ManagedDownload]() {
                links.append(OfflineDownload.init(managed: download))
            }
            
            self.downloadCount = links.count
            
            if links.count > 0 {
                footer.setShowDelete()
                var latest: [String: Int] = [String: Int]()
                for index in 0...links.count - 1 {
                    if !latest.keys.contains(links[index].site.slug) {
                        latest.updateValue(index, forKey: links[index].site.slug)
                    } else if let oldIndex: Int = latest[links[index].site.slug] {
                        if (links[oldIndex].managedDownload.created?.timeIntervalSince1970 ?? 0) < (links[index].managedDownload.created?.timeIntervalSince1970 ?? 0) {
                            latest.updateValue(index, forKey: links[index].site.slug)
                        }
                    }
                }
                
                for key in latest.keys {
                    if let index: Int = latest[key] {
                        links[index].latest = true
                    }
                }
                
            } else {
                footer.setNoDownloads()
            }
            
            
            tableView.data.removeAll()
            tableView.data.append(links)
            tableView.reloadData()
        }
    }
}


extension DownloadsController: CTableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func cellTypes() -> [AnyClass] {
        return [DownloadCell.self]
    }
    
    func cell(indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let object: OfflineDownload = self.tableView.data.item(indexPath: indexPath) as? OfflineDownload else { return }
        DownloadsManager.shared.setOffline(download: object)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let footerView = self.tableView.tableFooterView else {
            return
        }
        let width = self.tableView.bounds.size.width
        let size = footerView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height))
        if footerView.frame.size.height != size.height {
            footerView.frame.size.height = size.height
            self.tableView.tableFooterView = footerView
        }
    }
    
    
}

extension DownloadsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let delegate: CTableViewDelegate = self.tableView.delegate as? CTableViewDelegate {
            if let cell: UITableViewCell = delegate.cell(indexPath: indexPath) {
                return cell
            }
        }
        
        guard let object: CCellObject = self.tableView.data.item(indexPath: indexPath) else {
            return UITableViewCell.init()
        }
        
        
        if let cell: CCell = tableView.dequeueReusableCell(withIdentifier: "\(object.type)") as? CCell {
            cell.height = object.height
            cell.update(object: object)
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.rowHeight(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.rowHeight(indexPath: indexPath)
    }
    
    func rowHeight(indexPath: IndexPath) -> CGFloat {
        return self.tableView.data.item(indexPath: indexPath)?.height ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return self.tableView.data.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.tableView.data[section].count }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let object: OfflineDownload = self.tableView.data.item(indexPath: indexPath) as? OfflineDownload else { return }
            DownloadCache.shared.deleteDownload(id: object.managedDownload.objectID)
        }
    }
}

class DownloadsFooter: UIView {
    
    let titleLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.font = Fonts.smallBoldCaption
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    let descriptionLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.font = Fonts.smallCaption
        lbl.textColor = UIColor.gray
        lbl.numberOfLines = 5
        lbl.textAlignment = .center
        return lbl
    }()
    
    var separator: UIView = {
        let viw: UIView = UIView.init()
        if #available(iOS 13.0, *) {
            viw.backgroundColor = UIColor.separator
        } else {
            viw.backgroundColor = UIColor.lightGray
        }
        return viw
    }()
    
    var stackView: UIStackView!
    
    init() {
        super.init(frame: CGRect.zero)
        stackView = UIStackView.init(arrangedSubviews: [titleLbl, descriptionLbl])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        addSubview(stackView)
        updateConstraints()
        
        addSubview(separator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNoDownloads() {
        titleLbl.text = "Offline Viewing"
        descriptionLbl.text = "Press the add button to save disaster resources for offline use."
    }
    
    func setShowDelete() {
        titleLbl.text = "Delete Downloads"
        descriptionLbl.text = "Delete downloads by swiping to the left on them."
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        stackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).inset(16)
            maker.top.equalTo(self).inset(16)
            maker.right.equalTo(self).inset(16)
            maker.bottom.equalTo(self).inset(16)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        separator.frame = CGRect.init(x: 16, y: 0, width: bounds.width - 32, height: 0.5)
    }
    
}
