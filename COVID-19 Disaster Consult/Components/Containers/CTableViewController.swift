//
//  CTableViewController.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation
import UIKit

class CTableViewController: CViewController {
    
    let tableView: BTableView

    init(tableView: BTableView) {
        self.tableView = tableView
        super.init()
        view.addSubview(self.tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutTable()
    }
    
    func layoutTable() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            var isFullscreen: Bool = false
            
            if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
                if self.view.bounds.width >= 700 {
                    isFullscreen = true
                }
            } else {
                if self.view.bounds.width >= 800 {
                    isFullscreen = true
                }
            }
            
            if isFullscreen {
                let modifier: CGFloat = UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown ? 0.7 : 0.6
                self.tableView.frame = CGRect.init(x: (view.bounds.width / 2) - ((view.bounds.width * modifier) / 2), y: 0, width: view.bounds.width * modifier, height: view.bounds.height)
                return
            }
        }
        
        self.tableView.frame = view.bounds
    }
    
    @objc func retry() {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

