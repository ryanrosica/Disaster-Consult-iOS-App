//
//  DownloadsManager.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 6/12/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit

class DownloadsManager: NSObject {
    
    static let shared: DownloadsManager = DownloadsManager()
    
    let reachability = try! Reachability()
        
    var isOffline: Bool {
        get {
            return currentDownload != nil
        }
    }
    
    var currentDownload: OfflineDownload? = nil
    
    override init() {
        super.init()
        
        reachability.whenReachable = { reachability in
            // TODO: Popup
        }
        
        reachability.whenUnreachable = { _ in
            // TODO: Popup
        }
    }
    
    func setOffline(download: OfflineDownload) {
        self.currentDownload = download
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "DC_OfflineStatusUpdate")))
    }
    
    func download(site: String) {
        guard let request: URLRequest = Session.makeUrlRequest(endpoint: Endpoints.download(site: site), method: .GET) else { return }
        firstly {
            URLSession.shared.dataTask(.promise, with: request).validate()
        }.map {
            try JSON.init(data: $0.data)
        }.done { json in
            // Store download
            let data: String = json.rawString() ?? ""
            if data == "" {
                return
            }
            
            DownloadCache.shared.saveDownload(data: data, site: site)
            NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "DC_DownloadsUpdated")))
        }.catch { error in
            print(error)
        }
    }
    
    func fetchDownloads(completion: (([ManagedDownload]?) -> ())) {
        let fetchRequest: NSFetchRequest<ManagedDownload> = NSFetchRequest<ManagedDownload>(entityName: "ManagedDownload")
        fetchRequest.fetchBatchSize = 0
        fetchRequest.fetchOffset = 0
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let downloads: [ManagedDownload] = try DownloadCache.shared.persistentContainer.viewContext.fetch(fetchRequest)
            completion(downloads)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            //allowInfiniteScroll = false
            completion(nil)
        }
    }
    
}
