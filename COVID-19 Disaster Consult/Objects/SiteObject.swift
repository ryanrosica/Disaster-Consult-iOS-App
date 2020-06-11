//
//  SiteObject.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 6/8/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

class SiteObject: CCellObject {
    let site: Site
    
    init (site: Site) {
        self.site = site
        super.init(type: CategoryCell.self)
    }
}
