//
//  CategoryObject.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/14/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

class CategoryObject: CCellObject {
    let category: Category
    
    init (category: Category) {
        self.category = category
        super.init(type: CategoryCell.self)
    }
}
