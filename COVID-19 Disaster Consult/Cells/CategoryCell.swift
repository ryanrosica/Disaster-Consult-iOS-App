//
//  CategoryCell.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/14/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit

class CategoryCell: CCell {

    
    let titleLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
        //lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        lbl.font = Fonts.caption
        lbl.numberOfLines = 0
        lbl.backgroundColor = #colorLiteral(red: 0.7521713376, green: 0.8826304078, blue: 0.9193754196, alpha: 1)
        lbl.textColor = .black
        lbl.textAlignment =  .center
        lbl.layer.cornerRadius = 10
        lbl.layer.masksToBounds = true
        return lbl
    }()
    
    override func commonInit() {
        super.commonInit()
        self.selectionStyle = .none
        addSubview(titleLbl)
        updateConstraints()
    }
    
    override func update(object: CCellObject) {
        super.update(object: object)
        if let category: CategoryObject = object as? CategoryObject {
   
            titleLbl.text = category.category.title

         }
    
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        titleLbl.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).inset(16)
            maker.top.equalTo(self).inset(4)
            maker.right.equalTo(self).inset(16)
            maker.bottom.equalTo(self).inset(4)
            maker.height.equalTo(64)
        }
    }
    

}
