//
//  DownloadCell.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 6/12/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation
import UIKit

class DownloadCell: CCell {
    
    let titleLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.font = Fonts.title
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
        
        if let link: OfflineDownload = object as? OfflineDownload {
            titleLbl.text = link.site.title
            
            let muted: NSMutableAttributedString = NSMutableAttributedString.init()
            if link.latest {
                muted.append(NSAttributedString.init(string: "Latest Download", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: Fonts.smallBoldCaption]))
                muted.append(NSAttributedString.init(string: " · ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: Fonts.smallCaption]))
            }
            muted.append(NSAttributedString.init(string: (link.managedDownload.created?.timeAgoSince() ?? ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: Fonts.smallCaption]))
            descriptionLbl.attributedText = muted
            
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

