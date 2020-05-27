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
    var pageTitle: String = ""
    var url: String = ""
    var id = ""
    var tableOfContentsVisible = false
    let webView: WKWebView = {
        let view = WKWebView()
        
        return view
    }()
    
    
    
    func makeTableOfContentsView() {
        if (tableOfContentsVisible) {
            let tableOfcontentsButton = UIButton()
            tableOfcontentsButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            tableOfcontentsButton.setTitleColor(UIColor.black, for: .normal)

            tableOfcontentsButton.setTitle("Table Of Contents ☰", for: .normal)
            tableOfcontentsButton.addTarget(self, action: #selector(contentsPressed), for: .touchUpInside)
            
            self.view.addSubview(tableOfcontentsButton)
            tableOfcontentsButton.translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 11.0, *) {
                let guide = self.view!
                tableOfcontentsButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
                tableOfcontentsButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
                tableOfcontentsButton.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
                tableOfcontentsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            }
        }

    }
    
    
    @objc func contentsPressed() {
        let contentsController = TableOfContentsController(selectedID: id, completion: {controllers in
            self.navigationController?.setViewControllers(controllers, animated: true)
        })
        let navController = CNavigationController(rootViewController: contentsController)
            
        
        self.present(navController, animated: true, completion: nil)
    }
    
    override func loadView() {
        if let htmlFile = Bundle.main.path(forResource: "html", ofType: "html") {
            if var htmlString: String = try? String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8) {
                htmlString = htmlString.replacingOccurrences(of: "INSERT_TITLE", with: pageTitle)
                htmlString = htmlString.replacingOccurrences(of: "INSERT_BODY", with: html)
                
                webView.loadHTMLString(htmlString, baseURL: nil)
            }
        }
        view = webView
        makeTableOfContentsView()
        self.title = "Disaster Consult | COVID- 19"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        webView.navigationDelegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(showShare))
    }
    
    @objc func showShare() {
        if let uri: URL = URL.init(string: self.url) {
            self.present(Presenter.showShare(object: uri as AnyObject), animated: true, completion: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url {
                self.present(Presenter.openSVC(url: url), animated: true)
                decisionHandler(.cancel)
                return
            }
        }
        
        
        decisionHandler(.allow)
    }
}
