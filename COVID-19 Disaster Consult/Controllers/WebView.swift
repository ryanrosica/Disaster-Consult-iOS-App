//
//  WebView.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 4/27/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
class WebView: UIViewController {
    var html: String = ""
    var pageTitle = ""
    let webView: WKWebView = {
        let view = WKWebView()
        
        return view
    }()

    override func loadView() {
        let htmlFile = Bundle.main.path(forResource: "html", ofType: "html")
        let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        let header =    "<h2>\(pageTitle)</h2>"
        webView.loadHTMLString("\(htmlString ?? "")\(header)\(html)</div>", baseURL: nil)
        view = webView
        self.title = "Disaster Consult | COVID- 19"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        webView.navigationDelegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      if navigationAction.navigationType == .linkActivated  {
        if let url = navigationAction.request.url {
          UIApplication.shared.open(url)
          decisionHandler(.cancel)
        } else {
          decisionHandler(.allow)
        }
      } else {
        decisionHandler(.allow)
      }
    }
}
