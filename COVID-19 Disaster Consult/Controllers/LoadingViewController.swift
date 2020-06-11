//
//  LoadingViewController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 6/11/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit

class LoadingViewController: CViewController {
    let spinner = UIActivityIndicatorView()

    override func loadView() {

        super.viewDidLoad()
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
