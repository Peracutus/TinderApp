//
//  HomeBottomControlsStackView.swift
//  TinderApp
//
//  Created by Roman on 20.11.2021.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let bottomImages = [UIImage.init(imageLiteralResourceName: "refresh"),
                                .init(imageLiteralResourceName: "dismiss"),
                                .init(imageLiteralResourceName: "super_star"),
                                .init(imageLiteralResourceName: "like"),
                                .init(imageLiteralResourceName: "boost")].map { (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
    
        bottomImages.forEach { (v) in
            addArrangedSubview(v)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
