//
//  TopNavigationStackView.swift
//  TinderApp
//
//  Created by Roman on 20.11.2021.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
  //.  let fireImageView = UIImageView(image: .init(imageLiteralResourceName: <#T##String#>))

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        let topImages = [UIImage.init(imageLiteralResourceName: "left_profile"),
                                .init(imageLiteralResourceName: "fire"),
                                .init(imageLiteralResourceName: "right_message")].map { (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
    
        topImages.forEach { (v) in
            addArrangedSubview(v)
        }
        
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
