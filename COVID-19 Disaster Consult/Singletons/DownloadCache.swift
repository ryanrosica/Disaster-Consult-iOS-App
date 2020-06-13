//
//  DownloadCache.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 6/12/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation
import CoreData

class DownloadCache: NSObject {
    
    static let shared: DownloadCache = DownloadCache()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "downloads")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private override init() {
        super.init()
        print(persistentContainer.name)
    }
    
    
    func saveDownload(data: String, site: String) {
        if let object: ManagedDownload = NSEntityDescription.insertNewObject(forEntityName: "ManagedDownload", into: persistentContainer.viewContext) as? ManagedDownload {
            object.data = data
            object.site = site
            object.created = Date()
            do {
                try persistentContainer.viewContext.save()
            } catch {}
        }
    }
        
    func deleteDownload(id: NSManagedObjectID) {
        do {
            let download = try self.persistentContainer.viewContext.existingObject(with: id)
            self.persistentContainer.viewContext.delete(download)
            try self.persistentContainer.viewContext.save()
            NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "DC_DownloadsUpdated")))
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
