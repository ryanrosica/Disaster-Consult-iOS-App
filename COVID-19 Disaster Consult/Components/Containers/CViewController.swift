//
//  CViewController.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation
import UIKit

class CViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    func commonInit() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
    }
    
    func showClose() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
    }
    
    @objc func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
}
