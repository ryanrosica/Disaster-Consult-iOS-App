//
//  Endpoints.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

struct Endpoints {
    
    static func links() -> String {
        return "/links"
    }
    static func categories() -> String {
        return "/provider/categories"
    }
    
    static func category(id: String) -> String {
        return "/categories/\(id)"
    }
    static func literature () -> String {
        return "/literature"
    }
    static func literature (id: String) -> String {
        return "/literature/\(id)"
    }
    static func section(id: String) -> String {
        return "/section/\(id)"
    }
}
