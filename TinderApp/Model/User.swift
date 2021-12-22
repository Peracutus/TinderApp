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
    var imageUrl2: String?
    var imageUrl3: String?
    var bio: String?
    var minSearchAge: Int?
    var maxSearchAge: Int?
    var uid: String?
    
    init (dictionary: [String: Any]) {
        self.age = dictionary["age"] as? Int 
        self.profession = dictionary["profession"] as? String ?? ""
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.bio = dictionary["bio"] as? String ?? ""
        self.minSearchAge = dictionary["minAgeValue"] as? Int ?? 18
        self.maxSearchAge = dictionary["maxAgeValue"] as? Int ?? 50
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \(age ?? 0)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
        attributedText.append(NSAttributedString(string: "\n\(profession ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .medium)]))
        
        var imageUrls = [String]()
        if let url = imageUrl1 { imageUrls.append(url) }
        if let url = imageUrl2 { imageUrls.append(url) }
        if let url = imageUrl3 { imageUrls.append(url) }
        return CardViewModel(imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
}
