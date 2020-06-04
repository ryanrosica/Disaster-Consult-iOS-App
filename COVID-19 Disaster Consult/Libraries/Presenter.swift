//
//  Presenter.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 5/18/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class Presenter: NSObject {
    
    /*static func toast(text: String) {
        UIApplication.shared.keyWindow?.rootViewController?.view?.noticeSuccess(text, autoClear: true, autoClearTime: 1)
    }*/
    
    static func openSVC(url: URL) -> UIViewController {
        let config = SFSafariViewController.Configuration()
        
        
        let safariView = SFSafariViewController(url: url, configuration: config)
        safariView.preferredBarTintColor = #colorLiteral(red: 0.1468381584, green: 0.2079161704, blue: 0.2486139238, alpha: 1)
        return safariView
    }
    

    
    static func showShare(object: AnyObject) -> UIViewController {
        let objectsToShare = [object]
        let activityViewController = UIActivityViewController.init(activityItems: objectsToShare, applicationActivities: nil)
        return activityViewController
    }
    
}
