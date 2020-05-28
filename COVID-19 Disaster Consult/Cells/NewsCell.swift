//
//  HomeLinkCell.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher


class NewsCell: CCell {
    let imageBox: UIImageView = {
        let screenSize: CGRect = UIScreen.main.bounds
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.heightAnchor.constraint(equalToConstant: CGFloat(200)).isActive = true
        img.layer.borderWidth = 1
        return img
    }()
    
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
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let dateAndTimeLabel: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.font = Fonts.smallCaption
        lbl.numberOfLines = 0
        lbl.textColor = .gray
        return lbl
    }()
    
    let sourceLabel: UILabel = {
        let lbl: UILabel = UILabel.init()
        lbl.font = Fonts.smallCaption
        lbl.textColor = .systemBlue
        lbl.numberOfLines = 1
        return lbl
    }()
    
    
    
    var stackView: UIStackView!
    
    override func commonInit() {
        super.commonInit()
        stackView = UIStackView.init(arrangedSubviews: [imageBox, titleLbl, descriptionLbl, sourceLabel, dateAndTimeLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        
        addSubview(stackView)
        updateConstraints()

    }
    
    override func update(object: CCellObject) {
        super.update(object: object)
        
        if let link: LinkObject = object as? LinkObject {
            imageBox.kf.setImage(with: URL(string: link.link.source_url))
            titleLbl.text = link.link.title

            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            RFC3339DateFormatter.timeZone = .autoupdatingCurrent
            let date = RFC3339DateFormatter.date(from: link.link.last_updated)
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "MM/dd/yy"
            if let date = date {
                dateAndTimeLabel.text = "\(newDateFormatter.string(from: date))"
            }
            sourceLabel.text = cleanURL(link.link.url)

            let newDescription = NSMutableAttributedString(string: link.link.description)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 1.5
            newDescription.addAttribute(NSAttributedString.Key.paragraphStyle, value:style, range:NSMakeRange(0, newDescription.length))
            descriptionLbl.attributedText = newDescription
            
        }
        if let category: CategoryObject = object as? CategoryObject {
            titleLbl.text = category.category.title
         }
    }
    
    func cleanURL(_ url: String) -> String {
        return url.replacingOccurrences(of: "http://", with: "").replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "www.", with: "")
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


