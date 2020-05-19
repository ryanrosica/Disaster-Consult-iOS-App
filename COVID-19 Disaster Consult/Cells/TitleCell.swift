//
//  TitleCell.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/10/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import SnapKit

class TitleCell: CCell {
    
    let titleLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.font = Fonts.header
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    override func update (object: CCellObject) {
        super.update(object: object)
        
        if let titleObject = object as? TitleObject {
            titleLbl.text = titleObject.title
        }

    }

    override func commonInit() {
        super.commonInit()
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        addSubview(titleLbl)
        updateConstraints()
    }
    
    override func updateConstraints() {
           super.updateConstraints()
           
           titleLbl.snp.makeConstraints { (maker) in
               maker.left.equalTo(self).inset(16)
               maker.top.equalTo(self).inset(16)
               maker.right.equalTo(self).inset(16)
               maker.bottom.equalTo(self).inset(8)
           }
       }
}
