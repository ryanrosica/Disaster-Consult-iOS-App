//
//  HomeController.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation
import UIKit
import PMKFoundation
import PromiseKit
import SafariServices

class ArticleController: CTableViewController {
    var endpoint: String
    var dataJSONType: String
    var viewTitle: String
    var cellType: AnyClass
    var posts: [CCellObject] = [CCellObject]()
    var page: String? = nil
    var reloading: Bool = false
    
    init(endpoint: String, dataJSONType: String, title: String, cellType: AnyClass, seperators: Bool) {
        self.endpoint = endpoint
        self.dataJSONType = dataJSONType
        self.cellType = cellType
        self.viewTitle = title
        super.init(tableView: BTableView.init(style: .plain))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        tableView.setDelegate(self)
        if(!seperators) {
            tableView.separatorStyle = .none
        }
        else {
            tableView.separatorStyle = .singleLine
        }
        self.tableView.addSubview(refreshControl)
        self.tableView.showsVerticalScrollIndicator = false
        fetch()
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(fetch), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1468381584, green: 0.2079161704, blue: 0.2486139238, alpha: 1)
        //self.title = "Disaster Consult | COVID- 19"
    }
    
    func fetchNextPage() {
        get(page: self.page)
    }
    
    @objc func fetch() {
        //Presenter.toast(text: "Error")

        posts = [CCellObject]()
        self.posts.insert(TitleObject(title: self.viewTitle), at: 0)
        self.page = nil
        get(page: nil)
        refreshControl.endRefreshing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func get(page: String?) {
        if page == "" || reloading == true {
            return
        }
        reloading = true

        guard let request: URLRequest = Session.makeUrlRequest(endpoint: self.endpoint, parameters: ["page": page ?? ""], method: .GET) else {
            //Presenter.toast(text: "Error")
            return
        }

        firstly {
            URLSession.shared.dataTask(.promise, with: request).validate()
        }.map {
            try JSON.init(data: $0.data)
        }.done {json in
            if let data: [JSON] = json[self.dataJSONType].array {
                for js in data {
                    let linkObject = LinkObject.init(link: Link.init(json: js), cellType: self.cellType)
                    if (linkObject.link.is_public == true) {
                        self.posts.append(linkObject)
                    }
                }
                self.page = json["page"].stringValue
            }
            
            self.tableView.data = [self.posts]
            self.tableView.reloadData()
            self.reloading = false
        }.catch { error in
            self.reloading = false
            print(error)
        }
    }
}


extension ArticleController: CTableViewDelegate {
    
    func cellTypes() -> [AnyClass] {
        return [LitCell.self, TitleCell.self, NewsCell.self]
    }
    
    func cell(indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        if (indexPath.row == 0) {
            return
        }
        let link : LinkObject? = self.tableView.data[0][indexPath.row] as? LinkObject
        if let url = URL(string: link?.link.url ?? "") {
            present(Presenter.openSVC(url: url), animated: true)
        }
        else {
            if let description = link?.link.description {
                let webView = WebView()
                webView.html = description
                webView.pageTitle = link?.link.title ?? ""
                webView.url = "https://www.disasterconsult.org/literature/\(link?.link.id ?? "")"
                navigationController?.pushViewController(webView, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false) &&
        indexPath.row >= posts.count - 3 {
            fetchNextPage()
        }
    }
}
