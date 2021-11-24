//
//  TopNavigationStackView.swift
//  TinderApp
//
//  Created by Roman on 20.11.2021.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let settingsButton = UIButton()
    let fireView = UIImageView(image: UIImage(named: "fire"))
    let chatButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fireView.contentMode = .scaleAspectFit
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingsButton.setImage(UIImage(named: "left_profile")!.withRenderingMode(.alwaysOriginal), for: .normal)
        chatButton.setImage(UIImage(named: "right_message")!.withRenderingMode(.alwaysOriginal), for: .normal)
        [settingsButton,UIView(), fireView,UIView(), chatButton].forEach({ (v) in
            addArrangedSubview(v)
        })
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
