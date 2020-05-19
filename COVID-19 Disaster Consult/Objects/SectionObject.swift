//
//  SectionObject.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/22/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

class SectionObject: CCellObject {
    let section: Section
    
    init (section: Section) {
        self.section = section
        super.init(type: SectionCell.self)
    }
}
