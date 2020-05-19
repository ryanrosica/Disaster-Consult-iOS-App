//
//  LitCell.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/27/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class TextCell: CCell {
    
    let titleLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.font = Fonts.caption
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let descriptionLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.font = Fonts.smallCaption
        lbl.textColor = UIColor.gray
        lbl.numberOfLines = 5
        return lbl
    }()
    
    var stackView: UIStackView!
    
    override func commonInit() {
        super.commonInit()
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        stackView = UIStackView.init(arrangedSubviews: [titleLbl, descriptionLbl])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 4
        addSubview(stackView)
        updateConstraints()
    }
    
    override func update(object: CCellObject) {
        super.update(object: object)
        
        if let link: TitleObject = object as? TitleObject {
            titleLbl.text = link.title
            descriptionLbl.text = link.descrip
        }

    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        stackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).inset(16)
            maker.top.equalTo(self).inset(16)
            maker.right.equalTo(self).inset(16)
            maker.bottom.equalTo(self).inset(16)
        }
    }
    
}

