//
//  OldDownloadCell.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 8/1/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

import UIKit

class OldDownloadCell: CCell {
    
    let titleLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
        //lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        lbl.font = Fonts.smallTitle
        lbl.numberOfLines = 0
        lbl.textAlignment =  .left
        lbl.text = "Some of your offline downloads are more than 30 days old."
        return lbl
    }()

    
    let manageButton: UILabel = {
        let lbl: UILabel = UILabel.init()
        //lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        lbl.font = Fonts.caption
        lbl.numberOfLines = 0
        lbl.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        lbl.textColor = .white
        lbl.textAlignment =  .center
        lbl.layer.cornerRadius = 10
        lbl.layer.masksToBounds = true
        lbl.text = "Manage"
        return lbl
    }()
    

    
    var stackView: UIStackView!
        
    let back = UIView()

    override func commonInit() {
        super.commonInit()
        
        self.selectionStyle = .none
        
        
        
        stackView = UIStackView.init(arrangedSubviews: [titleLbl, manageButton])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10

        
        
        back.addSubview(stackView)
        back.clipsToBounds = true
        back.layer.cornerRadius = 10
        back.layer.borderWidth = 2
        back.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        addSubview(back)
        
        updateConstraints()
    }
    
    
    override func updateConstraints() {
        super.updateConstraints()
        stackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(back).inset(16)
            maker.top.equalTo(back).inset(12)
            maker.right.equalTo(back).inset(16)
            maker.bottom.equalTo(back).inset(12)
        }
        
        manageButton.snp.makeConstraints { (maker) in
            maker.height.equalTo(40)
            
        }

        back.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).inset(16)
            maker.top.equalTo(self).inset(4)
            maker.right.equalTo(self).inset(16)
            maker.bottom.equalTo(self).inset(4)
        }
    }
    

}

