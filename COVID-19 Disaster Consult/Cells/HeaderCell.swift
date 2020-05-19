//
//  HeaderCell.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/27/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit

class HeaderCell: TitleCell {

    override func commonInit() {
        super.commonInit()
        titleLbl.font = Fonts.caption

    }

    override func update (object: CCellObject) {
        super.update(object: object)
        
        if let titleObject = object as? TitleObject {
            titleLbl.text = titleObject.title
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        titleLbl.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).inset(16)
            maker.top.equalTo(self).inset(0)
            maker.right.equalTo(self).inset(16)
            maker.bottom.equalTo(self).inset(16)
        }
    }
}
