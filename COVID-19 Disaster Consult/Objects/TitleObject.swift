//
//  TitleObject.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/14/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

class TitleObject: CCellObject {
    let title: String
    init(title: String, cellType: AnyClass = TitleCell.self) {
        self.title = title
        super.init(type: cellType)
        
    }
}
