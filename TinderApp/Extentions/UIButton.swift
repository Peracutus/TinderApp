//
//  UIButton.swift
//  TinderApp
//
//  Created by Roman on 07.12.2021.
//

import UIKit

extension UIButton {
    convenience init(title: String, color: UIColor, size: CGFloat) {
        self.init()
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: size)
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setRegLogButton(title: String) {
        self.layer.cornerRadius = 25
        self.backgroundColor = .systemGray
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.black, for: .disabled)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        self.backgroundColor = .systemGray
        self.isEnabled = false
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.layer.cornerRadius = 25
    }
}
