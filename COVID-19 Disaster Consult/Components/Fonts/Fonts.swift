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
        return getFont(style: "Bold", textStyle: .title2)
    }
    static var caption: UIFont {
        return getFont(style: "Regular", textStyle: .body)
    }
    static var header: UIFont {
        return getFont(style: "ExtraBold", textStyle: .title1)
    }
    static var smallTitle: UIFont {
        return getFont(style: "Bold", textStyle: .body)
    }
    static var smallCaption: UIFont {
        return getFont(style: "Regular", textStyle: .caption1)
    }
    static var smallBoldCaption: UIFont {
        return getFont(style: "Bold", textStyle: .callout)
    }
    static var bodySize: CGFloat {
        let font = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        return font.pointSize
    }
    static var headerSize: CGFloat {
        let font = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
        return font.pointSize
    }
    
    private static func getFont (style: String, textStyle: UIFont.TextStyle) -> UIFont {
        
        let userFont =  UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        let pointSize = userFont.pointSize
        
        guard let customFont = UIFont(name: "\(family)-\(style)", size: pointSize) else {
            fatalError("""
                Failed to load font.
                """
            )
        }
        return customFont
    }
    
    static func provideFont(size: CGFloat, style: String) -> UIFont {
        guard let customFont = UIFont(name: "\(family)-\(style)", size: size) else {
            fatalError("""
                Failed to load font.
                """
            )
        }
        return customFont
    }

}
