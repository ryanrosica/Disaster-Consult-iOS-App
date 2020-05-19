//
//  CellObjectDatasource.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation
import UIKit

typealias CCellObjectDatasource = [[CCellObject]]

extension CCellObjectDatasource {
    
    func item(indexPath: IndexPath) -> CCellObject? {
        guard self.indices.contains(indexPath.section) else { return nil }
        guard self[indexPath.section].indices.contains(indexPath.row) else { return nil }
        
        return self[indexPath.section][indexPath.row]
    }
    
}
