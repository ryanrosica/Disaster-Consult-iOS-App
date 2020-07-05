//
//  Site.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 6/8/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

struct Site {
    public let id: String
    public var title: String
    public var slug: String
    public var description: String
    public var hasLiterature: Bool
    public var hasNews: Bool
    public init(json: JSON) {
        self.id = json["id"].string ?? ""
        self.title = json["title"].string ?? ""
        self.description = json["description"].string ?? ""
        self.slug = json["slug"].string ?? ""
        self.hasLiterature = json["has_literature"].bool ?? false
        self.hasNews = json["has_news"].bool ?? false

    }
}
