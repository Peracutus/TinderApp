//
//  User.swift
//  TinderApp
//
//  Created by Roman on 21.11.2021.
//

import UIKit

struct User {
    let name: String
    let age: Int
    let profession: String
    let imageName: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .medium)]))
        
        return CardViewModel(imageName: imageName, attributedString: attributedText, textAlignment: .left)
    }
}
