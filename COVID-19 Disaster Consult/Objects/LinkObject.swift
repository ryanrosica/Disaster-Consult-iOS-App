//
//  HomeLinkObject.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

class LinkObject: CCellObject {
    
    let link: Link
    let page: String?
    
    init(link: Link, cellType: AnyClass, page: String? = nil) {
        self.link = link
        self.page = page
        super.init(type: cellType)
    }
    
}


