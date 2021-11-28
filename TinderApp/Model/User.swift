//
//  User.swift
//  TinderApp
//
//  Created by Roman on 21.11.2021.
//

import UIKit

struct User: ProducesCardViewModel {
    var name: String?
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var uid: String?
    
    init (dictionary: [String: Any]) {
        self.age = dictionary["age"] as? Int ?? 0
        self.profession = dictionary["profession"] as? String ?? ""
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \(age ?? 0)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
        attributedText.append(NSAttributedString(string: "\n\(profession ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .medium)]))
        
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}
