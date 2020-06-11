//
//  Font.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/14/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit

public struct Fonts {
    static let family = "Montserrat"
    static var title: UIFont {
        return getFont(style: "Bold", fontSize: 22)
    }
    static var caption: UIFont {
        return getFont(style: "Regular", fontSize: 16)
    }
    static var header: UIFont {
        return getFont(style: "ExtraBold", fontSize: 28)
    }
    static var smallTitle: UIFont {
        return getFont(style: "Bold", fontSize: 16)
    }
    static var smallCaption: UIFont {
        return getFont(style: "Regular", fontSize: 12)
    }
    
    private static func getFont (style: String, fontSize: CGFloat) -> UIFont {
        
        guard let customFont = UIFont(name: "\(family)-\(style)", size: fontSize) else {
            fatalError("""
                Failed to load font.
                """
            )
        }
        return customFont
    }

}
