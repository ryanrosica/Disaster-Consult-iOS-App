//
//  ContentCell.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/27/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import WebKit

class ContentCell: CCell {
    
    let contentLbl: UILabel = {
        let lbl: UILabel = UILabel.init()
        //lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.font = Fonts.caption
        lbl.numberOfLines = 5
        return lbl
    }()
    
    let webView: WKWebView = {
        let view = WKWebView()
        view.autoresizingMask = [.flexibleHeight]
        view.scrollView.bounces = false
        view.scrollView.isScrollEnabled = false
        return view
    }()
    
    override func commonInit() {
        super.commonInit()
        self.selectionStyle = .none
        addSubview(webView)
        updateConstraints()
    }
    
    
    override func update(object: CCellObject) {
        super.update(object: object)
        
        if let link: LinkObject = object as? LinkObject {
            webView.loadHTMLString(link.link.content, baseURL: URL(string: "https://www.disasterconsult.org"))
            //contentLbl.text = link.link.content.htmlToString
        }

    }

    
    
    override func updateConstraints() {
        super.updateConstraints()
        
        webView.snp.makeConstraints { (maker) in
            maker.height.greaterThanOrEqualTo(300)
            maker.left.equalTo(self).inset(32)
            maker.top.equalTo(self).inset(16)
            maker.right.equalTo(self).inset(32)
            maker.bottom.equalTo(self).inset(16)
            
        }
    }

}

