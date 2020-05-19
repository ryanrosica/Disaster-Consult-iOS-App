//
//  SectionCell.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/22/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit

class SectionCell: CCell {
    
    let titleLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
        //lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        lbl.font = Fonts.smallTitle
        lbl.numberOfLines = 0
        lbl.textAlignment =  .left
        return lbl
    }()
    let descriptionLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
     //lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.font = Fonts.smallCaption
        lbl.numberOfLines = 2
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        return lbl
     }()
    
    var stackView: UIStackView!
        
    let back = UIView()

    override func commonInit() {
        super.commonInit()
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        self.selectionStyle = .none
        stackView = UIStackView.init(arrangedSubviews: [titleLbl, descriptionLbl])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 3
        back.addSubview(stackView)
        back.clipsToBounds = true
        back.layer.cornerRadius = 10
        back.layer.borderWidth = 2
        back.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        addSubview(back)
        updateConstraints()
    }
    
    
    override func update(object: CCellObject) {
        super.update(object: object)
        if let section: SectionObject = object as? SectionObject {
            titleLbl.text = section.section.title
            descriptionLbl.text = section.section.description
        }
        else if let link: LinkObject = object as? LinkObject {
            titleLbl.text = link.link.title
            descriptionLbl.text = link.link.description
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        stackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(back).inset(8)
            maker.top.equalTo(back).inset(12)
            maker.right.equalTo(back).inset(16)
            maker.bottom.equalTo(back).inset(12)
        }
        

        back.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).inset(16)
            maker.top.equalTo(self).inset(4)
            maker.right.equalTo(self).inset(16)
            maker.bottom.equalTo(self).inset(4)
        }
    }
    

}

