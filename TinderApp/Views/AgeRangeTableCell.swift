//
//  AgeRangeTableCell.swift
//  TinderApp
//
//  Created by Roman on 02.12.2021.
//

import Foundation
import UIKit

class AgeRangeTableCell: UITableViewCell {
    
    let minAgeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 55
        return slider
    }()
    
    let maxAgeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 55
        return slider
    }()
    
    let minLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "min age"
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "max age"
        return label
    }()
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel, minAgeSlider]),
            UIStackView(arrangedSubviews: [maxLabel, maxAgeSlider])
        ])
        stackView.axis = .vertical
        stackView.spacing = 15
        contentView.addSubview(stackView)
        stackView.fillSuperview()
        //stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
