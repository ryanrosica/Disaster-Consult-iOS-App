//
//  LitCell.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/27/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import SnapKit


class LitCell: CCell {
    
    let titleLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
        //lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        lbl.font = Fonts.title
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let descriptionLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
        //lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.font = Fonts.caption
        lbl.numberOfLines = 5
        return lbl
    }()
    
    var stackView: UIStackView!
    
    override func commonInit() {
        super.commonInit()
        stackView = UIStackView.init(arrangedSubviews: [titleLbl, descriptionLbl])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        addSubview(stackView)
        updateConstraints()
    }
    
    override func update(object: CCellObject) {
        super.update(object: object)
        
        if let link: LinkObject = object as? LinkObject {
            titleLbl.text = link.link.title
            descriptionLbl.text = link.link.excerpt
        }
        if let category: CategoryObject = object as? CategoryObject {
            titleLbl.text = category.category.title
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


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
