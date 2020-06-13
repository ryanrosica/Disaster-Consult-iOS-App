//
//  OfflineDownload.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 6/12/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

class OfflineDownload: CCellObject {
    
    var managedDownload: ManagedDownload
    var site: Site
    var categoriesJS: JSON
    var latest: Bool = false
    
    init(managed: ManagedDownload) {
        managedDownload = managed
        
        let json: JSON = JSON.init(parseJSON: managed.data ?? "")
        site = Site.init(json: json["site"])
        categoriesJS = json["categories"]

        super.init(type: DownloadCell.self)
    }

}
