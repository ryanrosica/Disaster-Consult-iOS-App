//
//  Post.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

public struct Link: Thing {
    
    public let id: String

    public let title: String
    public let url: String
    public let description: String
    public let author: String
    public let large_url: String
    public let last_updated: String
    public let is_public: Bool
    public let source_url: String
    public let content: String
    public let excerpt: String
    
    public init(id: String) {
        self.id = id
        self.title = ""
        self.url = ""
        self.author = ""
        self.description = ""
        self.large_url = ""
        self.last_updated = ""
        self.is_public = false
        self.source_url = ""
        self.content = ""
        self.excerpt = ""
    }
    
    public init(json: JSON) {
        id = json["id"].string ?? ""
        self.url = json["url"].string ?? ""
        self.title = json["title"].string ?? ""
        self.author = json["author"].string ?? ""
        self.description = json["description"].string ?? ""
        self.large_url = json["large_url"].string ?? ""
        self.last_updated = json["last_updated"].string ?? ""
        self.is_public = json["public"].bool ?? false
        self.source_url = json["source_url"].string ?? ""
        self.content = json["content"].string ?? ""
        self.excerpt = json["excerpt"].string ?? ""

    }
    
}
