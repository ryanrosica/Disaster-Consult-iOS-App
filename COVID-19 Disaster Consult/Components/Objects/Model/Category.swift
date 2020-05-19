//
//  Category.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/14/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

public struct Category: Thing {
    
    public let id: String

     public let title: String
     public let description: String
     public let last_updated: String
     public let is_public: Bool


     public init(id: String) {
         self.id = id
         self.title = ""
         self.description = ""
         self.last_updated = ""
         self.is_public = false

     }
     
     public init(json: JSON) {
         id = json["id"].string ?? ""
         self.title = json["title"].string ?? ""
         self.description = json["description"].string ?? ""
         self.last_updated = json["last_updated"].string ?? ""
         self.is_public = json["public"].bool ?? false
     }
}
