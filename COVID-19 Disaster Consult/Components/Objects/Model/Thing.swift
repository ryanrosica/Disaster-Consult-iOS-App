//
//  Thing.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

public protocol Thing {
    
    var id: String { get }
    
    init(id: String)
    
}

