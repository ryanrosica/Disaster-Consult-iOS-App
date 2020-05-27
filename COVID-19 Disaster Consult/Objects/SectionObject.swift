//
//  SectionObject.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/22/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

class SectionObject: CCellObject {
    var section: Section
    var bold = false
    
    init (section: Section, cellType: AnyClass = SectionCell.self) {
        self.section = section
        super.init(type: cellType)
    }
}
