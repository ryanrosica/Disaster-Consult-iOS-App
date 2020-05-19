//
//  CTableView.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation
import UIKit

protocol CTableViewDelegate: UITableViewDelegate {
    
    // Return all used cell types for registration
    func cellTypes() -> [AnyClass]
    
    // For returning a static row
    func cell(indexPath: IndexPath) -> UITableViewCell?
    
}

class BTableView: UITableView {
    
    var data: CCellObjectDatasource = CCellObjectDatasource.init()

    init(style: UITableView.Style) {
        super.init(frame: CGRect.zero, style: style)
        
        self.dataSource = self
        self.dragInteractionEnabled = false

    }
    
    func setDelegate(_ delegate: CTableViewDelegate) {
        self.delegate = delegate
        
        let cellClasses:[AnyClass] = delegate.cellTypes()
        for i in cellClasses {
            register(i, forCellReuseIdentifier: "\(i)")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let delegate: CTableViewDelegate = delegate as? CTableViewDelegate {
            if let cell: UITableViewCell = delegate.cell(indexPath: indexPath) {
                return cell
            }
        }
        
        guard let object: CCellObject = data.item(indexPath: indexPath) else {
            return UITableViewCell.init()
        }
        
        
        if let cell: CCell = tableView.dequeueReusableCell(withIdentifier: "\(object.type)") as? CCell {
            cell.height = object.height
            cell.update(object: object)
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight(indexPath: indexPath)
    }
    
    func rowHeight(indexPath: IndexPath) -> CGFloat {
        return data.item(indexPath: indexPath)?.height ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return data.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return data[section].count }
    
}
