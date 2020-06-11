//
//  Endpoints.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

struct Endpoints {
    
    static func site_api(_ endpoint: String) -> String {
        return "/\(Session.shared.slug)/api/v1\(endpoint)"
    }
    
    static func api(_ endpoint: String) -> String {
        return "/api/v1\(endpoint)"
    }
    
    static func links() -> String {
        return site_api("/links")
    }
    
    static func categories() -> String {
        return site_api("/provider/categories")
    }
    
    static func category(id: String) -> String {
        return site_api("/categories/\(id)")
    }
    
    static func literature () -> String {
        return site_api("/literature")
    }
    
    static func literature (id: String) -> String {
        return site_api("/literature/\(id)")
    }
    
    static func section(id: String) -> String {
        return site_api("/section/\(id)")
    }
    
    static func tableOfContents() -> String {
        return site_api("/contents")
    }
    
    static func sites() -> String {
        return api("/sites")
    }
}
