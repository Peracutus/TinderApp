//
//  HomeBottomControlsStackView.swift
//  TinderApp
//
//  Created by Roman on 20.11.2021.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: UIImage.init(imageLiteralResourceName: "refresh"))
    let dismissButton = createButton(image: UIImage.init(imageLiteralResourceName: "dismiss"))
    let superStarButton = createButton(image: UIImage.init(imageLiteralResourceName: "super_star"))
    let likeButton = createButton(image: UIImage.init(imageLiteralResourceName: "like"))
    let boostButton = createButton(image: UIImage.init(imageLiteralResourceName: "boost"))
                                     

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        [refreshButton, dismissButton, superStarButton, likeButton, boostButton].forEach { (button) in
            self.addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
