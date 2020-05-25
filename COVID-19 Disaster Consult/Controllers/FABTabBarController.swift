//
//  FABTabBarController.swift
//  COVID-19 Disaster Consult
//
//  Created by Ryan Rosica on 5/25/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import UIKit
import SnapKit

class FABTabBarController: CTabBarController, ConstraintRelatableTarget {
    static let buttonWidth: CGFloat = 70
    
    let floatingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 0.5 * buttonWidth
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.2
        button.layer.masksToBounds = false
        button.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        button.tintColor = .white
        button.titleLabel?.font = Fonts.smallCaption
        button.setTitle("Feedback", for: .normal)
        //button.setImage(#imageLiteral(resourceName: "icons8-feedback-30"), for: .normal)
        
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func buttonPressed() {
        let safariController = Presenter.openSVC(url: URL(string: "https://www.disasterconsult.org/contact")!)
        safariController.providesPresentationContextTransitionStyle = true
        safariController.modalPresentationStyle = .pageSheet
        self.present(safariController, animated: true, completion: nil)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(floatingButton, belowSubview: self.tabBar)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.snp.makeConstraints { maker in
            maker.height.equalTo(FABTabBarController.buttonWidth)
            maker.width.equalTo(FABTabBarController.buttonWidth)
            maker.right.equalTo(self.view).inset(16)
            maker.bottom.equalTo(self.view).inset(100)
        }
        
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

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
